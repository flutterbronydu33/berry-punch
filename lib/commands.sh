#!/usr/bin/env false

# Commandes utilisateur à lancer depuis le chat
# Auteur: Adrien Sohier (adriens33)

liblist+=("commands");
HOOKS["msg_received"]+="parse_message;";

# Chargement de la config
touch "${global_confdir}/cmd_right.cfg"
source "${global_confdir}/cmd_right.cfg"

# Correspondance commande ↔ fonction
declare -Ag cmdtable=(['stop']="stop_the_bot"
					 ['muffin']="muffin_throw \$args"
					 ['do']="do_smgth \"\$args\""
					 ['say']="say_smgth \"\$args\""
					 ['niorphlo']="say_smgth \"Salut, \$args !\""
					 ['history']="log_last"
					 ['niorph']="say_smgth \"Have you niorphed today, \$args ?\""
					 ['flag']="admin_flagcmd \$args"
					 ['reload']="reload_libs"
					 ['voice']="admin_flagcmd mod +v \$args"
					 ['devoice']="admin_flagcmd mod -v \$args"
					 ['welcome']="say_smgth \"Bienvenue sur le chat de BronyCUB, \$args !\";say_smgth \"Amuse-toi bien !\""
					 ['op']="admin_flagcmd mod +o \$args"
					 ['deop']="admin_flagcmd mod -o \$args"
					 ['help']="cmd_help \$args"
					 ['kick']="cmd_kick \$args"
					 ['ban']="cmd_ban \$args"
					 ['unban']="cmd_ban - \$args"
					 ['inscription']="cmd_inscript \$args"
					 ['list']="list_cmds");

# Droit d'accès à certaines commandes
# Si la commande n'est pas précisée ici, elle est considérée comme publique
declare -Ag cmdwrong=();

# ---------- Commands ----------
# Liste des commandes disponibles
list_cmds()
{
	local a="${!cmdtable[@]}"
	send "PRIVMSG $irc_back :Commandes disponibles :";
	send "PRIVMSG $irc_back :$a";
}

# Permet de bannir / débannir quelqu'un
cmd_ban()
{
	local mask hostip INV;

	INV=0;
	[ "$1" == "-" ] && INV=1;

	mask="${1}"; shift;
	hostip="$(LC_ALL=c host "${HOST}"|sed "s@^.*address @@")"
	if [ $INV -eq 0 ]; then
		[ $(echo "${mask}"|grep "${BAN_WHITELIST}"|wc -l) -gt 0 ] && {
			send "PRIVMSG $irc_back :Tu rêves là."
			return;
		}
		[ $(echo "${mask}"|grep "${NICK}\|${HOST}\|${hostip}"|wc -l) -gt 0 ] && {
			send "PRIVMSG $irc_back :Donc tu penses que je vais me bannir. Raté, je suis bourrée mais pas à ce point XD";
			return;
		}
		send_sec "MODE ${CHAN} +b ${mask}"
	else
		send_sec "MODE ${CHAN} -b ${mask}"
	fi
}

# Permet de kick quelqu'un
cmd_kick()
{
	local name reason;
	name="$1"; shift;
	[ "$name" == "$NICK" ] && {
		send "PRIVMSG $irc_back :Non mais ça va pas ? Je vais pas me kicker !"
		return;
	}
	[ "$name" == "adriens33" ] && {
		send "PRIVMSG $irc_back :Tu rêves là."
		return;
	}

	reason="${@}";

	[ "$reason" != "" ] && reason=":${reason}";

	send_sec "KICK ${CHAN} $name ${reason}"
}

# Inscrit un nouvel arrivant
cmd_inscript()
{
	local pseudo="$1";
	admin_flagcmd set +v "$pseudo"
	admin_flagcmd mod +v "$pseudo"
	send "PRIVMSG ${CHAN} :Bienvenue dans la horde, $pseudo =D"
}

# Aide pour une commande
cmd_help()
{
	local cmd="$1"
	local helptext=();
	local cnt;

	[ "$cmd" == "" ] && {
		send "PRIVMSG $irc_back :Entrez help <commande> pour avoir de l'aide sur cette commande."
		return
	}
	case "$cmd" in
		"inscription")	helptext=("Inscrit quelqu'un." "${cmd_char}inscription <pseudo>")
			;;
		"ban")	helptext=("Bannit quelqu'un du canal." "${cmd_char}ban xxx!yyy@zzz xxx=pseudo yyy=username zzz=adresse")
			;;
		"unban")	helptext=("Enlève l'état de banissement de quelqu'un sur le canal." "${cmd_char}unban xxx!yyy@zzz xxx=pseudo yyy=username zzz=adresse")
			;;
		"kick")	helptext=("Kicke (vire) quelqu'un du canal." "${cmd_char}kick <nom> [raison]")
			;;
		"niorphlo") helptext=("Dit bonjour à quelqu'un." "${cmd_char}niorphlo <nom>")
			;;
		"stop")	helptext=("Stoppe le bot.")
			;;
		"niorph")	helptext=("Demande à quelqu'un s'il a niorph" "${cmd_char}niorph <user>")
			;;
		"muffin")	helptext=("Jette un muffin sur quelqu'un." "${cmd_char}muffin <user>")
			;;
		"welcome")	helptext=("Souhaite la bienvenue à quelqu'un" "${cmd_char}welcome <user>")
			;;
		"do")	helptext=("Effectue une action." "${cmd_char}do <quelque chose>")
			;;
		"say")	helptext=("Fait parler le bot." "${cmd_char}say <du texte>")
			;;
		"history")	helptext=("Affiche les 10 dernières lignes de l'historique.")
			;;
		"flag")		helptext=("Gère les flags user/canal." "flag: état de vos flags"
														   "flag get <user>: flags enregistrés pour user"
														   "flag set <flags> <user>: modifie les flags enregistrés de user en flags"
														   "flag mod <flags> [user]: modifie les flags actuels de user (ou du canal si pas d'user précisé)")
			;;
		"reload")	helptext=("Recharge le bot")
			;;
		"voice")	helptext=("Donne le flag +v à quelqu'un." "${cmd_char}voice <user>" "équivalent de ${cmd_char}flag mod +v <user>")
			;;
		"devoice")	helptext=("Sort le flag +v de quelqu'un." "${cmd_char}devoice <user>" "équivalent de ${cmd_char}flag mod -v <user>")
			;;
		"op")	helptext=("Donne les droits admins à quelqu'un." "${cmd_char}op <user>" "équivalent de ${cmd_char}flag mod +o <user>")
			;;
		"deop")	helptext=("Sort les droits admins de quelqu'un." "${cmd_char}deop <user>" "équivalent de ${cmd_char}flag mod -o <user>")
			;;
		"list")	helptext=("Liste les commandes utilisables.")
			;;
		*)	helptext=("Commande inconnue." "Essayez '${cmd_char}list'.")
			;;
	esac
	let cnt=0
	for i in "${helptext[@]}"; do
		send "PRIVMSG $irc_back :$i"
		let cnt++;
		# [ $(($cnt%5)) -eq 0 ] && sleep 1;
	done
}

# Arrête le bot (plus nécessaire depuis le commit 80f80e26)
stop_the_bot()
{
	send "PRIVMSG $irc_back :Bye $irc_user !";
	msg "Stopping server…";
	sleep 1;
	exitbot;
}
# Action sur le canal (/me)
do_smgth()
{
	local args="${@}"
	send_sec "PRIVMSG ${CHAN} :\x01ACTION ${args}\x01";
}
# Fait dire quelque chose au bot
say_smgth()
{
	local args="${@}"
	send "PRIVMSG ${CHAN} :${args}";
}

# Lance un muffin sur quelqu'un
muffin_throw()
{
	local name speed secret;

	name="$1";
	secret="$2";

	speed=$((1+$RANDOM%1999));
	[ "$secret" == "m" ] && let speed+=2000;

	do_smgth "lance un muffin sur $name à $speed km/h"

	if [ $speed -ge 1220 ]; then
		say_smgth "MUFFIN RAINBOOM !!"
	fi
}
# ---------- Internals ----------
# (HOOK) parse les messages utilisateur pour extraire les commandes et leurs paramètres
parse_message()
{
	local cmd args;
	cmd="$(echo $irc_msg|cut -d' ' -f1)"
	args="${irc_msg#${cmd}}"

	# Supprime l'espace au début des arguments
	[ "${args:0:1}" == " " ] && args="${args:1}";

	# Pas de caractère de commande au début ? Ben c'est pas une commande alors.
	[ "${cmd:0:1}" == "${cmd_char}" ] || return;
	cmd="${cmd:1}";
	
	# Si vous n'avez pas le droit d'exécuter une commande, c'esst ici que le bot vous tape dessus.
	# Attention, au 4e essai il vous kickera.
	[ "${cmdright[$cmd]}" != "" ] && [ $(echo " ${cmdright[$cmd]} "|grep " $irc_user "|wc -l) -lt 1 ] && {
		let cmdwrong[$irc_user]++;
		case ${cmdwrong[$irc_user]} in
			1)
				send "PRIVMSG $irc_back :Je suis désolé $irc_user, mais je n'ai pas le droit de te laisser faire ça.";;
			2)
				send "PRIVMSG $irc_back :N'insiste pas, s'il te plaît, $irc_user…";;
			3)
				send "PRIVMSG $irc_back :Bon. $irc_user, prochaine tentative, je te vire. OKAY ??";;
			4)
				[ "${irc_back:0:1}" == "#" ] && {
					send "PRIVMSG $irc_back: Désolé, je t'avais prévenu $irc_user .";
					sleep 0.5;
					send "KICK $irc_back $irc_user :Punaise, il est casse-pieds lui…";
					let cmdwrong[$irc_user]=0;
				};;
		esac
		return;
	}

	# On exécute la commande ici
	if [ "${cmdtable[$cmd]}" != "" ]; then
		# args="$(echo "${args}"|sed "s|>|'&'|g;s|<|'&'|g;s|\;|'&'|g")"
		eval "${cmdtable[$cmd]}";
	fi
}

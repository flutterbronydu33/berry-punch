#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <libircclient/libircclient.h>
#include <libircclient/libirc_rfcnumeric.h>

#include <berrypunch/config.h>
#include <berrypunch/events.h>

int main()
{
	irc_callbacks_t callbacks;
	memset (&callbacks, 0, sizeof(callbacks));

	callbacks.event_connect = event_connect;
	callbacks.event_numeric = event_numeric;
	callbacks.event_privmsg = event_messg;
	callbacks.event_channel = event_messg;

	irc_session_t * session = irc_create_session(&callbacks);
	if (!session) {
		fprintf(stderr, "[ERROR] Could not create IRC session\n");
		return 1;
	}

	irc_option_set(session, LIBIRC_OPTION_STRIPNICKS);
	if (irc_connect(session, IRC_SERV, IRC_PORT, 0, IRC_NICK, IRC_USERNAME, IRC_REALNAME)) {
		fprintf(stderr, "[ERROR] %s (%d)\n", irc_strerror(irc_errno(session)), irc_errno(session));
		return 2;
	}

	return irc_run (session);
}


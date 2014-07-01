#ifndef __bp_regex_h__
#define __bp_regex_h__

#include <stdlib.h>
#include <stdio.h>
#include <regex.h>

// ---------------------------- Types de groupes ---------------------------- //
#define TRG_GROUP_ALCOOL	0
#define TRG_GROUP_APPEL		1
#define	TRG_GROUP_INJURE	2

// ------------------------- Structures de données ------------------------- //
// Groupe de regex qui déclenchent un 
// certain type de réponse
typedef struct {
	// Regex de déclenchement
	struct {
		char ** str;
		unsigned int nb;
	} regex;

	// Réponses possibles
	struct {
		char ** str;
		unsigned int nb;
	} resp;
} trigger_group_t;

// Toutes les infos sur les triggers
typedef struct {
	// Groupes de déclenchement
	trigger_group_t ** groups;
	unsigned int nb;
} triggers_t;

// ------------------------------- Fonctions ------------------------------- //
// Gestion des groupes
void msgtrigger_group_add_regex(trigger_group_t * g, char * regex);
void msgtrigger_group_add_resp(trigger_group_t * g, char * resp);
void msgtrigger_add_group(triggers_t * t, trigger_group_t * g);

// Gestion de la config globale
triggers_t * msgtrigger_init();
trigger_group_t * msgtrigger_group_init();

#endif

#include <berrypunch/msgtrigger.h>

// -----------------------------Init structures ----------------------------- //
/**
 * @brief Initialise une structure de données de type triggers_t
 * @return Un pointeur sur une structure de type triggers_t
 */
triggers_t * msgtrigger_init()
{
	triggers_t * t = malloc(sizeof(triggers_t));
	t->nb = 0;
	t->groups = NULL;

	return t;
}

/**
 * @brief Initialise une structure de données de type trigger_group_t
 * @return Un pointeur sur une structure de type trigger_group_t
 */
trigger_group_t * msgtrigger_group_init()
{
	trigger_group_t * g = malloc(sizeof(trigger_group_t));

	g->regex.str = NULL;
	g->regex.nb = 0;
	g->resp.str = NULL;
	g->resp.nb = 0;

	return g;
}

// ----------------------- Gestion données de groupe ----------------------- //
/**
 * @brief Ajoute un groupe de réponses à une structure triggers_t
 * @param t La structure dans laquelle ajouter les données
 * @param g Le groupe à ajouter
 */
void msgtrigger_add_group(triggers_t * t, trigger_group_t * g)
{
	trigger_group_t **tmp, **repl;
	unsigned int i;

	tmp = malloc(sizeof(trigger_group_t*)*(t->nb+1));

	for(i=0 ; i<t->nb ; i++) {
		tmp[i] = t->groups[i];
	}

	tmp[t->nb] = g;

	repl = t->groups;
	t->groups = tmp;
	t->nb++;
	free(repl);
}

/**
 * @brief Ajoute une expression régulière à un groupe donné
 * @param g Le groupe à modifier
 * @param regex L'expression régulière à ajouter
 */
void msgtrigger_group_add_regex(trigger_group_t * g, char * regex)
{
	char **tmp, **repl;
	unsigned int i;

	tmp = malloc(sizeof(char*)*(g->regex.nb+1));

	for(i=0 ; i<g->regex.nb ; i++) {
		tmp[i] = g->regex.str[i];
	}

	tmp[g->regex.nb] = regex;

	repl = g->regex.str;
	g->regex.str = tmp;
	g->regex.nb++;
	free(repl);
}

/**
 * @brief Ajoute une réponse dans la liste pour un groupe donné
 * @param g Le groupe à modifier
 * @param resp La réponse à ajouter
 */
void msgtrigger_group_add_repl(trigger_group_t * g, char * resp)
{
	char **tmp, **repl;
	unsigned int i;

	tmp = malloc(sizeof(char*)*(g->resp.nb+1));

	for(i=0 ; i<g->resp.nb ; i++) {
		tmp[i] = g->resp.str[i];
	}

	tmp[g->resp.nb] = resp;

	repl = g->resp.str;
	g->resp.str = tmp;
	g->resp.nb++;
	free(repl);
}

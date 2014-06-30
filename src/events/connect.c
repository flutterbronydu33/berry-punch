#include <berrypunch/events.h>

void event_connect(irc_session_t * session, const char *event, const char *origin, const char **params, unsigned int count)
{
	fprintf(stdout, "[  OK ] Connection established\n");
	irc_cmd_join(session, IRC_CHAN, 0);
}

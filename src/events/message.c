#include <berrypunch/events.h>

void event_messg(irc_session_t * session, const char *event, const char *origin, const char **params, unsigned int count)
{
	fprintf(stdout, "[MESSG] %s on %s : %s\n", origin, params[0], params[1]);
}

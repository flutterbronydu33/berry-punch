#include <berrypunch/events.h>

void event_numeric(irc_session_t * session, unsigned int event, const char * origin, const char ** params, unsigned int count)
{
	unsigned int i;
	switch (event) {
		case 372:
			fprintf(stdout, "[ MOTD] %s\n", params[1]);
			break;
		default:
			fprintf(stdout, "[EVENT] Event %d detected (%d parameter(s))\n", event, count);
			for(i=0 ; i<count ; i++) {
				fprintf(stdout, "\t[%3d] %s\n", i, params[i]);
			}
			break;
	}
}

#include <libgen.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

#include "my_parser.h"
//#include "cli_trans.h"
#include "log.h"

int main(void)
{
	signal(SIGHUP, SIG_DFL);
	signal(SIGINT, SIG_IGN);

	init_readline();
	start_cli();

	return 0;
}

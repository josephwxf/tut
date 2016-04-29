#ifndef __MY_PARSER_H__
#define __MY_PARSER_H__

#include <stdio.h>

#define MAX_CMD_NUM  512
#define MAX_CMD_WORD_NUM 64
#define MAX_CMD_WORD_LEN 16
#define MAX_BUF_SIZE (sizeof(char) * MAX_CMD_WORD_NUM * MAX_CMD_WORD_LEN)

extern int end_of_line;
extern char *helplist[MAX_CMD_NUM][MAX_CMD_WORD_NUM];
extern char *tokenlist[MAX_CMD_WORD_NUM][MAX_CMD_NUM];

extern int start_cli(void);
extern char *back_token_str(char *input);
extern int find_token(char *input);
extern void init_readline(void);
extern char *command_generator(const char *text, int state);
//extern int cli_print_help(char *helplist);
extern int variable_match_check(char *var, const char *str);

#endif

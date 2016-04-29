#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <readline/readline.h>
#include <readline/history.h>

#ifdef UNUSED
#elif defined(__GNUC__)
#  define UNUSED(x) UNUSED_ ## x __attribute__((unused))
#elif defined(__LCLINT__)
#  define UNUSED(x) /*@unused@*/ x
#else
#  define UNUSED(x) x
#endif

#include "my_parser.h"

int get_history_number(char **history_list)
{
	int i = 0;
	int matched_number = 0;
	char *p = NULL;
	char *substr = NULL;
	static char g_rl_str[MAX_BUF_SIZE] = { 0 };

	if (history_list == NULL) {
		return 0;
	}

	memset(g_rl_str, 0, sizeof(char) * MAX_BUF_SIZE);
	strncpy(g_rl_str, rl_line_buffer, MAX_BUF_SIZE);

	for (i = 0, p = g_rl_str;; i++, p = NULL) {
		substr = strtok(p, " \t\n");
		//printf("i:%d, substr:%s;\n", i, substr);
		if (NULL == substr) {
			break;
		} else {
			history_list[i] = substr;
		}
	}
	matched_number = i;

	return matched_number;
}

int token_is_variable(char c)
{
	if (c < 'a' || c > 'z') {
		return 1;
	}

	return 0;
}

int get_history_matched_number(int index, int history_number, char **history_list, int *at_end)
{
	int i = 0;
	int j = 0;
	int matched_number = 0;

	*at_end = 0;

	for (i = 0; i < history_number; i++) {
		if (strncmp(history_list[i], helplist[index][i + 1], strlen(helplist[index][i + 1])) == 0) {
			/* keyword match */
			matched_number++;
		} else if (strncmp(history_list[i], helplist[index][i + 1], strlen(history_list[i])) == 0) {
			/* partly matched keywork */
			//printf("history_list[%d]:%s, helplist[%d][%d]:%s\n", i, history_list[i], index, i+1, helplist[index][i+1]);
			matched_number++;
			if (matched_number == atoi(helplist[index][0])) {
				*at_end = 1;
			}
		} else if (token_is_variable(helplist[index][i + 1][0])) {
			/* for variable, not keyword */
			/* before this position is all matched */
			if (matched_number == i) {
				if (tokenlist[history_number - 1]) {
					if (tokenlist[history_number - 1][0]) {
						int token_len = atoi(tokenlist[history_number - 1][0]);
						//printf("token_len:%d\n", token_len);
						for (j = 0; j < token_len; j++) {
							//printf("tokenlist[%d][%d]:%s\n", history_number-1, j+1, tokenlist[history_number-1][j+1]);
							if (strncmp(history_list[i], tokenlist[history_number - 1][j + 1], strlen(history_list[i])) == 0) {
								//printf("matched!\n");
								break;
							}
						}
						if (j == token_len) {
							matched_number++;
						}
					}
				}
				//matched_number++;
			}
		}
	}
	return matched_number;
}

char *command_generator(const char *text, int state)
{
	static int index = 0;
	static int end = 0;
	static int help_matched = 0;
	static char *help_matched_list[MAX_CMD_NUM] = { 0 };
	static int history_number = 0;
	static char *history_list[MAX_CMD_WORD_NUM] = { 0 };

	int i = 0;
	int j = 0;
	char *token = NULL;
	int at_end = 0;
	int list_index = 0;
	int matched_number = 0;

	if (!state) {
		index = 0;
		end = 0;
		help_matched = 0;
		memset(help_matched_list, 0, sizeof(char *) * MAX_CMD_NUM);

		memset(history_list, 0, sizeof(char *) * MAX_CMD_WORD_NUM);
		history_number = get_history_number(history_list);
	}
	//printf("rl_line_buffer:%s, text:%s, state:%d\n", rl_line_buffer, text, state);

#if 0
	printf("histroy_number:%d\n", history_number);
	for (i = 0; i < history_number; i++) {
		printf("history_list[%d]:%s;\n", i, history_list[i]);
	}
#endif
	if (strcmp(text, "") == 0) {
		list_index = history_number + 1;
	} else {
		list_index = history_number;
	}

	while (helplist[index]) {
		if (helplist[index][0]) {
			if (atoi(helplist[index][0]) >= history_number) {
				matched_number = get_history_matched_number(index, history_number, history_list, &at_end);
				//printf("matched_number:%d, history_number: %d list_index:%d\n", matched_number, history_number, list_index);
				if (matched_number == atoi(helplist[index][0]) && at_end == 0) {
					//printf("%d:matched all, end:%d\n", __LINE__, end);
					token = helplist[index][list_index];
					//printf("line:%d, token:%s\n", __LINE__, token);
					if (!end && strcmp(text, "") != 0) {
						end = 1;
						//token = helplist[index][list_index];
						//printf("line:%d, token:%s\n", __LINE__, token);
						if (token_is_variable(token[0])) {
							if (variable_match_check(token, text) == 0) {
								if (token[0] == '[') {
									/* FIXME: not safe */
									char buf[16] = { 0 };
									strncpy(buf, token + 1, strlen(token) - 2);
									//printf("buf:%s\n", buf);
									if (strncmp(text, buf, strlen(text)) == 0) {
										//printf("match square\n");
										return strdup(buf);
									} else {
										//printf("not match\n");
										return NULL;
									}
								}
								//printf("match variable\n");
								return strdup("");
							} else {
								//printf("not match variable\n");
								return NULL;
							}
						} else {
							//printf("not variable\n");
							return strdup("");
						}
					} else if (!end && token && token_is_variable(token[0])) {
						//printf("text is blank\n");
						end = 1;
						return strdup("");
					} else {
						//printf("at end and not blank\n");
						return NULL;
					}
				}

				if (list_index - matched_number <= 1) {
					token = helplist[index][list_index];
					//printf("token:%s\n", token);
					if (token == NULL) {
						index++;
						return NULL;
					}
					if (strncasecmp(text, token, strlen(text)) == 0 || token_is_variable(token[0])) {
						//printf("match name:%s, index:%d, help_matched:%d\n", token, index, help_matched);
						help_matched_list[help_matched] = token;
						for (i = 0; i < help_matched; i++) {
							//printf("help_matched_list[%d]:%s, token:%s\n", i, help_matched_list[i], token);
							if (strcmp(help_matched_list[i], token) == 0) {
								help_matched_list[help_matched] = NULL;
								break;
							} else if (token_is_variable(token[0]) && strcmp(text, "") != 0 && strncmp(text, help_matched_list[i], strlen(text)) == 0) {
								//printf("variable and matched partly\n");
								break;
							}
						}
						if (token_is_variable(token[0]) && strcmp(text, "") != 0 && help_matched == 0) {
							if (tokenlist[history_number - 1]) {
								if (tokenlist[history_number - 1][0]) {
									int token_len = atoi(tokenlist[history_number - 1][0]);
									//printf("token_len:%d\n", token_len);
									for (j = 0; j < token_len; j++) {
										//printf("tokenlist[%d][%d]:%s\n", history_number-1, j+1, tokenlist[history_number-1][j+1]);
										if (strncmp(text, tokenlist[history_number - 1][j + 1], strlen(text)) == 0) {
											//printf("matched!\n");
											i++;
											break;
										}
									}
								}
							}
						}
						if (i == help_matched) {
							if (token_is_variable(token[0]) && strcmp(text, "") != 0) {
								//printf("variable:%s\n", token);
								if (variable_match_check(token, text) == 0) {
									index++;
									help_matched++;
									return strdup("");
								}
							} else if (matched_number == history_number) {
								//printf("true match name:%s, index:%d\n", token, index);
								index++;
								help_matched++;
								return strdup(token);
							}
						}
					}
				}
			}
			index++;
		} else {
			break;
		}
	}

	return (char *)NULL;
}


char **cmd_completion(const char *text, int UNUSED(start), int UNUSED(end) )
{
	char **matches;
	matches = (char **)NULL;
	matches = rl_completion_matches(text, command_generator);
	return matches;
}

void init_readline(void)
{
	rl_readline_name = "";
	/* replace the default rl_filename_completion_function */
	rl_completion_entry_function = command_generator;
	/* our match function */
	rl_attempted_completion_function = cmd_completion;
}

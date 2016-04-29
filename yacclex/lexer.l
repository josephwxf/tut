%{

#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <readline/readline.h>
#include <readline/history.h>

#include "parser.tab.h"
#include "my_parser.h"
#include "my_lexer.h"
#include "def.h"
char text_cmd[MAX_CLI_CMD_LEN];
#define YY_INPUT(buf, result, max_size)             \
    if (hy_is_interactive()) {                      \
        char *s = NULL;                             \
        while(s == NULL || *s == 0)                 \
            s = readline("CLI> ");                  \
        add_history(s);                             \
        strncpy(buf, s, max_size);                  \
        snprintf(text_cmd, MAX_CLI_CMD_LEN,"%s",buf);\
        strcat(buf, "\n");                          \
        result = strlen(buf);                       \
        free(s);                                    \
    } else {                                        \
        int c = fgetc(yyin);                        \
        result = (c == EOF) ? 0 : (buf[0] = c, 1);  \
    }


#define MAXNAMES 128
#define MAXWORDLEN  257

static char g_name[MAXNAMES][MAXWORDLEN];
static int  g_nameindex = 0;

static char *add_name_table(char *name)
{
    if (g_nameindex < MAXNAMES) {
        strncpy(g_name[g_nameindex], name, MAXWORDLEN);
        g_name[g_nameindex][MAXWORDLEN - 1] = '\0';
        return g_name[g_nameindex++];
    }
        
    fprintf(stderr,"Can't use more than %d names, '%s' discarded!\n", MAXNAMES, name);

    return g_name[g_nameindex];
}

void clear_name_table(void)
{
    g_nameindex = 0;
}

static int str2map(char *s, int *map)
{
    char *ret;
    char buf[80] = {0};
    char *str = buf;
    int a,b,i,tmp;

    if (!s)
        return 1;

    strcpy(buf,s);
    *map = 0;

    while (1) {
        ret = (char *)strsep(&str,",");
        if (ret == NULL)
            break;

        if (strlen(ret) > 2) {
            if (sscanf(ret, "%d-%d", &a, &b) != 2)
                return 1;
            if(a > b){
                tmp = a;
                a = b;
                b = tmp;
            }
            if ((a > b) || (b > 31) || (a < 1))
                return 1;

            for(i = a; i <= b; i++)
            *map |= 1 << (i - 1);
        } else if (strlen(ret) == 1) {
            if ((ret[0] == 'r') || (ret[0] == 'R'))
                *map |= 1 << 4;
            else if ((ret[0] == 'f') || (ret[0] == 'F'))
                *map |= 1 << 5;
            else if ((ret[0] == '*'))
                *map |= PORT_BIT_MASK;
            else {
                a = atoi(ret);
                if ((a > 31) || (a < 1))
                    return 1;
                *map |= 1 << (a - 1);
            }
        } else if (strlen(ret) == 2) {
            a = atoi(ret);
            if ((a > 31) || (a < 1))
                return 1;
            *map |= 1 << (a - 1);
        }
    }

    return 0;
}

%}

/* %x helps */

/* suppresee "yyunput defined but not used" */
%option nounput
%option noinput

smp_num  [1-9][0-9]*
smp_m1 [1-4]|[1-4][-][1-4]|[fF]|[rR]
smp_m2 {smp_m1}|{smp_m1}[,]{smp_m1}
smp_m3 {smp_m2}|{smp_m2}[,]{smp_m2}|[*]
smp_nums {smp_num}|{smp_num}[-]{smp_num}
smp_elem1 {smp_nums}|{smp_nums}[,]{smp_nums}
smp_elem {smp_elem1}|{smp_elem1}([,]{smp_elem1})*|[*]
smp_data {smp_elem}[/]{smp_m3}[/]{smp_elem}
sm_data {smp_elem}[/]{smp_m3}

integer  [0-9]+
hexdigit [0-9a-fA-F]
ident    [@a-zA-Z]+[a-zA-Z0-9_-]*
char     [A-Za-z0-9.+-_/@]
string     \"[A-Za-z0-9_+-\\*/@ ]+\"
hexint   {hexdigit}+
ipnum    [0-9]{1,2}|1[0-9]{1,2}|2[0-4][0-9]|25[0-5]
ipaddr   {ipnum}\.{ipnum}\.{ipnum}\.{ipnum}
ipv6num  {hexdigit}|{hexdigit}{2}|{hexdigit}{3}|{hexdigit}{4}
ipv6addr {ipv6num}:{ipv6num}:{ipv6num}:{ipv6num}:{ipv6num}:{ipv6num}:{ipv6num}:{ipv6num}
macnum   {hexdigit}{2}
macaddr  {macnum}:{macnum}:{macnum}:{macnum}:{macnum}:{macnum}


%%

{smp_data}  {
                char *s;
                char *m;
                char *p;
                char * str = yytext;

                s = (char *)strsep(&str, "/");
                m = (char *)strsep(&str, "/");
                p = (char *)strsep(&str, "/");
                if(str2map(s, &yylval._smp_3d[0]) != 0 || 
                    (yylval._smp_3d[0] & SLOT_BIT_MASK) != yylval._smp_3d[0]) { 
                    memset(yylval._smp_3d, 0, sizeof(yylval._smp_3d)); 
                    return _SMP_; 
                }
                if(str2map(m, &yylval._smp_3d[1]) != 0 || 
                    (yylval._smp_3d[1] & MODULE_BIT_MASK) != yylval._smp_3d[1]) { 
                    memset(yylval._smp_3d, 0, sizeof(yylval._smp_3d)); 
                    return _SMP_;
                }
                if(str2map(p, &yylval._smp_3d[2]) != 0 || 
                    (yylval._smp_3d[2] & PORT_BIT_MASK) != yylval._smp_3d[2]) { 
                    memset(yylval._smp_3d, 0, sizeof(yylval._smp_3d)); 
                    return _SMP_; 
                }
                yylval._smp_3d[0] &= SLOT_BIT_MASK;
                yylval._smp_3d[1] &= MODULE_BIT_MASK;
                yylval._smp_3d[2] &= PORT_BIT_MASK;
                return _SMP_;
            }

{sm_data}   {
    char *s;
    char *m;
    char * str = yytext;

    s = (char *)strsep(&str, "/");
    m = (char *)strsep(&str, "/");
    if(str2map(s, &yylval._sm_3d[0]) != 0 ||
        (yylval._sm_3d[0] & SLOT_BIT_MASK) != yylval._sm_3d[0]) {
        memset(yylval._sm_3d, 0, sizeof(yylval._sm_3d));
        return _SM_;
    }
    if(str2map(m, &yylval._sm_3d[1]) != 0 ||
       (yylval._sm_3d[1] & MODULE_BIT_MASK) != yylval._sm_3d[1]) {
        memset(yylval._sm_3d, 0, sizeof(yylval._sm_3d));
        return _SM_;
    }
    yylval._sm_3d[0] &= SLOT_BIT_MASK;
    yylval._sm_3d[1] &= MODULE_BIT_MASK;
    return _SM_;
        }

{integer}   {
                yylval.ival = atoi(yytext);
                return _INT_;
            }
0x{hexint}  {
                sscanf(yytext, "0x%lx", &(yylval.ival));
                return _INT_;
            }
{ident}        {
                int token;
                token = find_token(yytext);
                if (token > 0) {
                    return token; 
                }
                yylval.sptr = add_name_table(yytext);
                return _NAME_;
            }
 ((ftp)|(http)):\/\/({char}+(:{char}+)*@)*{ipaddr}(:{integer})*\/{char}+    {

            yylval.sptr = add_name_table(yytext);
            return _URL_;
        }
{ipaddr}    {
            yylval.ipaddr = inet_network(yytext);  //以主机字节序存下来
            return _IPADDR_;
        }
{ipv6addr}    {
            unsigned int i8[8];

            sscanf(yytext, "%x:%x:%x:%x:%x:%x:%x:%x", i8, i8 + 1, i8 + 2, i8 + 3, 
            i8 + 4, i8 + 5, i8 + 6, i8 + 7);

            yylval.ipv6addr[0] = i8[0];
            yylval.ipv6addr[1] = i8[1];
            yylval.ipv6addr[2] = i8[2];
            yylval.ipv6addr[3] = i8[3];
            yylval.ipv6addr[4] = i8[4];
            yylval.ipv6addr[5] = i8[5];
            yylval.ipv6addr[6] = i8[6];
            yylval.ipv6addr[7] = i8[7];

            return _IPV6ADDR_;
        }
{macaddr}   {
                unsigned int tmp_mac[6], i;
                sscanf(yytext, "%02x:%02x:%02x:%02x:%02x:%02x", &tmp_mac[0], &tmp_mac[1],
                                &tmp_mac[2], &tmp_mac[3], &tmp_mac[4], &tmp_mac[5]);
                for (i = 0; i < 6; i++) {
                    yylval.mac[i] = (unsigned char)tmp_mac[i];
                }
                return _MAC_;
            }
{string}    {
                int len = strlen(yytext);
                yytext[len - 1] = 0;
                yylval.sptr = add_name_table(yytext + 1);
                return _STRING_;
            }
[\r\n]        return EOS;
[ \t]+          /* ignore whitespace */;
[\x80-\xFF]     {               
                    if (isalpha(yytext[0]))
                    {
                        return yytext[0];
                    }
                    else
                    {
                        return INVALID_CHAR;
                    }
                 }

.                return yytext[0];

%%

int yywrap(void)
{
    return 1;
}

int hy_is_interactive(void)
{
#ifdef YY_FLEX_SUBMINOR_VERSION
    return YY_CURRENT_BUFFER->yy_is_interactive;
#else
    return yy_current_buffer->yy_is_interactive;
#endif    
}

int hy_switch_to_file(FILE* fp)
{
    yy_switch_to_buffer(yy_create_buffer(fp, YY_BUF_SIZE));
    return 0;
}

int hy_switch_to_buffer(char *cmd)
{
    if (cmd) {
        yy_switch_to_buffer(yy_scan_string(cmd));
    }
    return 0;
}


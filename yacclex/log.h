#ifndef _H_LOG_H_
#define _H_LOG_H_
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#define LOGTAG "#01"
#define NETSYSLOG_DEFAULT_PORT 514  /* syslog port */
#define NETSYSLOG_DEFAULT_HOST "127.0.0.1"
#define IPSTR_LEN 16
#define LOG_ADMIN_EN_SW_DEF  0//enable switch default 
#define LOG_USER1_EN_SW_DEF  0
#define LOG_USER2_EN_SW_DEF  0
#define LOG_USER3_EN_SW_DEF  0
#define LOG_USER4_EN_SW_DEF  0
#define LOG_MAIN_EN_SW_DEF  0
#define LOG_DBG_EN_SW_DEF  0
#define LOG_PUB_EN_SW_DEF  1
enum
{
	LOG_ADMIN = 0,//map to log local0: + 24
	LOG_MAIN,
	LOG_USER1,
	LOG_USER2,
	LOG_USER3,
	LOG_USER4,
	LOG_DBG,
	LOG_PUB,
	LOG_ALL_USER,
};

enum {
	NO_TIME = 0,
	RFC_TIME,
	RFC_YEAR,
	RFC_MSEC,
	RFC_YEAR_MSEC,
	HAS_YEAR,
	HAS_YEAR_MSEC,
	LOG_DEF_TF = RFC_TIME,//default time format
};

enum {
	PRIVATE_TYPE = 0,
	PUBLIC_TYPE = 1,
	LOG_DEF_MIBINFO_TYPE = PUBLIC_TYPE,
};
enum {
	TRAP_LOG_DISABLE = 0,
	TRAP_LOG_ENABLE = 1,
	LOG_DEF_TRAP_LOG = TRAP_LOG_DISABLE,
};
enum
{
	LSF_USERID,//log filter userid
	LSF_USERID_PRI,//log filter userid and priority
}
;
enum
{
	LV_FATAL,
	LV_ALERT,
	LV_CRIT,
	LV_ERROR,
	LV_WARN,
	LV_NOTICE,
	LV_INFO,
	LV_DEBUG,
	LV_TRACE,
	LV_UNKNOWN
};
struct log_conf_s
{
	uint8_t enable_sw[LOG_ALL_USER];//enable switch
	uint8_t time_format;
	uint8_t mibinfo_format;
	uint32_t sys_logfile_sz;
	uint32_t nosys_logfile_sz;
#define LOG_DEF_SYS_LFSZ 2560 //default log file size
#define LOG_DEF_NOSYS_LFSZ 17920
	uint8_t enable;
	uint8_t trap_log_en_sw;
};

struct netsyslog_udata {
    int socket;
    int port;
    char hostip[IPSTR_LEN];
    struct sockaddr_in host;
};
extern struct log_conf_s l_log_conf;
extern int myip;
extern char g_buffer[2048];
uint8_t user_show_auth[LOG_ALL_USER];
uint8_t user_enable_auth[LOG_ALL_USER];
uint8_t user_facility_id[LOG_ALL_USER];
extern char* facility_map[];
extern int log_init(void);
extern struct netsyslog_udata sud;
extern void set_log_port(int port);
extern void set_log_hostip(char *ip);
extern int write_log( int facility, int severity, char *prefix, char* msgfmt,...);
extern int vwrite_log( int facility, int severity, char *prefix, const char* msgfmt,va_list args);
extern void log_dump(FILE *fp);
#endif

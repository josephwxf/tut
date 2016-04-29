#define _XOPEN_SOURCE
#include <stdio.h>
#include <string.h>
#include <time.h>

#include "eflags/eflags.h"

/* man page
 *
       char *asctime(const struct tm *tm);
       char *asctime_r(const struct tm *tm, char *buf);

       char *ctime(const time_t *timep);
       char *ctime_r(const time_t *timep, char *buf);

       struct tm *gmtime(const time_t *timep);
       struct tm *gmtime_r(const time_t *timep, struct tm *result);

       struct tm *localtime(const time_t *timep);
       struct tm *localtime_r(const time_t *timep, struct tm *result);

       time_t mktime(struct tm *tm);

	   struct tm {
	       int tm_sec;
	       int tm_min;
	       int tm_hour;
	       int tm_mday;
	       int tm_mon;
	       int tm_year;
	       int tm_wday;
	       int tm_yday;
	       int tm_isdst;
	   };
*/

static void dump_tm( struct tm *tm)
{
    printf("+-------+-------+-------+-------+-------+-------+-------+-------+-------+\n"); 
    printf("|  sec  |  min  |  hour |  mday |  mon  |  year |  wday |  yday | isdst |\n"); 
    printf("+-------+-------+-------+-------+-------+-------+-------+-------+-------+\n"); 
    printf("|  %3d  |  %3d  |  %4d |  %4d |  %3d  |  %4d |  %4d |  %4d | %5d |\n", 
            tm->tm_sec, tm->tm_min, tm->tm_hour,
            tm->tm_mday, tm->tm_mon, tm->tm_year,
            tm->tm_wday, tm->tm_yday,
            tm->tm_isdst
            ); 
    printf("+-------+-------+-------+-------+-------+-------+-------+-------+-------+\n"); 
}

int ex_tm()
{
    time_t t, t2;
    struct tm tm;

    t = time(NULL);
    tm = *gmtime(&t);
    printf("asctime = [%s]\n", asctime(&tm));
    printf("ctime = [%s]\n", ctime(&t));
    dump_tm(&tm);
    t2 = mktime(&tm);
    printf("%ld \n", t-t2);

    tm.tm_mday -= 100;
    t = mktime(&tm);
    dump_tm(&tm);
    printf("%s\n", ctime(&t));
}

int ex_strftime()
{
    struct tm tm;
    char buf[255];

    memset(&tm,  0,  sizeof(struct tm));
    strptime("2001-11-12 18:31:01",  "%Y-%m-%d %H:%M:%S",  &tm);
    strftime(buf,  sizeof(buf),  "%d %b %Y %H:%M",  &tm);
    puts(buf);

    return 0; 
}

int ex_strptime()
{
    struct tm tm;
    char *s;

    memset(&tm,  0,  sizeof(struct tm));
    if ( (s = strptime("2001-11-12 18:31:62",  "%Y-%m-%d %H:%M:%S",  &tm)) != NULL ) {
        printf("[%s]\n", s );
    } else { 
        printf("ERROR\n" );
        memset(&tm,  0,  sizeof(struct tm));
    }
    dump_tm(&tm);
    printf("%s\n", asctime(&tm));
    mktime(&tm);
    printf("%s\n", asctime(&tm));

    return 0; 
}

DEFINE_function(ex_tm); 
DEFINE_function(ex_strftime); 
DEFINE_function(ex_strptime); 


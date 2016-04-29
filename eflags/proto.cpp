#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <netdb.h>

#include <google/gflags.h>
#include "eflags/eflags.h"

DEFINE_int32(stayopen, 0,  ""); 

static void dump_prot(struct protoent *pp)
{
    int x; 

    printf("%s:\n"
            "\tProtocol: %d\n"
            "\tAliases:    ",
            pp->p_name,
            pp->p_proto);
    for ( x=0; pp->p_aliases[x] != NULL; ++x )
        printf("%s ",pp->p_aliases[x]);
    putchar('\n');
}

int ex_byname(void)
{
    struct protoent *pp;

    setprotoent(FLAGS_stayopen); 

    if ( (pp = getprotobyname("tcp")) != NULL ) {
        dump_prot(pp); 
    }
    if ( (pp = getprotobyname("TCP")) != NULL ) {
        dump_prot(pp); 
    }
    return 0; 
}

int ex_get(void)
{
    struct protoent *pp;

    for (int i=0; i<5; i++) {
        errno = 0;
        if ( !(pp = getprotoent()) )
            break;

        dump_prot(pp); 
    }

    if ( errno != 0 &&  errno != ENOENT ) 
        fprintf(stderr, "%s: getprotoent(3) %d\n", strerror(errno),errno);

    endprotoent(); 

    return 0;
}

int ex_set(void)
{
    struct protoent *pp;

    errno = 0;

    if ( (pp = getprotoent())!=NULL ) dump_prot(pp); 
    if ( (pp = getprotoent())!=NULL ) dump_prot(pp); 

    setprotoent(FLAGS_stayopen); 

    if ( (pp = getprotoent())!=NULL ) dump_prot(pp); 
    if ( (pp = getprotoent())!=NULL ) dump_prot(pp); 

    endprotoent(); 

    return 0; 

}

DEFINE_function(ex_set); 
DEFINE_function(ex_get); 
DEFINE_function(ex_byname); 

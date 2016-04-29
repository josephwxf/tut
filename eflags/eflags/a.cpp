#include <stdio.h>
#include "eflags.h"

int fa(void)
{
    printf("%s\n", __func__ ); 
    return 0; 
}


DEFINE_function(fa); 


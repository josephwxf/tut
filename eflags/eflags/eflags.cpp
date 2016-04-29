#include <iostream>
#include "eflags.h"

using namespace std; 

int eflags::add(string name, int (*f)())
{
    list[name]=f; 
    return 0; 
}

int eflags::invoke(string name)
{
    if(list[name])
        list[name](); 
    return 0; 
}

eflags *h = NULL; 

int eflags_define_func(string name, int (*f)())
{
    if ( h == NULL )
        h = new eflags; 
    return h->add(name, f); 
}

int eflags_invoke_func(string name)
{
    if ( h != NULL )
        return h->invoke(name); 
    return 0; 
}

void eflags_shutdown(void)
{
    if( h != NULL ) 
        delete h; 
}

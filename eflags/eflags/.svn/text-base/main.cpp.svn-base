#include <iostream>
#include "eflags.h"

using namespace std; 

static int f(void)
{
    cout << __func__ << endl; 
}

DEFINE_function(f); 

int main(int argc, const char *argv[])
{

    eflags_define_func("abc", f); 

    if( argc == 2 ) { 
        eflags_invoke_func(argv[1]); 
    }

    eflags_shutdown(); 

    return 0;
}

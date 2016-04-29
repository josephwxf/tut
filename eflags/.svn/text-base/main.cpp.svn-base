#include <iostream>
#define STRIP_FLAG_HELP 1 
#include <google/gflags.h>
#include "eflags/eflags.h"

int main(int argc, char *argv[])
{

    google::ParseCommandLineFlags(&argc,  &argv,  true); 

    if( argc == 2 ) { 
        eflags_invoke_func(argv[1]); 
    }

    eflags_shutdown(); 

    google::ShutDownCommandLineFlags();

    return 0;
}

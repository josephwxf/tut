#include <iostream>
#include <map>

using namespace std; 

class eflags {
    public:
        int add(string , int(*)()); 
        int invoke(string); 
    private:
        map <string, int(*)()> list; 
}; 

//extern eflags *h ; 

extern int eflags_define_func( string, int(*)()); 
extern int eflags_invoke_func( string ); 
extern void eflags_shutdown(void); 

#define DEFINE_function( func ) \
    static const int no_use_##func = eflags_define_func(#func, func)


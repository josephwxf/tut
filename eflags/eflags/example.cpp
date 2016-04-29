#include <iostream>
#include <map>

using namespace std; 

class handler {
    public:
        int add(string , int(*)()); 
        int invoke(string); 
    private:
        map <string, int(*)()> list; 
}; 

int handler::add(string name, int (*f)())
{
    list[name]=f; 
    return 0; 
}

int handler::invoke(string name)
{
    if(list[name])
        list[name](); 
    return 0; 
}

static int f()
{
    cout << __func__ << endl; 
    return 0; 
}

handler h; 

int main(int argc, const char *argv[])
{
    if( argc != 2 ) { 
        cout << "Usage:" << argv[0] << " abc" << endl; 
        return 0; 
    }

    h.add("abc", f); 

    h.invoke(argv[1]); 

    return 0;
}

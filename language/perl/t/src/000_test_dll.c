#include <windows.h>
#include <windef.h>
typedef void (*f_void_str)(char *);
int main(int argc, char **argv, char **env)
{
    HINSTANCE handle; 
    f_void_str print_a_string;
    puts("1..1");
    handle=LoadLibrary("t/lib/test_mod.dll");
    print_a_string=(f_void_str) GetProcAddress(handle,"print_a_string");
    print_a_string("ok\n");
}

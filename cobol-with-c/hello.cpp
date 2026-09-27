#include <algorithm>
#include <cstdio>

extern "C" int max(int a, int b)
{
    return std::max(a, b);
}

extern "C" void display_number(int n)
{
    static_cast<void>(printf("%d\n", n));
}

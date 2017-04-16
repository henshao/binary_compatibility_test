
#include "Bar.h"

using namespace std;

int main()
{
    Bar *bar = new Bar();
//    bar->member0 = new string("member0");
    bar->member1 = new string("member1");
    bar->member2 = new string("member2");
    bar->member3 = new string("member3");
    bar->func2();
    delete bar;

    return 0;
}

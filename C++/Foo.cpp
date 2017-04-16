
#include "Foo.h"

using namespace std;

void Foo::func1() {
}

void Foo::func2() {
    cout << "member2 : " << *(this->member2) << endl;
}

Foo::~Foo() {
}

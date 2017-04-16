
#include "Bar.h"
#include <iostream>

void Bar::func3() {
    cout << "member3: " << *(this->member3) << endl;
}

Bar::~Bar() {
}


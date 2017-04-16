#import <objc/runtime.h>
#include "Bar.h"

int main(int argc, char * argv[]) {

    Bar* bar = [Bar new];
    bar->member1 = @"member1";
    bar->member2 = @"member2";
    bar->member3 = @"member3";
    [bar func2];

    NSUInteger size = class_getInstanceSize([Bar class]);
    NSLog(@"Bar size: %lu", size);
//    bar.prop3 = @"abc";
//    NSLog(@"prop3: %@", bar.prop3);
//    [bar func3];

    return 0;   
}

> 鉴于目前动态库在iOS App中使用越来越广泛，二进制的兼容问题可能会成为一个令人头疼的问题。本文主要对比一下C++、Objecive-C和Swift的二进制兼容问题。

### iOS端动态库使用情况

0. iOS 8开始支持App使用动态库。
0. 苹果对提交的App的`__TEXT__`段大小是有限制的，很多巨无霸App容易超出这个限制。iOS9之前每个架构的`__TEXT__`段比较小，iOS9放大到了500MB。详细情况请看：[To submit an app for review](https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/iTunesConnect_Guide/Chapters/SubmittingTheApp.html)。
0. 开源库只能通过Podfile做源码引入，源码依赖，编译非常慢。
0. 可持续构建也需要基于苹果的环境，比如使用Mac Pro/Mac Mini构建。Mac Pro比较昂贵，Mac mini性能不行，构建一次需要花费大量时间。
0. 大型App为了加快编译速度，可以维护自己的私有仓库，把依赖的库尽量编译成Framework，加快编译速度。
0. 目前Swift目前基于动态库开发。
0. 基于动态库构建App，升级一个动态库需要将整个依赖树编译一遍。尤其是一些频繁变动的组件，比如UIKit，视觉组件比较基础，并且经常需要变动。

### 测试环境

C++、OC和Swift分别实现Foo这个基类，然后再实现Bar这个子类，main则使用Bar类打印成员变量的信息。给Foo类添加成员变量，重新编译Foo，Bar和main不变，然后观察执行结果。

代码地址：[ABI_test](https://github.com/henshao/ABI_test)。

### 测试结果

0. C++会出现错位，但是没有崩溃。二进制也是比较脆弱的。
0. OC能正常工作。OC非常适合基于动态库的组件方式。
0. Swift构造Bar对象就会崩溃。现状让我们非常头疼。

```
warning: (x86_64) libBar.dylib unable to load swift module 'Bar' (failed to get module 'Bar' from AST context:
error: missing required module 'Foo'
)
* thread #1, queue = 'com.apple.main-thread', stop reason = EXC_BAD_ACCESS (code=2, address=0x1000a7a98)
  * frame #0: 0x00007fff90419fd1 libobjc.A.dylib`realizeClass(objc_class*) + 1155
    frame #1: 0x00007fff9041d26d libobjc.A.dylib`_class_getNonMetaClass + 127
    frame #2: 0x00007fff9041d053 libobjc.A.dylib`lookUpImpOrForward + 232
    frame #3: 0x00007fff9041cad4 libobjc.A.dylib`_objc_msgSend_uncached + 68
    frame #4: 0x00000001000a4df5 libBar.dylib`type metadata accessor for Bar at Bar.swift:0
    frame #5: 0x0000000100001584 main`main at main.swift:7
    frame #6: 0x00007fff90d0f235 libdyld.dylib`start + 1
    frame #7: 0x00007fff90d0f235 libdyld.dylib`start + 1
```

### 结果分析

0. C++的设计没有考虑到二进制兼容的问题，所以兼容很一般。
0. OC使用方法和属性都使用消息派发，增加和删除方法，移动方法的顺序，都不会导致问题；另外增对成员变量的改变做了支持，所以二进制兼容完美。
0. 作为一种崭新的语言，Swift的二进制兼容最差，匪夷所思啊。

另外大家讨论的时候也提到C++虚函数改变顺序会不会出问题。针对这个问题我验证了一下，确认C++虚函数表里面函数的顺序完全取决于函数声明的顺序。

比如Foo有func1和func2两个虚函数，调换func1和func2的顺序，不重新编译main。在main里面调用func2，实际上会调用到func1。

```
#include "Foo.h"

using namespace std;

int main()
{
    Foo *foo = new Foo();
    foo->func2();
    delete foo;

    return 0;
}   
```

```
$ lldb main
(lldb) target create "main"
Current executable set to 'main' (x86_64).
(lldb) br set -f main.cpp -l 17
Breakpoint 1: where = main`main + 65 at main.cpp:17, address = 0x0000000100000f11
(lldb) run
Process 11179 launched: '/Users/henshao/ABI_test/C++/main' (x86_64)
Process 11179 stopped
* thread #1, queue = 'com.apple.main-thread', stop reason = breakpoint 1.1
    frame #0: 0x0000000100000f11 main`main at main.cpp:17
   14       delete bar;*/
   15   
   16       Foo *foo = new Foo();
-> 17       foo->func2();
   18       delete foo;
   19   
   20       return 0;
(lldb) x/10a *(void**)foo
0x1000900f0: 0x000000010008eff0 libfoo.dylib`Foo::func2() at Foo.cpp:10
0x1000900f8: 0x000000010008ee40 libfoo.dylib`Foo::func1() at Foo.cpp:6
0x100090100: 0x000000010008f050 libfoo.dylib`Foo::~Foo() at Foo.cpp:15
0x100090108: 0x000000010008f070 libfoo.dylib`Foo::~Foo() at Foo.cpp:15
0x100090110: 0x00007fff999b9bb8 libc++abi.dylib`vtable for __cxxabiv1::__class_type_info + 16
0x100090118: 0x000000010008ff00 libfoo.dylib`typeinfo name for Foo
0x100090120: 0x0000000000000000
0x100090128: 0x0000000000000000
0x100090130: 0x0000000000000000
0x100090138: 0x0000000000000000
```

### 参考文章

0. [C++ ABI Compliance Checker](https://lvc.github.io/abi-compliance-checker/)
0. [Objective-C类成员变量深度剖析](http://quotation.github.io/objc/2015/05/21/objc-runtime-ivar-access.html)
0. [Non Fragile ivars](http://www.jianshu.com/p/3b219ab86b09)
0. [Objc源码](https://github.com/opensource-apple/objc4)
0. [Swift库二进制接口(ABI)兼容性研究](http://www.jianshu.com/p/5860f5542f21)

### 最后的最后

欢迎广大有为青年补充一个Java的版本😀

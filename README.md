> 鉴于目前动态库在iOS App中使用越来越广泛，二进制的兼容问题可能会成为一个令人头疼的问题。本文主要对比一下Objecive-C和Swift的二进制兼容问题。

### 测试环境

OC和Swift分别实现Foo这个基类，然后再实现Bar这个子类，main则使用Bar类打印成员变量的信息。给Foo类添加成员变量，重新编译Foo和main，然后观察执行结果。

### 测试结果

1. OC能正常工作
2. Swift会崩溃

### 结果分析

1. 
2. Swift每个成员变量都会生成三个函数，并且放在witness table的最前面，导致。

### 参考文章

1. [Objective-C类成员变量深度剖析](http://quotation.github.io/objc/2015/05/21/objc-runtime-ivar-access.html)
2. [Swift库二进制接口(ABI)兼容性研究](http://www.jianshu.com/p/5860f5542f21)

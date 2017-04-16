> 鉴于目前动态库在iOS App中使用越来越广泛，二进制的兼容问题可能会成为一个令人头疼的问题。本文主要对比一下C++、Objecive-C和Swift的二进制兼容问题。

### iOS端动态库使用情况

1. 开源库只能通过Podfile做源码引入，源码依赖，编译非常慢。
2. 可持续构建也需要基于苹果的环境，比如使用Mac Pro/Mac Mini构建。Mac Pro比较昂贵，Mac mini性能不行，构建一次需要花费大量时间。
3. 大型App为了加快编译速度，可以维护自己的私有仓库，把依赖的库尽量编译成Framework，加快编译速度。
4. 目前Swift目前基于动态库开发。
5. 基于动态库构建App，升级一个动态库需要将整个依赖树编译一遍。尤其是一些频繁变动的组件，比如UIKit，视觉组件比较基础，并且经常需要变动。

### 测试环境

C++、OC和Swift分别实现Foo这个基类，然后再实现Bar这个子类，main则使用Bar类打印成员变量的信息。给Foo类添加成员变量，重新编译Foo，Bar和main不变，然后观察执行结果。

代码地址：[ABI_test](https://github.com/henshao/ABI_test)。

### 测试结果

1. C++会出现错位，但是没有崩溃。二进制也是比较脆弱的。
2. OC能正常工作。OC非常适合基于动态库的组件方式。
3. Swift构造Bar对象就会崩溃。现状让我们非常头疼。

### 结果分析

1. C++的设计没有考虑到二进制兼容的问题，所以兼容很一般。
2. OC使用方法和属性都使用消息派发，增加和删除方法，移动方法的顺序，都不会导致问题；另外增对成员变量的改变做了支持，所以二进制兼容完美。
3. 作为一种崭新的语言，Swift的二进制兼容最差，匪夷所思啊。

### 参考文章

1. [C++ ABI Compliance Checker](https://lvc.github.io/abi-compliance-checker/)
2. [Objective-C类成员变量深度剖析](http://quotation.github.io/objc/2015/05/21/objc-runtime-ivar-access.html)
3. [Non Fragile ivars](http://www.jianshu.com/p/3b219ab86b09)
4. [Objc源码](https://github.com/opensource-apple/objc4)
5. [Swift库二进制接口(ABI)兼容性研究](http://www.jianshu.com/p/5860f5542f21)

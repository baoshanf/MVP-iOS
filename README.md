# MVP-iOS

#简书地址：https://www.jianshu.com/p/abea207c23e7

前言
随着移动互联网承载着越来越错综复杂的业务，传统的MVC已经不能完全满足我们的需求，于是就出现了MVVM、MVP、VIPER等架构。其中，最广为人知的是MVVM，虽说上手没那么容易，但是出于它能为controller减压的优越性，被广泛使用。因此，关于MVVM的文章比比皆是。

或许很多同学都会取出各架构的优越性，结合产品的业务来搭建架构。比如猿题库的MVC+VM架构，利用MVC的易读性加上一层对数据的处理层，也能大大减小controller的负担。MVP实际用起来确实没有MVVM用起来效果明显，但是不排除有小伙伴的公司业务用MVP会比较合适，但是目前关于iOS MVP架构的文章并不多。我们来谈正事：

MVP
MVP模式是MVC模式的一个演化版本（好像所有的模式都是出自于MVC~~），MVP全称Model-View-Presenter。顾名思义，

Model：与MVC中的model没有太大的区别。主要提供数据的存储功能，一般都是用来封装网络获取的json数据的集合。Presenter通过调用Model进行对象交互。

View：这里的View与MVC中的V又有一些小差别，这个View可以是viewcontroller、view等控件。Presenter通过向View传model数据进行交互。

Presenter：作为model和view的中间人，从model层获取数据之后传给view，使得View和model没有耦合。

说了那么多，总得来说MVP的好处就是解除view与model的耦合，使得view或model有更强的复用性。

上一下MVP的概念图：



下面我们结合代码来看：

首先来看项目的文件结构：


mvp文件结构
代码给出了一个控制器作为例子，大家可以看到，home里面包含了四个文件夹，model、controller、presenter、view。home当中的HomePresenter是继承presenter的，HomePresenter根据业务的不同来实现自己的presenter。

网络
网络的底层还是用AFNetWorking来实现，HttpClient具体的封装大概为


网络层
这里说明一下，这里用delegate而不用block做回调是因为后面的HomePresenter需要对返回的数据进行处理，为了然后结构更加清晰，遵守一个函数一个功能的原则。后面还会再说一下。HttpClient提供了赋值responseHandle的init函数，外部可以通过init函数来绑定responseHandle协议。

再来看一下上面那个responseHandle这个proctocol的结构：


responseHandle
目前只写了success和fail两个回调，这里为了方便演示，只写了一个参数，这个一块大伙可以根据自己的业务需求来写。

结合HttpClient来看一下，我们分别在AFNetWorking请求成功、失败的回调当中处理delegate。简单说，HttpResponseHandle就是嫁接presenter和HttpClient的协议~~

接下来看一下父类Presenter的设计。先看接口：


Presenter.h

Presenter.m
这里采用了泛型，简单说泛型就是有点类似objective-c中的id类型，大伙可以自行Google一下。父类Presenter主要是提供绑定View和解绑View的功能。

基于网络请求设计的HttpPresenter，HttpPresenter继承与Presenter，遵守HttpResponseHandle协议，并且拥有自己的泛型，HttpClient成员变量。供外部调用HttpClient，降低耦合性。


HttpPresenter.m
应用
大致就可以分为这几层了，看一下怎么应用到实例中。

上文的文件目录中可以看出我们每个功能模块都有presenter这个文件夹，对每个模块的presenter都是为这个模块服务，我们可以把请求、储存数据的活动放在这里。并且在这层presenter中处理model数据。为了使controller得到的数据能直接使用，可以多写一个protocol，来承上启下，HomeViewProtocol就为了这个产生。

@protocol HomeViewProtocol

- (void)onGetMovieListSuccess:(HomeModel*)homeModel;

- (void)onGetMovieListFail:(NSInteger) errorCode des:(NSString*)des;

@end

先看了protocol，HomePresenter看起来就清晰多了吧


HomePresenter.m
在看一下controller的调用，初始化HomePresenter，然后绑定一下自己的视图，


controller对presenter的调用
遵循HomeViewProtocol


controller实现HomeViewProtocol协议


db
db这层也简单的封装了一下fmdb，代码已更新。

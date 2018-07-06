#前言

AFNetworking为我们封装了一系列的网络服务，直接使用基本上可以满足大多数需求。随着需求不断增加，架构不断完善，直接使用AFNetworking未免会代码冗余，于是就出现了各种对AFNetworking的二次封装。
###现有的AFNetworking二次封装优秀框架
- [YTKNetworking](https://github.com/yuantiku/YTKNetwork)
YTKNetwork是基于AFNetworking的高级请求实用,适用于稍微复杂的项目，而不适用于简单的个人项目
- [PPNetworkHelper](https://github.com/jkpang/PPNetworkHelper)
PPNetworkHelper对AFNetworking 3.x 与YYCache的二次封装,封装常见的GET、POST、文件上传/下载、网络状态监测的功能、方法接口简洁明了,并结合YYCache实现对网络数据的缓存,简单易用,不用再写FMDB那烦人的SQL语句,一句代码搞定网络数据的请求与缓存. 无需设置,无需插件,控制台可直接打印json中文字符,调试更方便
- [XMNetworking](https://github.com/kangzubin/XMNetworking)
XMNetworking是一个轻量的，简单易用但功能强大的网络库
###一套适合公司业务的网络框架
[YTKNetworking](https://github.com/yuantiku/YTKNetwork) 与 [PPNetworkHelper](https://github.com/jkpang/PPNetworkHelper)都是面向相对复杂的项目而生，我们没用到缓存部分，同时我们更倾向于轻量级的网络框架。但是我们又崇尚YTKNetworking那样的风格，结合当前项目架构，借鉴 [XMNetworking](https://github.com/kangzubin/XMNetworking)，于是写了能cover住的[HKHttpManager](https://github.com/baoshanf/HKHttpManager)。
# 解释 [HKHttpManager](https://github.com/baoshanf/HKHttpManager)
`HKHttpManager` 由`configure`、`logger`、`manager`、`response`、`request`组成。
- `request`的组成
```
/**
请求 Base URL，优先级高于 [HKHttpConfigure generalServer];
*/
@property (nonatomic, copy) NSString *baseURL;

/**
请求路径 eg: /login2
*/
@property (nonatomic, copy) NSString *requestURL;

/**
请求头，默认为空 @{}
*/
@property (nonatomic, strong) NSDictionary *requestHeader;

/**
请求参数，加密参数 默认为空 @{}
*/
@property (nonatomic, strong) NSDictionary *encryptParams;

/**
请求参数，不用加密 默认为 @{}
*/
@property (nonatomic, strong) NSDictionary *normalParams;

/**
请求方式 默认为 HKRequestTypePost
*/
@property (nonatomic, assign) HKHttpRequestType requestMethod;


/**
请求方式string
*/
@property (nonatomic,copy) NSString *requestMethodName;

/**
请求超时时间 默认 30s
*/
@property (nonatomic, assign) NSTimeInterval reqeustTimeoutInterval;

/**
api 版本号，默认 1.0
*/
@property (nonatomic, copy) NSString *apiVersion;

/**
重试次数，默认为 0
*/
@property (nonatomic, assign) UInt8 retryCount NS_UNAVAILABLE;

/**
生成请求

@return NSURLRequest
*/
- (NSURLRequest *)generateRequest;
```
![三个Request类](https://upload-images.jianshu.io/upload_images/4248528-c4588ca4005e093e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
以上属性都可以再在初始化之后设置，并且都设置了默认值。同时有些相同的部分你也可以修改`generateRequest`,无论是`chainRequest`还是`groupRequest`都需要以`HKHttpRequest`为请求`request`。`chainRequest`和`groupRequest`某种意义上都是为了在`HKHttpmanager`调用方便而封装。
- `HKHttpmanager`组成
`HKHttpManager`主要提供发起请求接口，普通请求可通过`block`赋值`request`。
```
/**
直接进行请求，不进行参数及 url 的包装

@param request 请求实体类
@param result 响应结果
@return 该请求对应的唯一 task id
*/
- (NSString *_Nullable)sendRequest:(nonnull HKHttpRequest *)request complete:(nonnull HKHttpResponseBlock) result;


/**
发送网络请求，紧凑型

@param requestBlock 请求配置 Block
@param result 请求结果 Block
@return 该请求对应的唯一 task id
*/
- (NSString *_Nullable)sendRequestWithConfigBlock:(nonnull HKRequestConfigBlock )requestBlock complete:(nonnull HKHttpResponseBlock) result;
```
- `HKHttpManager+Group`与`HKHttpManager+Chain`
特意将`Group`和`Chain`封装成了类别，单独处理`HKHTTPGroupRequest`、`HKHttpChainRequest`并行串行等关系，在这里将`request`序列化，再调用`sendRequest:`请求。
```
- (NSString *)sendGroupRequest:(nullable HKGroupRequestConfigBlock)configBlock
complete:(nullable HKGroupResponseBlock)completeBlock;


- (void)cancelGroupRequest:(NSString *)taskID;
@end
```

![结构图.png](https://upload-images.jianshu.io/upload_images/4248528-47ab20b16890fd91.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
# 使用 [HKHttpManager](https://github.com/baoshanf/HKHttpManager)
#####普通 `request`
1. `#import "HKHttpManagerHeader.h"`,建议在`APPDelegate`初始化`baseURL`
```
[HKHttpConfigure shareInstance].generalServer = @"https://www.apiopen.top/";
```
2. 根据需要设置公共请求头`generalHeaders`、公共参数`generalParameters`
```
[HKHttpConfigure shareInstance].generalHeaders = @{@"token":token};
[HKHttpConfigure shareInstance].generalParameters = @{@"openid":@"xxx"};
```
3. 构建`request`
```
HKHttpRequest *request = [[HKHttpRequest alloc] init];
request.requestURL = @"satinApi";
request.normalParams = @{@"type":@"1",
@"page":@"1"
};
request.requestMethod = HKHttpRequestTypeGet;
```
4.发起请求
```
[[HKHttpManager shareManager] sendRequest:request complete:^(HKHttpResponse * _Nullable response) {
NSLog(@"%@",response.content);
}];
```
或者在`block`里构建`request`
```
[[HKHttpManager shareManager] sendRequestWithConfigBlock:^(HKHttpRequest * _Nullable request) {
request.requestURL = @"satinApi";
request.normalParams = @{@"type":@"1",
@"page":@"1"
};
request.requestMethod = HKHttpRequestTypeGet;
} complete:^(HKHttpResponse * _Nullable response) {
if (response.status == HKHttpResponseStatusSuccess) {
NSLog(@"%@",response.content);
}
}];
```
#####使用`chainQequest`实现链式请求
```
[[HKHttpManager shareManager] sendChainRequest:^(HKHttpChainRequest * _Nullable chainRequest) {
[chainRequest onFirst:^(HKHttpRequest * _Nullable request) {
request.requestURL = @"satinApi";
request.normalParams = @{@"type":@"1",
@"page":@"1"
};
request.requestMethod = HKHttpRequestTypeGet;
}];
[chainRequest onNext:^(HKHttpRequest * _Nullable request, HKHttpResponse * _Nullable responseObject, BOOL * _Nullable isSent) {
request.requestURL = @"satinApi";
request.normalParams = @{@"type":@"1",
@"page":@"2"
};
request.requestMethod = HKHttpRequestTypeGet;
}];
[chainRequest onNext:^(HKHttpRequest * _Nullable request, HKHttpResponse * _Nullable responseObject, BOOL * _Nullable isSent) {
request.requestURL = @"satinApi";
request.normalParams = @{@"type":@"1",
@"page":@"3"
};
request.requestMethod = HKHttpRequestTypeGet;
}];

} complete:^(NSArray<HKHttpResponse *> * _Nullable responseObjects, BOOL isSuccess) {

}];
```
####使用`groupQequest`实现无序批量请求
```
[[HKHttpManager shareManager] sendGroupRequest:^(HKHttpGroupRequest * _Nullable groupRequest) {
for (NSInteger i = 0; i < 5; i ++) {
HKHttpRequest *request = [[HKHttpRequest alloc] init];
request.requestURL = @"satinApi";
request.normalParams = @{@"type":@"1",
@"page":@"1"
};
request.requestMethod = HKHttpRequestTypeGet;
[groupRequest addRequest:request];
}
} complete:^(NSArray<HKHttpResponse *> * _Nullable responseObjects, BOOL isSuccess) {

}];
```
##TODO
`HKHttpManager`目前能满足公司的业务，但是许多细节方面还需优化，例如：
1. 实现断点续传
2. `groupRequest`和`chainRequest`与`request`一致，支持两种请求方式（目前只能在`block`中对`groupRequest`、`chainRequest`赋值）。
3. `configure`这方面还需要优化，增加对`request`默认请求的配置
#End
GitHub地址在这里： [HKHttpManager](https://github.com/baoshanf/HKHttpManager)
谢谢各位阅读，能力有限，希望大家能多提点优化建议和看法！

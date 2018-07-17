# YFLogManager
Check log on the ios device

平时查看 log 时都需要直接连接 Xcode 通过控制台查看， 嫌弃太麻烦了， 实在太懒， 就想写一个直接在 iOS 设备上查看 log 的类

# 思路

> 怎么在真机上获取到 log 呢？

对于 NSLog 就不去顾虑了， 因为在自己的项目中实在是很少用到 NSLog， 都是自己定义的 Log， 如下

```objective-c
#ifdef DEBUG
#define YFLog(fmt, ...) ((NSLog((@"%@" fmt), @"", ##__VA_ARGS__)));
#else
#define YFLog(fmt, ...)
#endif
```

最简单的就是把这个打印的信息直接写在沙盒中， 然后在某个地方读取出来即可



> 怎么存入沙盒？时机呢？

调用 YFLog 的时候直接将 log 写入沙盒的一个 txt 文件中， 这里采用发通知的方式， 简化宏定义的内容。

所以就在 YFLogManager 中写了一个`-registerLogMgr`的方法， 注册三个通知： 

- saveLog
- checkLog
- clearLog

然后在响应的方法中将 Notifycation 中的log 写入沙盒即可

那么现在 YFLog 就变成了这样子

```objective-c
#ifdef DEBUG
#define YFLog(fmt, ...) ((NSLog((@"%@" fmt), @"", ##__VA_ARGS__))); \
([[NSNotificationCenter defaultCenter] postNotificationName:@"saveLog" object:nil userInfo:@{@"log":[NSString stringWithFormat:fmt,##__VA_ARGS__]}]);
#else
#define YFLog(fmt, ...)
#endif
```

# 怎么使用

1. 定义 log 时只需要在输出完成后发个通知即可
2. 在适当时机注册 LogMgr， 调用`-registerLogMgr`方法
3. 给一个查看 log 的入口， 发通知`[[NSNotificationCenter defaultCenter] postNotificationName:@"checkLog" object:nil]; `
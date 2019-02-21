# iOS | Socket

### 一、目录
1. 基础概念
2. CocoAsycSocket源码分析
3. 构建TCP框架

### 二、内容缩略图
![内容缩略图](https://upload-images.jianshu.io/upload_images/1893416-87e535e94e1cc0c4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 三、其他
#### 3.1 Socket位置
![Socket位置](https://upload-images.jianshu.io/upload_images/1893416-6c01b53cf5f78ceb.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 3.2 TCP客户—服务器程序设计基本框架
![TCP客户—服务器程序设计基本框架](https://upload-images.jianshu.io/upload_images/1893416-34e84245d10273be.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 3.3 TCP建立连接~TCP断开连接
![TCP建立连接~TCP断开连接](https://upload-images.jianshu.io/upload_images/1893416-45f869f5eb090586.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

注:
简介一下几个标志，SYN（`synchronous`），同步标志；ACK (`Acknowledgement`），即确认标志；seq(`Sequence Number`)，序列号的意思；另外还有四次握手的fin，应该是`final`，表示结束标志。

#### 3.4 数据封装与解封装过程
![数据封装与解封装总过程](https://upload-images.jianshu.io/upload_images/1893416-de36cf775bea737f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 3.4.1 数据封装
![数据封装 图示一](https://upload-images.jianshu.io/upload_images/1893416-09b82c7214d924f7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![数据封装 图示二](https://upload-images.jianshu.io/upload_images/1893416-d968629720676b04.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 3.4.2 数据解封装
![数据解封装 图示一](https://upload-images.jianshu.io/upload_images/1893416-35d1ce70df7eb9a7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![数据解封装 图示二](https://upload-images.jianshu.io/upload_images/1893416-a01f8da5a41dd726.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

注:
* mac地址只在本地有效，通过路由器传输过程，mac地址信息会发生变化
* 路由器根据路由表识别目标IP地址网段信息，确认是否可以进行转发，或是进行数据包的丢弃

#### 3.5 CocoaAsyncSocket源码分析
![CocoaAsyncSocket源码分析](https://upload-images.jianshu.io/upload_images/1893416-10ec1445bd532622.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 学习：
* [OSI七层模型、数据封装与解封装过程、TCP三次握手、四次挥手](http://blog.51cto.com/13055758/2061535)
* [iOS socket网络编程(一)](https://www.jianshu.com/p/0a050f098a1e)
* [iOS socket网络编程（二）](https://www.jianshu.com/p/ea48c093d8cc)

//
//  Demo5ViewController.m
//  SocketProject
//
//  Created by 帅斌 on 2019/2/20.
//  Copyright © 2019 dongming. All rights reserved.
//

#import "Demo5ViewController.h"

#import <SocketRocket.h>
#import "Person.h"

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


@interface Demo5ViewController ()<SRWebSocketDelegate>
// websocket 实例对象
@property (nonatomic, strong) SRWebSocket *websocket;
// 发送的内容textFiled
@property (strong, nonatomic)  UITextField *contentTF;
// 心跳timer
@property (nonatomic, strong) NSTimer *heartTimer;
// 重连等待时间
@property (nonatomic, assign) NSInteger reconnectTime;

@property (nonatomic, strong) Person *p;

@end

@implementation Demo5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self setupHeartBeat];
    
}
// 断开连接
- (void)didClickDisconnecttSocket:(id)sender {
    //    [self.websocket close];
    //    self.websocket.delegate = nil;
    //    self.websocket          = nil;
    [self disconnectSocket];
}

// 简历socket连接
- (void)didClickConnectSocket:(id)sender {
    if (self.websocket) {
        NSLog(@"websocket 已经存在");
        return;
    }
    NSURL *url = [NSURL URLWithString:@"ws://127.0.0.1:8090"];
    self.websocket = [[SRWebSocket alloc] initWithURL:url];
    self.websocket.delegate = self;
    [self.websocket open];
}

// 发送消息
- (void)didClickSendAction:(id)sender {
    if (self.websocket) {
        [self.websocket send:self.contentTF.text];
        self.contentTF.text = @"";
    }
}

// 发送ping
- (void)didClickSendPingAction:(id)sender {
    [self ping];
}

// 重连机制
- (void)reconnectSocket{
    // 1:关闭socket
    [self disconnectSocket];
    
    // 3.1 超时判断
    if (self.reconnectTime>64) {
        NSLog(@"网络超时,不在重连");
        return;
    }
    
    // 3.3 延时等待重连
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.reconnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 2:去创建连接新的socket
        NSURL *url = [NSURL URLWithString:@"ws://127.0.0.1:8090"];
        self.websocket = [[SRWebSocket alloc] initWithURL:url];
        self.websocket.delegate = self;
        [self.websocket open];
    });
    
    // 3:发现问题,每次都是毫无处理的重连是不合理的,对那些经常出问题的肯定是有问题的
    // 需要做处理 重连次数 重连时间要处理  2^5 = 64
    // 3.2 超时时长处理
    if (self.reconnectTime == 0) {
        self.reconnectTime = 2;
    }else{
        self.reconnectTime *= 2;
    }
    
}

// 关闭socket
- (void)disconnectSocket{
    if (self.websocket) {
        [self.websocket close];
        self.websocket.delegate = nil;
        self.websocket = nil;
        [self destoryHeartBeat];
    }
}

// 心跳处理 : 不断去骚扰
- (void)setupHeartBeat{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 为了方便其他地方调用是不是可以抽取出来一个销毁方法
        //        if (self.heartTimer) {
        //            [self.heartTimer invalidate];
        //            self.heartTimer = nil;
        //        }
        [self destoryHeartBeat];
        __weak typeof(self) weakSelf = self;
        self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:15 repeats:YES block:^(NSTimer * _Nonnull timer) {
            //尽量简单 节约
            //发送心跳 和后台可以约定发送什么内容
            //一般可以调用ping  我这里根据后台的要求 发送了data给他
            NSData *heartData = [@"heartBeat" dataUsingEncoding:NSUTF8StringEncoding];
            [weakSelf.websocket sendPing:heartData];
            NSLog(@"heartBeat");
            // 也可以不断发
            //[weakSelf.websocket send:@"heartBeat"];
        }];
        // 注意别被UI影响
        [[NSRunLoop currentRunLoop] addTimer:self.heartTimer forMode:NSRunLoopCommonModes];
    });
}

- (void)destoryHeartBeat{
    
    //当然这里还以更加严谨一点: 因为已经在主线程了
    dispatch_main_async_safe(^{
        if (self.heartTimer && [self.heartTimer respondsToSelector:@selector(isValid)] && [self.heartTimer isValid]) {
            [self.heartTimer invalidate];
            self.heartTimer = nil;
        }
    });
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        if (self.heartTimer) {
    //            [self.heartTimer invalidate];
    //            self.heartTimer = nil;
    //        }
    //    });
}

// ping
- (void)ping{
    if (self.websocket && self.websocket.readyState == SR_OPEN) {
        NSData *pingData = [@"ping" dataUsingEncoding:NSUTF8StringEncoding];
        //        [self.websocket sendPing:nil];
        [self.websocket sendPing:pingData];
    }
}

#pragma mark - SRWebSocketDelegate

// 接受消息
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"接收到了:%@",message);
}

// 建立连接的回调
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"webSocket 建立连接打开了");
    // 建立连接成功,开启心跳
    [self setupHeartBeat];
}
// 错误回调
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"发生错误:%@",error);
    
    [self disconnectSocket];
}
// 关闭错误原因
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
    NSLog(@"错误码:%ld---reason:%@ ---wasClean:%d",code,reason,wasClean);
}
// 接收到pong信息
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    //    NSString *pingStr =
    NSLog(@"接收到了pong 信息 %@",pongPayload);
}

// Return YES to convert messages sent as Text to an NSString. Return NO to skip NSData -> NSString conversion for Text messages. Defaults to YES.
- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket{
    // NO 就是不要把data转成string
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

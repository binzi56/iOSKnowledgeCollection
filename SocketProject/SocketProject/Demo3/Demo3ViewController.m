//
//  Demo3ViewController.m
//  SocketProject
//
//  Created by 帅斌 on 2019/2/19.
//  Copyright © 2019 dongming. All rights reserved.
//
//  客户端

#import "Demo3ViewController.h"
#import <GCDAsyncSocket.h>

// 数据类型
#define kcImageDataType 0x00000001
#define kcVideoDataType 0x00000002

@interface Demo3ViewController ()<GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket *socket;
@end

@implementation Demo3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didClickConnectSocket:(id)sender {
    
    // 创建socket
    if (self.socket == nil)
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    // 连接socket
    if (!self.socket.isConnected){
        NSError *error;
        [self.socket connectToHost:@"127.0.0.1" onPort:8060 withTimeout:-1 error:&error];
        if (error) NSLog(@"%@",error);
    }
}

- (void)didClickSendAction:(id)sender {
    // 发送图片
    UIImage *image = [UIImage imageNamed:@"test"];
    NSData  *imageData  = UIImagePNGRepresentation(image);
    
    unsigned int command = kcImageDataType;
    [self sendData:imageData dataType:command];
    
}

- (void)didClickDisconnectAction:(id)sender {
    //    [self.socket disconnect];
    //    self.socket = nil;
    // 发送视频
    NSData  *videoData  = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"q1.mp4" ofType:nil]];
    unsigned int command = kcVideoDataType;
    [self sendData:videoData dataType:command];
    
}

- (void)sendData:(NSData *)data dataType:(unsigned int)dataType{
    
    NSMutableData *mData = [NSMutableData data];
    // 计算数据总长度 data
    unsigned int dataLength = 4+4+(int)data.length;
    NSData *lengthData = [NSData dataWithBytes:&dataLength length:4];
    [mData appendData:lengthData];
    
    // 数据类型 data
    // 2.拼接指令类型(4~7:指令)
    NSData *typeData = [NSData dataWithBytes:&dataType length:4];
    [mData appendData:typeData];
    
    // 最后拼接数据
    [mData appendData:data];
    NSLog(@"发送数据的总字节大小:%ld",mData.length);
    
    // 发数据
    [self.socket writeData:mData withTimeout:-1 tag:10086];
    
}

#pragma mark - GCDAsyncSocketDelegate

//已经连接到服务器
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(nonnull NSString *)host port:(uint16_t)port{
    
    NSLog(@"连接成功 : %@---%d",host,port);
    [self.socket readDataWithTimeout:-1 tag:10086];
}

// 连接断开
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"断开 socket连接 原因:%@",err);
}

//已经接收服务器返回来的数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"接收到tag = %ld : %ld 长度的数据",tag,data.length);
    
    /**
     *  解析服务器返回的数据
     */
    // 获取总的数据包大小
    NSData *totalSizeData = [data subdataWithRange:NSMakeRange(0, 4)];
    unsigned int totalSize = 0;
    [totalSizeData getBytes:&totalSize length:4];
    NSLog(@"响应总数据的大小 %u",totalSize);
    
    // 获取指令类型
    NSData *commandIdData = [data subdataWithRange:NSMakeRange(4, 4)];
    unsigned int commandId = 0;
    [commandIdData getBytes:&commandId length:4];
    
    // 结果
    NSData *resultData = [data subdataWithRange:NSMakeRange(8, 4)];
    unsigned int result = 0;
    [resultData getBytes:&result length:4];
    
    NSMutableString *str = [NSMutableString string];
    if (commandId == kcImageDataType) {
        [str appendString:@"图片 "];
    }
    
    if(result == 1){
        [str appendString:@"上传成功"];
    }else{
        [str appendString:@"上传失败"];
    }
    NSLog(@"%@",str);
    
    [self.socket readDataWithTimeout:-1 tag:10086];
    
}

//消息发送成功 代理函数 向服务器 发送消息
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"%ld 的发送数据成功",tag);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

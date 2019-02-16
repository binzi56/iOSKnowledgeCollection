//
//  Demo1ViewController.m
//  NetworkProgramming
//
//  Created by 帅斌 on 2019/2/14.
//  Copyright © 2019年 dongming. All rights reserved.
//


/*
 注意:
 NSURLSession是NSURLConnection 的替代者，在2013年苹果全球开发者大会（WWDC2013）随ios7一起发布，是对NSURLConnection进行了重构优化后的新的网络访问接口。从iOS9.0开始， NSURLConnection中发送请求的两个方法已过期（同步请求，异步请求），初始化网络连接（initWithRequest: delegate:）的方法也被设置为过期，系统不再推荐使用，建议使用NSURLSession发送网络请求。
 
 */

#import "Demo1ViewController.h"

@interface Demo1ViewController ()<NSURLConnectionDataDelegate>

@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor brownColor];
//    [self dataDemo];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //    NSURL *url = [[NSURL alloc] initWithString:@"http://172.16.80.101/123.mp4"];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    //    NSURLConnection *connection = [[NSURLConnection alloc]
    //                                   initWithRequest:request
    //                                   delegate:self
    //                                   startImmediately:NO];
    //
    //    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    //    [[NSRunLoop currentRunLoop] run]; // 默认不开启
    //    NSLog(@"end");
    //    [connection start];
    
    NSLog(@"开始请求数据");
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSURL *url = [[NSURL alloc] initWithString:@"http://127.0.0.1:8080/123.mp4"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
        NSURLConnection *connection = [[NSURLConnection alloc]
                                       initWithRequest:request
                                       delegate:self
                                       startImmediately:NO];
        [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run]; // 默认不开启
        NSLog(@"end");
        [connection start];
        
    });
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"请求失败 -- %@",error);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    // tu 无符号长整型
    NSLog(@"接收到:%tu",data.length);
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"%@",response);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"终于加载完成了");
}



#pragma mark - session
- (void)sessionDemo{
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://172.16.80.101/netDemo.json"];
    /**
     NSURLRequestUseProtocolCachePolicy = 0,   // http 协议策略
     NSURLRequestReloadIgnoringLocalCacheData = 1, // 不缓存
     NSURLRequestReturnCacheDataElseLoad = 2,  // 有缓存加载缓存 加载网络
     NSURLRequestReturnCacheDataDontLoad = 3,  // 有缓存加载缓存  或则不加载
     */
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:30];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@",result);
    }];
    [task resume];
}

- (void)dataDemo{
    NSURL *url = [[NSURL alloc] initWithString:@"http://172.16.80.101/netDemo.json"];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"%@",result);
}



@end

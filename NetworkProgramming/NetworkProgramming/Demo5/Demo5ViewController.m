//
//  Demo5ViewController.m
//  NetworkProgramming
//
//  Created by 帅斌 on 2019/2/15.
//  Copyright © 2019年 dongming. All rights reserved.
//
/*
 NSURLProtocol作用:
 重定向网络请求（可以解决之前电信的 DNS 域名劫持问题）
 缓存
 自定义 Response （过滤敏感信息）
 全局网络请求设置
 HTTP Mocking
 */
#import "Demo5ViewController.h"
#import <WebKit/WebKit.h>
#import <AFNetworking.h>
#import "KCURLProtocol.h"

@interface Demo5ViewController ()<NSURLSessionDataDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WKWebView *wk;

@end

@implementation Demo5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSURLProtocol registerClass:[KCURLProtocol class]];
    [KCURLProtocol hookNSURLSessionConfiguration];
}

// webView加载
- (void)didClickLoadBDAction:(id)sender {
    
    [self.webView removeFromSuperview];
    [self.wk removeFromSuperview];
    self.webView = nil;
    self.wk = nil;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 300, self.view.bounds.size.width, 300)];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
}

// WK加载
- (void)didClickLoadWKBDAction:(id)sender {
    
    [self.webView removeFromSuperview];
    [self.wk removeFromSuperview];
    self.webView = nil;
    self.wk = nil;
    
    self.wk = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 300, self.view.bounds.size.width, 300)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [self.wk  loadRequest:request];
    [self.view addSubview:self.wk ];
}

// session加载
- (void)didClickLocahostAction:(id)sender {
    
    
    NSString *url  = @"http://www.baidu.com";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //    NSURLSession *session = [NSURLSession sharedSession];
    //    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //
    //        NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    //    }];
    
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:mainQueue];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    
    [dataTask resume];
}

// conntion加载
- (void)didClickUrlConnection:(id)sender {
    
    NSString *url  = @"http://www.baidu.com";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSLog(@"%@---%@",response,data);
    }];
    
}


- (void)didClickAFNAction:(id)sender {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url  = @"http://www.baidu.com";
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"AFN---%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"AFN---%@",error);
    }];
}





#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    NSLog(@"data == %@",data);
}

- (void)dealloc{
    [NSURLProtocol unregisterClass:[KCURLProtocol class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

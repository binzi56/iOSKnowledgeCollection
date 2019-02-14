//
//  Demo9VC.m
//  Multithreading
//
//  Created by 帅斌 on 2019/2/14.
//  Copyright © 2019年 dongming. All rights reserved.
//

#import "Demo9VC.h"

@interface Demo9VC ()
@property (nonatomic, strong) NSOperationQueue *queue;

@end
@implementation Demo9VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.queue = [[NSOperationQueue alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self demo];
}


- (void)demo{
    NSBlockOperation *bo1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:0.5];
        NSLog(@"请求token");
    }];
    
    NSBlockOperation *bo2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:0.5];
        NSLog(@"拿着token,请求数据1");
    }];
    
    NSBlockOperation *bo3 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:0.5];
        NSLog(@"拿着数据1,请求数据2");
    }];
    
    //因为异步,不好控制,我们借助依赖
    [bo2 addDependency:bo1];
    [bo3 addDependency:bo2];
    //注意这里一定不要构成循环依赖 : 不会报错,但是所有操作不会执行
    //[bo1 addDependency:bo3];
    //waitUntilFinished 堵塞线程
    [self.queue addOperations:@[bo1,bo2,bo3] waitUntilFinished:NO];
    
    NSLog(@"执行完了?我要干其他事");
}

- (void)pauseOrContinue:(id)sender {
    
    if (self.queue.operationCount == 0) {
        NSLog(@"当前没有操作,没有必要挂起和继续");
        return;
    }
    // 一个细节 正在执行的操作无法挂起
    if (self.queue.suspended) {
        NSLog(@"当前是挂起状态,准备继续");
    }else{
        NSLog(@"当前为执行状态,准备挂起");
    }
    self.queue.suspended = !self.queue.isSuspended;
    
}

- (void)cancel:(id)sender {
    
    // 执行结果发现,正在执行的操作无法取消,因为这要回想到之前的NSThread
    // 只有在内部判断才能取消完毕
    // 取消操作之后,再点继续,发现没有调度的任务没了 会
    [self.queue cancelAllOperations];
}

@end

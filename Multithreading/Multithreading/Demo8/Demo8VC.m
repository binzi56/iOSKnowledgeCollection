//
//  Demo8VC.m
//  Multithreading
//
//  Created by 帅斌 on 2019/2/14.
//  Copyright © 2019年 dongming. All rights reserved.
//

#import "Demo8VC.h"
@interface Demo8VC ()
@property (nonatomic, strong) NSOperationQueue *queue;

@end
@implementation Demo8VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.queue = [[NSOperationQueue alloc] init];

    
    [self demo];
}


/**
 NSInvocationOperation : 创建操作 ---> 创建队列 ---> 操作加入队列
 */
- (void)demo{
    //1:创建操作
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(handleInvocation:) object:@"123"];
    //2:创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //3:操作加入队列 --- 操作会在新的线程中
    [queue addOperation:op];
}

- (void)handleInvocation:(id)op{
    NSLog(@"%@ --- %@",op,[NSThread currentThread]);
}


/**
 手动调起操作
 */
- (void)demo1{
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(handleInvocation:) object:@"123"];
    // 注意 : 如果该任务已经添加到队列,你再手动调回出错
    // something other than the operation queue it is in is trying to start the receiver'
    // NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // [queue addOperation:op];
    // 手动调起操作,默认在当前线程
    [op start];
}

/**
 blockOperation 初体验
 */
- (void)demo2{
    
    //1:创建blockOperation
    NSBlockOperation *bo = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@",[NSThread currentThread]);
    }];
    //1.1 设置监听
    bo.completionBlock = ^{
        NSLog(@"完成了!!!");
    };
    //2:创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //3:添加到队列
    [queue addOperation:bo];
    
}

/**
 测试操作与队列的执行效果:异步并发
 */
- (void)demo3{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    for (int i = 0; i<20; i++) {
        [queue addOperationWithBlock:^{
            NSLog(@"%@---%d",[NSThread currentThread],i);
        }];
    }
}


/**
 优先级,只会让CPU有更高的几率调用,不是说设置高就一定全部先完成
 */
- (void)demo4{
    
    NSBlockOperation *bo1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"第1个操作 %d --- %@", i, [NSThread currentThread]);
        }
    }];
    // 设置优先级 - 最高
    // CPU有更高的几率调用
    bo1.qualityOfService = NSQualityOfServiceUserInteractive;
    
    //创建第二个操作
    NSBlockOperation *bo2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"第二个操作 %d --- %@", i, [NSThread currentThread]);
        }
    }];
    // 设置优先级 - 最低
    bo2.qualityOfService = NSQualityOfServiceBackground;
    
    //2:创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //3:添加到队列
    [queue addOperation:bo1];
    [queue addOperation:bo2];
}

/**
 可执行代码块
 */
- (void)demo5{
    //创建操作
    NSBlockOperation *ob = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@",[NSThread currentThread]);
    }];
    //添加执行代码块
    [ob addExecutionBlock:^{
        NSLog(@"这是一个执行代码块 - %@",[NSThread currentThread]);
    }];
    // 执行代码块 在新的线程  创建的操作在当前线程
    //[ob start];
    
    //利用队列,两个都在新的线程中
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:ob];
    
}

/**
 线程通讯
 */
- (void)demo6{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"shuaibin";
    [queue addOperationWithBlock:^{
        NSLog(@"%@ = %@",[NSOperationQueue currentQueue],[NSThread currentThread]);
        //模拟请求网络
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"%@ --%@",[NSOperationQueue currentQueue],[NSThread currentThread]);
        }];
    }];
}

- (void)demo7{
    
    self.queue.name = @"shuaibin";
    self.queue.maxConcurrentOperationCount = 2;
    [self.queue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
        for (int i = 0; i<10; i++) {
            NSLog(@"%d-%@",i,[NSThread currentThread]);
        }
    }];
    
}

@end

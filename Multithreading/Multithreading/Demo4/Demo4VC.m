//
//  Demo4VC.m
//  Multithreading
//
//  Created by 帅斌 on 2019/2/13.
//  Copyright © 2019年 dongming. All rights reserved.
//

#import "Demo4VC.h"

@interface Demo4VC ()

@end

@implementation Demo4VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //mei tuan
    __block int a = 0;
    while (a < 5) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"currentThread:%@========a:%d", [NSThread currentThread], a);
        });
    }
    NSLog(@"currentThread:%@==******==a:%d", [NSThread currentThread], a);

    
//    [self mainSyncTest];
}

/**
 主队列同步
 不会开线程
 */
- (void)mainSyncTest{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (int i = 0; i<20; i++) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"%d-%@",i,[NSThread currentThread]);
            });
        }
    });
    
    NSLog(@"hello queue");
}
/**
 主队列异步
 不会开线程 顺序
 */
- (void)mainAsyncTest{
    for (int i = 0; i<20; i++) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%d-%@",i,[NSThread currentThread]);
        });
    }
    NSLog(@"hello queue");
}


/**
 全局异步
 全局队列:一个并发队列
 */
- (void)globalAsyncTest{
    for (int i = 0; i<20; i++) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"%d-%@",i,[NSThread currentThread]);
        });
    }
    
    for (int i = 0; i<1000000; i++) {
    }
    NSLog(@"hello queue");
}

/**
 全局同步
 全局队列:一个并发队列
 */
- (void)globalSyncTest{
    for (int i = 0; i<20; i++) {
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"%d-%@",i,[NSThread currentThread]);
        });
    }
    
    for (int i = 0; i<1000000; i++) {
    }
    NSLog(@"hello queue");
}




/**
 同步并发
 不开线程:就算并发出来,没有坑位接受,所以顺序执行
 */
- (void)concurrentSyncTest{
    
    //1:创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("Cooci", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i<20; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"%d-%@",i,[NSThread currentThread]);
        });
    }
    
    for (int i = 0; i<1000000; i++) {
        
    }
    NSLog(@"hello queue");
}


/**
 异步并发
 一次多个 没有顺序
 开线程
 */
- (void)concurrentAsyncTest{
    //1:创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("Cooci", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i<20; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%d-%@",i,[NSThread currentThread]);
        });
    }
    
    for (int i = 0; i<1000000; i++) {
        
    }
    
    NSLog(@"hello queue");
    
}


/**
 串行异步队列
 1:异步执行：会开启线程,顺序跟着耗时走
 */
- (void)serialAsyncTest{
    //1:创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("Cooci", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i<20; i++) {
        dispatch_async(queue, ^{
            NSLog(@"%d-%@",i,[NSThread currentThread]);
        });
    }
    
    for (int i = 0; i<1000000; i++) {
        
    }
    
    NSLog(@"hello queue");
    
}

/**
 串行同步队列
 1:同步执行：一行一行代码从上向下执行，当前代码不执行完成，不会执行后续代码 同步不会开启线程
 2:串行队列：一个一个的调度任务，前一个任务没有执行完成，不会调度后面的任务
 */
- (void)serialSyncTest{
    //1:创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("Cooci", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i<20; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"%d-%@",i,[NSThread currentThread]);
        });
    }
    
}


/**
 * 还原最基础的写法,很重要
 */

- (void)syncTest{
    
    //1:创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("Cooci", DISPATCH_QUEUE_SERIAL);
    //下面的方式也可以,但是用得少, DISPATCH_QUEUE_SERIAL 更加易懂
    //dispatch_queue_t queue = dispatch_queue_create("Cooci", NULL);
    
    //2:创建任务
    dispatch_block_t taskBlock = ^{
        NSLog(@"%@",[NSThread currentThread]);
    };
    //3:利用函数把任务放入队列
    dispatch_sync(queue, taskBlock);
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    /**
     关于队列的说明:
     1:来了一个任务 -->
     2:线程调度池发觉有了任务过来,先去找有没有闲置的队列
     2.1:如果有就会把任务加到队列上
     2.2:如果没有就会创建队列,并把任务加到队列上去
     3:调度队列中的任务在线程执行
     4:执行完毕就会闲置队列,超出时限就会销毁队列
     */
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"%@",[NSThread currentThread]);
    });
}


@end

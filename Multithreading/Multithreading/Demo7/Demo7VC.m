//
//  Demo7VC.m
//  Multithreading
//
//  Created by 帅斌 on 2019/2/14.
//  Copyright © 2019年 dongming. All rights reserved.
//

#import "Demo7VC.h"

@interface Demo7VC ()

@end

@implementation Demo7VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //信号量
    //总结：由于设定的信号值为3，先执行三个线程，等执行完一个，才会继续执行下一个，保证同一时间执行的线程数不超过3
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
    
    //任务1
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"执行任务1");
        sleep(1);
        NSLog(@"任务1完成");
        dispatch_semaphore_signal(semaphore);
    });
    
    //任务2
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"执行任务2");
        sleep(1);
        [NSThread sleepForTimeInterval:1.0f];
        NSLog(@"任务2完成");
        dispatch_semaphore_signal(semaphore);
    });
    
    //任务3
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"执行任务3");
        sleep(1);
        NSLog(@"任务3完成");
        dispatch_semaphore_signal(semaphore);
    });
}



@end

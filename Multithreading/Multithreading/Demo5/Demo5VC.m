//
//  Demo5VC.m
//  Multithreading
//
//  Created by 帅斌 on 2019/2/13.
//  Copyright © 2019年 dongming. All rights reserved.
//

#import "Demo5VC.h"

@interface Demo5VC ()
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation Demo5VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self demo3];
}


/**
 可变数组 线程不安全 解决办法
 */
- (void)demo3{
    
    // 顺序执行
    // 线程安全
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("cooci", DISPATCH_QUEUE_CONCURRENT);
    //    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(0, 0);
    
    // signal
    for (int i = 0; i<10000; i++) {
        dispatch_async(concurrentQueue, ^{
            NSString *imageName = [NSString stringWithFormat:@"%d.jpg", (i % 10)];
            NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            NSLog(@"%zd --- %@ ---- %d",self.mArray.count,[NSThread currentThread],i);
            dispatch_barrier_async(concurrentQueue, ^{
                [self.mArray addObject:image];
                NSLog(@"%zd --- %@ ---- %d",self.mArray.count,[NSThread currentThread],i);
            });
            //            @synchronized(self){
            //               [self.mArray addObject:image];
            //            }
            if (i==1999) {
                NSLog(@":%zd",self.mArray.count);
            }
        });
    }
}



//水印 栅栏函数影响
- (void)demo1{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("cooci", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrentQueue, ^{
        NSString *logoStr = @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3351002169,4211425181&fm=27&gp=0.jpg";
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoStr]];
        UIImage *image = [UIImage imageWithData:data];
        [self.mArray addObject:image];
    });
    
    dispatch_async(concurrentQueue, ^{
        NSString *logoStr = @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3033952616,135704646&fm=27&gp=0.jpg";
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoStr]];
        UIImage *image = [UIImage imageWithData:data];
        [self.mArray addObject:image];
    });
    
    
    
    
    //加载完毕了 栅栏函数上
    __block UIImage *newImage = nil;
    dispatch_barrier_async(concurrentQueue, ^{
        
        for (int i = 0; i<self.mArray.count; i++) {
            UIImage *waterImage = self.mArray[i];
            newImage = waterImage;
        }
    });
    
    
    dispatch_async(concurrentQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = newImage;
        });
    });
}

- (void)demo2{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("cooci", DISPATCH_QUEUE_CONCURRENT);
    /* 1.异步函数 */
    dispatch_async(concurrentQueue, ^{
        for (NSUInteger i = 0; i < 5; i++) {
            NSLog(@"download1-%zd-%@",i,[NSThread currentThread]);
        }
    });
    
    dispatch_async(concurrentQueue, ^{
        for (NSUInteger i = 0; i < 5; i++) {
            NSLog(@"download2-%zd-%@",i,[NSThread currentThread]);
        }
    });
    
    /* 2. 栅栏函数 */
    dispatch_barrier_sync(concurrentQueue, ^{
        NSLog(@"---------------------%@------------------------",[NSThread currentThread]);
    });
    NSLog(@"加载那么多,喘口气!!!");
    /* 3. 异步函数 */
    dispatch_async(concurrentQueue, ^{
        for (NSUInteger i = 0; i < 5; i++) {
            NSLog(@"日常处理3-%zd-%@",i,[NSThread currentThread]);
        }
    });
    NSLog(@"接着干!!!!");
    
    dispatch_async(concurrentQueue, ^{
        for (NSUInteger i = 0; i < 5; i++) {
            NSLog(@"日常处理4-%zd-%@",i,[NSThread currentThread]);
        }
    });
}


- (NSMutableArray *)mArray{
    if (!_mArray) {
        _mArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _mArray;
}

@end

//
//  Demo6VC.m
//  Multithreading
//
//  Created by 帅斌 on 2019/2/13.
//  Copyright © 2019年 dongming. All rights reserved.
//

#import "Demo6VC.h"

@interface Demo6VC ()
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation Demo6VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 300, 300, 200)];
    self.imageView.image = [UIImage imageNamed:@"backImage"];
    [self.view addSubview:self.imageView];
    
    [self groupDemo];
}

/**
 调度组测试
 */
- (void)groupDemo{
    
    //创建调度组
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_async(group, queue, ^{
        NSString *logoStr = @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3351002169,4211425181&fm=27&gp=0.jpg";
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoStr]];
        UIImage *image = [UIImage imageWithData:data];
        [self.mArray addObject:image];
    });
    
    dispatch_group_async(group, queue, ^{
        
        // afn --- sdk : queue: com.afn.cn
        
        NSString *logoStr = @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3033952616,135704646&fm=27&gp=0.jpg";
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:logoStr]];
        UIImage *image = [UIImage imageWithData:data];
        [self.mArray addObject:image];
    });
    
    long timeout = dispatch_group_wait(group, 0.5);
    
    if (timeout == 0) {
        __block UIImage *newImage = nil;
        //所有线程处理完毕后执行
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"数组个数:%ld",self.mArray.count);
            for (int i = 0; i<self.mArray.count; i++) {
                UIImage *waterImage = self.mArray[i];
                newImage = waterImage;
            }
            self.imageView.image = newImage;
        });
    }else{
        NSLog(@"你超时了,该方法性能不给力");
    }
    
}

/**
 调度组内部方法 enter - leave
 */
- (void)groupDemo2{
    
    // 问题: 如果 dispatch_group_enter 多 dispatch_group_leave 不会调用通知
    // dispatch_group_enter 少 dispatch_group_leave  奔溃
    // 成对存在
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"第一个走完了");
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"第二个走完了");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"所有任务完成,可以更新UI");
    });
    
}

/**
 延迟测试
 */
- (void)delayDemo{
    
    //NSEC_PER_SEC : 1000000000ull 纳秒每秒 0.0000001 可以这么做参数
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    //串行队列来测试 延迟的方法是不是异步的!
    dispatch_queue_t queue = dispatch_queue_create("com.tz.cn", DISPATCH_QUEUE_SERIAL);
    dispatch_after(time, queue, ^{
        NSLog(@"延迟打印");
    });
    NSLog(@"打印完了?");
}


#pragma mark - lazy

- (NSMutableArray *)mArray{
    if (!_mArray) {
        _mArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _mArray;
}
@end

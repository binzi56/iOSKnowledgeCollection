//
//  Demo1VC.m
//  Multithreading
//
//  Created by 帅斌 on 2019/2/2.
//  Copyright © 2019年 dongming. All rights reserved.
//

#import "Demo1VC.h"

@interface Demo1VC ()

@end

@implementation Demo1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // thread
    [NSThread detachNewThreadSelector:@selector(threadTest) toTarget:self withObject:nil];
}

- (void)threadTest{
    // 多核 CPU
    NSLog(@"begin");
    // 现象: 堵塞
    NSInteger count = 1000 * 100;
    // nslog IO 性能优化 : debug DBGLOG realese
    for (NSInteger i = 0; i < count; i++) {
        // 文字常量区: 未初始化的全局变量 静态变量
        // 五大区: 堆  栈 常量区  文字常量区 代码区
        // 代码区 : 二进制代码
        // 栈 : study函数 栈帧 局部变量 函数参数 出栈 入栈  pop push nav
        NSInteger num = i;
        // 常量区
        NSString *name = @"HelloWorld";
        NSString *myName = [NSString stringWithFormat:@"%@ - %zd", name, num];
        NSLog(@"%@", myName);
    }
    NSLog(@"over");
}
@end

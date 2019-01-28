//
//  Demo1ViewController.m
//  PerformanceOptimization
//
//  Created by 帅斌 on 2018/9/25.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "Demo1ViewController.h"

@interface Demo1ViewController ()

@end

@implementation Demo1ViewController

// 全局区
int g1;
static int s1;

// 数据段
int g2 = 0;
static int s2 = 0;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 栈区
    int i = 10;
    int j = 10;
    NSObject *obj = [NSObject new];
    
    NSLog(@"==========栈区==============");
    NSLog(@"%p", &i);
    NSLog(@"%p", &j);
    NSLog(@"%p", &obj);
    
    // 堆区
    NSObject *obj1 = [NSObject new];
    NSObject *obj2 = [NSObject new];
    NSLog(@"==========堆区==============");
    NSLog(@"%p", obj);
    NSLog(@"%p", obj1);
    NSLog(@"%p", obj2);

    // 全局区
    NSLog(@"%p", &g1);
    NSLog(@"%p", &s1);
    
    NSLog(@"%p", &g2);
    NSLog(@"%p", &s2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)printDemo1{
    NSLog(@"打印demo1成功");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

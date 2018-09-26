//
//  Demo2ViewController.m
//  PerformanceOptimization
//
//  Created by 帅斌 on 2018/9/26.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "Demo2ViewController.h"

@interface Demo2ViewController ()

@end

@implementation Demo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // tag + Data
    for (int i = 0; i < 10; i++) {
//        NSNumber* num = @(i*0xFFFFFFFFFFFFFFF);
        NSNumber* num = @(i*1.0f);
        NSLog(@"%p", num);
    }
    
    NSString* s = @"123";
    NSString* s1 = [NSString stringWithFormat:@"123"];
    NSString* s2 = [NSString stringWithFormat:@"12344556679"];
    NSLog(@"s = %p \n s1 = %p \n s2 = %p \n", s, s1, s2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

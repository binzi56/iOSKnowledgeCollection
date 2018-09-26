//
//  Demo3ViewController.m
//  PerformanceOptimization
//
//  Created by 帅斌 on 2018/9/26.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "Demo3ViewController.h"


//struct Test {
//    Test() {
//        printf("Test() \n");       //入栈调用
//    }
//
//    ~Test() {                      //出栈调用
//        printf("~Test() \n");
//    }
//};

@interface Demo3ViewController ()

@end

@implementation Demo3ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.基本调用过程
    @autoreleasepool {
        
    }
    
    
    /*
     { __AtAutoreleasePool __autoreleasepool;
     
     }
     
     
     struct __AtAutoreleasePool {
     __AtAutoreleasePool() {
     atautoreleasepoolobj = objc_autoreleasePoolPush();
     
     }
     ~__AtAutoreleasePool() {
     objc_autoreleasePoolPop(atautoreleasepoolobj);
     
     }
     void * atautoreleasepoolobj;
     };
     
     */
    
    
    //结构体讲解
//    {
//        Test t;
//    }
    
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

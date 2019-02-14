//
//  ViewController.m
//  Multithreading
//
//  Created by 帅斌 on 2018/9/25.
//  Copyright © 2018年 personal. All rights reserved.
//

#import "ViewController.h"
#import "Demo2VC.h"

@interface ViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    UITableView * _mainTableView;
    NSArray     * _dataArr;
}

@end

@implementation ViewController


#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *tempDic = _dataArr[indexPath.section];
    NSArray *valueArr = tempDic[@"value"];
    NSArray *classArr = tempDic[@"class"];
    
    NSString *className = classArr[indexPath.row];

    UIViewController *subViewController = [[NSClassFromString(className) alloc] init];
    subViewController.title = valueArr[indexPath.row];
    
    [self.navigationController pushViewController:subViewController animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *tempDic = _dataArr[section];
    return tempDic[@"title"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


#pragma mark - tableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *tempDic = _dataArr[section];
    NSArray *valueArr = tempDic[@"value"];
    return valueArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mainCellIdentifier = @"cm.huozhiyu.mainCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mainCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    NSDictionary *tempDic = _dataArr[indexPath.section];
    NSArray *valueArr = tempDic[@"value"];
    NSArray *classArr = tempDic[@"class"];
    cell.textLabel.text = valueArr[indexPath.row];
    cell.detailTextLabel.text = classArr[indexPath.row];
    
    return cell;
}

#pragma mark - init
- (void)initData
{
    //主页面数据
    _dataArr = @[@{@"title":@"1. 相关概念",
                   @"value": @[@"Demo1 | 线程堵塞/卡顿",
                               @"Demo2 | 线程间的通讯"],
                   @"class": @[@"Demo1VC",
                               @"Demo2VC"]},
                 @{@"title":@"2. 多线程的方案",
                   @"value": @[@"Demo3 | NSThread"],
                   @"class": @[@"Demo3VC"]},
                 @{@"title":@"3.GCD",
                   @"value": @[@"Demo4 | 函数与队列关系",
                               @"Demo5 | 栅栏函数",
                               @"Demo6 | 调度组",
                               @"Demo7 | 最大并发数"],
                   @"class": @[@"Demo4VC",
                               @"Demo5VC",
                               @"Demo6VC",
                               @"Demo7VC"]},
                 @{@"title":@"4.NSOperation",
                   @"value": @[@"Demo8 | 初体验",
                               @"Demo9 | 深入浅出"],
                   @"class": @[@"Demo8VC",
                               @"Demo9VC"]}
                 ];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iOS多线程";
    
    [self initData];
    
    _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _mainTableView.sectionHeaderHeight = 10;
    _mainTableView.sectionFooterHeight = 0;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self.view addSubview:_mainTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}


@end

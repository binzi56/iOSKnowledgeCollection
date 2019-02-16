//
//  ViewController.m
//  NetworkProgramming
//
//  Created by 帅斌 on 2019/2/14.
//  Copyright © 2019年 dongming. All rights reserved.
//

#import "ViewController.h"

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
    static NSString *mainCellIdentifier = @"com.huozhiyu.mainCellIdentifier";
    
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
    _dataArr = @[@{@"title":@"1. 网络基础",
                   @"value": @[@"Demo1 | 初体验",
                               @"Demo2 | NSURLConnection",
                               @"Demo3 | 文件流"],
                   @"class": @[@"Demo1ViewController",
                               @"Demo2ViewController",
                               @"Demo3ViewController"]},
                 @{@"title":@"2. 网络底层",
                   @"value": @[@"Demo4 | OC与JS交互"],
                   @"class": @[@"Demo4ViewController"]},
                 @{@"title":@"3. 网络框架",
                   @"value": @[@"Demo5 | NSURLProtocol"],
                   @"class": @[@"Demo5ViewController"]}
                 ];
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"iOS网络编程";
    
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

//
//  Demo3ViewController.m
//  NetworkProgramming
//
//  Created by 帅斌 on 2019/2/15.
//  Copyright © 2019年 dongming. All rights reserved.
//

#import "Demo3ViewController.h"
#import "KCFileStreamNetwork.h"

@interface Demo3ViewController ()
@property (strong, nonatomic)  UILabel *progressLabel;
@end

@implementation Demo3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//文件流下载
- (void)fileSteamBtn:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    
    KCFileStreamNetwork *fileStream = [KCFileStreamNetwork new];
    [fileStream  getDownFileUrl:@"https://pic.ibaotu.com/00/48/71/79a888piCk9g.mp4" backBlock:^(NSURL *fileUrl,NSString *progress) {
        weakSelf.progressLabel.text = progress;
        if (fileUrl) {
            NSLog(@"文件路径:%@",[fileUrl absoluteString]);
        }
    }];
    
}

- (void)editFileBtn:(id)sender {
    
    NSString* filePath =  @"/Users/LM/Desktop/data.txt";
    NSFileManager* fm = [NSFileManager defaultManager];
    NSData* fileData =  [fm contentsAtPath:filePath];
    
    NSFileHandle *fielHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    //[fielHandle seekToFileOffset:2];
    [fielHandle seekToEndOfFile];
    NSString *str = @"你好";
    NSData* stringData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [fielHandle writeData:stringData];
    [fielHandle closeFile];
    
}


@end

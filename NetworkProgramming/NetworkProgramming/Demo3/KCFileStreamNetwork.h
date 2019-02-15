//
//  KCFileStreamNetwork.h
//  NetworkProgramming
//
//  Created by 帅斌 on 2019/2/15.
//  Copyright © 2019年 dongming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^KCFileHandleBlock)(NSURL* fileUrl, NSString *progress);

@interface KCFileStreamNetwork : NSObject

- (NSURLSessionDataTask*)getDownFileUrl:(NSString*)fileUrl backBlock:(KCFileHandleBlock)handleBlock;
@property(nonatomic,strong)UILabel *proLab;

@end

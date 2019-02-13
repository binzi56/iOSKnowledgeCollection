//
//  KCPerson.h
//  Multithreading
//
//  Created by 帅斌 on 2019/2/13.
//  Copyright © 2019年 dongming. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface KCPerson : NSObject
- (void)personLaunchThreadWithPort:(NSPort *)port;
@end

NS_ASSUME_NONNULL_END

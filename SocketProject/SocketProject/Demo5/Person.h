//
//  Person.h
//  001---WebSocket初体验
//
//  Created by Cooci on 2018/8/16.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy) NSString *age;
- (void)givePersonName:(NSString *)name;
@end

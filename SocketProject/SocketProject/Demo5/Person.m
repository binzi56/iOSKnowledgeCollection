//
//  Person.m
//  001---WebSocket初体验
//
//  Created by Cooci on 2018/8/16.
//  Copyright © 2018年 Cooci. All rights reserved.
//

#import "Person.h"

@implementation Person
- (void)givePersonName:(NSString *)name{
//    [self willChangeValueForKey:@"name"];
//    _name = name;
//    [self didChangeValueForKey:@"name"];
    
    [self setValue:name forKey:@"name"];
}

@end

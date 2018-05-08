//
//  ActivityModel.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/8/13.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"activity_id":@"id"};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (oldValue == [NSNull null]) {
        return @"";
    }
    
    if ([property.name isEqualToString:@"time_created"] || [property.name isEqualToString:@"time_started"] ||[property.name isEqualToString:@"time_ended"]) {
        NSRange range = NSMakeRange(0, 10);
        return [oldValue substringWithRange:range];
    }
    
    return oldValue;
}

@end

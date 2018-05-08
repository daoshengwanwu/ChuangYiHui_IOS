//
//  PublishRequireModel.m
//  ChuangYiHui
//
//  Created by BaiHaoran on 2018/5/6.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import "PublishRequireModel.h"

@implementation PublishRequireModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"require_id":@"id"};
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

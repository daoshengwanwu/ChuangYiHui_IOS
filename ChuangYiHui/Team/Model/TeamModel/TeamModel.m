//
//  TeamModel.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/9.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "TeamModel.h"

@implementation TeamModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"team_id":@"id", @"team_description": @"description"};
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (oldValue == [NSNull null]) {
        return @"";
    }
    
    if ([property.name isEqualToString:@"time_created"]) {
        NSRange range = NSMakeRange(0, 10);
        return [oldValue substringWithRange:range];
    }
    
    return oldValue;
}
@end

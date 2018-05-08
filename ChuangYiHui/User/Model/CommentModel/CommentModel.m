//
//  CommentModel.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/25.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"comment_id":@"id"};
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

//
//  AchievementModel.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/8.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "AchievementModel.h"

@implementation AchievementModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"achievement_id":@"id", @"achievement_description": @"description"};
}

@end

//
//  ExperienceModel.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/15.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "ExperienceModel.h"

@implementation ExperienceModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"experience_description":@"description", @"experience_id":@"id"};
}

@end

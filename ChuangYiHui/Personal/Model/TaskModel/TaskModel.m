//
//  TaskModel.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/6.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "TaskModel.h"

@implementation TaskModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"task_id":@"id"};
}

@end

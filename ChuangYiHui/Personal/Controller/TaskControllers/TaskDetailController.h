//
//  TaskDetailController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/8.
//  Copyright © 2017年 litingdong. All rights reserved.
//

//内部任务详情
#import <UIKit/UIKit.h>

@interface TaskDetailController : UIViewController

@property (nonatomic, strong)TaskModel *taskModel;

//0 团队  1 个人
@property (nonatomic, assign)NSInteger enterWay;
@property (nonatomic, strong)TeamModel *teamModel;

@end

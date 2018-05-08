//
//  TaskExternalDetailController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/8.
//  Copyright © 2017年 litingdong. All rights reserved.
//

//外部任务详情
#import <UIKit/UIKit.h>

@interface TaskExternalDetailController : UIViewController

@property (nonatomic, strong)TaskModel *taskModel;

//0 团队  1 个人
@property (nonatomic, assign)NSInteger enterWay;

@end

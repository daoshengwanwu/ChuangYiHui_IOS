//
//  TaskStatusController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/5.
//  Copyright © 2017年 litingdong. All rights reserved.
//

//进行中 已满足 已删除
#import <UIKit/UIKit.h>

@interface TaskStatusController : UIViewController


//0 内部任务  1 承接任务  2 外包任务
@property (nonatomic, assign)NSInteger type;

//0 团队  1 个人
@property (nonatomic, assign)NSInteger enterWay;

@property (nonatomic, strong)TeamModel *teamModel;

@end

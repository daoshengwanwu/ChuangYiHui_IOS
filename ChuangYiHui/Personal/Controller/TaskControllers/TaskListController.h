//
//  TaskListController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/5.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskListController : UIViewController


//0内部任务  1承接任务  2外包任务
@property (nonatomic, assign)NSInteger type;

//0 团队  1 个人
@property (nonatomic, assign)NSInteger enterWay;

//0 进行中 1 已完成 2 已删除
@property (nonatomic, assign)NSInteger status;

@property (nonatomic, strong)TeamModel *teamModel;

@end

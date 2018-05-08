//
//  TaskInternalReleaseController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/6.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskInternalReleaseController : UIViewController

@property (nonatomic, strong)TeamModel *model;

@property (nonatomic, strong)TaskModel *taskModel;

//0发布任务 1再派任务
@property (nonatomic, assign)NSInteger enterWay;

@property (nonatomic, strong)void(^resignDoneBlock)();

@end

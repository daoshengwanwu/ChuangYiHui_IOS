//
//  NeedListController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/6.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeedListController : UIViewController

//0 人员需求  1 承接需求  2 外包需求
@property (nonatomic, assign)NSInteger type;

//0 进行中 1 已完成 2 已删除
@property (nonatomic, assign)NSInteger status;

@property (nonatomic, assign) BOOL isOwner;

//0 从首页进入 1 从团队页进入
@property (nonatomic, assign) NSInteger enterWay;

@property (nonatomic, strong)TeamModel *teamModel;

@end

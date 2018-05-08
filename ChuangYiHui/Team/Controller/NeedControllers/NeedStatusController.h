//
//  NeedStatusController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/6.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeedStatusController : UIViewController

//0 内部任务  1 承接任务  2 外包任务
@property (nonatomic, assign)NSInteger type;

@property (nonatomic, strong)TeamModel *teamModel;

@property (nonatomic, assign) BOOL isOwner;

//0 从首页进入 1 从团队页进入
@property (nonatomic, assign) NSInteger enterWay;


@end

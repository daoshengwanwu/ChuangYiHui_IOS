//
//  MemberApplyListController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/7/31.
//  Copyright © 2017年 litingdong. All rights reserved.
//


//人员需求的申请列表
#import <UIKit/UIKit.h>

@interface MemberApplyListController : UIViewController


//0 人员需求  1 承接需求  2 外包需求
@property (nonatomic, assign)NSInteger enterWay;

@property (nonatomic, strong)NeedModel *needModel;

@property (nonatomic, strong)TeamModel *teamModel;



@end

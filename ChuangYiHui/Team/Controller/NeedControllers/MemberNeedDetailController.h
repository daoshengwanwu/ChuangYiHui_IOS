//
//  MemberNeedDetailController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/7/21.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberNeedDetailController : UIViewController

//首页 0   我的团队进入 1
@property (nonatomic, assign)NSInteger enterWay;

@property (nonatomic, strong)NeedModel *needModel;

@end

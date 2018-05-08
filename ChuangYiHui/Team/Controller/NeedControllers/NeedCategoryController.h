//
//  NeedCategoryController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/6.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeedCategoryController : UIViewController

@property (nonatomic, strong) TeamModel *model;

@property (nonatomic, assign) BOOL isOwner;

//0 从首页进入 1 从团队页进入
@property (nonatomic, assign) NSInteger enterWay;

@end

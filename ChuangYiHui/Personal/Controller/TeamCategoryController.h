//
//  TeamCategoryController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/11.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamCategoryController : UIViewController

//0 团队列表  1 关注列表 2 其他用户的团队列表  3 他人的经历背景  4 我的经历背景
@property (nonatomic, assign)NSInteger type;

@property (nonatomic, strong)NSString *user_id;

@end

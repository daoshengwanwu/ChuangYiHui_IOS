//
//  PersonalTeamListController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/11.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalTeamListController : UIViewController<UITableViewDelegate, UITableViewDataSource>

//0 参与的团队 1 创建的团队 2 其他用户参与的团队 3 其他用户创建的团队
@property (nonatomic, assign)NSInteger type;

@property (nonatomic, strong)NSString *user_id;

@end

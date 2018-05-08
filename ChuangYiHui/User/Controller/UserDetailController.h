//
//  UserDetailController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/9.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UserModel *model;

@end

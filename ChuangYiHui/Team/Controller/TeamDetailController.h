//
//  TeamDetailController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/12.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamDetailController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)TeamModel *teamModel;

@end

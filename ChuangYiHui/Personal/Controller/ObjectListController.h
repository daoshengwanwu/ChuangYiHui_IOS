//
//  ObjectListController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/10.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObjectListController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger displayType;

@property (nonatomic, strong) NSString *object_id;

@end

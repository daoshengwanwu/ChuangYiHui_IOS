//
//  OutSourceAdapter.h
//  ChuangYiHui
//
//  Created by BaiHaoran on 2018/5/10.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define OutSourceRequireCellIdentifier @"outSourceRequireCellIdentifier"

@interface OutSourceAdapter : NSObject<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

- (void)setTableView:(UITableView*)tableView;
- (void)setUnderTakeRequireList:(NSArray*)list;
- (void)setLimit:(NSInteger)limit;
- (void)getDataFromServer;
- (void)setViewController:(UIViewController*)controller;
- (NSInteger)getLimit;

@end

//
//  SyscgAdapter.h
//  ChuangYiHui
//
//  Created by p1p1us on 2019/1/14.
//  Copyright © 2019年 litingdong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SyscgCellIdentifier @"SyscgCellIdentifier"

@interface SyscgAdapter : NSObject<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

- (void)setTableView:(UITableView*)tableView;
- (void)setSyscgList:(NSArray*)list;
- (void)setLimit:(NSInteger)limit;
- (void)getDataFromServer;
- (void)setViewController:(UIViewController*)controller;
- (NSInteger)getLimit;

@end


//
//  ZjcgAdapter.h
//  ChuangYiHui
//
//  Created by p1p1us on 2019/1/10.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ZjcgCellIdentifier @"ZjcgCellIdentifier"

@interface ZjcgAdapter : NSObject<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

- (void)setTableView:(UITableView*)tableView;
- (void)setZjcgList:(NSArray*)list;
- (void)setLimit:(NSInteger)limit;
- (void)getDataFromServer;
- (void)setViewController:(UIViewController*)controller;
- (NSInteger)getLimit;

@end


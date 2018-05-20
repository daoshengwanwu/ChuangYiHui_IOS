//
//  UnderTakeListAdapter.h
//  ChuangYiHui
//
//  Created by BaiHaoran on 2018/5/10.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define UnderTakeRequireCellIdentifier @"underTakeRequireCellIdentifier"

@interface UnderTakeListAdapter : NSObject<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate> {
    
}

- (void)setTableView:(UITableView*)tableView;
- (void)setUnderTakeRequireList:(NSArray*)list;
- (void)setLimit:(NSInteger)limit;
- (void)setViewController:(UIViewController*)controller;
- (void)getDataFromServer;
- (NSInteger)getLimit;

@end

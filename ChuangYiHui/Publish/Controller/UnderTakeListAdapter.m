//
//  UnderTakeListAdapter.m
//  ChuangYiHui
//
//  Created by BaiHaoran on 2018/5/10.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import "UnderTakeListAdapter.h"
#import "UnderTakeRequireCell.h"
#import "PeopleRequireDetailController.h"

@interface UnderTakeListAdapter()

@property (nonatomic, strong) UITableView * underTakeRequireTableView;
@property (nonatomic, strong) NSArray * underTakeRequires;
@property (nonatomic, assign) NSInteger underTakeListLimit;
@property (nonatomic, strong) UIViewController * controller;

@end

@implementation UnderTakeListAdapter

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _underTakeRequires.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UnderTakeRequireCell * cell = [tableView dequeueReusableCellWithIdentifier:UnderTakeRequireCellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell bindData:[_underTakeRequires objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"GoToActivityDetail" object: nil];
    //do nothing
    [_controller presentViewController:[[PeopleRequireDetailController alloc] initWithPublishRequireModel:[_underTakeRequires objectAtIndex:indexPath.row] Type:1] animated:true completion:^{
        //跳转完成后需要执行的事件；
    }];
    
}

- (UIImage *)imageForEmptyDataSet: (UIScrollView *)scrollView {
    return [UIImage imageNamed:@"no_record_icon"];
}

- (NSAttributedString *)titleForEmptyDataSet: (UIScrollView *)scrollView {
    NSString *text = @"没有需求~";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)getDataFromServer {
    NSString * url = [NSString stringWithFormat:@"%@?limit=%ld", URL_GET_ALL_UNDERTAKE_NEEDS, _underTakeListLimit];
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        [_underTakeRequireTableView.mj_header endRefreshing];
        [_underTakeRequireTableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        _underTakeRequires = [PublishRequireModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        [_underTakeRequireTableView reloadData];
        
    } failed:^(id data, NSString *message) {
        NSLog(@"%@",message);
        [SVProgressHUD dismiss];
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        [_underTakeRequireTableView.mj_header endRefreshing];
        [_underTakeRequireTableView.mj_footer endRefreshing];
    }];
}

- (void)setTableView:(UITableView *)tableView {
    _underTakeRequireTableView = tableView;
}

- (void)setLimit:(NSInteger)limit {
    _underTakeListLimit = limit;
}

- (void)setUnderTakeRequireList:(NSArray *)list {
    _underTakeRequires = list;
}

- (NSInteger)getLimit {
    return _underTakeListLimit;
}

- (void)setViewController:(UIViewController*)controller {
    self.controller = controller;
}

@end

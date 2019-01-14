//
//  ZjcgAdapter.m
//  ChuangYiHui
//
//  Created by p1p1us on 2019/1/10.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import "ZjcgAdapter.h"
#import "ZjcgTableViewCell.h"
#import "PeopleRequireDetailController.h"

@interface ZjcgAdapter()

@property (nonatomic, strong) UITableView * ZjcgTableView;
@property (nonatomic, strong) NSArray * ZjcgRequires;
@property (nonatomic, assign) NSInteger ZjcgListLimit;
@property (nonatomic, strong) UIViewController * controller;

@end

@implementation ZjcgAdapter

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _ZjcgRequires.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZjcgTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ZjcgCellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell bindData:[_ZjcgRequires objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"GoToActivityDetail" object: nil];
    //do nothing
    [_controller presentViewController:[[PeopleRequireDetailController alloc] initWithPublishRequireModel:[_ZjcgRequires objectAtIndex:indexPath.row] Type:2] animated:true completion:^{
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
    NSString * url = [NSString stringWithFormat:@"%@?limit=%ld", URL_GET_ALL_ZJCG, _ZjcgListLimit];
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        NSLog(@"至少成功了1");
        [_ZjcgTableView.mj_header endRefreshing];
        [_ZjcgTableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        _ZjcgRequires = [PublishRequireModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        [_ZjcgTableView reloadData];
        
    } failed:^(id data, NSString *message) {
        NSLog(@"失败了%@",message);
        [SVProgressHUD dismiss];
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        [_ZjcgTableView.mj_header endRefreshing];
        [_ZjcgTableView.mj_footer endRefreshing];
    }];
}

- (void)setTableView:(UITableView *)tableView {
    _ZjcgTableView = tableView;
}

- (void)setLimit:(NSInteger)limit {
    _ZjcgListLimit = limit;
}

- (void)setZjcgList:(NSArray *)list {
    _ZjcgRequires = list;
}

- (NSInteger)getLimit {
    return _ZjcgListLimit;
}

- (void)setViewController:(UIViewController*)controller {
    self.controller = controller;
}

@end


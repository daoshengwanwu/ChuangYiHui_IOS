//
//  OutSourceAdapter.m
//  ChuangYiHui
//
//  Created by BaiHaoran on 2018/5/10.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import "OutSourceAdapter.h"
#import "OutSourceRequireCell.h"

@interface OutSourceAdapter()

@property (nonatomic, strong) UITableView * outSourceRequireTableView;
@property (nonatomic, strong) NSArray * outSourceRequires;
@property (nonatomic, assign) NSInteger outSourceListLimit;

@end

@implementation OutSourceAdapter

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _outSourceRequires.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OutSourceRequireCell * cell = [tableView dequeueReusableCellWithIdentifier:OutSourceRequireCellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell bindData:[_outSourceRequires objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"GoToActivityDetail" object: nil];
    //do nothing
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
    NSString * url = [NSString stringWithFormat:@"%@?limit=%ld", URL_GET_ALL_OUTSOURCE_NEEDS, _outSourceListLimit];
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        [_outSourceRequireTableView.mj_header endRefreshing];
        [_outSourceRequireTableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        _outSourceRequires = [PublishRequireModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        [_outSourceRequireTableView reloadData];
        
    } failed:^(id data, NSString *message) {
        NSLog(@"%@",message);
        [SVProgressHUD dismiss];
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        [_outSourceRequireTableView.mj_header endRefreshing];
        [_outSourceRequireTableView.mj_footer endRefreshing];
    }];
}

- (void)setTableView:(UITableView *)tableView {
    _outSourceRequireTableView = tableView;
}

- (void)setLimit:(NSInteger)limit {
    _outSourceListLimit = limit;
}

- (void)setUnderTakeRequireList:(NSArray *)list {
    _outSourceRequires = list;
}

- (NSInteger)getLimit {
    return _outSourceListLimit;
}

@end

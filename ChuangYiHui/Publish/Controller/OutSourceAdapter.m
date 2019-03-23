//
//  OutSourceAdapter.m
//  ChuangYiHui
//
//  Created by BaiHaoran on 2018/5/10.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import "OutSourceAdapter.h"
#import "OutSourceRequireCell.h"
#import "PeopleRequireDetailController.h"

@interface OutSourceAdapter()

@property (nonatomic, strong) UITableView * outSourceRequireTableView;
@property (nonatomic, strong) NSArray * outSourceRequires;
@property (nonatomic, assign) NSInteger outSourceListLimit;
@property (nonatomic, strong) UIViewController * controller;

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
    [_controller presentViewController:[[PeopleRequireDetailController alloc] initWithPublishRequireModel:[_outSourceRequires objectAtIndex:indexPath.row] Type:2] animated:true completion:^{
        //跳转完成后需要执行的事件；
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //在设置高度的回调中获取当前indexpath的cell 然后返回给他的frame的高度即可。在创建cell的时候记得最后把cell.frame.size.height 等于你内容的高。
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    /*此写法会导致循环引用。引起崩溃
     UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
     */
    
    return cell.frame.size.height;
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
    [[NetRequest sharedInstance] httpRequestWithGETandSort:url success:^(id data, NSString *message) {
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

- (void)setViewController:(UIViewController*)controller {
    self.controller = controller;
}

@end

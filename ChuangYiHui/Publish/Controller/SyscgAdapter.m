//
//  SyscgAdapter.m
//  ChuangYiHui
//
//  Created by p1p1us on 2019/1/14.
//  Copyright © 2019年 litingdong. All rights reserved.
//

#import "SyscgAdapter.h"
#import "SyscgTableViewCell.h"
#import "PeopleRequireDetailController.h"
#import "ZjcgDetailController.h"

@interface SyscgAdapter()

@property (nonatomic, strong) UITableView * SyscgTableView;
@property (nonatomic, strong) NSArray * SyscgRequires;
@property (nonatomic, assign) NSInteger SyscgListLimit;
@property (nonatomic, strong) UIViewController * controller;

@end

@implementation SyscgAdapter

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _SyscgRequires.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SyscgTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SyscgCellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell bindData:[_SyscgRequires objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"GoToActivityDetail" object: nil];
    //do nothing
    [_controller presentViewController:[[ZjcgDetailController alloc] initWithPublishRequireModel:[_SyscgRequires objectAtIndex:indexPath.row] Type:1] animated:true completion:^{
        //跳转完成后需要执行的事件；
    }];
}

- (UIImage *)imageForEmptyDataSet: (UIScrollView *)scrollView {
    return [UIImage imageNamed:@"no_record_icon"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //在设置高度的回调中获取当前indexpath的cell 然后返回给他的frame的高度即可。在创建cell的时候记得最后把cell.frame.size.height 等于你内容的高。
    
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    /*此写法会导致循环引用。引起崩溃
     UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
     */
    
    return cell.frame.size.height;
}

- (NSAttributedString *)titleForEmptyDataSet: (UIScrollView *)scrollView {
    NSString *text = @"暂无成果~";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)getDataFromServer {
    NSString * url = [NSString stringWithFormat:@"%@?limit=%ld", URL_GET_ALL_SYSCG, _SyscgListLimit];
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        NSLog(@"至少成功了2");
        [_SyscgTableView.mj_header endRefreshing];
        [_SyscgTableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        _SyscgRequires = [PublishRequireModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        [_SyscgTableView reloadData];
        
    } failed:^(id data, NSString *message) {
        NSLog(@"失败了%@",message);
        [SVProgressHUD dismiss];
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        [_SyscgTableView.mj_header endRefreshing];
        [_SyscgTableView.mj_footer endRefreshing];
    }];
}

- (void)setTableView:(UITableView *)tableView {
    _SyscgTableView = tableView;
}

- (void)setLimit:(NSInteger)limit {
    _SyscgListLimit = limit;
}

- (void)setSyscgList:(NSArray *)list {
    _SyscgRequires = list;
}

- (NSInteger)getLimit {
    return _SyscgListLimit;
}

- (void)setViewController:(UIViewController*)controller {
    self.controller = controller;
}

@end


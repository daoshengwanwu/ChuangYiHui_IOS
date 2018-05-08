//
//  PersonalTeamListController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/11.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "PersonalTeamListController.h"
#import "TeamDetailController.h"
#import "TeamListCell.h"
#define cellIdentifier @"teamListCell"

@interface PersonalTeamListController ()<DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *teamArr;
@property (nonatomic, assign) NSInteger limit;

@end

@implementation PersonalTeamListController

- (void)viewDidLoad {
    [super viewDidLoad];
    _limit = 10;
    _teamArr = @[];
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView.emptyDataSetSource = self;
        tableView.rowHeight = 102.0f;
        [tableView registerNib:[UINib nibWithNibName:@"TeamListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
        tableView.tableFooterView = [UIView new];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _limit = 10;
            [self getTeams];
        }];
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _limit += 10;
            [self getTeams];
        }];
        tableView;
    });
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self getTeams];
}

- (void)getTeams{
    NSString *url = [NSString stringWithFormat:@"%@?limit=%ld",[self getBaseUrl], _limit];
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        _teamArr = [TeamModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        [_tableView reloadData];
        
    } failed:^(id data, NSString *message) {
        NSLog(@"%@",message);
        [SVProgressHUD dismiss];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}


- (NSString *)getBaseUrl{
    if (_type == 0) {
        return URL_GET_RELATED_TEAMS;
    }else if(_type == 1){
        return URL_GET_OWNED_TEAMS;
    }else if(_type == 2){
        return URL_GET_OTHER_USER_RELATED_TEAMS(_user_id);
    }else{
        return URL_GET_OTHER_USER_OWNED_TEAMS(_user_id);
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _teamArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setTeamCellByTeamModel:[_teamArr objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamDetailController *vc = [TeamDetailController new];
    vc.teamModel = [_teamArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark DZNEmptyDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_record_icon"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有记录~";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  MemberApplyListController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/7/31.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "MemberApplyListController.h"
#import "TaskExternalReleaseViewController.h"
#import "AgreeOrDisagreeCell.h"

#define cellIdentifier @"agreeOrDisagreeCell"
#define cellHeight 147

@interface MemberApplyListController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *applyArr;
@property (nonatomic, assign) NSInteger limit;

@end

@implementation MemberApplyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请列表";
    self.view.backgroundColor = [UIColor whiteColor];
    _limit = 10;
    _applyArr = [NSMutableArray array];
    [self setUpView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self getNeeds];
}

- (void)setUpView{
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView.rowHeight = cellHeight;
        [tableView registerNib:[UINib nibWithNibName:@"AgreeOrDisagreeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _limit = 10;
            [self getNeeds];
        }];
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _limit += 10;
            [self getNeeds];
        }];
        
        tableView.tableFooterView = [UIView new];
        tableView;
    });
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)getNeeds{
    NSString *url = @"";
    if (_enterWay == 0) {
        url = URL_GET_TEAM_MEMBER_NEED_REQUESTS(_needModel.need_id);
    }else if(_enterWay == 1){
        //承接需求暂用 外包需求的接口
        url = URL_GET_TEAM_COPORATION_REQUESTS(_teamModel.team_id, _needModel.need_id);
    }else{
        url = URL_GET_TEAM_COPORATION_REQUESTS(_teamModel.team_id, _needModel.need_id);
    }
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        
        NSLog(@"data:%@", data);
        
        if (_enterWay == 0) {
            _applyArr = [UserModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        }else{
            _applyArr = [TeamModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        }
        [_tableView reloadData];
        
    } failed:^(id data, NSString *message) {
        NSLog(@"%@",message);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        
    }];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _applyArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AgreeOrDisagreeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(_enterWay == 0){
    UserModel *userModel = [_applyArr objectAtIndex:indexPath.row];
    [cell setNeedMemberApplyCellByModel:userModel];
    
    cell.AgreeBlock = ^{
        [self agreeApplyByUserID:userModel.user_id];
    };
    
    cell.DisAgreeBlock = ^{
        [self DisagreeApplyByUserID:userModel.user_id];
    };
    }else if(_enterWay == 1){
        //承接需求
        TeamModel *teamModel = [_applyArr objectAtIndex:indexPath.row];
        [cell setNeedMemberApplyCellByTeamModel:teamModel];
        cell.AgreeBlock = ^{
            [self agreeApplyByTeamID:teamModel.team_id];
        };
        
        cell.DisAgreeBlock = ^{
            [self DisagreeApplyByTeamID:teamModel.team_id];
        };

    }else{
        //外包需求
        TeamModel *teamModel = [_applyArr objectAtIndex:indexPath.row];
        [cell setNeedMemberApplyCellByTeamModel:teamModel];
        cell.AgreeBlock = ^{
            [self agreeApplyByTeamID:teamModel.team_id];
        };
        
        cell.DisAgreeBlock = ^{
            [self DisagreeApplyByTeamID:teamModel.team_id];
        };
    }
    
    return cell;
}


- (void)agreeApplyByUserID: (NSString *)user_id{
    [[NetRequest sharedInstance] httpRequestWithPost:URL_ACCEPT_TEAM_MEMBER_NEED_REQUESTS(_needModel.need_id, user_id) parameters:@{} withToken:NO success:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"操作成功" andTime:1.0f DoneBlock:^{
            [self getNeeds];
        }];
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"操作失败" andTime:1.5f];
    }];
}

- (void)DisagreeApplyByUserID: (NSString *)user_id{
    [[NetRequest sharedInstance] httpRequestWithDELETE:URL_ACCEPT_TEAM_MEMBER_NEED_REQUESTS(_needModel.need_id, user_id) success:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"操作成功" andTime:1.0f DoneBlock:^{
            [self getNeeds];
        }];
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"操作失败" andTime:1.5f];
    }];
}

//同意外包需求的申请
- (void)agreeApplyByTeamID: (NSString *)team_id{
    NSLog(@"URL:%@", URL_AGREE_TEAM_COPORATION_REQUESTS(team_id, _needModel.need_id));
    [[NetRequest sharedInstance] httpRequestWithPost:URL_AGREE_TEAM_COPORATION_REQUESTS(team_id, _needModel.need_id) parameters:@{} withToken:NO success:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"操作成功" andTime:1.0f DoneBlock:^{
            [self getNeeds];
            TaskExternalReleaseViewController *vc = [TaskExternalReleaseViewController new];
            vc.enterWay = 2;
            vc.model = _teamModel;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"操作失败" andTime:1.5f];
    }];
}

//拒绝外包需求的申请
- (void)DisagreeApplyByTeamID: (NSString *)team_id{
    [[NetRequest sharedInstance] httpRequestWithDELETE:URL_AGREE_TEAM_COPORATION_REQUESTS(team_id, _needModel.need_id)  success:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"操作成功" andTime:1.0f DoneBlock:^{
            [self getNeeds];
        }];
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"操作失败" andTime:1.5f];
    }];
}





#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark DZNEmptyDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_record_icon"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"";
    if (_enterWay == 0) {
        text = @"还没有人员申请~";
    }else if(_enterWay == 1){
        text = @"还没有承接申请~";
    }else{
        text = @"还没有外包申请~";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

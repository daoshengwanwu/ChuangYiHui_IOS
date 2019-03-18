//
//  UserListController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/8.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "ExpertListController.h"
#import "UserDetailController.h"
#import "UserListCell.h"
#import "LBXScan1ViewController.h"
#import "StyleDIY.h"

#define cellIdentifier @"userListCell"

@interface ExpertListController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *userArr;
@property (nonatomic, assign) NSInteger limit;

@end

@implementation ExpertListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpRightButton];
    _limit = 10;
    _userArr = @[];
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 102.0f;
        [tableView registerNib:[UINib nibWithNibName:@"UserListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
        tableView.tableFooterView = [UIView new];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _limit = 10;
            [self getUsers];
        }];
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _limit += 10;
            [self getUsers];
        }];
        tableView;
    });
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self getUsers];
    
    // Do any additional setup after loading the view.
}

- (void)setUpRightButton{
    //设置导航栏的右边按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [rightButton setImage:[UIImage imageNamed:@"scan_icon"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)rightButtonAction{
    [self openScanVCWithStyle:[StyleDIY weixinStyle]];
}


#pragma mark ---自定义界面

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    LBXScan1ViewController *vc = [LBXScan1ViewController new];
    vc.style = style;
    vc.isOpenInterestRect = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUsers{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"专家" forKey:@"role"];
    NSLog(@"profile :%@", params);
    
//    NSString *url = [NSString stringWithFormat:@"%@?limit=%ld",URL_GET_EXPERTS, _limit];
    
//    [[NetRequest sharedInstance] httpRequestWithGET:url parameters:params withToken:NO success:^(id data, NSString *message) {
//        NSLog(@"profile 提交成功 :%@", [[[UserManager sharedManager] getCurrentUser] user_id]);
//        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"提交成功" andTime:1.0f DoneBlock:^{
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//
//    } failed:^(id data, NSString *message) {
//        NSLog(@"profile 提交失败 :%@", [[[UserManager sharedManager] getCurrentUser] user_id]);
//        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
//    }];
    
    
    NSString *url = [NSString stringWithFormat:@"%@?limit=%ld",URL_GET_EXPERTS, _limit];
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[NetRequest sharedInstance] httpRequestWithGETandParam:url parameters:params success:^(id data, NSString *message) {
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        
        _userArr = [UserModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
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
    return _userArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setUserCellByUserModel:[_userArr objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([CommonTool checkIfLogin:self]) {
        UserDetailController *vc =[UserDetailController new];
        vc.model = [_userArr objectAtIndex:indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end

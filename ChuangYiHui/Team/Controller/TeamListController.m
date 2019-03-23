//
//  TeamListController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/8.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "TeamListController.h"
#import "TeamListCell.h"
#import "TeamDetailController.h"
#import "LBXScan1ViewController.h"
#import "StyleDIY.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"
#import "LLSearchViewController.h"

#define cellIdentifier @"teamListCell"

@interface TeamListController ()
{
    NSMutableArray *_obj;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *teamArr;
@property (nonatomic, assign) NSInteger limit;

@end

@implementation TeamListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpRightButton];
    [self initPopView];
    _limit = 20;
    _teamArr = @[];
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 52.0f;
        [tableView registerNib:[UINib nibWithNibName:@"TeamListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
        tableView.tableFooterView = [UIView new];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _limit = 20;
            [self getTeams];
        }];
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _limit += 20;
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

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpRightButton{
    //设置导航栏的右边按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)rightButtonAction{
    [self moreClicked];
}

//- (void)rightButtonAction{
//    [self openScanVCWithStyle:[StyleDIY weixinStyle]];
//}


#pragma mark ---自定义界面

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    LBXScan1ViewController *vc = [LBXScan1ViewController new];
    vc.style = style;
    vc.isOpenInterestRect = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initPopView{
    _obj = [NSMutableArray array];
    
    for (NSInteger i=0; i<[self titles].count; i++) {
        WBPopMenuModel *info = [[WBPopMenuModel alloc] init];
        info.title = [self titles][i];
        [_obj addObject:info];
    }
}

- (NSArray *) titles
{
    return @[@"扫一扫", @"搜一搜"];
}


- (void)moreClicked
{
    [[WBPopMenuSingleton shareManager] showPopMenuSelecteWithFrame:80.0 item:_obj action:^(NSInteger index) {
        if(index==0){
            [self openScanVCWithStyle:[StyleDIY weixinStyle]];
        }else if(index ==1){
            LLSearchViewController *seachVC = [[LLSearchViewController alloc] init];
            [self.navigationController pushViewController:seachVC animated:YES];
        }
        
    }];
}


- (void)getTeams{
    NSString *url = [NSString stringWithFormat:@"%@?limit=%ld",URL_GET_TEAMS, _limit];
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
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

#pragma mark UITableViewDataSource
//显示多少个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _teamArr.count;
}


//每个cell的样子
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setTeamCellByTeamModel:[_teamArr objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark UITableViewDelegate
//点击每个cell执行的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([CommonTool checkIfLogin:self]) {
        TeamDetailController *vc = [TeamDetailController new];
        vc.teamModel = [_teamArr objectAtIndex:indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
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

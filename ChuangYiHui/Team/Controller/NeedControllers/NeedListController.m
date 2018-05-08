//
//  NeedListController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/6.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "NeedListController.h"
#import "TaskDetailController.h"
#import "MemberNeedDetailController.h"
#import "OutSourceNeedDetailController.h"
#import "UnderTakeNeedDetailController.h"
#import "MemberApplyListController.h"
#import "NeedCell.h"

#define RowHeight 69.0
#define CellIdentifier @"needCell"

@interface NeedListController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *needArr;
@property (nonatomic, assign)NSInteger limit;

@end

@implementation NeedListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"需求列表";
    self.view.backgroundColor = [UIColor whiteColor];
    _limit = 10;
    _needArr = [NSMutableArray array];
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
        tableView.rowHeight = RowHeight;
        [tableView registerNib:[UINib nibWithNibName:@"NeedCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIdentifier];
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
    NSString *url = [NSString stringWithFormat:@"%@?limit=%ld&status=%ld",[self getUrl], _limit, _status];
    NSLog(@"url: %@", url);
    
//    [SVProgressHUD showWithStatus:@"加载中"];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
//        [SVProgressHUD dismiss];
        
        _needArr = [NeedModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        [_tableView reloadData];
        
    } failed:^(id data, NSString *message) {
        NSLog(@"%@",message);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
//        [SVProgressHUD dismiss];
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        
    }];
}

- (NSString *)getUrl{
    NSString *url = @"";
    if (_enterWay == 0){
        //从首页进入
        switch (_type) {
            case 0:
                //人员需求
                url = URL_GET_ALL_MEMBER_NEEDS;
                break;
            case 1:
                //承接需求
                url = URL_GET_ALL_UNDERTAKE_NEEDS;
                break;
            case 2:
                //外包需求
                url = URL_GET_ALL_OUTSOURCE_NEEDS;
                break;
            default:
                break;
        }
    }else{
        //从团队主页进入
        switch (_type) {
            case 0:
                //人员需求
                url = URL_GET_TEAM_MEMBER_NEEDS(_teamModel.team_id);
                break;
            case 1:
                //承接需求
                url = URL_GET_TEAM_UNDERTAKE_NEEDS(_teamModel.team_id);
                break;
            case 2:
                //外包需求
                url = URL_GET_TEAM_OUTSOURCE_NEEDS(_teamModel.team_id);
                break;
                
            default:
                break;
        }
    }
    return url;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _needArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellByNeedModel:[_needArr objectAtIndex:indexPath.row]];
    if (_enterWay == 0) {
        //从首页进入
        [cell setMemberListBtnHiden:YES];
    }else if(_isOwner){
        //
        [cell setMemberListBtnHiden:NO];
        cell.memberListBlock = ^{
            MemberApplyListController *vc = [MemberApplyListController new];
            vc.needModel = [_needArr objectAtIndex:indexPath.row];
            vc.teamModel = _teamModel;
            vc.enterWay = _type;
            [self.navigationController pushViewController:vc animated:YES];
        };
    }else{
        [cell setMemberListBtnHiden:YES];
    }
    return cell;
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == 0) {
        //人员需求
        UIStoryboard *personalSB = [UIStoryboard storyboardWithName:@"Team" bundle:nil];
        MemberNeedDetailController *vc = [personalSB instantiateViewControllerWithIdentifier:@"memberNeedDetailController"];
        vc.enterWay = _enterWay;
        vc.needModel = [_needArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if(_type == 1){
        //承接需求
        UIStoryboard *personalSB = [UIStoryboard storyboardWithName:@"Team" bundle:nil];
        UnderTakeNeedDetailController *vc = [personalSB instantiateViewControllerWithIdentifier:@"underTakeNeedDetailController"];
        vc.enterWay = _enterWay;
        vc.needModel = [_needArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //外包需求
        UIStoryboard *personalSB = [UIStoryboard storyboardWithName:@"Team" bundle:nil];
        OutSourceNeedDetailController *vc = [personalSB instantiateViewControllerWithIdentifier:@"outSourceNeedDetailController"];
        vc.enterWay = _enterWay;
        vc.needModel = [_needArr objectAtIndex:indexPath.row];
        vc.teamModel = _teamModel;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

#pragma mark DZNEmptyDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_record_icon"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没有需求~";
    
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

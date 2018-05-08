//
//  TaskListController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/5.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "TaskListController.h"
#import "TaskDetailController.h"
#import "InternalTaskCell.h"

#define cellIdentifier @"internalTaskCell"

@interface TaskListController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *taskArr;
@property (nonatomic, assign) NSInteger limit;

@end

@implementation TaskListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务列表";
    self.view.backgroundColor = [UIColor whiteColor];
    _limit = 10;
    _taskArr = [NSMutableArray array];
    [self setUpView];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    [self getTasks];
}


- (void)setUpView{
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView.rowHeight = 69.0f;
        [tableView registerNib:[UINib nibWithNibName:@"InternalTaskCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _limit = 10;
            [self getTasks];
        }];
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _limit += 10;
            [self getTasks];
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

- (void)getTasks{
    NSString *url = [NSString stringWithFormat:@"%@?limit=%ld&sign=%ld",[self getUrl], _limit, _status];
    NSLog(@"url: %@", url);
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        
        _taskArr = [TaskModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        [_tableView reloadData];
        
    } failed:^(id data, NSString *message) {
        NSLog(@"%@",message);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        
    }];
}

- (NSString *)getUrl{
    NSString *url = @"";
    if (_enterWay == 0){
        //从团队主页进入
        switch (_type) {
            case 0:
                url = URL_GET_TEAM_INTERNAL_TASKS(_teamModel.team_id);
                break;
            case 1:
                url = URL_GET_TEAM_EXTERNAL_TASKS(_teamModel.team_id);
                break;
            case 2:
                url = URL_GET_TEAM_EXTERNAL_TASKS(_teamModel.team_id);
                break;
            default:
                break;
        }
    }else{
      //从个人主页进入
        url = URL_GET_MY_INTERNAL_TASKS;
    }
    return url;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _taskArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InternalTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellByTaskModel:[_taskArr objectAtIndex:indexPath.row]];
    return cell;
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *personalSB = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    TaskDetailController *vc = [personalSB instantiateViewControllerWithIdentifier:@"taskDetailController"];
    vc.taskModel = [_taskArr objectAtIndex:indexPath.row];
    vc.enterWay = _enterWay;
    vc.teamModel = _teamModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark DZNEmptyDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_record_icon"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没有任务~";
    
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

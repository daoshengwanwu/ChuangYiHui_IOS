//
//  PersonnelActionController.m
//  ChuangYiHui
//
//  Created by p1p1us on 2018/5/7.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import "PersonnelActionController.h"
#import "PersonActionListCell.h"
#import "ObjectListController.h"

#define PersonActionListCellIdentifier @"PersonActionListCell"

@interface PersonnelActionController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *personactionArr;
@property (nonatomic, assign) NSInteger limit;

@end

@implementation PersonnelActionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)initView{
    UIView *lineView = [UIView new];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(0);
    }];
    lineView.backgroundColor = LINE_COLOR;
    
    _limit = 10;
    _personactionArr = @[];
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView.rowHeight = 160.0f;
        [tableView registerNib:[UINib nibWithNibName:@"PersonActionListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:PersonActionListCellIdentifier];
        
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _limit = 10;
            [self getPersonActions];
        }];
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _limit += 10;
            [self getPersonActions];
        }];
        tableView;
    });
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(lineView.mas_bottom);
        make.bottom.mas_equalTo(-TAB_HEIGHT);
    }];
    
    [self getPersonActions];
}

- (void)getPersonActions{
    NSString *url = [NSString stringWithFormat:@"%@?limit=%ld",URL_GET_ALL_USER_EVENT, _limit];
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        _personactionArr = [PersonActionModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
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
    return _personactionArr.count;
}


//每个cell的样子
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonActionListCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonActionListCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellByPersonActionModel:[_personactionArr objectAtIndex:indexPath.row]];
//    [cell.comment_button addTarget:self action:@selector(playAsk:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickComment:)];
    cell.comment_button.tag = indexPath.row;
    cell.comment_button.userInteractionEnabled = YES;  //这句话千万不能忘记了
    [cell.comment_button addGestureRecognizer:singleTap];
//    [singleTap release];
    return cell;
}
- (void)onClickComment:(UITapGestureRecognizer *)recognizer
{
    //朋友评价
//    _personactionArr[]
    ObjectListController *vc = [ObjectListController new];
    vc.object_id =  [NSString stringWithFormat:@"%ld", recognizer.view.tag];
    vc.displayType = User_Comments;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UITableViewDelegate
//点击每个cell执行的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoToActivityDetail" object: nil];
//    //朋友评价
//    ObjectListController *vc = [ObjectListController new];
//    __weak typeof(self) weakSelf = self;
//    vc.object_id = weakSelf.model.user_id;
//    vc.displayType = User_Comments;
//    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark DZNEmptyDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_record_icon"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有动态~";
    
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

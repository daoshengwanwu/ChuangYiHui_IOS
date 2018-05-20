//
//  PersonnelActionController.m
//  ChuangYiHui
//
//  Created by p1p1us on 2018/5/7.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import "TeamActionController.h"
#import "TeamActionListCell.h"
#import "ObjectListController.h"
#import "TeamDetailController.h"

#define TeamActionListCellIdentifier @"TeamActionListCell"

@interface TeamActionController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *teamactionArr;
@property (nonatomic, assign) NSInteger limit;

@end

@implementation TeamActionController

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
    _teamactionArr = @[];
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView.rowHeight = 160.0f;
        [tableView registerNib:[UINib nibWithNibName:@"TeamActionListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TeamActionListCellIdentifier];
        
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _limit = 10;
            [self getTeamActions];
        }];
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _limit += 10;
            [self getTeamActions];
        }];
        tableView;
    });
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(lineView.mas_bottom);
        make.bottom.mas_equalTo(-TAB_HEIGHT);
    }];
    
    [self getTeamActions];
}

- (void)getTeamActions{
    NSString *url = [NSString stringWithFormat:@"%@?limit=%ld",URL_GET_ALL_TEAM_EVENT, _limit];
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        _teamactionArr = [TeamActionModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
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
    return _teamactionArr.count;
}


//每个cell的样子
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamActionListCell *cell = [tableView dequeueReusableCellWithIdentifier:TeamActionListCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCellByTeamActionModel:[_teamactionArr objectAtIndex:indexPath.row]];
    //    [cell.comment_button addTarget:self action:@selector(playAsk:) forControlEvents:UIControlEventTouchUpInside];
    
    //点击评论
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickComment:)];
    cell.comment_button.tag = indexPath.row;
    cell.comment_button.userInteractionEnabled = YES;  //这句话千万不能忘记了
    [cell.comment_button addGestureRecognizer:singleTap];
    
    //点击点赞
    UITapGestureRecognizer *singleTapOnZan =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickZan:)];
    cell.like_button.tag = indexPath.row;
    cell.like_button.userInteractionEnabled = YES;  //这句话千万不能忘记了
    [cell.like_button addGestureRecognizer:singleTapOnZan];
    
    //点击收藏
    UITapGestureRecognizer *singleTapOnSC =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickSC:)];
    cell.StarButton.tag = indexPath.row;
    cell.StarButton.userInteractionEnabled = YES;  //这句话千万不能忘记了
    [cell.StarButton addGestureRecognizer:singleTapOnSC];
    
    //    [singleTap release];
    return cell;
}

- (void)onClickZan:(UITapGestureRecognizer *)recognizer
{
    UIView * v=[recognizer.view superview];
    TeamActionListCell *cell=(TeamActionListCell *)[v superview];//找到cell
    [[NetRequest sharedInstance] httpRequestWithGET:URL_CHECK_IF_LIKE_ACTION(@"team", ((TeamActionModel*)[_teamactionArr objectAtIndex:recognizer.view.tag]).action_id) success:^(id data, NSString *message) {
        //取消点赞
        [[NetRequest sharedInstance] httpRequestWithDELETE:URL_CHECK_IF_LIKE_ACTION(@"team", ((TeamActionModel*)[_teamactionArr objectAtIndex:recognizer.view.tag]).action_id) success:^(id data, NSString *message) {
            [cell.like_button setImage:[UIImage imageNamed:@"zan_off"]];
            //        int lll = ;
            [cell.like_count setText:[NSString stringWithFormat:@"%d", [cell.like_count.text intValue] - 1]];
        } failed:^(id data, NSString *message) {
        }];
    } failed:^(id data, NSString *message) {
        //点赞
        [[NetRequest sharedInstance] httpRequestWithPost:URL_CHECK_IF_LIKE_ACTION(@"team", ((TeamActionModel*)[_teamactionArr objectAtIndex:recognizer.view.tag]).action_id) parameters:@{} withToken:NO success:^(id data, NSString *message) {
            //            _isLiked = YES;
            [cell.like_button setImage:[UIImage imageNamed:@"zan_on"]];
            //        NSString *lll = ((PersonActionModel*)[_personactionArr objectAtIndex:recognizer.view.tag]).liker_count;
            //            NSLog(@"点赞成功 %ld", _likerCount);
            [cell.like_count setText:[NSString stringWithFormat:@"%d", [cell.like_count.text intValue] + 1]];
        } failed:^(id data, NSString *message) {
        }];
    }];
}

- (void)onClickSC:(UITapGestureRecognizer *)recognizer
{
    UIView * v=[recognizer.view superview];
    TeamActionListCell *cell=(TeamActionListCell *)[v superview];//找到cell
    [[NetRequest sharedInstance] httpRequestWithGET:URL_CHECK_IF_FAVOR_ACTION(@"team", ((TeamActionModel*)[_teamactionArr objectAtIndex:recognizer.view.tag]).action_id) success:^(id data, NSString *message) {
        //取消收藏
        [[NetRequest sharedInstance] httpRequestWithDELETE:URL_CHECK_IF_FAVOR_ACTION(@"team", ((TeamActionModel*)[_teamactionArr objectAtIndex:recognizer.view.tag]).action_id) success:^(id data, NSString *message) {
            [cell.StarButton setImage:[UIImage imageNamed:@"star_icon"]];
        } failed:^(id data, NSString *message) {
        }];
    } failed:^(id data, NSString *message) {
        //收藏
        [[NetRequest sharedInstance] httpRequestWithPost:URL_CHECK_IF_FAVOR_ACTION(@"team", ((TeamActionModel*)[_teamactionArr objectAtIndex:recognizer.view.tag]).action_id) parameters:@{} withToken:NO success:^(id data, NSString *message) {
            //            _isLiked = YES;
            [cell.StarButton setImage:[UIImage imageNamed:@"star_icon_hover"]];
        } failed:^(id data, NSString *message) {
        }];
    }];
}

- (void)onClickComment:(UITapGestureRecognizer *)recognizer
{
    //朋友评价
    //    _personactionArr[]
    ObjectListController *vc = [ObjectListController new];
    //    vc.object_id = [NSString stringWithFormat:@"%ld", recognizer.view.tag];
    vc.object_id = ((TeamActionModel*)[_teamactionArr objectAtIndex:recognizer.view.tag]).action_id;
    vc.displayType = Team_Event_Comments;
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
    //跳转到用户详情的页面
    TeamDetailController *vc = [TeamDetailController new];
    TeamActionModel *model = [_teamactionArr objectAtIndex:indexPath.row];
    TeamModel *teamModel = [TeamModel new];
    [teamModel setTeam_id:model.id];
    vc.teamModel = teamModel;
    [self.navigationController pushViewController:vc animated:YES];
    
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


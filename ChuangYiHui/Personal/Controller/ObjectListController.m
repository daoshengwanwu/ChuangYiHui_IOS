//
//  ObjectListController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/10.
//  ReWrite by p1p1us on 2018/5/09.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "ObjectListController.h"
#import "UserDetailController.h"
#import "TeamDetailController.h"

#import "UserListCell.h"
#import "ScoreCell.h"
#import "AgreeOrDisagreeCell.h"
#import "TeamListCell.h"
#import "UserCommentCell.h"
#import "AchievementCell.h"
#import "CompetitionRankList.h"
#import "CompetitionRankModel.h"

#define cellIdentifier @"userListCell"
#define scoreCellIdentifier @"scoreCell"
#define agreeOrDisagreeCellIdentifier @"agreeOrDisagreeCell"
#define teamListCellIdentifier @"teamListCell"
#define commentCellIdentifier @"userCommentCell"
#define competitionRankListIdentifier @"competitionRankList"
#define achievementCellIdentifier @"achievementCell"


@interface ObjectListController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *objectArr;
@property (nonatomic, assign) NSInteger limit;

@end

@implementation ObjectListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置标题
    [self setControllerTitle];
    _limit = 10;
    _objectArr = @[];
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        if (_displayType == User_Comments||_displayType == User_Event_Comments||_displayType == Team_Event_Comments||_displayType == Activity_Comments||_displayType==Competition_Comments||_displayType == Competition_Rank) {
            tableView.estimatedRowHeight = [self getRowHeight];
            tableView.rowHeight = UITableViewAutomaticDimension;
        }else{
            tableView.rowHeight = [self getRowHeight];
        }
        [tableView registerNib:[UINib nibWithNibName:@"UserListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:@"CompetitionRankList" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:competitionRankListIdentifier];
        [tableView registerNib:[UINib nibWithNibName:@"ScoreCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:scoreCellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:@"AgreeOrDisagreeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:agreeOrDisagreeCellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:@"TeamListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:teamListCellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:@"UserCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:commentCellIdentifier];
        tableView.tableFooterView = [UIView new];
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _limit = 10;
            [self getObjects];
        }];
        tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _limit += 10;
            [self getObjects];
        }];
        tableView;
    });
    
    [self setUpRightButton];
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self getObjects];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self getObjects];
}

- (void)setControllerTitle{
    switch (_displayType) {
            case User_Friends:
            self.title = @"好友列表";
            break;
            
            case User_Follower:
            self.title = @"粉丝列表";
            break;
            
            case User_Followed:
            self.title = @"关注列表";
            break;
            
            case User_Score:
            self.title = @"积分明细";
            break;
            
            case User_Friend_Invitation:
            self.title = @"好友申请";
            break;
            
            case User_Comments:
            self.title = @"评价";
            break;
            
            case Competition_Rank:
            self.title = @"当前排名";
            break;
            
            case User_Event_Comments:
            self.title = @"评论";
            break;
            
            case Activity_Comments:
            self.title = @"评论";
            break;
            
            case Competition_Comments:
            self.title = @"评论";
            break;
            
            case Team_Event_Comments:
            self.title = @"评论";
            break;
            
            case User_Team_Invitation:
            self.title = @"团队邀请";
            break;
            
            case Team_Visitors:
            self.title = @"最近访客";
            break;
            
            case Team_Member_Requests:
            self.title = @"申请加入";
            break;
            
            case Team_Achievements:
            self.title = @"团队成果";
            break;
            
            
        default:
            self.title = @"";
            break;
    }
}


- (CGFloat)getRowHeight{
    CGFloat rowHeight = 0;
    switch (_displayType) {
            case User_Score:
            rowHeight = 44.0;
            break;
            
            case User_Comments:
            rowHeight = 75.0;
            break;
            
            case Competition_Rank:
            rowHeight = 86.0;
            break;
            
            case User_Event_Comments:
            rowHeight = 75.0;
            break;
            
            case Activity_Comments:
            rowHeight = 75.0;
            break;
            
            case Competition_Comments:
            rowHeight = 75.0;
            break;
            
            case Team_Event_Comments:
            rowHeight = 75.0;
            break;
            
            case User_Friend_Invitation:
            case User_Team_Invitation:
            case Team_Member_Requests:
            rowHeight = 147.0;
            break;
            
        default:
            rowHeight = 102.0;
            break;
    }
    return rowHeight;

}

- (NSString *)getBaseUrl{
    NSString *baseUrl = @"";
    switch (_displayType) {
            case User_Friends:
            baseUrl = URL_GET_FRIENDS;
            break;
            
            case User_Follower:
            baseUrl = URL_GET_FOLLOWERS;
            break;
            
            case User_Score:
            baseUrl = URL_GET_SCORE_RECORDS;
            break;

            case User_Comments:
            baseUrl = URL_GET_USER_COMMENTS(_object_id);
            break;
            
            case Competition_Rank:
            baseUrl = URL_GET_COMPETITION_RANK(_object_id);
            break;
            
            
            case User_Event_Comments:
            baseUrl = URL_GET_EVENT_COMMENTS(@"user",_object_id);
            break;
            
            case Activity_Comments:
            baseUrl = URL_GET_ACTIVITY_COMMENTS(_object_id);
            break;
            
            case Competition_Comments:
            baseUrl = URL_GET_COMPETITION_COMMENTS(_object_id);
            break;
            
            case Team_Event_Comments:
            baseUrl = URL_GET_EVENT_COMMENTS(@"team",_object_id);
            break;
            
            case User_Friend_Invitation:
            baseUrl = URL_GET_FRIEND_REQUESTS;
            break;
            
            case User_Team_Invitation:
            baseUrl = URL_GET_TEAM_INVITATIONS;
            break;
            
            case User_Followed_Team:
            baseUrl = URL_GET_FOLLOWED_TEAMS;
            break;
            
            case User_Followed_User:
            baseUrl = URL_GET_FOLLOWED_USERS;
            break;
            
            case Team_Visitors:
            baseUrl = URL_TEAM_VISITORS(_object_id);
            break;
            
            case Team_Member_Requests:
            baseUrl = URL_TEAM_MEMBER_REQUESTS(_object_id);
            break;
            
            case Team_Achievements:
            baseUrl = URL_GET_TEAM_ACHIEVEMENTS(_object_id);
            break;
            
        default:
            break;
    }
    return baseUrl;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getObjects{
    NSString *url = [NSString stringWithFormat:@"%@?limit=%ld",[self getBaseUrl], _limit];
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        
        NSLog(@"data：%@", data);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        
        if (_displayType == User_Score) {
            _objectArr = [ScoreModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        }else if (_displayType == User_Followed_Team){
            _objectArr = [TeamModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        }else if(_displayType == User_Comments||_displayType == Activity_Comments||_displayType==Competition_Comments){
            _objectArr = [CommentModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        }else if(_displayType == Competition_Rank){
            _objectArr = [CompetitionRankModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        }
        else if(_displayType == User_Event_Comments){
            _objectArr = [CommentModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        }else if(_displayType == Team_Event_Comments){
            _objectArr = [CommentModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        }else if(_displayType == Team_Achievements){
            //团队成果
            _objectArr = [AchievementModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        }else{
            _objectArr = [UserModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        }
        [_tableView reloadData];
        
    } failed:^(id data, NSString *message) {
        NSLog(@"%@",message);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
    }];
}

//添加好友
- (void)addFriend: (NSString *)user_id{
    NSLog(@"%@", [NSString stringWithFormat:@"%@%@/", URL_GET_FRIENDS, user_id]);
    [[NetRequest sharedInstance] httpRequestWithPost:[NSString stringWithFormat:@"%@%@/", URL_GET_FRIENDS, user_id] parameters:@{} withToken:NO success:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"添加好友成功" andTime:1.0f];
    } failed:^(id data, NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                       selector:@selector(hudDismiss) userInfo:nil repeats:NO];
    }];
}

//忽略好友请求
- (void)disagreeFriendRequest:(NSString *)request_id{
    [[NetRequest sharedInstance] httpRequestWithDELETE:[NSString stringWithFormat:@"%@%@/", URL_GET_FRIEND_REQUESTS, request_id] success:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"拒绝成功" andTime:1.0f];
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
    }];
}

//同意团队邀请
- (void)agreeTeamInvitation:(NSString *)invitation_id{
    [[NetRequest sharedInstance] httpRequestWithPost:[NSString stringWithFormat:@"%@%@/", URL_GET_TEAM_INVITATIONS, invitation_id] parameters:@{} withToken:NO success:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"加入团队成功" andTime:1.0f];
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
    }];
}

//忽略团队邀请
- (void)disagreeTeamInvitation:(NSString *)invitation_id{
    [[NetRequest sharedInstance] httpRequestWithDELETE:[NSString stringWithFormat:@"%@%@/", URL_GET_TEAM_INVITATIONS, invitation_id] success:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"拒绝成功" andTime:1.0f];
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
    }];
}

//添加好友到团队
- (void)addMemberToTeam: (NSString *)user_id{
    [[NetRequest sharedInstance] httpRequestWithPost:URL_CHECK_IS_MEMBER(_object_id, user_id) parameters:@{} withToken:NO success:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"添加成功" andTime:1.0f];
        [self getObjects];
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
    }];
}

//忽略某用户加入团队请求
- (void)deleteMemberRequest: (NSString *)user_id{
    [[NetRequest sharedInstance] httpRequestWithDELETE:URL_DELETE_TEAM_MEMBER_REQUESTS(_object_id, user_id) success:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"已忽略" andTime:1.0f];
        [self getObjects];
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
    }];
}


- (void)hudDismiss{
    [SVProgressHUD dismiss];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _objectArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    __weak typeof(self) weakSelf = self;
    if (_displayType == User_Score) {
         ScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:scoreCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setScoreCellByScoreModel:[_objectArr objectAtIndex:indexPath.row]];
        return cell;
    }else if(_displayType == User_Friend_Invitation){
        AgreeOrDisagreeCell *cell = [tableView dequeueReusableCellWithIdentifier:agreeOrDisagreeCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UserModel *userModel = [_objectArr objectAtIndex:indexPath.row];
        [cell setCellByUserModel:userModel];
        cell.AgreeBlock = ^{
            [self addFriend:userModel.user_id];
        };
        cell.DisAgreeBlock = ^{
            [self disagreeFriendRequest:userModel.request_id];
        };
        return cell;
    }else if(_displayType == User_Team_Invitation){
        AgreeOrDisagreeCell *cell = [tableView dequeueReusableCellWithIdentifier:agreeOrDisagreeCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UserModel *userModel = [_objectArr objectAtIndex:indexPath.row];
        [cell setCellByUserModel:userModel];
        cell.AgreeBlock = ^{
            [self agreeTeamInvitation:userModel.invitation_id];
        };
        cell.DisAgreeBlock = ^{
            [self disagreeTeamInvitation:userModel.invitation_id];
        };
        return cell;
    }else if(_displayType == Team_Member_Requests){
        AgreeOrDisagreeCell *cell = [tableView dequeueReusableCellWithIdentifier:agreeOrDisagreeCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UserModel *userModel = [_objectArr objectAtIndex:indexPath.row];
        [cell setCellByUserModel:userModel];
        cell.AgreeBlock = ^{
            [self addMemberToTeam:userModel.user_id];
        };
        cell.DisAgreeBlock = ^{
            [self deleteMemberRequest:userModel.user_id];
        };
        return cell;
    }else if(_displayType == User_Followed_Team){
        TeamListCell *cell = [tableView dequeueReusableCellWithIdentifier:teamListCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTeamCellByTeamModel:[_objectArr objectAtIndex:indexPath.row]];
        return cell;
    }else if(_displayType == User_Comments||_displayType == Activity_Comments||_displayType==Competition_Comments){
        UserCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellByCommentModel:[_objectArr objectAtIndex:indexPath.row]];
        return cell;
    }else if(_displayType == Competition_Rank){
        CompetitionRankList *cell = [tableView dequeueReusableCellWithIdentifier:competitionRankListIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellByCompetititonRankModel:[_objectArr objectAtIndex:indexPath.row]];
        return cell;
    }else if(_displayType == User_Event_Comments){
        UserCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellByCommentModel:[_objectArr objectAtIndex:indexPath.row]];
        return cell;
    }else if(_displayType == Team_Event_Comments){
        UserCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellByCommentModel:[_objectArr objectAtIndex:indexPath.row]];
        return cell;
    }else if(_displayType == Team_Achievements){
        AchievementCell *cell = [tableView dequeueReusableCellWithIdentifier:achievementCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UserListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setUserCellByUserModel:[_objectArr objectAtIndex:indexPath.row]];
        return cell;
    }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_displayType == User_Friends || _displayType == User_Follower || _displayType == User_Followed_User || _displayType == User_Friend_Invitation ||_displayType == Team_Visitors || _displayType == Team_Member_Requests) {
        //跳转到用户详情的页面
        UserDetailController *vc = [UserDetailController new];
        vc.model = [_objectArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(_displayType == User_Comments || _displayType == User_Event_Comments || _displayType == Team_Event_Comments || _displayType == Activity_Comments||_displayType==Competition_Comments){
        //跳转到用户详情的页面
        UserDetailController *vc = [UserDetailController new];
        CommentModel *model = [_objectArr objectAtIndex:indexPath.row];
        UserModel *userModel = [UserModel new];
        [userModel setUser_id:model.author_id];
        vc.model = userModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(_displayType == Competition_Rank){
        //跳转到团队详情的页面
        TeamDetailController *vc = [TeamDetailController new];
        CompetitionRankModel *model = [_objectArr objectAtIndex:indexPath.row];
        TeamModel *teamModel = [TeamModel new];
        [teamModel setTeam_id:model.team_id];
        vc.teamModel = teamModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(_displayType == User_Followed_Team){
        TeamDetailController *vc = [TeamDetailController new];
        vc.teamModel = [_objectArr objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
//设置导航栏的右边按钮
- (void)setUpRightButton{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

//评论
- (void)rightButtonAction{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.customViewColor = MAIN_COLOR;
    // 初始化输入框并设置位置和大小
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 180)];
//    // 设置预设文本
//    textView.text = @"输入评论内容";
    // 初始化输入框并设置位置和大小
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 160, 180)];
    // 设置预设文本
    textView.text = @"输入评论内容";
    // 设置文本字体
    textView.font = [UIFont fontWithName:@"Arial" size:16.5f];
    // 设置文本颜色
    textView.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
    // 设置文本框背景颜色
    textView.backgroundColor = [UIColor whiteColor];
    // 设置文本对齐方式
    textView.textAlignment = NSTextAlignmentLeft;
    // 设置自动纠错方式
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    
    //外框
    textView.layer.borderColor = [UIColor redColor].CGColor;
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius =5;
    
    // 设置是否可以拖动
//    textView.scrollEnabled = YES;
//    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

//    UITextView *textField = [alert addTextField:@"输入评论内容"];
    [alert addCustomView:textView];
//    textField.scrollEnabled = YES; // 当文字宽度超过UITextView的宽度时，是否允许滑动
    [alert addButton:@"确定" actionBlock:^(void) {
        [[NetRequest sharedInstance] httpRequestWithPost:[self getBaseUrl] parameters:@{@"content": textView.text} withToken:NO success:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"评论成功" andTime:1.0f];
            [self getObjects];
        } failed:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        }];
    }];
    
    [alert showEdit:self title:@"评论" subTitle:@"" closeButtonTitle:@"取消" duration:0.0f];
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

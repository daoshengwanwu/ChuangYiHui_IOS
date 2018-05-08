//
//  TeamDetailController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/12.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "TeamDetailController.h"
#import "TeamHeaderView.h"
#import "ImageTitleArrowCell.h"
#import "PersonalQRCodeController.h"
#import "ObjectListController.h"
#import "TeamIntroductionController.h"
#import "TaskCategoryController.h"
#import "TeamMemberController.h"
#import "NeedCategoryController.h"


#define cellIdentifier @"imageTitleArrowCell"
#define cellHeight 48
#define bottomButtonHeight 50

@interface TeamDetailController ()

@property (nonatomic, strong)NSArray *rowCountArr;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *imageNameArr;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)TeamHeaderView *teamHeaderView;
@property (nonatomic, assign)BOOL isLiked;
@property (nonatomic, assign)NSInteger likerCount;
//是否是队长
@property (nonatomic, assign)BOOL isOwner;
//是否是队员
@property (nonatomic, assign)BOOL isMember;
//判断是否已经关注
@property (nonatomic, assign)BOOL isFocused;
@property (nonatomic, assign)NSInteger followerCount;



@end

@implementation TeamDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"团队主页";
    _isLiked = NO;
    _isOwner = NO;
    _isMember = NO;
    _isFocused = NO;
    
    _rowCountArr = @[@"1", @"6", @"1"];
    _titleArr = @[@[@"最近访客"], @[@"团队简介", @"团队成员", @"团队动态", @"团队需求", @"团队成果", @"团队竞赛"], @[@"举报"]];
    _imageNameArr = @[@[@"visitors_icon"], @[@"information_icon", @"member_icon", @"team_event_icon", @"create_team_icon", @"create_team_icon", @"competition_icon"], @[@"report_icon"]];

    [self checkIsOwner:^{
        if (_isOwner) {
            _rowCountArr = @[@"1", @"6", @"4"];
            _titleArr = @[@[@"最近访客"], @[@"团队简介", @"团队成员", @"团队动态", @"团队需求", @"团队成果", @"团队竞赛"], @[@"任务管理", @"申请加入", @"通知", @"举报"]];
            _imageNameArr = @[@[@"visitors_icon"], @[@"information_icon", @"member_icon", @"team_event_icon", @"create_team_icon", @"create_team_icon", @"competition_icon"], @[@"team_task_management", @"team_application_icon", @"team_message_icon", @"report_icon"]];
        }else if(_isMember){
            _rowCountArr = @[@"1", @"6", @"2"];
            _titleArr = @[@[@"最近访客"], @[@"团队简介", @"团队成员", @"团队动态", @"团队需求", @"团队成果", @"团队竞赛"], @[@"通知", @"举报"]];
            _imageNameArr = @[@[@"visitors_icon"], @[@"information_icon", @"member_icon", @"team_event_icon", @"create_team_icon", @"create_team_icon", @"competition_icon"], @[@"team_message_icon", @"report_icon"]];
            [self addBottomButton];
        }else{
            _rowCountArr = @[@"1", @"6", @"1"];
            _titleArr = @[@[@"最近访客"], @[@"团队简介", @"团队成员", @"团队动态", @"团队需求", @"团队成果", @"团队竞赛"], @[@"举报"]];
            _imageNameArr = @[@[@"visitors_icon"], @[@"information_icon", @"member_icon", @"team_event_icon", @"create_team_icon", @"create_team_icon", @"competition_icon"], @[@"report_icon"]];
            [self addBottomButton];
        }
        [_tableView reloadData];
    }];
    
    //设置导航栏的左边按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _tableView = [UITableView new];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(_isOwner? 0 : -bottomButtonHeight);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 48;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"ImageTitleArrowCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
    
    _teamHeaderView = [TeamHeaderView teamHeaderView];
    __weak typeof(self) weakSelf = self;
    _teamHeaderView.QRCodeClickBlock = ^{
        UIStoryboard *personalSB = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
        PersonalQRCodeController *vc = [personalSB instantiateViewControllerWithIdentifier:@"QRCodeController"];
        vc.object_id = weakSelf.teamModel.team_id;
        vc.type = @"team";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    _teamHeaderView.LikeClickBlock = ^{
        if (weakSelf.isLiked) {
            [weakSelf unLike:weakSelf.teamModel.team_id];
        }else{
            [weakSelf like:weakSelf.teamModel.team_id];
            
        }
    };
    
    _teamHeaderView.FocusButtonClickBlock = ^{
        if (weakSelf.isFocused) {
            //取消关注
            [weakSelf unFocus:weakSelf.teamModel.team_id];
        }else{
            [weakSelf focus:weakSelf.teamModel.team_id];
        }
    };


    [_tableView setTableHeaderView:_teamHeaderView];
    
    //检测是否点赞
    [self checkIfLike:_teamModel.team_id];
    //检测是否关注
    [self checkIfFocused:_teamModel.team_id];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self getTeamProfile];
}


- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)getTeamProfile{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_TEAM_PROFILE(_teamModel.team_id) success:^(id data, NSString *message) {
        NSLog(@"team profile:%@", data);
        _teamModel = [TeamModel mj_objectWithKeyValues:data];
        _likerCount = [_teamModel.liker_count integerValue];
        _followerCount = [_teamModel.fan_count integerValue];
        [_teamHeaderView setHeaderByTeamModel:_teamModel];
    } failed:^(id data, NSString *message) {
        
    }];
}

//添加底部按钮
- (void)addBottomButton{
    UIButton *bottomButton = [UIButton new];
    [self.view addSubview:bottomButton];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(bottomButtonHeight);
        make.bottom.mas_equalTo(0);
    }];
    if (_isMember) {
        [bottomButton setTitle:@"退出团队" forState:UIControlStateNormal];
        [bottomButton setBackgroundColor:[UIColor redColor]];
        [bottomButton addTarget:self action:@selector(quitTeam) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [bottomButton setTitle:@"加入团队" forState:UIControlStateNormal];
        [bottomButton setBackgroundColor: MAIN_COLOR];
        [bottomButton addTarget:self action:@selector(sendTeamRequest) forControlEvents:UIControlEventTouchUpInside];
    }
}

//向团队发送加入请求
- (void)sendTeamRequest{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    UITextField *textField = [alert addTextField:@"输入团队验证信息"];
    alert.customViewColor = MAIN_COLOR;
    [alert addButton:@"确定" actionBlock:^(void) {
        [[NetRequest sharedInstance] httpRequestWithPost:URL_TEAM_MEMBER_REQUESTS(_teamModel.team_id) parameters:@{@"description": textField.text} withToken:NO success:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"发送成功" andTime:1.0f];
        } failed:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        }];
    }];
    
    [alert showEdit:self title:@"加入团队" subTitle:@"" closeButtonTitle:@"取消" duration:0.0f];

}


//退出团队
- (void)quitTeam{
    UserModel *userModel = [[UserManager sharedManager] getCurrentUser];
    [[NetRequest sharedInstance] httpRequestWithDELETE:URL_CHECK_IS_MEMBER(_teamModel.team_id, userModel.user_id) success:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"退出团队成功" andTime:1.5f DoneBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"退出团队失败" andTime:1.5f];
    }];
}



//检测是否点过赞
- (void)checkIfLike: (NSString *)team_id{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_TEAM_LIKE_AND_UNLIKE(team_id) success:^(id data, NSString *message) {
        NSLog(@"已点赞");
        _isLiked = YES;
        [_teamHeaderView setLikeImg:_isLiked];
    } failed:^(id data, NSString *message) {
        NSLog(@"未点赞");
        _isLiked = NO;
        [_teamHeaderView setLikeImg:_isLiked];
    }];
}

//点赞
- (void)like: (NSString *)team_id{
    [[NetRequest sharedInstance] httpRequestWithPost:URL_TEAM_LIKE_AND_UNLIKE(team_id)  parameters:@{} withToken:NO success:^(id data, NSString *message) {
        _isLiked = YES;
        [_teamHeaderView setLikeImg:_isLiked];
        _likerCount = _likerCount + 1;
        NSLog(@"点赞成功 %ld", _likerCount);
        [_teamHeaderView setCount:[NSString stringWithFormat:@"%ld", _likerCount]];
    } failed:^(id data, NSString *message) {
        
    }];
}

//取消点赞
- (void)unLike: (NSString *)team_id{
    [[NetRequest sharedInstance] httpRequestWithDELETE:URL_TEAM_LIKE_AND_UNLIKE(team_id) success:^(id data, NSString *message) {
        _isLiked = NO;
        [_teamHeaderView setLikeImg:_isLiked];
        _likerCount = _likerCount - 1;
        NSLog(@"取消点赞成功 %ld", _likerCount);
        [_teamHeaderView setCount:[NSString stringWithFormat:@"%ld", _likerCount]];
    } failed:^(id data, NSString *message) {
    }];
}


//测试是否是团队成员
- (void)checkIsMember : (void(^)())doneBlock{
    UserModel *userModel = [[UserManager sharedManager] getCurrentUser];
    [[NetRequest sharedInstance] httpRequestWithGET:URL_CHECK_IS_MEMBER(_teamModel.team_id, userModel.user_id) success:^(id data, NSString *message) {
        //
        _isMember = YES;
        if (doneBlock) {
            doneBlock();
        }
    } failed:^(id data, NSString *message) {
        _isMember = NO;
        if (doneBlock) {
            doneBlock();
        }
    }];
}

//测试是否是团队队长
- (void)checkIsOwner : (void(^)())doneBlock{
    UserModel *userModel = [[UserManager sharedManager] getCurrentUser];
    if ([_teamModel.owner_id isEqualToString: userModel.user_id]) {
        _isOwner = YES;
        if (doneBlock) {
            doneBlock();
        }
    }else{
        _isOwner = NO;
        [self checkIsMember: doneBlock];
    }
}

//监测是否关注过
- (void)checkIfFocused: (NSString *)team_id{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_FOCUS_TEAM(team_id) success:^(id data, NSString *message) {
        NSLog(@"已关注");
        _isFocused = YES;
        [_teamHeaderView setFocusButtonImage:_isFocused];
    } failed:^(id data, NSString *message) {
        NSLog(@"未关注");
        _isFocused = NO;
        [_teamHeaderView setFocusButtonImage:_isFocused];
    }];
}

//关注
- (void)focus: (NSString *)team_id{
    [[NetRequest sharedInstance] httpRequestWithPost:URL_FOCUS_TEAM(team_id) parameters:@{} withToken:NO success:^(id data, NSString *message) {
        _isFocused = YES;
        [_teamHeaderView setFocusButtonImage:_isFocused];
        _followerCount = _followerCount + 1;
        [_teamHeaderView setFollowersCount:[NSString stringWithFormat:@"%ld", _followerCount]];
    } failed:^(id data, NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
    }];
}

//取消关注
- (void)unFocus: (NSString *)team_id{
    [[NetRequest sharedInstance] httpRequestWithDELETE:URL_FOCUS_TEAM(team_id) success:^(id data, NSString *message) {
        _isFocused = NO;
        [_teamHeaderView setFocusButtonImage:_isFocused];
        _followerCount = _followerCount - 1;
        [_teamHeaderView setFollowersCount:[NSString stringWithFormat:@"%ld", _followerCount]];
    } failed:^(id data, NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
    }];
}

//进去团队的群组
- (void)enterGroup{
    //新建一个聊天会话View Controller对象,建议这样初始化
    RCConversationViewController *chat = [[RCConversationViewController alloc] initWithConversationType:ConversationType_GROUP
                                                                                               targetId:_teamModel.team_id];
    
    //设置聊天会话界面要显示的标题
    chat.title = _teamModel.name;
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_rowCountArr[section] integerValue];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageTitleArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title.text = _titleArr[indexPath.section][indexPath.row];
    cell.img.image = [UIImage imageNamed:_imageNameArr[indexPath.section][indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _rowCountArr.count;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ObjectListController *vc = [[ObjectListController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.displayType = Team_Visitors;
            vc.object_id = _teamModel.team_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            //团队简介
            TeamIntroductionController *vc = [TeamIntroductionController new];
            if (_isOwner) {
                vc.identity = 0;
            }else if(_isMember){
                vc.identity = 1;
            }else{
                vc.identity = 2;
            }
            vc.teamModel = _teamModel;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 1){
            //团队成员
            TeamMemberController *vc = [TeamMemberController new];
            vc.model = _teamModel;
            vc.isOwner = _isOwner;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 2){
            
        }else if(indexPath.row == 3){
            //团队需求
            NeedCategoryController *vc = [NeedCategoryController new];
            vc.model = _teamModel;
            vc.isOwner = _isOwner;
            vc.enterWay = 1;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 4){
            //团队成果
            ObjectListController *vc = [[ObjectListController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.displayType = Team_Achievements;
            vc.object_id = _teamModel.team_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else{
        if (_isOwner) {
            if (indexPath.row == 0) {
                //任务管理
                TaskCategoryController *vc = [TaskCategoryController new];
                vc.teamModel = _teamModel;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if(indexPath.row == 1){
                //申请加入
                ObjectListController *vc = [[ObjectListController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.displayType = Team_Member_Requests;
                vc.object_id = _teamModel.team_id;
                [self.navigationController pushViewController:vc animated:YES];
            }else if(indexPath.row == 2){
                //通知
                [self enterGroup];
            }else{
                //举报
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                UITextField *textField = [alert addTextField:@"输入举报内容"];
                [alert addButton:@"确定" actionBlock:^(void) {
                    [CommonTool reportWithType:@"team" Content:textField.text ObjectId:_teamModel.team_id success:^{
                        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"举报成功" andTime:1.0f];
                    } failed:^(NSString *message){
                        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
                    }];
                }];
                
                [alert showEdit:self title:@"举报" subTitle:@"" closeButtonTitle:@"取消" duration:0.0f];
            }
        }else if(_isMember){
            if (indexPath.row == 0) {
                //通知
                [self enterGroup];
            }else{
                //举报
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                UITextField *textField = [alert addTextField:@"输入举报内容"];
                [alert addButton:@"确定" actionBlock:^(void) {
                    [CommonTool reportWithType:@"team" Content:textField.text ObjectId:_teamModel.team_id success:^{
                        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"举报成功" andTime:1.0f];
                    } failed:^(NSString *message){
                        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
                    }];
                }];
                
                [alert showEdit:self title:@"举报" subTitle:@"" closeButtonTitle:@"取消" duration:0.0f];
            }
        }else{
            if (indexPath.row == 0) {
                //举报
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                UITextField *textField = [alert addTextField:@"输入举报内容"];
                [alert addButton:@"确定" actionBlock:^(void) {
                    [CommonTool reportWithType:@"team" Content:textField.text ObjectId:_teamModel.team_id success:^{
                        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"举报成功" andTime:1.0f];
                    } failed:^(NSString *message){
                        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
                    }];
                }];
                
                [alert showEdit:self title:@"举报" subTitle:@"" closeButtonTitle:@"取消" duration:0.0f];
            }
        }
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor = LINE_COLOR;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 14;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"goToPersonalQRCode"]) {
        PersonalQRCodeController *vc = segue.destinationViewController;
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

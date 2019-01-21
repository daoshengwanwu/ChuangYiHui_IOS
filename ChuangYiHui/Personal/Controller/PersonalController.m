//
//  PersonalController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/8.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "PersonalController.h"
#import "ObjectListController.h"
#import "ImageTitleArrowCell.h"
#import "PersonalHeaderView.h"
#import "TeamCategoryController.h"
#import "PersonalQRCodeController.h"
#import "CreateTeamController.h"
#import "PersonalConversationListViewController.h"
#import "SetUpController.h"
#import "PersonalInformationController.h"
#import "TaskStatusController.h"
#import <RongIMKit/RongIMKit.h>
#import "IdentityVerifyController.h"
#import "IdentityVerifyStatusController.h"
#import "CreateZjcgController.h"

#define cellIdentifier @"imageTitleArrowCell"
#define cellHeight 48

@interface PersonalController ()

@property (nonatomic, strong)NSArray *rowCountArr;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *imageNameArr;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)PersonalHeaderView *personalHeaderView;
@property (nonatomic, strong)UserModel *userModel;



@end


@implementation PersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    _rowCountArr = @[@"1", @"5", @"2", @"3", @"2", @"2", @"1"];
    _titleArr = @[@[@"邀请码"], @[@"个人信息",@"创建团队", @"个人动态",@"发布专家成果",  @"经历背景"], @[@"身份认证", @"实名认证"],@[@"团队列表", @"邀请列表", @"好友申请"], @[@"我的活动", @"我的竞赛"], @[@"我的任务", @"我关注的动态"], @[@"设置"]];
    _imageNameArr = @[@[@"invite_code_icon"], @[@"information_icon", @"create_team_icon", @"event_icon",@"event_icon", @"exp_background_icon"], @[@"exp_background_icon", @"exp_background_icon"], @[@"team_list_icon", @"invitation_icon", @"friend_request_icon"], @[@"activity_icon", @"competition_icon"], @[@"task_icon", @"focus_event_icon"], @[@"setup_icon"]];
    
    _tableView = [UITableView new];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 48;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"ImageTitleArrowCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
    
    _personalHeaderView = [PersonalHeaderView personalHeaderView];
    __weak typeof(self) weakSelf = self;
    _personalHeaderView.QRCodeClickBlock = ^{
        [weakSelf performSegueWithIdentifier:@"goToPersonalQRCode" sender:weakSelf];
    };
    
    
    if ([CommonTool checkIfLogin:self]) {
        _personalHeaderView.FriendClickBlock = ^{
            ObjectListController *vc = [[ObjectListController alloc] init];
            vc.displayType = User_Friends;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        _personalHeaderView.FollowerClickBlock = ^{
            ObjectListController *vc = [[ObjectListController alloc] init];
            vc.displayType = User_Follower;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        _personalHeaderView.ScoreClickBlock = ^{
            ObjectListController *vc = [[ObjectListController alloc] init];
            vc.displayType = User_Score;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        _personalHeaderView.FollowedClickBlock = ^{
            TeamCategoryController *vc = [TeamCategoryController new];
            vc.type = 1;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        _personalHeaderView.headIconClickBlock = ^{
            PersonalInformationController *vc = [PersonalInformationController new];
            vc.hidesBottomBarWhenPushed = YES;
            vc.userModel = weakSelf.userModel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    
    [_tableView setTableHeaderView:_personalHeaderView];
    
    [self setLeftButton];
    

    
}


- (void)viewWillAppear:(BOOL)animated{
    [self getUserProfile];
}


- (void)setLeftButton{
    //设置导航栏的左边按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 29)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"personal_message_icon"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;

}

- (void)leftButtonAction{
    if ([CommonTool checkIfLogin:self]) {
        PersonalConversationListViewController *vc =[PersonalConversationListViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        //    vc.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


//获取个人资料
- (void)getUserProfile{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_SELF_PROFILE success:^(id data, NSString *message) {
        NSLog(@"self profile: %@", data);
        _userModel = [UserModel mj_objectWithKeyValues:data];
        UserModel *userModel = [[UserManager sharedManager] getCurrentUser];
        [_userModel setToken:userModel.token];
        [[UserManager sharedManager] saveUserInfo:_userModel];
        
        [_personalHeaderView setHeaderByUserModel:_userModel];
    } failed:^(id data, NSString *message) {
//        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//#pragma mark UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    UIColor *color = [UIColor colorWithRed:45/255.0 green:45/255.0 blue:45/255.0 alpha:1];
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY >= - (SCREEN_HEIGHT) * 0.5 - 64 - 64) {
//        CGFloat alpha = MIN(1, ((SCREEN_HEIGHT) * 0.5 - 64 + 64 + offsetY)/((SCREEN_HEIGHT) * 0.5 - 64));
////        [self.navigationController.navigationBar cnSetBackgroundColor:[color colorWithAlphaComponent:alpha]];
//        //替换这种方式
//        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:alpha];
//        //---end---
//    } else {
//        //[self.navigationController.navigationBar cnSetBackgroundColor:[color colorWithAlphaComponent:0]];
//        //替换这种方式
//        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
//        //---end---
//    }
//}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_rowCountArr[section] integerValue];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageTitleArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title.text = _titleArr[indexPath.section][indexPath.row];
    cell.img.image = [UIImage imageNamed:_imageNameArr[indexPath.section][indexPath.row]];
    if([cell.title.text isEqualToString:@"发布专家成果"] && ![_userModel.role isEqualToString:@"专家"])
    {
        cell.hidden = YES;//重点
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    //在设置高度的回调中获取当前indexpath的cell 然后返回给他的frame的高度即可。在创建cell的时候记得最后把cell.frame.size.height 等于你内容的高。

//    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];

    /*此写法会导致循环引用。引起崩溃
     UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
     */
    if(indexPath.section == 1 && indexPath.row == 3 && ![_userModel.role isEqualToString:@"专家"])
    {
        return 0;//重点
    }

    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _rowCountArr.count;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([CommonTool checkIfLogin:self]) {
        if (indexPath.section == 0) {
            
        }else if(indexPath.section == 1){
            if (indexPath.row == 0) {
                PersonalInformationController *vc = [PersonalInformationController new];
                vc.hidesBottomBarWhenPushed = YES;
                vc.userModel = _userModel;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (indexPath.row == 1) {
                //创建团队
                CreateTeamController *vc = [CreateTeamController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if(indexPath.row == 2){
                //个人动态
            }else if(indexPath.row == 3){
                //发布专家成果
                CreateZjcgController *vc = [CreateZjcgController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                //经历背景
                TeamCategoryController *vc = [[TeamCategoryController alloc] init];
                vc.type = 4;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if(indexPath.section == 2){
            //身份认证和实名认证
            if (indexPath.row == 0) {
                if ([_userModel.is_role_verified isEqualToString:@"0"]) {
                    
                    //身份认证,未提交
                    IdentityVerifyController *vc = [IdentityVerifyController new];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    
                    //身份认证，已提交
                    IdentityVerifyStatusController *vc = [IdentityVerifyStatusController new];
                    vc.status = [_userModel.is_role_verified integerValue];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }else{
                //实名认证
            }
            
        }else if(indexPath.section == 3){
            if (indexPath.row == 2) {
                ObjectListController *vc = [[ObjectListController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.displayType = User_Friend_Invitation;
                [self.navigationController pushViewController:vc animated:YES];
            }else if(indexPath.row == 1){
                ObjectListController *vc = [[ObjectListController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.displayType = User_Team_Invitation;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                TeamCategoryController *vc = [TeamCategoryController new];
                vc.type = 0;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if(indexPath.section == 4){
            
        }else if(indexPath.section == 5){
            if (indexPath.row == 0) {
                //我的任务
                TaskStatusController *vc = [TaskStatusController new];
                //内部任务
                vc.type = 0;
                vc.enterWay = 1;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                //我关注的动态
            }
            
        }else{
            //        SetUpController *vc = [SetUpController new];
            //        vc.hidesBottomBarWhenPushed = YES;
            //        [self.navigationController pushViewController:vc animated:YES];
            [self performSegueWithIdentifier:@"goToSetupController" sender:self];
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
        vc.object_id = _userModel.user_id;
        vc.type = @"user";
    }
}
@end

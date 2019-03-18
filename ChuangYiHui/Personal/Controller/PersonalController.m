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
#import "LBXScan1ViewController.h"
#import "StyleDIY.h"

#import "RealNameVerifyController.h"
#import "RealNameVerifyStatusController.h"

#define cellIdentifier @"imageTitleArrowCell"
#define cellHeight 48

@interface PersonalController ()

@property (nonatomic, strong)NSArray *rowCountArr;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *imageNameArr;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)PersonalHeaderView *personalHeaderView;
@property (nonatomic, strong)UserModel *userModel;
@property (nonatomic, strong)NSString *invitecode;



@end


@implementation PersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpRightButton];
    _rowCountArr = @[@"1", @"5", @"4", @"3", @"2", @"1"];
    _titleArr = @[@[@"邀请码"], @[@"个人动态",@"经历背景", @"实名认证" ,@"身份认证",@"发布专家成果"],@[@"团队列表", @"创建团队", @"邀请列表", @"好友申请"], @[@"我的活动", @"我的竞赛",@"我的收藏"], @[@"我的任务", @"我关注的动态"], @[@"设置"]];
    _imageNameArr = @[@[@"invite_code_icon"], @[@"event_icon", @"exp_background_icon", @"exp_background_icon",@"exp_background_icon",@"event_icon"], @[@"team_list_icon",@"create_team_icon", @"invitation_icon", @"friend_request_icon"], @[@"activity_icon", @"competition_icon",@"star_icon_hover"], @[@"task_icon", @"focus_event_icon"], @[@"setup_icon"]];
    
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

- (void)setUpRightButton{
    //设置导航栏的右边按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [rightButton setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightButtonAction
{
    NSString *textToShare = @"分享世纪智库！";
    UIImage *imageToShare = [UIImage imageNamed:@"logo_icon"];
    NSURL *urlToShare = [NSURL URLWithString:@"http://blog.csdn.net/Boyqicheng"];
    // 分享的图片不能为空
    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    // 排除（UIActivityTypeAirDrop）AirDrop 共享、(UIActivityTypePostToFacebook)Facebook
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypeAirDrop];
    [self presentViewController:activityVC animated:YES completion:nil];
    // 通过block接收结果处理
    UIActivityViewControllerCompletionWithItemsHandler completionHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        if (completed) {
//            [self showAlertViewWithMsg:@"恭喜你，分享成功！"];
            NSLog(@"分享成功");
        }else{
//            [self showAlertViewWithMsg:@"很遗憾，分享失败！"];
            NSLog(@"分享失败");
        }
    };
    activityVC.completionWithItemsHandler = completionHandler;
}


- (void)viewWillAppear:(BOOL)animated{
    [self getUserProfile];
    [self getInviteCode];
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
//        NSLog(@"self invite code: %@", _userModel.invitation_code);
    } failed:^(id data, NSString *message) {
//        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
    }];
}

//获取邀请码
- (void)getInviteCode{
    NSLog(@"getInvitecode");
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_INVITECODE success:^(id data, NSString *message) {
//        NSLog(@"self invite code: %@", data);
        UserModel *modela = [UserModel mj_objectWithKeyValues:data];
        _invitecode = modela.invitation_code;
        NSLog(@"self invite code: %@", _invitecode);
        
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0  inSection:0];
//        ImageTitleArrowCell *cell1 = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell1.title.text = _invitecode;
//        cell1.img.image = [UIImage imageNamed:_imageNameArr[indexPath.section][indexPath.row]];
        
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
    
//    if(indexPath.section == 0 &&indexPath.row == 0){
//        NSLog(@"self invite code1: %@", _invitecode);
//        cell.title.text = _invitecode;
//    }
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
    if(indexPath.section == 1 && indexPath.row == 4 && ![_userModel.role isEqualToString:@"专家"])
    {
        return 0;//重点
    }

    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _rowCountArr.count;
}

//查看邀请码
- (void)seeInviteCode
{
    // 1.创建弹框控制器, UIAlertControllerStyleAlert这个样式代表弹框显示在屏幕中央
    NSString *mess = [NSString stringWithFormat:@"您的邀请码为%@，邀请好友注册世纪智库时输入邀请码可以增加积分",_invitecode];
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:mess preferredStyle:UIAlertControllerStyleAlert];
    // 2.添加取消按钮，block中存放点击了“取消”按钮要执行的操作
//    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        NSLog(@"点击了取消按钮");
//    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"点击了确定按钮");
    }];
    // 3.将“取消”和“确定”按钮加入到弹框控制器中
//    [alertVc addAction:cancle];
    [alertVc addAction:confirm];
    // 4.控制器 展示弹框控件，完成时不做操作
    [self presentViewController:alertVc animated:YES completion:^{
        nil;
    }];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([CommonTool checkIfLogin:self]) {
        if (indexPath.section == 0) {
            [self seeInviteCode];
        }else if(indexPath.section == 1){
            if(indexPath.row == 0){
                //个人动态
            }else if (indexPath.row == 1){
                //经历背景
                TeamCategoryController *vc = [[TeamCategoryController alloc] init];
                vc.type = 4;
                NSLog(@"_userModel.role=%@",_userModel.role);
                if ([_userModel.role isEqualToString:@"专家"]){
                    vc.type = 5;
                }
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (indexPath.row == 3) {
                //身份认证
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
            }else if(indexPath.row == 2){
                
                //实名认证
                //0 未实名 1 待审核 2 已实名 3 实名失败 4 eID实名通过
                if ([_userModel.is_verified integerValue] == 0) {
                    RealNameVerifyController *vc = [RealNameVerifyController new];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if([_userModel.is_verified integerValue] == 1){
                    RealNameVerifyStatusController *vc = [RealNameVerifyStatusController new];
                    vc.status = [_userModel.is_role_verified integerValue];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if([_userModel.is_verified integerValue] == 2){
                    RealNameVerifyStatusController *vc = [RealNameVerifyStatusController new];
                    vc.status = [_userModel.is_role_verified integerValue];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if([_userModel.is_verified integerValue] == 3){
                    RealNameVerifyStatusController *vc = [RealNameVerifyStatusController new];
                    vc.status = [_userModel.is_role_verified integerValue];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else if([_userModel.is_verified integerValue] == 4){
                    RealNameVerifyStatusController *vc = [RealNameVerifyStatusController new];
                    vc.status = [_userModel.is_role_verified integerValue];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else if(indexPath.row == 4){
                //发布专家成果
                CreateZjcgController *vc = [CreateZjcgController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if(indexPath.section == 2){
            if (indexPath.row == 3) {
                ObjectListController *vc = [[ObjectListController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.displayType = User_Friend_Invitation;
                [self.navigationController pushViewController:vc animated:YES];
            }else if(indexPath.row == 2){
                ObjectListController *vc = [[ObjectListController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.displayType = User_Team_Invitation;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (indexPath.row == 1) {
                //创建团队
                if ([_userModel.is_role_verified isEqualToString:@"0"]){
                    // 1.创建弹框控制器, UIAlertControllerStyleAlert这个样式代表弹框显示在屏幕中央
                    NSString *mess = @"身份认证成功后才能创建团队";
                    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:mess preferredStyle:UIAlertControllerStyleAlert];
                    // 2.添加取消按钮，block中存放点击了“取消”按钮要执行的操作
                    //    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    //        NSLog(@"点击了取消按钮");
                    //    }];
                    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        NSLog(@"点击了确定按钮");
                    }];
                    // 3.将“取消”和“确定”按钮加入到弹框控制器中
                    //    [alertVc addAction:cancle];
                    [alertVc addAction:confirm];
                    // 4.控制器 展示弹框控件，完成时不做操作
                    [self presentViewController:alertVc animated:YES completion:^{
                        nil;
                    }];
                }else{
                    CreateTeamController *vc = [CreateTeamController new];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else if (indexPath.row == 0){
                TeamCategoryController *vc = [TeamCategoryController new];
                vc.type = 0;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if(indexPath.section == 3){
            
        }else if(indexPath.section == 4){
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

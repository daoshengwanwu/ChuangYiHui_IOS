//
//  UserDetailController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/9.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "UserDetailController.h"
#import "ObjectListController.h"
#import "ImageTitleArrowCell.h"
#import "TeamCategoryController.h"
#import "PersonalQRCodeController.h"
#import "TeamCategoryController.h"
#import "UserHeaderView.h"
#import <RongIMKit/RongIMKit.h>
#import "UserInformationController.h"


#define cellIdentifier @"imageTitleArrowCell"
#define cellHeight 48
#define bottomViewHeight 65

@interface UserDetailController ()

@property (nonatomic, strong)NSArray *rowCountArr;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *imageNameArr;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UserHeaderView *personalHeaderView;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, assign)BOOL isLiked;
//检测是否是朋友
@property (nonatomic, assign)BOOL isFriend;
//判断是否已经关注
@property (nonatomic, assign)BOOL isFocused;
@property (nonatomic, assign)NSInteger likerCount;
@property (nonatomic, assign)NSInteger followerCount;





@end

@implementation UserDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创友主页";
    self.view.backgroundColor = [UIColor whiteColor];
    _isLiked = NO;
    _isFriend = NO;
    _isFocused = NO;
    
    
//    [self checkIfFriend:^{
//        if (_isFriend) {
//            //已经是好友
//        }else{
//            //非好友
//        }
//    }];
    
    //设置导航栏的左边按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    _rowCountArr = @[@"2", @"2", @"2", @"3"];
    _titleArr = @[@[@"个人信息", @"经历背景"], @[@"个人动态", @"团队经历"], @[@"他的活动", @"他的竞赛"], @[@"个人标签", @"朋友评价", @"举报"]];
    _imageNameArr = @[@[@"information_icon", @"exp_background_icon"], @[@"event_icon", @"create_team_icon"], @[@"activity_icon", @"competition_icon"], @[@"tag_icon", @"comment_icon", @"report_icon"]];
    
    _tableView = [UITableView new];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-bottomViewHeight);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 48;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"ImageTitleArrowCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
    
    _personalHeaderView = [UserHeaderView userHeaderView];
    __weak typeof(self) weakSelf = self;
    _personalHeaderView.QRCodeClickBlock = ^{
        UIStoryboard *personalSB = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
        PersonalQRCodeController *vc = [personalSB instantiateViewControllerWithIdentifier:@"QRCodeController"];
        vc.object_id = weakSelf.model.user_id;
        vc.type = @"user";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    _personalHeaderView.FriendClickBlock = ^{
        
    };
    
    _personalHeaderView.FollowerClickBlock = ^{
        
    };
    
    _personalHeaderView.ScoreClickBlock = ^{
        
    
    };
    
    _personalHeaderView.LikeClickBlock = ^{
        NSLog(@"test");
        if (weakSelf.isLiked) {
            [weakSelf unLike:weakSelf.model.user_id];
        }else{
            [weakSelf like:weakSelf.model.user_id];

        }
    };
    
    _personalHeaderView.FocusButtonClickBlock = ^{
        if (weakSelf.isFocused) {
            //取消关注
            [weakSelf unFocus:weakSelf.model.user_id];
        }else{
            [weakSelf focus:weakSelf.model.user_id];
        }
    };
    
    _personalHeaderView.FollowedClickBlock = ^{
//        TeamCategoryController *vc = [TeamCategoryController new];
//        vc.type = 1;
//        vc.hidesBottomBarWhenPushed = YES;
//        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    [_tableView setTableHeaderView:_personalHeaderView];
    
    [self getUserProfile];
    [self checkIfLike:_model.user_id];
    [self checkIfFocused:_model.user_id];
    [self addBottonView];

}


- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)addBottonView{
    // 非好友： 邀请 加好友 发信息
    // 好友：   邀请 评论  发信息
    _bottomView = [UIView new];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(bottomViewHeight);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    UIView *leftView = [UIView new];
    [_bottomView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH/3);
    }];
    leftView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *leftViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftViewTapAction)];
    [leftView addGestureRecognizer:leftViewTap];
    
    //图片
    UIImageView *leftViewImage = [UIImageView new];
    [leftView addSubview:leftViewImage];
    [leftViewImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(30);
        make.centerX.equalTo(leftView.mas_centerX);
        make.top.mas_equalTo(5);
    }];
    leftViewImage.image = [UIImage imageNamed:@"user_invitation_icon"];
    
    //文字
    UILabel *leftViewLabel = [UILabel new];
    [leftView addSubview:leftViewLabel];
    [leftViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView.mas_centerX);
        make.top.equalTo(leftViewImage.mas_bottom).offset(5);
    }];
    leftViewLabel.text = @"邀请";
    leftViewLabel.font = [UIFont systemFontOfSize:15.0];
    
    
    UIView *middleView = [UIView new];
    [_bottomView addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right);
        make.top.bottom.mas_equalTo(0);
        make.width.equalTo(leftView.mas_width);
    }];
    middleView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *middleViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(middleViewTapAction)];
    [middleView addGestureRecognizer:middleViewTap];
    
    //图片
    UIImageView *middleViewImage = [UIImageView new];
    [middleView addSubview:middleViewImage];
    [middleViewImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(30);
        make.centerX.equalTo(middleView.mas_centerX);
        make.top.mas_equalTo(5);
    }];
    
    //文字
    UILabel *middleViewLabel = [UILabel new];
    [middleView addSubview:middleViewLabel];
    [middleViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(middleView.mas_centerX);
        make.top.equalTo(middleViewImage.mas_bottom).offset(5);
    }];
    middleViewLabel.font = [UIFont systemFontOfSize:15.0];

    
    [self checkIfFriend:^{
        if (_isFriend) {
            //已经是好友
            NSLog(@"评价");
            middleViewLabel.text = @"评价";
            middleViewImage.image = [UIImage imageNamed:@"comment_icon"];
        }else{
            //非好友
            NSLog(@"加好友");
            //        NSLog(@"加好友%@",_isFriend);
            middleViewLabel.text = @"加好友";
            middleViewImage.image = [UIImage imageNamed:@"add_friend_icon"];
        }
    }];
//    if (_isFriend) {
//        NSLog(@"评价");
//        middleViewLabel.text = @"评价";
//        middleViewImage.image = [UIImage imageNamed:@"comment_icon"];
//    }else{
//         NSLog(@"加好友");
////        NSLog(@"加好友%@",_isFriend);
//        middleViewLabel.text = @"加好友";
//        middleViewImage.image = [UIImage imageNamed:@"add_friend_icon"];
//    }
    
    UIView *rightView = [UIView new];
    [_bottomView addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.equalTo(leftView.mas_width);
    }];
    rightView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *rightViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightViewTapAction)];
    [rightView addGestureRecognizer:rightViewTap];
    //图片
    UIImageView *rightViewImage = [UIImageView new];
    [rightView addSubview:rightViewImage];
    [rightViewImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(30);
        make.centerX.equalTo(rightView.mas_centerX);
        make.top.mas_equalTo(5);
    }];
    rightViewImage.image = [UIImage imageNamed:@"send_message_icon"];
    
    //文字
    UILabel *rightViewLabel = [UILabel new];
    [rightView addSubview:rightViewLabel];
    [rightViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightView.mas_centerX);
        make.top.equalTo(rightViewImage.mas_bottom).offset(5);
    }];
    rightViewLabel.text = @"发消息";
    rightViewLabel.font = [UIFont systemFontOfSize:15.0];

}


- (void)leftViewTapAction{
    [self invite];
}

- (void)middleViewTapAction{
    if (_isFriend) {
//        NSLog(@"专家%@",_isFriend);
        if([_model.role isEqualToString:@"专家"]){
            [self use2];
        }else{
            [self comment];
        }
    }else{
//        NSLog(@"专家2%@",_isFriend);
        UserModel *userModel1 = [[UserManager sharedManager] getCurrentUser];
        if(![userModel1.role isEqualToString:@"专家"] && [_model.role isEqualToString:@"专家"]){
            [self use1];
        }else{
            [self addFriendRequest];
        }
    }
}

- (void)use1

{
    
    // 1.创建弹框控制器, UIAlertControllerStyleAlert这个样式代表弹框显示在屏幕中央
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂不可添加专家好友" preferredStyle:UIAlertControllerStyleAlert];
    
    // 2.添加取消按钮，block中存放点击了“取消”按钮要执行的操作
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        NSLog(@"点击了取消按钮");
        
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSLog(@"点击了确定按钮");
        
    }];
    
    // 3.将“取消”和“确定”按钮加入到弹框控制器中
    
    [alertVc addAction:cancle];
    
    [alertVc addAction:confirm];
    
    // 4.控制器 展示弹框控件，完成时不做操作
    
    [self presentViewController:alertVc animated:YES completion:^{
        
        nil;
        
    }];
    
}

- (void)use2

{
    
    // 1.创建弹框控制器, UIAlertControllerStyleAlert这个样式代表弹框显示在屏幕中央
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂不可评论专家" preferredStyle:UIAlertControllerStyleAlert];
    
    // 2.添加取消按钮，block中存放点击了“取消”按钮要执行的操作
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        NSLog(@"点击了取消按钮");
        
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSLog(@"点击了确定按钮");
        
    }];
    
    // 3.将“取消”和“确定”按钮加入到弹框控制器中
    
    [alertVc addAction:cancle];
    
    [alertVc addAction:confirm];
    
    // 4.控制器 展示弹框控件，完成时不做操作
    
    [self presentViewController:alertVc animated:YES completion:^{
        
        nil;
        
    }];
    
}
- (void)use3

{
    
    // 1.创建弹框控制器, UIAlertControllerStyleAlert这个样式代表弹框显示在屏幕中央
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"仅可给好友发消息..." preferredStyle:UIAlertControllerStyleAlert];
    
    // 2.添加取消按钮，block中存放点击了“取消”按钮要执行的操作
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        NSLog(@"点击了取消按钮");
        
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSLog(@"点击了确定按钮");
        
    }];
    
    // 3.将“取消”和“确定”按钮加入到弹框控制器中
    
    [alertVc addAction:cancle];
    
    [alertVc addAction:confirm];
    
    // 4.控制器 展示弹框控件，完成时不做操作
    
    [self presentViewController:alertVc animated:YES completion:^{
        
        nil;
        
    }];
    
}


- (void)rightViewTapAction{
    if (_isFriend) {
        //已经是好友
        [self sendMessage];
    }else{
        //非好友
        [self use3];
    }
    
}

                                


//获取个人资料
- (void)getUserProfile{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_OTHER_USER_PROFILE(_model.user_id) success:^(id data, NSString *message) {
        _model = [UserModel mj_objectWithKeyValues:data];
        _likerCount = [_model.liker_count integerValue];
        _followerCount = [_model.follower_count integerValue];
        [_personalHeaderView setHeaderByUserModel:_model];
    } failed:^(id data, NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
    }];
}


//检测是否点过赞
- (void)checkIfLike: (NSString *)user_id{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_CHECK_IF_LIKE(user_id) success:^(id data, NSString *message) {
        NSLog(@"已点赞");
        _isLiked = YES;
        [_personalHeaderView setLikeImg:_isLiked];
    } failed:^(id data, NSString *message) {
        NSLog(@"未点赞");
        _isLiked = NO;
        [_personalHeaderView setLikeImg:_isLiked];
    }];
}

//点赞
- (void)like: (NSString *)user_id{
    [[NetRequest sharedInstance] httpRequestWithPost:URL_CHECK_IF_LIKE(user_id) parameters:@{} withToken:NO success:^(id data, NSString *message) {
        _isLiked = YES;
        [_personalHeaderView setLikeImg:_isLiked];
        _likerCount = _likerCount + 1;
        NSLog(@"点赞成功 %ld", _likerCount);
        [_personalHeaderView setCount:[NSString stringWithFormat:@"%ld", _likerCount]];
    } failed:^(id data, NSString *message) {
        
    }];
}

//取消点赞
- (void)unLike: (NSString *)user_id{
    [[NetRequest sharedInstance] httpRequestWithDELETE:URL_CHECK_IF_LIKE(user_id) success:^(id data, NSString *message) {
        _isLiked = NO;
        [_personalHeaderView setLikeImg:_isLiked];
        _likerCount = _likerCount - 1;
        NSLog(@"取消点赞成功 %ld", _likerCount);
        [_personalHeaderView setCount:[NSString stringWithFormat:@"%ld", _likerCount]];
    } failed:^(id data, NSString *message) {
    }];
}


//监测是否关注过
- (void)checkIfFocused: (NSString *)user_id{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_FOCUS_USER(user_id) success:^(id data, NSString *message) {
        NSLog(@"已关注");
        _isFocused = YES;
        [_personalHeaderView setFocusButtonImage:_isFocused];
    } failed:^(id data, NSString *message) {
        NSLog(@"未关注");
        _isFocused = NO;
        [_personalHeaderView setFocusButtonImage:_isFocused];
    }];
}

//关注
- (void)focus: (NSString *)user_id{
    [[NetRequest sharedInstance] httpRequestWithPost:URL_FOCUS_USER(user_id) parameters:@{} withToken:NO success:^(id data, NSString *message) {
        _isFocused = YES;
        [_personalHeaderView setFocusButtonImage:_isFocused];
        _followerCount = _followerCount + 1;
        [_personalHeaderView setFollowersCount:[NSString stringWithFormat:@"%ld", _followerCount]];
    } failed:^(id data, NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
    }];
}

//取消关注
- (void)unFocus: (NSString *)user_id{
    [[NetRequest sharedInstance] httpRequestWithDELETE:URL_FOCUS_USER(user_id) success:^(id data, NSString *message) {
        _isFocused = NO;
        [_personalHeaderView setFocusButtonImage:_isFocused];
        _followerCount = _followerCount - 1;
        [_personalHeaderView setFollowersCount:[NSString stringWithFormat:@"%ld", _followerCount]];
    } failed:^(id data, NSString *message) {
        [SVProgressHUD showErrorWithStatus:message];
    }];
}



//检测是否是朋友
- (void)checkIfFriend :(void(^)())doneBlock{
    UserModel *userModel = [[UserManager sharedManager] getCurrentUser];
    [[NetRequest sharedInstance] httpRequestWithGET:URL_CHECK_IF_FRIEND(userModel.user_id, _model.user_id) success:^(id data, NSString *message) {
        _isFriend = YES;
        NSLog(@"是好友");
        
        if (doneBlock) {
            doneBlock();
        }
    } failed:^(id data, NSString *message) {
        _isFriend = NO;
        NSLog(@"不是好友");
        if (doneBlock) {
            doneBlock();
        }
    }];
}

//邀请
- (void)invite{
    
}

//加好友
- (void)addFriendRequest{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.customViewColor = MAIN_COLOR;
    UITextField *textField = [alert addTextField:@"输入好友验证信息"];
    [alert addButton:@"确定" actionBlock:^(void) {
        [[NetRequest sharedInstance] httpRequestWithPost:URL_SEND_FRIEND_REQUEST(_model.user_id) parameters:@{@"description": textField.text} withToken:NO success:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"发送成功" andTime:1.0f];
        } failed:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        }];
    }];
    
    [alert showEdit:self title:@"加好友" subTitle:@"" closeButtonTitle:@"取消" duration:0.0f];
}

//发消息
- (void)sendMessage{
    //新建一个聊天会话View Controller对象,建议这样初始化
    RCConversationViewController *chat = [[RCConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE
        targetId:_model.user_id];
    
    //设置聊天会话界面要显示的标题
    chat.title = _model.name;
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}

//评价
- (void)comment{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.customViewColor = MAIN_COLOR;
    UITextField *textField = [alert addTextField:@"输入对该好友的评价"];
    [alert addButton:@"确定" actionBlock:^(void) {
        [[NetRequest sharedInstance] httpRequestWithPost:URL_GET_USER_COMMENTS(_model.user_id) parameters:@{@"content": textField.text} withToken:NO success:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"评价成功" andTime:1.0f];
        } failed:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        }];
    }];
    
    [alert showEdit:self title:@"评价" subTitle:@"" closeButtonTitle:@"取消" duration:0.0f];
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
//    NSLog(@"name:%@,role:%@",_model.name,_model.role);
    if([cell.title.text isEqualToString:@"朋友评价"] && [_model.role isEqualToString:@"专家"])
    {
        NSLog(@"name:%@,role:%@",_model.name,_model.role);
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
    if(indexPath.section == 3 && indexPath.row == 1 && [_model.role isEqualToString:@"专家"])
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //个人信息
            UserInformationController *vc = [UserInformationController new];
            vc.model = _model;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 1) {
            //他人的经历背景
            TeamCategoryController *vc = [[TeamCategoryController alloc] init];
            vc.type = 3;
            if ([_model.role isEqualToString:@"专家"]){
                vc.type = 6;
            }
            vc.user_id = _model.user_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 1) {
            //团队经历
            TeamCategoryController *vc = [[TeamCategoryController alloc] init];
            vc.type = 2;
            vc.user_id = _model.user_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if(indexPath.section == 2){
//        if (indexPath.row == 2) {
//            ObjectListController *vc = [[ObjectListController alloc] init];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.displayType = User_Friend_Invitation;
//            [self.navigationController pushViewController:vc animated:YES];
//        }else if(indexPath.row == 1){
//            ObjectListController *vc = [[ObjectListController alloc] init];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.displayType = User_Team_Invitation;
//            [self.navigationController pushViewController:vc animated:YES];
//        }else{
//            TeamCategoryController *vc = [TeamCategoryController new];
//            vc.type = 0;
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
    }else{
        if (indexPath.row == 0) {
            //个人标签
        }else if(indexPath.row == 1){
            //朋友评价
            if ([_model.role isEqualToString:@"专家"]){
                // 1.创建弹框控制器, UIAlertControllerStyleAlert这个样式代表弹框显示在屏幕中央
                NSString *mess = @"专家暂不支持朋友评价";
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
                ObjectListController *vc = [ObjectListController new];
                vc.object_id = _model.user_id;
                vc.displayType = User_Comments;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            //举报
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.customViewColor = MAIN_COLOR;
            UITextField *textField = [alert addTextField:@"输入举报内容"];
            [alert addButton:@"确定" actionBlock:^(void) {
                [CommonTool reportWithType:@"user" Content:textField.text ObjectId:_model.user_id success:^{
                    [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"举报成功" andTime:1.0f];
                } failed:^(NSString *message){
                    [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
                }];
            }];
            
            [alert showEdit:self title:@"举报" subTitle:@"" closeButtonTitle:@"取消" duration:0.0f];
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

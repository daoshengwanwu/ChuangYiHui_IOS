//
//  LoginController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/10.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "LoginController.h"
#import "UIBarButtonItem+GYY.h"
#import "TabViewController.h"

//#import "WXApiManager.h"
//#import "ADWXLoginResp.h"
//#import "ADCheckLoginResp.h"
//#import "ADUserInfo.h"
//#import "ADConnectResp.h"
//#import "ADNetworkEngine.h"
//#import "ADGetUserInfoResp.h"
//#import "AppDelegate.h"
//#import "ADNetworkEngine.h"
//#import "AppDelegate.h"
//#import "Definition.h"
//#import "DebugViewController.h"

//#import "UserInfoViewController.h"
#import "AppDelegate.h"


#define ScreenHeight [UIScreen mainScreen].bounds.size.height



static const int kWXLoginButtonWidth = 327;
static const int kWXLoginButtonHeight = 40;
static const CGFloat kWXLoginButtonFontSize = 16.0f;

static NSString* const kWXLoginErrorTitle = @"微信登录失败";
static NSString* const kConnectErrorTitle = @"连接服务器失败";
static NSString* const kWXAuthDenyTitle = @"授权失败";


/* Title Message */
static NSString* const kVisitorLoginTitle = @"游客模式进入";
static NSString* const kTitleLabelText = @"WeDemo";
/* Font */
static const CGFloat kTitleLabelFontSize = 18.0f;
static const CGFloat kVisitorButtonFontSize = 12.0f;
/* Size */
static const int kLogoImageWidth = 75;
static const int kLogoImageHeight = 52;
static const int kTitleLabelWidth = 150;
static const int kTitleLabelHeight = 44;
static const int kWXLogoImageWidth = 25;
static const int kWXLogoImageHeight = 20;
static const int kVisitorLoginButtonWidth = 200;
static const int kVisitorLoginButtonHeight = 44;


@interface LoginController ()<RCIMUserInfoDataSource>


@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic, strong) UIButton *wxLoginButton;

@end

//@interface LoginController ()<WXAuthDelegate>

//@end

@implementation LoginController


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.delegate = self;
    [self setupView];
        // Do any additional setup after loading the view.
}

- (void)setLeftButton{
    //设置导航栏的左边按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)setupView{
    UIImage *backImg = [UIImage imageNamed:@"edittext_icon"];
    _usernameView.layer.contents = (id)backImg.CGImage;
    _passwordView.layer.contents = (id)backImg.CGImage;
    
    if (_enterType == 0) {
        [self setLeftButton];
    }
    [self.view addSubview:self.wxLoginButton];
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
//    CGFloat loginButtonCenterY = ScreenHeight / 3 * 2;
    CGFloat loginButtonCenterY = 465;
    self.wxLoginButton.frame = CGRectMake(0, 0, kWXLoginButtonWidth, kWXLoginButtonHeight);
    self.wxLoginButton.center = CGPointMake(self.view.center.x, loginButtonCenterY);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIButton *)wxLoginButton {
//    if (_wxLoginButton == nil) {
//        _wxLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _wxLoginButton.backgroundColor = [UIColor colorWithRed:0.04
//                                                         green:0.73
//                                                          blue:0.03
//                                                         alpha:1.00];
//        _wxLoginButton.layer.cornerRadius = kLoginButtonCornerRadius;
//        [_wxLoginButton setTitle:@"微信登录" forState:UIControlStateNormal];
//        [_wxLoginButton addTarget:self
//                           action:@selector(onClickWXLogin:)
//                 forControlEvents:UIControlEventTouchUpInside];
//        _wxLoginButton.titleLabel.font = [UIFont fontWithName:kChineseFont
//                                                         size:kWXLoginButtonFontSize];
//    }
//    return _wxLoginButton;
//}
//
//#pragma mark - User Actions
//- (void)onClickWXLogin: (UIButton *)sender {
//    if (sender != self.wxLoginButton)
//        return;
//    [[WXApiManager sharedManager] sendAuthRequestWithController:self
//                                                       delegate:self];
//}
//
//
//#pragma mark - WXAuthDelegate
//- (void)wxAuthSucceed:(NSString *)code {
//    [ADUserInfo currentUser].authCode = code;
//    ADShowActivity(self.view);
//    [[ADNetworkEngine sharedEngine] wxLoginForAuthCode:code
//                                        WithCompletion:^(ADWXLoginResp *resp) {
//                                            [self handleWXLoginResponse:resp];
//                                        }];
//}
//
//- (void)wxAuthDenied {
//    ADShowErrorAlert(kWXAuthDenyTitle);
//}
//
//#pragma mark - Network Handlers
//- (void)handleConnectResponse: (ADConnectResp *)resp {
//    if (resp && resp.baseResp.errcode == 0) {
//        [ADUserInfo currentUser].uin = (UInt32)resp.tempUin;
//        [ADUserInfo visitorUser].uin = (UInt32)resp.tempUin;
////        NSLog(@"sda");
//    } else {
//        NSLog(@"Connect Failed");
//        NSString *errorTitle = [NSString errorTitleFromResponse:resp.baseResp
//                                                   defaultError:kConnectErrorTitle];
//        ADShowErrorAlert(errorTitle);
//        ADHideActivity;
//    }
//}
//
//- (void)handleWXLoginResponse:(ADWXLoginResp *)resp {
//    if (resp && resp.baseResp.errcode == ADErrorCodeNoError) {
//        NSLog(@"WXLogin Success");
//        [ADUserInfo currentUser].uin = (UInt32)resp.uin;
//        [ADUserInfo currentUser].loginTicket = resp.loginTicket;
//        [[ADNetworkEngine sharedEngine] checkLoginForUin:resp.uin
//                                             LoginTicket:resp.loginTicket
//                                          WithCompletion:^(ADCheckLoginResp *checkLoginResp) {
//                                              [self handleCheckLoginResponse:checkLoginResp];
//                                          }];
//    } else {
//        NSLog(@"WXLogin Fail");
//        NSString *errorTitle = [NSString errorTitleFromResponse:resp.baseResp
//                                                   defaultError:kWXLoginErrorTitle];
//        ADShowErrorAlert(errorTitle);
//        ADHideActivity;
//    }
//}
//
//- (void)handleCheckLoginResponse:(ADCheckLoginResp *)resp {
//    ADHideActivity;
//    if (resp && resp.sessionKey) {
//        NSLog(@"Check Login Success");
//        [ADUserInfo currentUser].sessionExpireTime = resp.expireTime;
//        [[ADUserInfo currentUser] save];
//        [[ADNetworkEngine sharedEngine] getUserInfoForUin:[ADUserInfo currentUser].uin
//                                              LoginTicket:[ADUserInfo currentUser].loginTicket
//                                           WithCompletion:^(ADGetUserInfoResp *resp) {
//                                               [ADUserInfo currentUser].nickname = resp.nickname;
//                                               [ADUserInfo currentUser].headimgurl = resp.headimgurl;
//                                               AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
////                                               delegate.userInfoView.userInfoResp = resp;
////                                               [[ADNetworkEngine sharedEngine] downloadImageForUrl:resp.headimgurl
////                                                                                    WithCompletion:^(UIImage *image) {
////                                                                                        [delegate.userInfoView.tableView reloadData];
////                                                                                    }];
//                                           }];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    } else {
////        NSLog(@"Check Login Fail");
//        NSString *errorTitle = [NSString errorTitleFromResponse:resp.baseResp
//                                                   defaultError:kWXLoginErrorTitle];
//        ADShowErrorAlert(errorTitle);
//        ADHideActivity;
//    }
//}




//注册
- (IBAction)regsiterAction:(id)sender {
    [self performSegueWithIdentifier:@"goToRegisterController" sender:self];
}

//忘记密码
- (IBAction)forgetPassword:(id)sender {
    [self performSegueWithIdentifier:@"goToForgetPasswordController" sender:self];
}

- (IBAction)loginAction:(id)sender {

    if([self checkInput]){
        [[NetRequest sharedInstance] httpRequestWithPost:URL_LOGIN parameters:@{@"username": _usernameText.text, @"password": _passwordText.text} withToken:NO success:^(id data, NSString *message) {
            
                [self initRongYun:data[@"token"]];
            
                UserModel *userModel = [UserModel new];
                userModel.token = data[@"token"];
                [[UserManager sharedManager] saveUserInfo:userModel];
            
                [self getUserProfile:userModel.token];
            
                [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"登录成功" andTime:1.0f DoneBlock:^{
                TabViewController *tabVC = [[TabViewController alloc] initWithNibName:nil bundle:nil];
                [self presentViewController:tabVC animated:YES completion:^{
            
                }];
                    
            }];
        } failed:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"登录失败" andTime:1.0f];
        }];
    }
}

- (IBAction)youkeAction:(id)sender {
    
    [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"游客登录" andTime:1.0f DoneBlock:^{
        TabViewController *tabVC = [[TabViewController alloc] initWithNibName:nil bundle:nil];
        [self presentViewController:tabVC animated:YES completion:^{
                    
        }];
                
    }];
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    
//    //设置导航栏的颜色
//    //navigationController.navigationBar.barTintColor = MAIN_COLOR;
//    viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem  initWithIcon:@"back" size:CGSizeMake(12, 20) highlightedIcon:nil target:self action:@selector(backTapped)];
//
//}

- (void)backTapped{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)checkInput{
    if (_usernameText.text.length == 0 || _passwordText.text.length == 0) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入账号密码" andTime:1.0f];
        return NO;
    }
    
    if (![CommonTool checkPhoneNum:_usernameText.text]) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入有效的手机号" andTime:1.0f];
        return NO;
    }
    
    
    return YES;
}

- (void)getUserProfile :(NSString *)token{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_SELF_PROFILE success:^(id data, NSString *message) {
        
        UserModel *userModel = [UserModel mj_objectWithKeyValues:data];
        [userModel setToken:token];
        [[UserManager sharedManager] saveUserInfo:userModel];
        
    } failed:^(id data, NSString *message) {
    }];
}


- (void)initRongYun: (NSString *)token{
    [[RCIM sharedRCIM] initWithAppKey:RongYunAppkey];
    //测试融云的登录
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        dispatch_async(dispatch_get_main_queue(), ^{
            //设置数据源代理
            [[RCIM sharedRCIM] setUserInfoDataSource:self];
            //设置当前用户的信息
            [self setRCCurrentUserProfile];
        });
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
    
}

//融云用户信息的数据源
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion{
    
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_OTHER_USER_PROFILE(userId) success:^(id data, NSString *message) {
        UserModel *model = [UserModel mj_objectWithKeyValues:data];
        NSLog(@"RongYun profile: %@", data);
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:model.user_id name:model.name portrait:URLFrame(model.icon_url)];
        return completion(userInfo);
    } failed:^(id data, NSString *message) {
        
        NSLog(@"RongYun profile failed: %@", message);
        return completion(nil);
    }];
    return completion(nil);
    
}

//获取个人的资料,设置融云的当前用户
- (void)setRCCurrentUserProfile{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_SELF_PROFILE success:^(id data, NSString *message) {
        UserModel *model = [UserModel mj_objectWithKeyValues:data];
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:model.user_id name:model.name portrait:URLFrame(model.icon_url)];
        [[RCIM sharedRCIM] setCurrentUserInfo:userInfo];
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
    }];
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

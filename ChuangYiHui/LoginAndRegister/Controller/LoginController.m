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



@interface LoginController ()<RCIMUserInfoDataSource>

@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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

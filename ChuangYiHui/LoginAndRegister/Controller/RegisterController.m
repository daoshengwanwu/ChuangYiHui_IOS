//
//  RegisterController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/10.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "RegisterController.h"
#import "TabViewController.h"
#import "ServiceProtocolController.h"
#import "CTCheckBox.h"

@interface RegisterController ()<RCIMUserInfoDataSource>

@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UIView *verifyCodeView;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeText;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIView *repasswordView;
@property (weak, nonatomic) IBOutlet UITextField *repasswordText;
@property (weak, nonatomic) IBOutlet UIView *inviteCodeView;
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeText;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;


@property (weak, nonatomic) IBOutlet CTCheckbox *checkBox;

@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)NSInteger limit;

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setLeftButton];
    // Do any additional setup after loading the view.
}

- (void)setupView{
    UIImage *backImg = [UIImage imageNamed:@"edittext_icon"];
    _usernameView.layer.contents = (id)backImg.CGImage;
    _passwordView.layer.contents = (id)backImg.CGImage;
    _repasswordView.layer.contents = (id)backImg.CGImage;
    _verifyCodeView.layer.contents = (id)backImg.CGImage;
    _inviteCodeView.layer.contents = (id)backImg.CGImage;
}

- (void)setLeftButton{
    //设置导航栏的左边按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)backTapped{
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)checkInput{
    if (!_checkBox.checked) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请勾选用户服务协议" andTime:1.0f];
        return NO;
    }
    if (_usernameText.text.length == 0) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入手机号" andTime:1.0f];
        return NO;
    }
    
    if (![CommonTool checkPhoneNum:_usernameText.text]) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入合法的手机号" andTime:1.0f];
        return NO;
    }
    
    if (_verifyCodeText.text.length == 0) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入验证码" andTime:1.0f];
        return NO;
    }
    
    if (_passwordText.text.length == 0) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入密码" andTime:1.0f];
        return NO;
    }
    
    if (_repasswordText.text.length == 0) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请重复输入密码" andTime:1.0f];
        return NO;
    }
    
    if (![_repasswordText.text isEqualToString:_passwordText.text]) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"两次输入的密码不一致" andTime:1.0f];
        return NO;
    }
    
    
    return YES;
}

//注册
- (IBAction)regsiterAction:(id)sender {
    if ([self checkInput]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:_usernameText.text forKey:@"phone_number"];
        [params setObject:_passwordText.text forKey:@"password"];
        [params setObject:_verifyCodeText.text forKey:@"validation_code"];
        if (_inviteCodeText.text.length > 0) {
            [params setObject:_inviteCodeText.text forKey:@"invitation_code"];
        }
        [[NetRequest sharedInstance] httpRequestWithPost:URL_GET_USERS parameters:params withToken:NO success:^(id data, NSString *message) {
            [self initRongYun:data[@"token"]];
            
            UserModel *userModel = [UserModel new];
            userModel.token = data[@"token"];
            [[UserManager sharedManager] saveUserInfo:userModel];
            
            [self getUserProfile:userModel.token];
            
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"注册成功" andTime:1.0f DoneBlock:^{
                TabViewController *tabVC = [[TabViewController alloc] initWithNibName:nil bundle:nil];
                [self presentViewController:tabVC animated:YES completion:^{
                    
                }];
                
            }];
        } failed:^(id data, NSString *message) {
            if ([data isEqualToString:@"400"]) {
                [[SVHudManager sharedInstance] showErrorHudWithTitle:@"验证码错误" andTime:1.0f];
            }else if ([data isEqualToString:@"404"]) {
                [[SVHudManager sharedInstance] showErrorHudWithTitle:@"邀请码错误" andTime:1.0f];
            }else if ([data isEqualToString:@"403"]) {
                [[SVHudManager sharedInstance] showErrorHudWithTitle:@"手机号已注册" andTime:1.0f];
            }else{
                [[SVHudManager sharedInstance] showErrorHudWithTitle:@"创建用户失败" andTime:1.0f];
            }
        }];
    }
}


- (IBAction)sendCodeButtonAction:(id)sender {
    if (![CommonTool checkPhoneNum:_usernameText.text]) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入合法的手机号" andTime:1.0f];
    }else{
        NSString *url = [NSString stringWithFormat:@"%@?phone_number=%@", URL_SEND_SMS_CODE, _usernameText.text];
        [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"发送验证码成功" andTime:1.5f];
            [_sendCodeButton setEnabled:NO];
            _limit = 30;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [_sendCodeButton setTitle:[NSString stringWithFormat:@"%ld s",_limit] forState:UIControlStateNormal];
                if (_limit == -1) {
                    [timer invalidate];
                    [_sendCodeButton setEnabled:YES];
                    [_sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                }else{
                    _limit = _limit - 1;
                }
            }];

        } failed:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"发送验证码失败" andTime:1.0f];
        }];
    }
}


- (void)getUserProfile :(NSString *)token{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_SELF_PROFILE success:^(id data, NSString *message) {
        
        UserModel *userModel = [UserModel mj_objectWithKeyValues:data];
        [userModel setToken:token];
        [[UserManager sharedManager] saveUserInfo:userModel];
        
    } failed:^(id data, NSString *message) {
    }];
}


- (void)initRongYun :(NSString *)token{
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

- (IBAction)ServiceProtocolAction:(id)sender {
    ServiceProtocolController *vc = [ServiceProtocolController new];
    [self.navigationController pushViewController:vc animated:YES];
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

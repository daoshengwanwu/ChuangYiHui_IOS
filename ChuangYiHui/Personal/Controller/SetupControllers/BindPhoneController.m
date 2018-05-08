//
//  BindPhoneController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/28.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "BindPhoneController.h"

@interface BindPhoneController ()

@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UIView *verifyCodeView;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeText;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;

@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)NSInteger limit;

@end

@implementation BindPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView{
    UIImage *backImg = [UIImage imageNamed:@"edittext_icon"];
    _usernameView.layer.contents = (id)backImg.CGImage;
    _passwordView.layer.contents = (id)backImg.CGImage;
    _verifyCodeView.layer.contents = (id)backImg.CGImage;
}


- (BOOL)checkInput{
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
    
    return YES;
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


- (IBAction)BindButtonAction:(id)sender {
    if ([self checkInput]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:_usernameText.text forKey:@"phone_number"];
        [params setObject:_passwordText.text forKey:@"password"];
        [params setObject:_verifyCodeText.text forKey:@"validation_code"];
        
        [[NetRequest sharedInstance] httpRequestWithPost:URL_BIND_PHONE parameters:params withToken:NO success:^(id data, NSString *message) {
            
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"绑定手机号成功" andTime:1.0f DoneBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } failed:^(id data, NSString *message) {
            if ([data isEqualToString:@"400"]) {
                [[SVHudManager sharedInstance] showErrorHudWithTitle:@"验证码错误" andTime:1.0f];
            }else{
                [[SVHudManager sharedInstance] showErrorHudWithTitle:@"找回密码失败" andTime:1.0f];
            }
        }];
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

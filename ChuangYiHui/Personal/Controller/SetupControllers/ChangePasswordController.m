//
//  ChangePasswordController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/28.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "ChangePasswordController.h"

@interface ChangePasswordController ()
@property (weak, nonatomic) IBOutlet UIView *oldPasswordView;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordText;
@property (weak, nonatomic) IBOutlet UIView *freshPasswordView;
@property (weak, nonatomic) IBOutlet UITextField *freshPasswordText;
@property (weak, nonatomic) IBOutlet UIView *reFreshPasswordView;
@property (weak, nonatomic) IBOutlet UITextField *reFreshPasswordText;
@end

@implementation ChangePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (BOOL)checkInput{
    if (_oldPasswordText.text.length == 0) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入旧密码" andTime:1.0f];
        return NO;
    }
    
    if (_freshPasswordText.text.length == 0 || _reFreshPasswordText.text.length == 0) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入新密码" andTime:1.0f];
        return NO;
    }
    
    if (![_freshPasswordText.text isEqualToString:_reFreshPasswordText.text]) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"新密码和旧密码不一致" andTime:1.0f];
        return NO;
    }

    return YES;
}


- (IBAction)enterButtonAction:(id)sender {
    if ([self checkInput]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:_oldPasswordText.text forKey:@"old_password"];
        [params setObject:_freshPasswordText.text forKey:@"new_password"];
        
        [[NetRequest sharedInstance] httpRequestWithPost:URL_CHANGE_PASSWORD parameters:params withToken:NO success:^(id data, NSString *message) {
            
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"修改密码成功" andTime:1.0f DoneBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } failed:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"修改密码失败" andTime:1.0f];
        }];
    }
    
}


- (void)setupView{
    UIImage *backImg = [UIImage imageNamed:@"edittext_icon"];
    _oldPasswordView.layer.contents = (id)backImg.CGImage;
    _freshPasswordView.layer.contents = (id)backImg.CGImage;
    _reFreshPasswordView.layer.contents = (id)backImg.CGImage;
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

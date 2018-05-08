//
//  FeedbackController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/22.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "FeedbackController.h"

@interface FeedbackController ()

@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextView *feedbackText;
@end

@implementation FeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBorder];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addBorder{
    _feedbackText.layer.borderColor = [UIColor grayColor].CGColor;
    _feedbackText.layer.borderWidth = 1.0f;
    _emailText.layer.borderColor = [UIColor grayColor].CGColor;
    _emailText.layer.borderWidth = 1.0f;
}

- (BOOL)checkInput{
    if (_emailText.text.length == 0) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入邮箱" andTime:1.0f];
        return NO;
    }else if(![CommonTool isValidateEmail:_emailText.text]){
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入合法邮箱" andTime:1.0f];
        return NO;
    }else if(_feedbackText.text.length == 0){
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入反馈内容" andTime:1.0f];
        return NO;
    }
    return YES;
}


- (IBAction)commit:(id)sender {
    if ([self checkInput]) {
     //提交反馈
        NSDictionary *params = @{@"content": _feedbackText.text};
        [[NetRequest sharedInstance] httpRequestWithPost:URL_FEEDBACK parameters:params withToken:NO success:^(id data, NSString *message) {
            
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"反馈成功" andTime:1.5f DoneBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
             
        } failed:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.5f];
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

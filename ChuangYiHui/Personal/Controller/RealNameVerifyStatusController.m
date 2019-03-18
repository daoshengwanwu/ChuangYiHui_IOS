//
//  IdentityVerifyStatusController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/30.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "RealNameVerifyStatusController.h"
#import "RealNameVerifyController.h"

@interface RealNameVerifyStatusController ()

@property (nonatomic, strong)UIImageView *statusImg;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UIButton *statusButton;

@end

@implementation RealNameVerifyStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    [self initData];
    [self setLeftButton];
    // Do any additional setup after loading the view.
}

- (void)initView{
    _statusImg = [UIImageView new];
    [self.view addSubview:_statusImg];
    [_statusImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(100);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-20);
        //        make.top.mas_equalTo(100);
    }];
    
    _statusLabel = [UILabel new];
    [self.view addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_statusImg.mas_bottom).offset(15);
    }];
    
    _statusButton = [UIButton new];
    [self.view addSubview:_statusButton];
    [_statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_statusLabel.mas_bottom).offset(5);
    }];
    [_statusButton setTitle:@"重新提交" forState:UIControlStateNormal];
    [_statusButton addTarget:self action:@selector(statusButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_statusButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_statusButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [_statusButton setHidden:YES];
}

- (void)statusButtonAction{
    //跳转到认证页面
    RealNameVerifyController *vc = [RealNameVerifyController new];
    [self.navigationController pushViewController:vc animated:YES];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)initData{
    
    if (_status == 1) {
        //等待审核
        _statusLabel.text = @"等待审核中";
        [_statusImg setImage:[UIImage imageNamed:@"checking_icon"]];
        
    }else if(_status == 2||_status == 4){
        //审核通过
        _statusLabel.text = @"审核通过";
        [_statusImg setImage:[UIImage imageNamed:@"check_success_icon"]];
    }else{
        //审核失败，请重新提交
        _statusLabel.text = @"审核失败，请重新提交";
        [_statusImg setImage:[UIImage imageNamed:@"check_failed_icon"]];
        [_statusButton setHidden:NO];
    }
    
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


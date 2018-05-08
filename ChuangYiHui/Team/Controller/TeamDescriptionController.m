//
//  TeamDescriptionController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/19.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "TeamDescriptionController.h"

@interface TeamDescriptionController ()

@property (nonatomic, strong)UITextView *textView;

@end

@implementation TeamDescriptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团队描述";
    self.view.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUpTextView];
    if (_type == 0) {
        [self setUpRightButton];
        _textView.editable = YES;
    }else{
        _textView.editable = NO;
    }
    // Do any additional setup after loading the view.
}

- (void)setUpTextView{
    _textView = [UITextView new];
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(300);
        make.top.mas_equalTo(NAV_HEIGHT + 15);
    }];
    _textView.text = _team_description;
}


- (void)setUpRightButton{
    //设置导航栏的右边按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [rightButton setImage:[UIImage imageNamed:@"save_icon"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightButtonAction{
    if (_setContentBlock) {
        _setContentBlock(_textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
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

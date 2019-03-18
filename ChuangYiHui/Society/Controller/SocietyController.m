//
//  SocietyController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/8.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "SocietyController.h"
#import "ActionController.h"
#import "TeamActionController.h"
#import "PersonnelActionController.h"
#import "HelperController.h"
#import "ForumController.h"
#import "XLSlideSwitch.h"
#import "ExpertActionControllerViewController.h"
#import "LBXScan1ViewController.h"
#import "StyleDIY.h"

@interface SocietyController ()<XLSlideSwitchDelegate>

@property (nonatomic, strong) XLSlideSwitch *slideSwitch;

@end

@implementation SocietyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpRightButton];
//    NSArray *titles = @[@"创友", @"团队", @"论坛", @"助手"];
    NSArray *titles = @[@"创友", @"专家",@"团队"];
    NSMutableArray *viewControllers = [NSMutableArray new];
//    for (int i = 0 ; i< titles.count; i++) {
//        if (i == 0) {
//            ActionController *vc = [ActionController new];
//            [viewControllers addObject:vc];
//        }else if(i == 1){
//            ActionController *vc = [ActionController new];
//            [viewControllers addObject:vc];
//        }else if(i == 2){
//            ForumController *vc = [ForumController new];
//            [viewControllers addObject:vc];
//        }else{
//            HelperController *vc = [HelperController new];
//            [viewControllers addObject:vc];
//        }
//    }
    
    for (int i = 0 ; i< titles.count; i++) {
        if (i == 0) {
            PersonnelActionController *vc = [PersonnelActionController new];
            [viewControllers addObject:vc];
        }else if(i == 1){
            ExpertActionControllerViewController *vc = [ExpertActionControllerViewController new];
            [viewControllers addObject:vc];
        }else if(i == 2){
            TeamActionController *vc = [TeamActionController new];
            [viewControllers addObject:vc];
        }
    }
    
    _slideSwitch = [[XLSlideSwitch alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) Titles:titles viewControllers:viewControllers];
    //设置代理
    _slideSwitch.delegate = self;
    //设置按钮选中和未选中状态的标题颜色
    _slideSwitch.itemSelectedColor = MAIN_COLOR;
    _slideSwitch.itemNormalColor = DARK_FONT_COLOR;
    [_slideSwitch showInViewController:self];
    // Do any additional setup after loading the view.
}

- (void)setUpRightButton{
    //设置导航栏的右边按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [rightButton setImage:[UIImage imageNamed:@"scan_icon"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)rightButtonAction{
    [self openScanVCWithStyle:[StyleDIY weixinStyle]];
}


#pragma mark ---自定义界面

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    LBXScan1ViewController *vc = [LBXScan1ViewController new];
    vc.style = style;
    vc.isOpenInterestRect = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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

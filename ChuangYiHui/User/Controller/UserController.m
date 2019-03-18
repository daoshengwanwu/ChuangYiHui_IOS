//
//  UserController.m
//  ChuangYiHui
//
//  Created by p1p1us on 2019/3/17.
//  Copyright © 2019年 litingdong. All rights reserved.
//

#import "ActionController.h"
#import "TeamActionController.h"
#import "PersonnelActionController.h"
#import "HelperController.h"
#import "ForumController.h"
#import "XLSlideSwitch.h"
#import "ExpertActionControllerViewController.h"
#import "UserController.h"
#import "UserListController.h"
#import "ExpertListController.h"
#import "LBXScan1ViewController.h"
#import "StyleDIY.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"

@interface UserController ()<XLSlideSwitchDelegate>
{
    NSMutableArray *_obj;
}

@property (nonatomic, strong) XLSlideSwitch *slideSwitch;

@end

@implementation UserController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpRightButton];
    [self initPopView];
    //    NSArray *titles = @[@"创友", @"团队", @"论坛", @"助手"];
    NSArray *titles = @[@"创友", @"专家"];
    NSMutableArray *viewControllers = [NSMutableArray new];
    
    for (int i = 0 ; i< titles.count; i++) {
        if (i == 0) {
            UserListController *vc = [UserListController new];
            [viewControllers addObject:vc];
        }else if(i == 1){
            ExpertListController *vc = [ExpertListController new];
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
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)rightButtonAction{
    [self moreClicked];
}

//- (void)rightButtonAction{
//    [self openScanVCWithStyle:[StyleDIY weixinStyle]];
//}


#pragma mark ---自定义界面

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    LBXScan1ViewController *vc = [LBXScan1ViewController new];
    vc.style = style;
    vc.isOpenInterestRect = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)initPopView{
    _obj = [NSMutableArray array];
    
    for (NSInteger i=0; i<[self titles].count; i++) {
        WBPopMenuModel *info = [[WBPopMenuModel alloc] init];
        info.title = [self titles][i];
        [_obj addObject:info];
    }
}

- (NSArray *) titles
{
    return @[@"扫一扫", @"搜一搜"];
}


- (void)moreClicked
{
    [[WBPopMenuSingleton shareManager] showPopMenuSelecteWithFrame:80.0 item:_obj action:^(NSInteger index) {
        if(index==0){
            [self openScanVCWithStyle:[StyleDIY weixinStyle]];
        }else if(index ==1){
            
        }

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

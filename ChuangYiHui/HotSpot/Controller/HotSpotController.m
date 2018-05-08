//
//  HotSpotController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/8.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "HotSpotController.h"
#import "CompetitionListController.h"
#import "ActivityListController.h"
#import "XLSlideSwitch.h"
#import "ActivityModel.h"
#import "ActivityDetailController.h"
#import "PublishViewController.h"


@interface HotSpotController ()<XLSlideSwitchDelegate>

@property (nonatomic, strong) XLSlideSwitch *slideSwitch;

@end

@implementation HotSpotController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *titles = @[@"发布", @"竞赛", @"活动"];
    NSMutableArray *viewControllers = [NSMutableArray new];
    
    [viewControllers addObject:[PublishViewController new]];
    [viewControllers addObject:[CompetitionListController new]];
    [viewControllers addObject:[ActivityListController new]];

    
    _slideSwitch = [[XLSlideSwitch alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) Titles:titles viewControllers:viewControllers];
    //设置代理
    _slideSwitch.delegate = self;
    //设置按钮选中和未选中状态的标题颜色
    _slideSwitch.itemSelectedColor = MAIN_COLOR;
    _slideSwitch.itemNormalColor = DARK_FONT_COLOR;
    [_slideSwitch showInViewController:self];
    // Do any additional setup after loading the view.
    
    [self registerNotificationCenter];
}

- (void)registerNotificationCenter{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToActivityDetail:) name:@"GoToActivityDetail" object:nil];
}

- (void)goToActivityDetail :(NSNotification *)notification{
    ActivityModel *model = [notification object];
    UIStoryboard *hotspotSB = [UIStoryboard storyboardWithName:@"HotSpot" bundle:nil];
    ActivityDetailController *vc = [hotspotSB instantiateViewControllerWithIdentifier:@"activityDetail"];
    vc.model = model;
    vc.hidesBottomBarWhenPushed = YES;
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

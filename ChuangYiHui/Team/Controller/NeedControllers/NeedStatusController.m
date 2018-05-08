//
//  NeedStatusController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/6.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "NeedStatusController.h"
#import "NeedListController.h"
#import "ReleaseNeedsController.h"
#import "XLSlideSwitch.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"

@interface NeedStatusController ()<XLSlideSwitchDelegate>
{
    NSMutableArray *_obj;
}

@property (nonatomic, strong) XLSlideSwitch *slideSwitch;
@end

@implementation NeedStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self getTitle];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *titles = @[@"进行中", @"已满足", @"已删除"];
    NSMutableArray *viewControllers = [NSMutableArray new];
    for (int i = 0 ; i< titles.count; i++) {
        NeedListController *vc = [NeedListController new];
        vc.teamModel = _teamModel;
        vc.status = i;
        vc.type = _type;
        vc.isOwner = _isOwner;
        vc.enterWay = _enterWay;
        [viewControllers addObject:vc];
    }
    
    _slideSwitch = [[XLSlideSwitch alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) Titles:titles viewControllers:viewControllers];
    //设置代理
    _slideSwitch.delegate = self;
    //设置按钮选中和未选中状态的标题颜色
    _slideSwitch.itemSelectedColor = MAIN_COLOR;
    _slideSwitch.itemNormalColor = DARK_FONT_COLOR;
    [_slideSwitch showInViewController:self];
    
    if (_isOwner) {
        [self setUpRightButton];
    }
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
    ReleaseNeedsController *vc = [ReleaseNeedsController new];
    vc.needType = _type;
    vc.teamModel = _teamModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)getTitle{
    if (_type == 0) {
        return @"人员需求";
    }else if(_type == 1){
        return @"承接需求";
    }else{
        return @"外包需求";
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  TaskStatusController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/5.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "TaskStatusController.h"
#import "TaskListController.h"
#import "TaskInternalReleaseController.h"
#import "TaskExternalReleaseViewController.h"
#import "XLSlideSwitch.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"

@interface TaskStatusController ()<XLSlideSwitchDelegate>
{
    NSMutableArray *_obj;
}

@property (nonatomic, strong) XLSlideSwitch *slideSwitch;
@end

@implementation TaskStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self getTitle];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *titles = @[@"进行中", @"已满足", @"已删除"];
    NSMutableArray *viewControllers = [NSMutableArray new];
    for (int i = 0 ; i< titles.count; i++) {
        TaskListController *vc = [TaskListController new];
        vc.type = _type;
        vc.teamModel = _teamModel;
        vc.status = i;
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
    
    if (_enterWay == 0) {
        [self setUpRightButton];
    }
}

//- (void)initPopView{
//    _obj = [NSMutableArray array];
//    
//    for (NSInteger i=0; i<[self titles].count; i++) {
//        WBPopMenuModel *info = [[WBPopMenuModel alloc] init];
//        info.title = [self titles][i];
//        [_obj addObject:info];
//    }
//}
//
//- (NSArray *) titles
//{
//    
//    return @[@"教育经历", @"实习经历", @"工作经历"];
//    
//}

- (void)setUpRightButton{
    //设置导航栏的右边按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightButtonAction{
    if (_type == 0) {
        //内部任务
        TaskInternalReleaseController *vc = [TaskInternalReleaseController new];
        vc.model = _teamModel;
        vc.enterWay = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(_type == 1){
        //承接任务
        TaskExternalReleaseViewController *vc = [TaskExternalReleaseViewController new];
        vc.model = _teamModel;
        vc.enterWay = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //外包任务
        TaskExternalReleaseViewController *vc = [TaskExternalReleaseViewController new];
        vc.model = _teamModel;
        vc.enterWay = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSString *)getTitle{
    if (_type == 0) {
        return @"内部任务";
    }else if(_type == 1){
        return @"承接任务";
    }else{
        return @"外包任务";
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

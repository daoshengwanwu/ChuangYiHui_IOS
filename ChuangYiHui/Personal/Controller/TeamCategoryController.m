//
//  TeamCategoryController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/11.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "TeamCategoryController.h"
#import "PersonalTeamListController.h"
#import "ObjectListController.h"
#import "ExperienceBackgroundController.h"
#import "ExperienceDetailController.h"
#import "XLSlideSwitch.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"


@interface TeamCategoryController ()<XLSlideSwitchDelegate>
{
    NSMutableArray *_obj;
}

@property (nonatomic, strong) XLSlideSwitch *slideSwitch;

@end

@implementation TeamCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *titles = @[];
    if (_type == 0 || _type == 2){
        self.title = @"团队列表";
        titles = @[@"参与的团队",@"创建的团队"];
    }else if (_type == 1){
        self.title = @"关注列表";
        titles = @[@"关注的创友",@"关注的团队"];
    }else if(_type == 3){
        self.title = @"经历背景";
        titles = @[@"教育经历", @"实习经历", @"工作经历"];
    }else{
        //我的经历背景
        self.title = @"经历背景";
        titles = @[@"教育经历", @"实习经历", @"工作经历"];
        [self setUpRightButton];
        [self initPopView];
    }
    
    
    NSMutableArray *viewControllers = [NSMutableArray new];
    for (int i = 0 ; i< titles.count; i++) {
        if (_type == 0){
            PersonalTeamListController *vc = [PersonalTeamListController new];
            vc.type = i;
            [viewControllers addObject:vc];
        }else if (_type == 1){
            ObjectListController *vc = [ObjectListController new];
            if (i == 0) {
                vc.displayType = User_Followed_User;
            }else{
                vc.displayType = User_Followed_Team;
            }
            [viewControllers addObject:vc];
        }else if (_type == 2){
            PersonalTeamListController *vc = [PersonalTeamListController new];
            vc.type = i + 2;
            vc.user_id = _user_id;
            [viewControllers addObject:vc];
        }else if (_type == 3){
            ExperienceBackgroundController *vc = [ExperienceBackgroundController new];
            vc.type = i + 3;
            vc.user_id = _user_id;
            [viewControllers addObject:vc];
        }else{
            ExperienceBackgroundController *vc = [ExperienceBackgroundController new];
            vc.type = i;
//            vc.user_id = _user_id;
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
    
    return @[@"教育经历", @"实习经历", @"工作经历"];
    
}


- (void)moreClicked
{
    [[WBPopMenuSingleton shareManager] showPopMenuSelecteWithFrame:110.0 item:_obj action:^(NSInteger index) {
        ExperienceDetailController *vc = [ExperienceDetailController new];
        vc.editType = 0;
        vc.type = index;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

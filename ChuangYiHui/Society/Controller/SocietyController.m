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

@interface SocietyController ()<XLSlideSwitchDelegate>

@property (nonatomic, strong) XLSlideSwitch *slideSwitch;

@end

@implementation SocietyController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSArray *titles = @[@"创友", @"团队", @"论坛", @"助手"];
    NSArray *titles = @[@"创友", @"团队"];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

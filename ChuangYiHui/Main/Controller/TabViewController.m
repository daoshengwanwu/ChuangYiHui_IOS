//
//  TabViewController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/8.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "TabViewController.h"
#import "UserDetailController.h"
#import "UIBarButtonItem+GYY.h"
#import "TeamDetailController.h"
#import "IdentityVerifyController.h"
#import "IdentityVerifyStatusController.h"

@interface TabViewController ()
{
    NSMutableArray *_viewControllers;
}

@end

@implementation TabViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarController.delegate = self;
        
        _curIndex = 0;
        
        UIStoryboard *hotspotSB = [UIStoryboard storyboardWithName:@"HotSpot" bundle:nil];
        UINavigationController *tab1 = (UINavigationController *)hotspotSB.instantiateInitialViewController;
        tab1.delegate = self;
        
        UITabBarItem *hotspotItem = [[UITabBarItem alloc] initWithTitle:@"热点" image:[UIImage imageNamed:@"tab_hotspot"] selectedImage:[UIImage imageNamed:@"tab_hotspot_selected"]];
        hotspotItem.tag = 0;
        tab1.tabBarItem = hotspotItem;
        
        
        UIStoryboard *societySB = [UIStoryboard storyboardWithName:@"Society" bundle:nil];
        UINavigationController *tab2 = (UINavigationController *)societySB.instantiateInitialViewController;
        tab2.delegate = self;
        
        UITabBarItem *societyItem = [[UITabBarItem alloc] initWithTitle:@"动态" image:[UIImage imageNamed:@"tab_society"] selectedImage:[UIImage imageNamed:@"tab_society_selected"]];
        societyItem.tag = 1;
        tab2.tabBarItem = societyItem;
        
        UIStoryboard *userSB = [UIStoryboard storyboardWithName:@"User" bundle:nil];
        UINavigationController *tab3 = (UINavigationController *)userSB.instantiateInitialViewController;
        tab3.delegate = self;
        
        UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:@"个人" image:[UIImage imageNamed:@"tab_user"] selectedImage:[UIImage imageNamed:@"tab_user_selected"]];
        tabItem.tag = 2;
        tab3.tabBarItem = tabItem;
        
        UIStoryboard *teamSB = [UIStoryboard storyboardWithName:@"Team" bundle:nil];
        UINavigationController *tab4 = (UINavigationController *)teamSB.instantiateInitialViewController;
        tab4.delegate = self;
        
        UITabBarItem *teamItem = [[UITabBarItem alloc] initWithTitle:@"群体" image:[UIImage imageNamed:@"tab_team"] selectedImage:[UIImage imageNamed:@"tab_team_selected"]];
        teamItem.tag = 3;
        
        tab4.tabBarItem = teamItem;
        
        
        UIStoryboard *personalSB = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
        UINavigationController *tab5 = (UINavigationController *)personalSB.instantiateInitialViewController;
        tab5.delegate = self;
        UITabBarItem *personalItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"tab_me"] selectedImage:[UIImage imageNamed:@"tab_me_selected"]];
        personalItem.tag = 4;
        tab5.tabBarItem = personalItem;
        
        
        
        _viewControllers = [NSMutableArray arrayWithObjects:tab1,tab2,tab3,tab4,tab5,nil];
        self.viewControllers = @[tab1,tab2,tab3,tab4,tab5];
        self.tabBar.tintColor = MAIN_COLOR;
        
    }
    
    return self;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    _curIndex = item.tag;
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //设置导航栏的颜色
    //navigationController.navigationBar.barTintColor = MAIN_COLOR;
    
    UIViewController *root = navigationController.viewControllers[0];
    
    if (root != viewController && ![viewController isKindOfClass:[UserDetailController class]] && ![viewController isKindOfClass:[TeamDetailController class]] && ![viewController isKindOfClass:[IdentityVerifyController class]] && ![viewController isKindOfClass:[IdentityVerifyStatusController class]]) {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem  initWithIcon:@"back" size:CGSizeMake(12, 20) highlightedIcon:nil target:self action:@selector(backTapped)];
        
    }
}

- (void)backTapped
{
    [_viewControllers[_curIndex] popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

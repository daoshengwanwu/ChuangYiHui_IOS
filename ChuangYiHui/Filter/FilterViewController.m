//
//  ViewController.m
//  YZPullDownMenuDemo
//
//  Created by yz on 16/8/13.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "FilterViewController.h"
#import "YZPullDownMenu.h"
#import "YZMenuButton.h"
#import "YZMoreMenuViewController.h"
#import "YZSortViewController.h"
//#import "YZAllCourseViewController.h"
#import "YZCityTableViewController.h"

#define YZScreenW [UIScreen mainScreen].bounds.size.width
#define YZScreenH [UIScreen mainScreen].bounds.size.height

@interface FilterViewController ()<YZPullDownMenuDataSource>
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *classes;
@property (nonatomic, strong) NSArray *saveShaixuan;                       // 存储选中筛选数组
/**
 *  观察者
 */
@property (nonatomic, weak)   id observer;
@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"筛选";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view, typically from a nib.
//    self.view.backgroundColor = [UIColor brownColor];
    
    // 创建下拉菜单
    YZPullDownMenu *menu = [[YZPullDownMenu alloc] init];
    menu.frame = CGRectMake(0, 64, YZScreenW, 44);
    [self.view addSubview:menu];
    
    // 设置下拉菜单代理
    menu.dataSource = self;
    
    // 初始化标题
    _titles = @[@"地区",@"领域"];
    _area = @"不限";
    _classes = @"不限";
    
    // 添加子控制器
    [self setupAllChildViewController];
    //添加监控
    [self addObser];
    //确定按钮
    UIButton * btn_zan = [UIButton new];
    [self.view addSubview:btn_zan];
    [btn_zan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-5);
        make.height.mas_equalTo(38);
    }];
    UIColor * blueTextColor = COLOR(50, 177, 230);
    [btn_zan setTitle:@"确 定" forState:UIControlStateNormal];
    btn_zan.backgroundColor = blueTextColor;
    
    [btn_zan addTarget:self action:@selector(onSureClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onSureClick {
    
    //保存信息
    NSString *province = _area;
    NSString *lingyu = _classes;
    
    self.saveShaixuan = @[province,lingyu];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"saveShaixuan"]) {
        
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveShaixuan"];

        NSString *everProvince = array[0];
        NSString *everLingyu = array[1];
        if([province isEqualToString:everProvince]&&[lingyu isEqualToString:everLingyu]){
            //未做修改
//            NSLog(@"未做修改0%@",province);
//            NSLog(@"未做修改1%@",lingyu);
//            NSLog(@"未做修改2%@",everProvince);
//            NSLog(@"未做修改3%@",everLingyu);
            NSString *title = NSLocalizedString(@"未选择", nil);
            NSString *message = NSLocalizedString(@"请您选择或者更改选择后再点击确定。", nil);
            NSString *OKButtonTitle = NSLocalizedString(@"确定", nil);
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:OKButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            [alertVC addAction:OKAction];
            [self.parentViewController presentViewController:alertVC animated:YES completion:nil];
        }else{
            //将筛选项保存到本地
//            NSLog(@"保存0%@",province);
//            NSLog(@"保存1%@",lingyu);
            [[NSUserDefaults standardUserDefaults] setObject:self.saveShaixuan forKey:@"saveShaixuan"];
        }
    }
    else{
        //左上角展示为不限
        //将筛选项保存到本地
        [[NSUserDefaults standardUserDefaults] setObject:self.saveShaixuan forKey:@"saveShaixuan"];
    }
    
//    NSLog(@"area%@",_area);
//    NSLog(@"classes%@",_classes);
    [self.navigationController popToRootViewControllerAnimated:YES];
//    NSLog(@"%@",self.)
//    NSLog(@"self.childViewControllers[0].title:%@",self.childViewControllers[0].title);
//    NSLog(@"title%@",notification);
}
- (void)addObser
{
    // 监听更新菜单标题通知
    _observer = [[NSNotificationCenter defaultCenter] addObserverForName:YZUpdateMenuTitleNote object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        // 获取列
        NSInteger col = [self.childViewControllers indexOfObject:note.object];
        
        if(col != NSNotFound){
            // 获取所有值
            NSArray *allValues = note.userInfo.allValues;
            if(col==0){
                _area = allValues.firstObject;
            }
            else if(col == 1){
                _classes = allValues.firstObject;
            }
        }
        
    }];
}

#pragma mark - 添加子控制器
- (void)setupAllChildViewController
{
    YZCityTableViewController *allCourse = [[YZCityTableViewController alloc] init];
    YZSortViewController *sort = [[YZSortViewController alloc] init];
//    YZMoreMenuViewController *moreMenu = [[YZMoreMenuViewController alloc] init];
   
    //地区
    [self addChildViewController:allCourse];
    //领域
    [self addChildViewController:sort];
    
    
    //学校
//    [self addChildViewController:moreMenu];
}

#pragma mark - YZPullDownMenuDataSource
// 返回下拉菜单多少列
- (NSInteger)numberOfColsInMenu:(YZPullDownMenu *)pullDownMenu
{
    return 2;
}

// 返回下拉菜单每列按钮
- (UIButton *)pullDownMenu:(YZPullDownMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index
{
    YZMenuButton *button = [YZMenuButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:_titles[index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:25 /255.0 green:143/255.0 blue:238/255.0 alpha:1] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"标签-向下箭头"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"标签-向上箭头"] forState:UIControlStateSelected];
    
    return button;
}

// 返回下拉菜单每列对应的控制器
- (UIViewController *)pullDownMenu:(YZPullDownMenu *)pullDownMenu viewControllerForColAtIndex:(NSInteger)index
{
    return self.childViewControllers[index];
}

// 返回下拉菜单每列对应的高度
- (CGFloat)pullDownMenu:(YZPullDownMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index
{
    // 第1列 高度
    if (index == 0) {
        return 500;
    }
    
    // 第2列 高度
    if (index == 1) {
        return 500;
    }
    
    // 第3列 高度
    return 500;
}


@end

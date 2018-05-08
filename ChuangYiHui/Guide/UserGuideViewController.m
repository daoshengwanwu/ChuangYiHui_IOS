//
//  UserGuideViewController.m
//  onlinetransapp
//
//  Created by litingdong on 16/3/17.
//  Copyright © 2016年 litingdong. All rights reserved.
//

#import "UserGuideViewController.h"
#import "AppDelegate.h"
#import "TabViewController.h"
@interface UserGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIPageControl *pageControl;

@end

@implementation UserGuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initPageController];
    [self initGuide];   //加载新用户指导页面
}

- (void)initPageController{
    _pageControl = [UIPageControl new];
    _pageControl.frame = CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 20);
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 0;
    [self.view addSubview:_pageControl];
}

- (void)initGuide
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 3, 0)];
    [scrollView setPagingEnabled:YES];  //视图整页显示
    //    [scrollView setBounces:NO]; //避免弹跳效果,避免把根视图露出来
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [imageview setImage:[UIImage imageNamed:@"guide_page_1"]];
    [scrollView addSubview:imageview];
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*1, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [imageview1 setImage:[UIImage imageNamed:@"guide_page_2"]];
    [scrollView addSubview:imageview1];
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [imageview2 setImage:[UIImage imageNamed:@"guide_page_3"]];
    [scrollView addSubview:imageview2];
    
    imageview2.userInteractionEnabled = YES;    //打开imageview3的用户交互;否则下面的
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//在imageview3上加载一个透明的button
    [button setTitle:@"立即体验" forState:UIControlStateNormal];
    [button setTitleColor:COLOR(75.0, 159.0, 240.0) forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"start_icon"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:MAIN_COLOR];
    button.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [button setFrame:CGRectMake((SCREEN_WIDTH - 250)/2,SCREEN_HEIGHT - 80, 250, 45)];
    [button addTarget:self action:@selector(firstpressed) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5.0;
    [imageview2 addSubview:button];
    
    [self.view addSubview:scrollView];
    [self.view bringSubviewToFront:_pageControl];
}

- (void)firstpressed
{
    TabViewController *tabVC = [[TabViewController alloc] initWithNibName:nil bundle:nil];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = tabVC ;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;    
    // 设置页码
    _pageControl.currentPage = page;
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

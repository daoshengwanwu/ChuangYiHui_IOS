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
#import "CompetitionDetailControllerViewController.h"
#import "SHPlacePickerView.h"
#import "CY51CTOCourseListItem.h"
#import "PlaceModel.h"
#import "LBXScan1ViewController.h"
#import "StyleDIY.h"
#import "FilterViewController.h"


@interface HotSpotController ()<XLSlideSwitchDelegate>

@property (nonatomic, strong) XLSlideSwitch *slideSwitch;

@property (nonatomic, strong) NSMutableArray *dataArray;                // 存放model的数据数组

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) SHPlacePickerView *shplacePicker;


@end

@implementation HotSpotController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpRightButton];

    NSArray *titles = @[@"发布", @"竞赛", @"活动", @"资源"];
    NSMutableArray *viewControllers = [NSMutableArray new];
    
    [viewControllers addObject:[PublishViewController new]];
    [viewControllers addObject:[CompetitionListController new]];
    [viewControllers addObject:[ActivityListController new]];
    [viewControllers addObject:[CY51CTOCourseListItem new]];
    
    _slideSwitch = [[XLSlideSwitch alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) Titles:titles viewControllers:viewControllers];
    //设置代理
    _slideSwitch.delegate = self;
    //设置按钮选中和未选中状态的标题颜色
    _slideSwitch.itemSelectedColor = MAIN_COLOR;
    _slideSwitch.itemNormalColor = DARK_FONT_COLOR;
    [_slideSwitch showInViewController:self];
    // Do any additional setup after loading the view.
    
    
    // 选择/显示选中地区按钮
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.frame = CGRectMake(0, 64, 25, 45);
    selectButton.backgroundColor = [UIColor clearColor];
    selectButton.titleLabel.font = [UIFont systemFontOfSize: 12.0];
//    selectButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"saveArray"]) {
        
        self.dataArray = [NSMutableArray arrayWithCapacity:34];
        
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Place" ofType:@"plist"]];
        
        NSArray *provinceArray = [dict allKeys];
        //    self.selectedProvinceArray = provinceArray;
        
        for (int i = 0; i < provinceArray.count; i ++) {
            
            PlaceModel *placeModel = [[PlaceModel alloc] init];
            placeModel.provinceName = provinceArray[i];
            NSDictionary *cityDict = [[dict objectForKey:provinceArray[i]] firstObject];
            [cityDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                [placeModel.cityArray addObject:key];
                [placeModel.districtArray addObject:obj];
            }];
            [self.dataArray addObject:placeModel];
        }
        
        
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveArray"];
        
//        PlaceModel *placeModel = self.dataArray[[array[0] integerValue]];
        
        
//        NSArray *array1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveArray"];
//        self.shplacePicker = [[SHPlacePickerView alloc] initWithIsRecordLocation:YES SendPlaceArray:^(NSArray *placeArray) {
        [selectButton setTitle:[NSString stringWithFormat:@"%@",[[self.dataArray[[array[0] integerValue]] cityArray][[array[1] integerValue]] substringToIndex:2]] forState:UIControlStateNormal];
//        }];
    }else{
        [selectButton setTitle:@"不限" forState:UIControlStateNormal];
    }
    
    [selectButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectButton];
    self.selectButton = selectButton;
    
    self.selectButton.hidden = YES;
    
    UIImageView *arrowview = [UIImageView new];
    [self.view addSubview:arrowview];
    [arrowview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(5);
        make.width.mas_equalTo(8);
        make.left.mas_equalTo(selectButton.mas_right);
//        make.top.mas_equalTo(selectButton.mas_top);
        make.centerY.equalTo(selectButton.mas_centerY);
        //        make.centerY.equalTo(_headerView.mas_centerY);
    }];
    [arrowview setImage:[UIImage imageNamed:@"down_arrow"]];
    
    arrowview.hidden = YES;
    
    [self registerNotificationCenter];
    
    [self setUpLeftButton];
}

- (void)setUpLeftButton{
    //设置导航栏的左边按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"filter_icon"] forState:UIControlStateNormal];
    UIView *leftCustomView = [[UIView alloc] initWithFrame: leftButton.frame];
    [leftCustomView addSubview: leftButton];
    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem =[[UIBarButtonItem alloc] initWithCustomView: leftCustomView];
    
//    self.navigationItem.leftBarButtonItems = @[self.headerIconItem];
//    leftButton.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
//    [leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
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


- (void)leftButtonAction{
    FilterViewController *vc = [FilterViewController new];
//    vc.style = style;
//    vc.isOpenInterestRect = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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


-(void)selectAction{
    __weak __typeof(self)weakSelf = self;
    self.shplacePicker = [[SHPlacePickerView alloc] initWithIsRecordLocation:YES SendPlaceArray:^(NSArray *placeArray) {
        NSLog(@"省:%@ 市:%@ 区:%@",placeArray[0],placeArray[1],placeArray[2]);
        [weakSelf.selectButton setTitle:[NSString stringWithFormat:@"%@",[placeArray[1] substringToIndex:2]] forState:UIControlStateNormal];
    }];
    [self.view addSubview:self.shplacePicker];
}

- (void)registerNotificationCenter{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToActivityDetail:) name:@"GoToActivityDetail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToCompetitionDetail:) name:@"GoToCompetitionDetail" object:nil];
}

- (void)goToActivityDetail :(NSNotification *)notification{
    ActivityModel *model = [notification object];
    UIStoryboard *hotspotSB = [UIStoryboard storyboardWithName:@"HotSpot" bundle:nil];
    ActivityDetailController *vc = [hotspotSB instantiateViewControllerWithIdentifier:@"activityDetail"];
    vc.model = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)registerNotificationCenter{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToCompetitionDetail:) name:@"goToCompetitionDetail" object:nil];
//}

- (void)goToCompetitionDetail :(NSNotification *)notification{
    CompetitionModel *model = [notification object];
    UIStoryboard *hotspotSB = [UIStoryboard storyboardWithName:@"Competition" bundle:nil];
    CompetitionDetailControllerViewController *vc = [hotspotSB instantiateViewControllerWithIdentifier:@"competitionDetail"];
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

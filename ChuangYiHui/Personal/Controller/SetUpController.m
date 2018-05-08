//
//  SetUpController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/22.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "SetUpController.h"
#import "ServiceProtocolController.h"
#import "FeedbackController.h"
#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>

#define cellIdentifier @"cellIdentifier"
#define CLEAR_ALERT 10
#define QUIT_ALERT 11

@interface SetUpController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UIButton *bottomButton;


@end

@implementation SetUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initTitleArr];
    
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 44.0f;
        tableView.scrollEnabled = NO;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
        tableView.tableFooterView = [UIView new];
        tableView;
    });
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(NAV_HEIGHT);
        make.height.mas_equalTo(_titleArr.count * 44.0);
    }];
    
    [self addBottomButton];
    // Do any additional setup after loading the view.
}

- (void)initTitleArr{
    _titleArr = @[@"关于创易汇", @"绑定手机号", @"意见反馈", @"服务协议", @"清理缓存", @"版本更新", @"修改密码"];
}

- (void)addBottomButton{
    _bottomButton = [UIButton new];
    [self.view addSubview:_bottomButton];
    [_bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(45);
        make.top.equalTo(_tableView.mas_bottom).offset(20);
    }];
    _bottomButton.backgroundColor = MAIN_COLOR;
    [_bottomButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [_bottomButton addTarget:self action:@selector(bottomButtonAction) forControlEvents:UIControlEventTouchUpInside];
}


- (void)bottomButtonAction{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要注销吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = QUIT_ALERT;
    alertView.delegate = self;
    [alertView show];
}


//注销
- (void)logout{
    //退出融云
    [[RCIM sharedRCIM] logout];
    //清除用户缓存
    [[UserManager sharedManager] logOut];
    //注销，跳转到主界面
    [CommonTool goToLoginController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 4) {
        //清理缓存
        //cell.detailTextLabel.text = [CommonTool getCacheSize];
        cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)", [_titleArr objectAtIndex:indexPath.row], [CommonTool getCacheSize]];
    }else{
        cell.textLabel.text = [_titleArr objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
    //关于创易汇
        [self performSegueWithIdentifier:@"goToAboutAppController" sender:self];
    }else if(indexPath.row == 1){
    //绑定手机号
        [self performSegueWithIdentifier:@"goToBindPhoneController" sender:self];
    }else if(indexPath.row == 2){
     //意见反馈
        [self performSegueWithIdentifier:@"goToFeedbackController" sender:self];
    }else if(indexPath.row == 3){
     //服务协议
        ServiceProtocolController *vc = [ServiceProtocolController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 4){
        //清空缓存
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"缓存清除" message:@"确定清除缓存?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alertView.tag = CLEAR_ALERT;
        alertView.delegate = self;
        [alertView show];
        
    }else if(indexPath.row == 5){
        
    }else {
        //修改密码
        [self performSegueWithIdentifier:@"goToChangePasswordController" sender:self];
    }
}

#pragma mark - UIAlertViewDelegate方法实现
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CLEAR_ALERT) {
        //判断点击的是确认键
        if (buttonIndex == 1) {
            //01......
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //02.....
            NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
            //03......
            [fileManager removeItemAtPath:cacheFilePath error:nil];
            
            //04刷新第一行单元格
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }else if(alertView.tag == QUIT_ALERT){
        if (buttonIndex == 1) {
            [self logout];
        }
    }
}



@end

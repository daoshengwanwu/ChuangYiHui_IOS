//
//  TaskExternalReleaseViewController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/8/6.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "TaskExternalReleaseViewController.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetStringPicker.h"
#import "LabelFieldCell.h"
#import "LabelLabelArrowCell.h"
#import "LabelTextViewCell.h"

#define labelFieldCellIdentifier @"labelFieldCell"
#define labelLabelArrowCellIdentifier @"labelLabelArrowCell"
#define labelTextViewCellIdentifier @"labelTextViewCell"

#define RowHeight 48

@interface TaskExternalReleaseViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *paramsArr;
@property (nonatomic, strong)UIButton *enterButton;
@property (nonatomic, strong)NSArray *memberArr;
@property (nonatomic, strong)NSMutableArray *memberNameArr;
@property (nonatomic, strong)NSString *executorId;

@property (nonatomic, strong)NSArray *teamArr;
@property (nonatomic, strong)NSMutableArray *teamNameArr;


@end

@implementation TaskExternalReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布外部任务";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setArr];
    [self setupView];
    [self addEnterButton];
    [self getTeams];
    // Do any additional setup after loading the view.
}


- (void)setArr{
    _titleArr = @[@"任务标题", @"执行团队", @"截止时间", @"任务内容"];
    _paramsArr = @[@"title",@"executor_id", @"deadline", @"content"];
    _memberArr = @[];
    _memberNameArr = [NSMutableArray array];
}


- (void)setupView{
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"LabelLabelArrowCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:labelLabelArrowCellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:@"LabelFieldCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:labelFieldCellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:@"LabelTextViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:labelTextViewCellIdentifier];
        tableView.tableFooterView = [UIView new];
        tableView;
    });
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(NAV_HEIGHT);
        make.height.mas_equalTo(3 * RowHeight + 128.0);
    }];
}

- (void)setTaskDetail{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    LabelFieldCell *titleCell = [_tableView cellForRowAtIndexPath:indexPath];
    [titleCell setOnlyContent:_taskModel.title];
    
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    LabelLabelArrowCell *executorCell = [_tableView cellForRowAtIndexPath:indexPath];
    [executorCell setOnlyContent:[self findMemberById:_taskModel.executor_id]];
    
    indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    LabelLabelArrowCell *endTimeCell = [_tableView cellForRowAtIndexPath:indexPath];
    [endTimeCell setOnlyContent:_taskModel.deadline];
    indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    LabelTextViewCell *contentCell = [_tableView cellForRowAtIndexPath:indexPath];
    contentCell.content.text = _taskModel.content;
}

- (NSString *)findMemberById: (NSString *)user_id{
    for (UserModel *model in _memberArr) {
        if ([model.user_id isEqualToString:user_id]) {
            return model.name;
        }
    }
    return @"";
}

- (void)addEnterButton{
    _enterButton = [UIButton new];
    [self.view addSubview:_enterButton];
    [_enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(45);
        make.top.equalTo(_tableView.mas_bottom).offset(20);
    }];
    _enterButton.backgroundColor = MAIN_COLOR;
    [_enterButton setTitle:@"发 布" forState:UIControlStateNormal];
    [_enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)enterButtonAction{
    if (_enterWay == 1) {
        //再派任务
        [self resignTask];
    }else{
        
        if (_enterWay == 2) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            LabelLabelArrowCell *executorCell = [_tableView cellForRowAtIndexPath:indexPath];
            [executorCell setOnlyContent:_model.name];
        }
        
        if ([self checkInput]) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            LabelFieldCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            [params setObject:[cell getOnlyContent] forKey:@"title"];
            
            indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            LabelLabelArrowCell *memberCell = [_tableView cellForRowAtIndexPath:indexPath];
            [params setObject:_executorId forKey:@"executor_id"];
            
            indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            memberCell = [_tableView cellForRowAtIndexPath:indexPath];
            [params setObject:[memberCell getOnlyContent] forKey:@"deadline"];
            
            indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            LabelTextViewCell *contentCell = [_tableView cellForRowAtIndexPath:indexPath];
            [params setObject:contentCell.content.text forKey:@"content"];
            
            [[NetRequest sharedInstance] httpRequestWithPost:URL_GET_TEAM_EXTERNAL_TASKS(_model.team_id) parameters:params withToken:NO success:^(id data, NSString *message) {
                [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"发布成功" andTime:1.0f DoneBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } failed:^(id data, NSString *message) {
                [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
            }];
        }
    }
}

- (void)resignTask{
    if ([self checkInput]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        LabelFieldCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        [params setObject:[cell getOnlyContent] forKey:@"title"];
        
        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        LabelLabelArrowCell *memberCell = [_tableView cellForRowAtIndexPath:indexPath];
        [params setObject:[memberCell getOnlyContent] forKey:@"deadline"];
        
        indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        LabelTextViewCell *contentCell = [_tableView cellForRowAtIndexPath:indexPath];
        [params setObject:contentCell.content.text forKey:@"content"];
        
        [[NetRequest sharedInstance] httpRequestWithPost:URL_CHANGE_EXTERNAL_TASKS(_taskModel.task_id) parameters:params withToken:NO success:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"再派任务成功" andTime:1.0f DoneBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [self changeTaskStatus:@"0"];
        } failed:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        }];
    }
    
}

- (BOOL)checkInput{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    LabelFieldCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    if ([[cell getOnlyContent] length] == 0) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请填写任务标题" andTime:1.0f];
        return NO;
    }
    
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    LabelLabelArrowCell *memberCell = [_tableView cellForRowAtIndexPath:indexPath];
    if ([[memberCell getOnlyContent] length] == 0) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择执行团队" andTime:1.0f];
        return NO;
    }
    
    indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    memberCell = [_tableView cellForRowAtIndexPath:indexPath];
    if ([[memberCell getOnlyContent] length] == 0) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择截止日期" andTime:1.0f];
        return NO;
    }
    
    //    indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    //    LabelTextViewCell *contentCell = [_tableView cellForRowAtIndexPath:indexPath];
    //    if (contentCell.content.text.length == 0) {
    //        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请填写任务内容" andTime:1.0f];
    //        return NO;
    //    }
    //
    return YES;
}


- (void)getMembers{
    NSString *url = [NSString stringWithFormat:@"%@?limit=%d",URL_GET_TEAM_MEMBERS(_model.team_id), 100];
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        
        _memberArr = [UserModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        
        for (TeamModel *model in _memberArr) {
            [_memberNameArr addObject:model.name];
        }
        if (_enterWay == 1) {
            //再派任务
            //设置界面
            [self setTaskDetail];
        }
        
        [_tableView reloadData];
        
    } failed:^(id data, NSString *message) {
        NSLog(@"%@",message);
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        
    }];
}

//改变任务的状态
- (void)changeTaskStatus: (NSString *)status{
    NSDictionary *params = @{@"status" : status};
    [[NetRequest sharedInstance] httpRequestWithPost:URL_GET_EXTERNAL_TASK_DETAIL(_taskModel.task_id) parameters:params withToken:NO success:^(id data, NSString *message) {
        
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"操作失败" andTime:1.0f];
    }];
}


- (void)getTeams{
    NSString *url = [NSString stringWithFormat:@"%@?limit=%d",URL_GET_OWNED_TEAMS, 1000];
    [[NetRequest sharedInstance] httpRequestWithGET:url success:^(id data, NSString *message) {
        _teamArr = [TeamModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        _teamNameArr = [NSMutableArray array];
        for (TeamModel *team in _teamArr) {
            [_teamNameArr addObject:team.name];
        }
    } failed:^(id data, NSString *message) {
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        LabelFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:labelFieldCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitleAndContent:[_titleArr objectAtIndex:indexPath.row] Content:@""];
        return cell;
    }else if(indexPath.row == 3){
        LabelTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:labelTextViewCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title.text = [_titleArr objectAtIndex:indexPath.row];
        return cell;
    }else{
        LabelLabelArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:labelLabelArrowCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitleAndContent:[_titleArr objectAtIndex:indexPath.row] Content:@""];
        return cell;
    }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
    }else if(indexPath.row == 1){
        //执行人
        if (_teamNameArr.count == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"您还没创建团队" andTime:1.0f];
        }else{
            if (_enterWay == 0) {
                //创建任务
                [ActionSheetStringPicker showPickerWithTitle:@"选择执行团队" rows:@[_teamNameArr] initialSelection:@[@0] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
                    LabelLabelArrowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    [cell setOnlyContent:selectedValue[0]];
                    NSLog(@"index:%@", selectedIndex[0]);
                    TeamModel *teamModel = [_teamArr objectAtIndex:[selectedIndex[0] integerValue]];
                    _executorId = teamModel.team_id;
                } cancelBlock:^(ActionSheetStringPicker *picker) {
                    
                } origin:self.view];
            }else{
                //再派任务
                //需求直接指派
            }
        }
        
    }else if(indexPath.row == 2){
        //截止时间
        [ActionSheetDatePicker showPickerWithTitle:@"选择截止日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
            
            NSDateFormatter *formatter = [NSDateFormatter new];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            LabelLabelArrowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell setOnlyContent:[formatter stringFromDate:selectedDate]];
            
        } cancelBlock:^(ActionSheetDatePicker *picker) {
            
        } origin:self.view];
    }else{
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 128.0f;
    }else{
        return 48.0f;
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

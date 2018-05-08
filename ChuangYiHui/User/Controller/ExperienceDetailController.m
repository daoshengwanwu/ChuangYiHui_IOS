//
//  ExperienceDetailController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/15.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "ExperienceDetailController.h"
#import "LabelFieldCell.h"
#import "LabelLabelArrowCell.h"
#import "THDatePickerViewController.h"
#import "ActionSheetStringPicker.h"

#define LabelFieldCellIdentifier @"labelFieldCell"
#define LabelLabelArrowCellIdentifier @"labelLabelArrowCell"
#define RowHeight 48.0

@interface ExperienceDetailController ()<UITableViewDelegate, UITableViewDataSource, THDatePickerDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *paramsArr;
@property (nonatomic, retain) NSDate * curDate;
@property (nonatomic, retain) NSDateFormatter * formatter;
@property (nonatomic, strong) THDatePickerViewController * datePicker;
// 开始时间   结束时间
@property (nonatomic, assign) NSInteger selectDateType;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) NSDictionary *modelDic;


@end

@implementation ExperienceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self getTitle];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.curDate = [NSDate date];
    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    _modelDic = _model.mj_keyValues;

    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (_type == 0 || _type == 3) {
        //教育经历
        _titleArr = @[@"学校", @"专业", @"学历", @"开始时间", @"结束时间"];
        _paramsArr = @[@"unit", @"profession", @"degree", @"time_in", @"time_out"];
    }else{
        _titleArr = @[@"公司", @"职位", @"开始时间", @"结束时间"];
        _paramsArr = @[@"unit", @"profession", @"time_in", @"time_out"];
    }
    
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = RowHeight;
        tableView.scrollEnabled = NO;
        tableView.backgroundColor = [UIColor redColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"LabelFieldCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:LabelFieldCellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:@"LabelLabelArrowCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:LabelLabelArrowCellIdentifier];
        tableView.tableFooterView = [UIView new];
        tableView;
    });
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(_titleArr.count * RowHeight);
    }];
    
    [self setUpRightButton];
    
    if (_editType == 1) {
        [self addDeleteButton];
    }
    
    
    // Do any additional setup after loading the view.
}


- (void)setUpRightButton{
    //设置导航栏的右边按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [rightButton setImage:[UIImage imageNamed:@"save_icon"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}


//修改资料
- (void)rightButtonAction{
    if ([self checkInput]) {
        NSMutableDictionary *params = [NSMutableDictionary new];
        for (NSInteger i = 0; i < _titleArr.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            if (i < 2) {
                LabelFieldCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                [params setObject:[cell getOnlyContent] forKey:_paramsArr[i]];
                
            }else{
                LabelLabelArrowCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                [params setObject:[cell getOnlyContent] forKey:_paramsArr[i]];
            }
        }
        [params setObject:@"xxxx" forKey:@"description"];
        NSLog(@"params:%@", params);
        NSString *urlStr = @"";
        if (_editType == 0) {
            //新增
            if (_type == 0) {
                urlStr = URL_CREATE_EDUCATION_EXPERIENCE;
            }else if(_type == 1){
                urlStr = URL_CREATE_FIELDWORK_EXPERIENCE;
            }else{
                urlStr = URL_CREATE_WORK_EXPERIENCE;
            }
        }else{
            urlStr = URL_DELETE_POST_EXPERIENCE(_model.experience_id);
        }
        
        [[NetRequest sharedInstance] httpRequestWithPost:urlStr parameters:params withToken:NO success:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"操作成功" andTime:1.0f DoneBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } failed:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        }];
    }
}

- (BOOL)checkInput{
    for (NSInteger i = 0; i < _titleArr.count ; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        if (i < 2) {
            LabelFieldCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            if ([cell getOnlyContent].length == 0) {
                [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请完善资料" andTime:1.0F];
                return NO;
            }
        }else{
            LabelLabelArrowCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            if ([cell getOnlyContent].length == 0) {
                [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请完善资料" andTime:1.0F];
                return NO;
            }
        }
    }
    
    //判断开始时间和结束时间的先后
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_titleArr.count - 2 inSection:0];
    LabelLabelArrowCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    NSString *time_in = [cell getOnlyContent];
    
    indexPath = [NSIndexPath indexPathForRow:_titleArr.count - 1 inSection:0];
    cell = [_tableView cellForRowAtIndexPath:indexPath];
    NSString *time_out = [cell getOnlyContent];
    
    
    if ([time_in compare:time_out] == NSOrderedDescending) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"结束时间必须大于开始时间" andTime:1.0F];
        return NO;
    }

    return YES;
}


- (void)addDeleteButton{
    _deleteButton = [UIButton new];
    [self.view addSubview:_deleteButton];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(45);
        make.top.equalTo(_tableView.mas_bottom).offset(20);
    }];
    _deleteButton.backgroundColor = MAIN_COLOR;
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)deleteButtonAction{
    [[NetRequest sharedInstance] httpRequestWithDELETE:URL_DELETE_POST_EXPERIENCE(_model.experience_id) success:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"删除成功" andTime:1.0f DoneBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
    }];
}


- (NSString *)getTitle{
    NSString *title = @"";
    switch (_type) {
        case 0:
        case 3:
            title = @"教育经历";
            break;
            
        case 1:
        case 4:
            title = @"实习经历";
            break;
            
        default:
            title = @"工作经历";
            break;
    }
    return title;
}


- (NSString *)getEducationContentByIndex:(NSInteger) index{
    NSString *content = @"";
    switch (index) {
        case 0:
            content = _model.unit;
            break;
        
        case 1:
            content = _model.profession;
            break;
        
        case 2:
            content = _model.degree;
            break;
        
        case 3:
            content = _model.time_in;
            break;
            
        default:
            content = _model.time_out;
            break;
    }
    return content;
}

- (NSString *)getWorkContentByIndex:(NSInteger) index{
    NSString *content = @"";
    switch (index) {
        case 0:
            content = _model.unit;
            break;
            
        case 1:
            content = _model.profession;
            break;
            
        case 2:
            content = _model.time_in;
            break;
            
        default:
            content = _model.time_out;
            break;
    }
    return content;
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_type == 0 || _type == 3)
        if (indexPath.row <= 1) {
            LabelFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:LabelFieldCellIdentifier forIndexPath:indexPath];
            [cell setTitleAndContent:_titleArr[indexPath.row] Content:_modelDic[_paramsArr[indexPath.row]]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            LabelLabelArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:LabelLabelArrowCellIdentifier forIndexPath:indexPath];
            [cell setTitleAndContent:_titleArr[indexPath.row] Content:_modelDic[_paramsArr[indexPath.row]]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _titleArr.count - 1 || indexPath.row == _titleArr.count - 2) {
        _selectDateType = indexPath.row;
        [self selectDate];
    }
    
     if (_type == 0 || _type == 3) {
         if (indexPath.row == 2) {
             //学历
             [ActionSheetStringPicker showPickerWithTitle:@"选择学历" rows:@[@[@"专科", @"本科", @"研究生", @"博士"]] initialSelection:@[@0] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
                 LabelLabelArrowCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                 [cell setOnlyContent:selectedValue[0]];
                 
             } cancelBlock:^(ActionSheetStringPicker *picker) {
                 
             } origin:self.view];
             
         }
     }
}



- (void)selectDate{
    if(!self.datePicker)
        self.datePicker = [THDatePickerViewController datePicker];
    self.datePicker.date = self.curDate;
    self.datePicker.delegate = self;
    [self.datePicker setAllowClearDate:NO];
    [self.datePicker setClearAsToday:YES];
    [self.datePicker setAutoCloseOnSelectDate:NO];
    [self.datePicker setAllowSelectionOfSelectedDate:YES];
    [self.datePicker setDisableYearSwitch:YES];
    //[self.datePicker setDisableFutureSelection:NO];
    [self.datePicker setDaysInHistorySelection:12];
    [self.datePicker setDaysInFutureSelection:0];
    //    [self.datePicker setAllowMultiDaySelection:YES];
    //    [self.datePicker setDateTimeZoneWithName:@"UTC"];
    //[self.datePicker setAutoCloseCancelDelay:5.0];
    [self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
    [self.datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
    [self.datePicker setCurrentDateColorSelected:[UIColor yellowColor]];
    
    [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
        int tmp = (arc4random() % 30)+1;
        return (tmp % 5 == 0);
    }];
    //[self.datePicker slideUpInView:self.view withModalColor:[UIColor lightGrayColor]];
    [self presentSemiViewController:self.datePicker withOptions:@{
                                                                  KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                  KNSemiModalOptionKeys.animationDuration : @(0.3),
                                                                  KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                  }];
}

#pragma mark - THDatePickerDelegate

- (void)datePickerDonePressed:(THDatePickerViewController *)datePicker {
    self.curDate = datePicker.date;
    NSIndexPath *path = [NSIndexPath indexPathForRow:_selectDateType inSection:0];
    LabelLabelArrowCell *cell = [_tableView cellForRowAtIndexPath:path];
    [cell setOnlyContent:[_formatter stringFromDate:datePicker.date]];
    [self dismissSemiModalView];
}

- (void)datePickerCancelPressed:(THDatePickerViewController *)datePicker {
    [self dismissSemiModalView];
}

- (void)datePicker:(THDatePickerViewController *)datePicker selectedDate:(NSDate *)selectedDate {
    NSLog(@"Date selected: %@",[_formatter stringFromDate:selectedDate]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

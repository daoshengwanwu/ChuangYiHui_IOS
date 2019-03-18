//
//  ReleaseNeedsController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/30.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "ReleaseNeedsController.h"
#import "LabelFieldCell.h"
#import "LabelLabelArrowCell.h"
#import "ActionSheetStringPicker.h"
#import "IWAreaPickerView.h"
#import "ActionSheetDatePicker.h"
#import "FieldPickerView.h"
#import "LabelTextViewCell.h"


#define RowHeight 48
#define cellIdentifier @"labelFieldCell"
#define labelCellIdentifier @"labelLabelArrowCell"
#define labelTextViewIdentifier @"labelTextViewCell"

@interface ReleaseNeedsController ()<UITableViewDelegate, UITableViewDataSource, IWAreaPickerViewDelegate, FieldPickerViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *paramArr;
@property (nonatomic, strong)NSArray *sexArr;
@property (nonatomic, strong)NSMutableDictionary *paramsDic;
@property (nonatomic, strong)IWAreaPickerView *areaPickerView;
@property (nonatomic, strong)FieldPickerView *fieldPickerView;
@property (nonatomic, strong)NSArray *areaArr;

@end

@implementation ReleaseNeedsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setTitleText];
    [self initArray];
    [self initView];
    [self addFooterView];
}


- (void)setTitleText{
    if (_needType == 0) {
        self.title = @"发布人员需求";
    }else if(_needType == 1){
        self.title = @"发布附能需求";
    }else{
        self.title = @"发布项目需求";
    }
}

- (void)initArray{
    _paramsDic = [NSMutableDictionary dictionary];
    _sexArr = @[@"不限", @"男", @"女"];
    _areaArr = @[@"不限",@"北京",@"天津",@"上海",@"重庆", @"河北", @"河南", @"湖北", @"湖南", @"江苏", @"江西", @"辽宁", @"吉林", @"黑龙江", @"陕西", @"山西", @"山东", @"四川", @"青海", @"安徽", @"海南", @"广东", @"贵州", @"浙江", @"福建", @"台湾", @"甘肃", @"云南", @"西藏", @"宁夏", @"广西", @"新疆", @"内蒙古", @"香港", @"澳门"];
    if (_needType == 0) {
        _titleArr = @[@"需求标题", @"领域", @"技能", @"年龄", @"性别", @"地区", @"学历", @"人数", @"截止时间", @"需求描述"];
        //age_min age_max
        _paramArr = @[@"title", @"field", @"skill", @"age", @"gender", @"province", @"degree", @"number", @"deadline", @"description"];
    
    }else if(_needType == 1){
        _titleArr = @[@"需求标题", @"领域", @"技能", @"地区", @"学历", @"人数", @"费用", @"截止时间", @"任务开始时间", @"任务结束时间", @"需求描述"];
        //costUnit
        _paramArr = @[@"title", @"field", @"skill", @"province", @"degree", @"number", @"cost", @"deadline", @"time_started", @"time_ended", @"description"];
    }else{
        _titleArr = @[@"需求标题", @"领域", @"技能", @"地区", @"学历", @"人数", @"费用", @"截止时间", @"任务开始时间", @"任务结束时间", @"需求描述"];
        _paramArr = @[@"title", @"field", @"skill", @"province", @"degree", @"number", @"cost", @"deadline", @"time_started", @"time_ended", @"description"];
    }
}

- (void)initView{
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
//        tableView.rowHeight = RowHeight;
//        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"LabelFieldCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:@"LabelLabelArrowCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:labelCellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:@"LabelTextViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:labelTextViewIdentifier];
        tableView.tableFooterView = [UIView new];
        tableView;
    });
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(NAV_HEIGHT);
        make.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(_titleArr.count * RowHeight + 3 * 14);
    }];
}

- (void)addFooterView{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UIButton *releaseButton = [UIButton new];
    [footerView addSubview:releaseButton];
    [releaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(45);
        make.centerY.equalTo(footerView.mas_centerY);
    }];
    releaseButton.backgroundColor = MAIN_COLOR;
    [releaseButton setTitle:@"发  布" forState:UIControlStateNormal];
    [releaseButton addTarget:self action:@selector(releaseButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView.tableFooterView = footerView;
}


- (BOOL)checkInput{
    [_paramsDic removeAllObjects];
    if (_needType == 0) {
      //人员需求
        //标题
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        LabelFieldCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[cell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入需求标题" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[cell getOnlyContent] forKey:@"title"];
        }
        //领域
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        LabelLabelArrowCell *fieldCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[fieldCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择领域" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[fieldCell getOnlyContent] forKey:@"field"];
        }

        //技能
        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        LabelLabelArrowCell *skillCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[skillCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择技能" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[skillCell getOnlyContent] forKey:@"skill"];
        }
        
        //年龄
        indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        LabelLabelArrowCell *ageCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[ageCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择年龄" andTime:1.5f];
            return NO;
        }else{
            NSString *ageStr = [ageCell getOnlyContent];
            if ([ageStr isEqualToString:@"不限"]) {
                [_paramsDic setObject:@"0" forKey:@"age_min"];
                [_paramsDic setObject:@"100" forKey:@"age_max"];
            }else{
                NSArray *ageArr = [ageStr componentsSeparatedByString:@"-"];
                [_paramsDic setObject:ageArr[0] forKey:@"age_min"];
                [_paramsDic setObject:ageArr[1] forKey:@"age_max"];
            }
        }
        
        //性别
        indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        LabelLabelArrowCell *sexCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[sexCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择性别" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[NSString stringWithFormat:@"%lu", (unsigned long)[_sexArr indexOfObject:[sexCell getOnlyContent]]] forKey:@"gender"];
        }

        //地区
        indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        LabelLabelArrowCell *provinceCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[provinceCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择地区" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[provinceCell getOnlyContent] forKey:@"province"];
        }
        //学历
        
        indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
        LabelLabelArrowCell *degreeCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[degreeCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择学历" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[degreeCell getOnlyContent] forKey:@"degree"];
        }
        
        //人数
        indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
        LabelFieldCell *numberCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[numberCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择人数" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[numberCell getOnlyContent] forKey:@"number"];
        }
        
        //截止时间
        indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
        LabelLabelArrowCell *deadlineCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[deadlineCell getOnlyContent] length] ==0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择截止时间" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[deadlineCell getOnlyContent] forKey:@"deadline"];
        }

        //需求描述
        indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
        LabelTextViewCell *descriptionCell = [_tableView cellForRowAtIndexPath:indexPath];
        if (descriptionCell.content.text.length ==0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入需求描述内容" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:descriptionCell.content.text forKey:@"description"];
        }
        return YES;
    }else if(_needType == 1){
        //承接需求
        //标题
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        LabelFieldCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[cell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入需求标题" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[cell getOnlyContent] forKey:@"title"];
        }
        //领域
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        LabelLabelArrowCell *fieldCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[fieldCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择领域" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[fieldCell getOnlyContent] forKey:@"field"];
        }
        
        //技能
        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        LabelLabelArrowCell *skillCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[skillCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择技能" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[skillCell getOnlyContent] forKey:@"skill"];
        }
        
               //地区
        indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        LabelLabelArrowCell *provinceCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[provinceCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择地区" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[provinceCell getOnlyContent] forKey:@"province"];
        }
        //学历
        
        indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        LabelLabelArrowCell *degreeCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[degreeCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择学历" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[degreeCell getOnlyContent] forKey:@"degree"];
        }
        
        //人数
        indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        LabelFieldCell *numberCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[numberCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择人数" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[numberCell getOnlyContent] forKey:@"number"];
        }
        
        //费用
        indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
        LabelFieldCell *feeCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[feeCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请填写费用" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[numberCell getOnlyContent] forKey:@"cost"];
        }
        
        
        //截止时间
        indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
        LabelLabelArrowCell *deadlineCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[deadlineCell getOnlyContent] length] ==0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择截止时间" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[deadlineCell getOnlyContent] forKey:@"deadline"];
        }
        
        //截止时间
        indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
        LabelLabelArrowCell *startCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[startCell getOnlyContent] length] ==0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择任务开始时间" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[deadlineCell getOnlyContent] forKey:@"time_started"];
        }
        
        //截止时间
        indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
        LabelLabelArrowCell *endCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[endCell getOnlyContent] length] ==0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择任务结束时间" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[deadlineCell getOnlyContent] forKey:@"time_ended"];
        }
        
        //需求描述
        indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
        LabelTextViewCell *descriptionCell = [_tableView cellForRowAtIndexPath:indexPath];
        if (descriptionCell.content.text.length ==0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入需求描述内容" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:descriptionCell.content.text forKey:@"description"];
        }

        return YES;
    }else{
        //外包需求
        //标题
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        LabelFieldCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[cell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入需求标题" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[cell getOnlyContent] forKey:@"title"];
        }
        //领域
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        LabelLabelArrowCell *fieldCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[fieldCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择领域" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[fieldCell getOnlyContent] forKey:@"field"];
        }
        
        //技能
        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        LabelLabelArrowCell *skillCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[skillCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择技能" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[skillCell getOnlyContent] forKey:@"skill"];
        }
        
        //地区
        indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        LabelLabelArrowCell *provinceCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[provinceCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择地区" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[provinceCell getOnlyContent] forKey:@"province"];
        }
        //学历
        
        indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        LabelLabelArrowCell *degreeCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[degreeCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择学历" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[degreeCell getOnlyContent] forKey:@"degree"];
        }
        
        //人数
        indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        LabelFieldCell *numberCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[numberCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择人数" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[numberCell getOnlyContent] forKey:@"number"];
        }
        
        //费用
        indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
        LabelFieldCell *feeCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[feeCell getOnlyContent] length] == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请填写费用" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[numberCell getOnlyContent] forKey:@"cost"];
        }
        
        
        //截止时间
        indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
        LabelLabelArrowCell *deadlineCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[deadlineCell getOnlyContent] length] ==0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择截止时间" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[deadlineCell getOnlyContent] forKey:@"deadline"];
        }
        
        //截止时间
        indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
        LabelLabelArrowCell *startCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[startCell getOnlyContent] length] ==0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择任务开始时间" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[deadlineCell getOnlyContent] forKey:@"time_started"];
        }
        
        //截止时间
        indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
        LabelLabelArrowCell *endCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([[endCell getOnlyContent] length] ==0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择任务结束时间" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:[deadlineCell getOnlyContent] forKey:@"time_ended"];
        }
        
        //需求描述
        indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
        LabelTextViewCell *descriptionCell = [_tableView cellForRowAtIndexPath:indexPath];
        if (descriptionCell.content.text.length ==0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入需求描述内容" andTime:1.5f];
            return NO;
        }else{
            [_paramsDic setObject:descriptionCell.content.text forKey:@"description"];
        }
        return YES;
    }
}


- (void)releaseButtonAction{
    if ([self checkInput]) {
        NSLog(@"params: %@", _paramsDic);
        [[NetRequest sharedInstance] httpRequestWithPost:[self getUrl] parameters:_paramsDic withToken:NO success:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"发布成功" andTime:1.5f DoneBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } failed:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"发布失败" andTime:1.5f];
        }];
    }
}


- (NSString *)getUrl{
    if (_needType == 0) {
        return URL_GET_TEAM_MEMBER_NEEDS(_teamModel.team_id);
    }else if(_needType == 1){
        return URL_GET_TEAM_UNDERTAKE_NEEDS(_teamModel.team_id);
    }else{
        return URL_GET_TEAM_OUTSOURCE_NEEDS(_teamModel.team_id);
    }
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_needType == 0) {
        //人员需求
        if (indexPath.row == 0 || indexPath.row == 7) {
            LabelFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTitleAndContent:_titleArr[indexPath.row] Content:@""];
            return cell;
        }else if(indexPath.row == 9){
            LabelTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:labelTextViewIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.title.text = _titleArr[indexPath.row];
            return cell;
        }else{
            LabelLabelArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:labelCellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTitleAndContent:_titleArr[indexPath.row] Content:@""];
            return cell;
        }
    }else{
        //承接需求
        //外包需求
        if (indexPath.row == 0 || indexPath.row == 5 || indexPath.row == 6) {
            LabelFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTitleAndContent:_titleArr[indexPath.row] Content:@""];
            return cell;
        }else if(indexPath.row == 10){
            LabelTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:labelTextViewIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.title.text = _titleArr[indexPath.row];
            return cell;
        }else{
            LabelLabelArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:labelCellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setTitleAndContent:_titleArr[indexPath.row] Content:@""];
            return cell;
        }
    }
}



#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_needType == 0) {
        if (indexPath.row == 1) {
            //领域
            _fieldPickerView = [[FieldPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

            UIWindow *win=[UIApplication sharedApplication].keyWindow;
            [win addSubview:_fieldPickerView];
            _fieldPickerView.delegate = self;
        }else if(indexPath.row == 2){
            //技能
            
        }else if(indexPath.row == 3){
            //年龄
            [ActionSheetStringPicker showPickerWithTitle:@"选择年龄" rows:@[@[@"不限", @"0-20", @"20-30", @"30-40", @"40-50", @"50-60", @"60-70", @"70-80"]] initialSelection:@[@0] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
                
                LabelLabelArrowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [cell setOnlyContent:selectedValue[0]];
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:self.view];
        }else if(indexPath.row == 4){
            //性别
            [ActionSheetStringPicker showPickerWithTitle:@"选择性别" rows:@[@[@"不限", @"男", @"女"]] initialSelection:@[@0] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
                
                LabelLabelArrowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [cell setOnlyContent:selectedValue[0]];
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:self.view];
        }else if(indexPath.row == 5){
            //地区
//            _areaPickerView = [[IWAreaPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//            
//            UIWindow *win=[UIApplication sharedApplication].keyWindow;
//            [win addSubview:_areaPickerView];
//            _areaPickerView.delegate=self;
            [ActionSheetStringPicker showPickerWithTitle:@"选择地区" rows:@[_areaArr] initialSelection:@[@0] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
                
                LabelLabelArrowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [cell setOnlyContent:selectedValue[0]];
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:self.view];

            
        }else if(indexPath.row == 6){
            //学历
            [ActionSheetStringPicker showPickerWithTitle:@"选择学历" rows:@[@[@"博士生", @"研究生", @"本科生", @"专科生", @"其他"]] initialSelection:@[@0] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
                
                LabelLabelArrowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [cell setOnlyContent:selectedValue[0]];
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:self.view];
            
        }else if(indexPath.row == 8){
            //截止时间
            [ActionSheetDatePicker showPickerWithTitle:@"选择截止日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
                
                NSDateFormatter *formatter = [NSDateFormatter new];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                LabelLabelArrowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [cell setOnlyContent:[formatter stringFromDate:selectedDate]];
                
            } cancelBlock:^(ActionSheetDatePicker *picker) {
                
            } origin:self.view];
            
        }
    }else{
        if (indexPath.row == 1) {
            //领域
            _fieldPickerView = [[FieldPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            
            UIWindow *win=[UIApplication sharedApplication].keyWindow;
            [win addSubview:_fieldPickerView];
            _fieldPickerView.delegate = self;
        }else if(indexPath.row == 2){
            //技能
            
        }else if(indexPath.row == 3){
            //地区
            //            _areaPickerView = [[IWAreaPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            //
            //            UIWindow *win=[UIApplication sharedApplication].keyWindow;
            //            [win addSubview:_areaPickerView];
            //            _areaPickerView.delegate=self;
            [ActionSheetStringPicker showPickerWithTitle:@"选择地区" rows:@[_areaArr] initialSelection:@[@0] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
                
                LabelLabelArrowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [cell setOnlyContent:selectedValue[0]];
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:self.view];
            
            
        }else if(indexPath.row == 4){
            //学历
            [ActionSheetStringPicker showPickerWithTitle:@"选择学历" rows:@[@[@"博士生", @"研究生", @"本科生", @"专科生", @"其他"]] initialSelection:@[@0] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
                
                LabelLabelArrowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [cell setOnlyContent:selectedValue[0]];
                
            } cancelBlock:^(ActionSheetStringPicker *picker) {
                
            } origin:self.view];
            
        }else if(indexPath.row == 7){
            //截止时间
            [ActionSheetDatePicker showPickerWithTitle:@"选择截止日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
                
                NSDateFormatter *formatter = [NSDateFormatter new];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                LabelLabelArrowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [cell setOnlyContent:[formatter stringFromDate:selectedDate]];
                
            } cancelBlock:^(ActionSheetDatePicker *picker) {
                
            } origin:self.view];
        }else if(indexPath.row == 8){
            //任务开始时间
            [ActionSheetDatePicker showPickerWithTitle:@"选择任务开始日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
                
                NSDateFormatter *formatter = [NSDateFormatter new];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                LabelLabelArrowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [cell setOnlyContent:[formatter stringFromDate:selectedDate]];
                
            } cancelBlock:^(ActionSheetDatePicker *picker) {
                
            } origin:self.view];
        }else if(indexPath.row == 9){
            //任务结束时间
            [ActionSheetDatePicker showPickerWithTitle:@"选择任务结束日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
                
                NSDateFormatter *formatter = [NSDateFormatter new];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                LabelLabelArrowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                [cell setOnlyContent:[formatter stringFromDate:selectedDate]];
                
            } cancelBlock:^(ActionSheetDatePicker *picker) {
                
            } origin:self.view];
        }
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor = LINE_COLOR;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 14;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((_needType == 0 && indexPath.row ==  9) || (_needType == 1 && indexPath.row == 10) || (_needType == 2 && indexPath.row ==  10)) {
        return 128.0f;
    }else{
        return RowHeight;
    }
}

#pragma mark AreaPickerViewDelegate
-(void)iWAreaPickerViewConfirmClickWith:(NSArray *)arr{
    if (arr.count!=3) {
        
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%@-%@-%@",arr[0],arr[1],arr[2]];
    NSIndexPath *path = [NSIndexPath indexPathForRow:5 inSection:0];
    LabelLabelArrowCell *cell = [_tableView cellForRowAtIndexPath:path];
    [cell setOnlyContent:str];
}


#pragma mark FieldPickerViewDelegate
-(void)FieldPickerViewConfirmClickWith:(NSArray *)arr{
    if (arr.count!=3) {
        
        return;
    }
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
    LabelLabelArrowCell *cell = [_tableView cellForRowAtIndexPath:path];
    [cell setOnlyContent:arr[0]];
    
    path = [NSIndexPath indexPathForRow:2 inSection:0];
    cell = [_tableView cellForRowAtIndexPath:path];
    [cell setOnlyContent:arr[2]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

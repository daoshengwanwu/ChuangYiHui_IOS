//
//  UserInformationController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/26.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "UserInformationController.h"
#import "LabelLabelCell.h"

#define cellIdentifier @"labelLabelCell"

@interface UserInformationController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSArray *keyArr;
@property (nonatomic, strong) NSDictionary *userDic;

@end

@implementation UserInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor whiteColor];
    _titleArr = @[@[@"昵称", @"性别"], @[@"学校", @"学院", @"专业"], @[@"邮箱", @"QQ"]];
    _keyArr = @[@[@"name", @"gender"], @[@"unit1", @"unit2", @"profession"], @[@"email", @"qq"]];
    _userDic = _model.mj_keyValues;
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)initView{
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 48.0f;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = YES;
        [tableView registerNib:[UINib nibWithNibName:@"LabelLabelCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
        tableView.tableFooterView = [UIView new];
        tableView;
    });
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_titleArr[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LabelLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setTitleText:_titleArr[indexPath.section][indexPath.row]];
    NSString *key = _keyArr[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 1) {
        //性别
        if([_userDic[key] isEqualToString:@"0"]){
            [cell setContentText:@"保密"];
        }else if([_userDic[key] isEqualToString:@"1"]){
            [cell setContentText:@"男"];
        }else{
            [cell setContentText:@"女"];
        }
    }else{
        [cell setContentText:_userDic[key]];
    }
    return cell;
}



#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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


@end

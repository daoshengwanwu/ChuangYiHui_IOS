//
//  CreateTeamController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/17.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "CreateTeamController.h"
#import "IWAreaPickerView.h"
#import "FieldPickerView.h"
#import "TeamDescriptionController.h"

#import "ImageLabelLabelArrowCell.h"
#import "ImageTextfieldCell.h"
#import "FMDB.h"
#import "ActionSheetStringPicker.h"


#define cellIdentifier @"imageLabelLabelArrowCell"
#define imageTextfieldCellIdentifier @"imageTextfieldCell"

#define RowHeight 48

@interface CreateTeamController ()<UITableViewDelegate, UITableViewDataSource, IWAreaPickerViewDelegate, FieldPickerViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *imageNameArr;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *paramsArr;
@property (nonatomic, strong)UIButton *enterButton;
@property (nonatomic, strong)IWAreaPickerView *areaPickerView;
@property (nonatomic, strong)FieldPickerView *fieldPickerView;
@property (nonatomic, strong)NSArray *areaArr;
//用来接收picker选择后的数据
@property (nonatomic, strong)NSArray *fieldPickerArr;
@property(nonatomic,strong)FMDatabase *db;

@property (nonatomic, strong)NSMutableArray *fieldArr;
@property (nonatomic, strong)NSMutableDictionary *typeDic;
@property (nonatomic, strong)NSMutableDictionary *skillDic;



@end

@implementation CreateTeamController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"创建团队";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self setArr];
    [self setupView];
    [self addEnterButton];
//    [self initDatabase];
    // Do any additional setup after loading the view.
}


- (void)initDatabase{
    //1.获得数据库文件的路径
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"field" ofType:@"db"];
    
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    self.db=db;
    //3.打开数据库
    if ([db open]) {
        NSLog(@"打开数据库成功");
        //后台运行
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // something
            [self queryField];
        });
    }
}

- (void)queryField{
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM cy_field"];
    
    // 2.遍历结果
    while ([resultSet next]) {
        int ID = [resultSet intForColumn:@"id"];
        NSString *field = [resultSet stringForColumn:@"field"];
        NSLog(@"field: %d %@", ID, field);
        [_fieldArr addObject:field];
        [self queryTypeByFieldId:[NSString stringWithFormat:@"%d", ID] AndName:field];
    }

}

- (void)queryTypeByFieldId: (NSString *)field_id AndName: (NSString *)name{
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:[NSString stringWithFormat:@"SELECT * FROM cy_type WHERE field_id=%@", field_id]];
    
    NSMutableArray *typeArr = [NSMutableArray array];
    // 2.遍历结果
    while ([resultSet next]) {
        int ID = [resultSet intForColumn:@"id"];
        NSString *type = [resultSet stringForColumn:@"type"];
        NSLog(@"type: %d %@", ID, type);
        [typeArr addObject:type];
        [self querySkillByTypeId:[NSString stringWithFormat:@"%d", ID] AndName:type];
    }
    [_typeDic setObject:typeArr forKey:name];
}


- (void)querySkillByTypeId: (NSString *)type_id AndName: (NSString *)name{
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:[NSString stringWithFormat:@"SELECT * FROM cy_skill WHERE type_id=%@", type_id]];
    
    NSMutableArray *skillArr = [NSMutableArray array];
    // 2.遍历结果
    while ([resultSet next]) {
        int ID = [resultSet intForColumn:@"id"];
        NSString *skill = [resultSet stringForColumn:@"skill"];
        NSLog(@"skill: %d %@", ID, skill);
        [skillArr addObject:skill];
    }
    
    [_skillDic setObject:skillArr forKey:name];

}


- (void)setArr{
    _titleArr = @[@"请输入团队名称", @"所在地区", @"所属领域", @"团队标签", @"请输入团队链接", @"团队描述"];
    _imageNameArr = @[@"team_name_icon", @"team_area_icon", @"team_field_icon", @"team_tags_icon", @"team_link_icon", @"team_description_icon"];
    _paramsArr = @[@"name", @"", @"fields", @"tags", @"url", @"description"];
    _areaArr = @[];
    _fieldArr = [NSMutableArray array];
    _typeDic = [NSMutableDictionary dictionary];
    _skillDic = [NSMutableDictionary dictionary];
    _fieldPickerArr = @[];
}

- (void)setupView{
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = RowHeight;
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"ImageLabelLabelArrowCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:@"ImageTextfieldCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:imageTextfieldCellIdentifier];
        tableView.tableFooterView = [UIView new];
        tableView;
    });
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(NAV_HEIGHT);
        make.height.mas_equalTo(_titleArr.count * RowHeight);
    }];
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
    [_enterButton setTitle:@"确 定" forState:UIControlStateNormal];
    [_enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
}


- (BOOL)checkInput{
//    for (NSInteger i = 0; i < _titleArr.count; i++) {
//        if (i == 0 || i == _titleArr.count - 2) {
//            ImageTextfieldCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//            if ([[cell getOnlyContent] length] == 0) {
//                [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请完善资料" andTime:1.0f];
//                return NO;
//            }
//        }else{
//            ImageLabelLabelArrowCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
//            if ([[cell getOnlyContent] length] == 0) {
//                [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请完善资料" andTime:1.0f];
//                return NO;
//            }
//        }
//    }
    return YES;
}

- (void)enterButtonAction{
    if ([self checkInput]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        for (NSInteger i = 0; i < _titleArr.count; i++) {
            if (i != 1) {
                if (i == 0 || i == _titleArr.count - 2) {
                    ImageTextfieldCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    [params setObject:[cell getOnlyContent] forKey:_paramsArr[i]];
                }else{
                    ImageLabelLabelArrowCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    [params setObject:[cell getOnlyContent] forKey:_paramsArr[i]];
                }
            }
        }
        
        [params setObject:_areaArr[0] forKey:@"province"];
        [params setObject:_areaArr[1] forKey:@"city"];
        [params setObject:_areaArr[2] forKey:@"county"];
        if (_fieldPickerArr.count == 3) {
            [params setObject:[NSString stringWithFormat:@"%@|%@", _fieldPickerArr[0], _fieldPickerArr[2]] forKey:@"fields"];
        }

        [[NetRequest sharedInstance] httpRequestWithPost: URL_CREATE_TEAM parameters:params withToken:NO success:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"创建团队成功" andTime:1.0f DoneBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } failed:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        }];
    }
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 4) {
        ImageTextfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:imageTextfieldCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setOnlyImage:_imageNameArr[indexPath.row]];
        [cell setPlaceHolder:_titleArr[indexPath.row]];
        return cell;
    }else{
        ImageLabelLabelArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setOnlyTitle:_titleArr[indexPath.row]];
        [cell setOnlyImage:_imageNameArr[indexPath.row]];
        return cell;
    }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
    }else if(indexPath.row == 1){
        _areaPickerView = [[IWAreaPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        UIWindow *win=[UIApplication sharedApplication].keyWindow;
        [win addSubview:_areaPickerView];
        _areaPickerView.delegate=self;
    }else if(indexPath.row == 2){
//        NSLog(@"typedic: %@", _typeDic);
//        NSLog(@"skilldic: %@", _skillDic);
//        [ActionSheetStringPicker showPickerWithTitle:@"领域技能" rows:@[_fieldArr,_typeDic] initialSelection:@[@0, @0] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
//            
//        } cancelBlock:^(ActionSheetStringPicker *picker) {
//            
//        } origin:self.view];
        
        _fieldPickerView = [[FieldPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _fieldPickerView.delegate = self;
        UIWindow *win=[UIApplication sharedApplication].keyWindow;
        [win addSubview:_fieldPickerView];
    }else if(indexPath.row == 3){
        
    }else if(indexPath.row == 4){
        
    }else{
        TeamDescriptionController *vc = [TeamDescriptionController new];
        //可编辑
        vc.type = 0;
        vc.setContentBlock = ^(NSString *content){
            ImageLabelLabelArrowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell setOnlyContent:content];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark IWAreaPickerDelegate
//将省市区赋值
-(void)iWAreaPickerViewConfirmClickWith:(NSArray *)arr{
    
    if (arr.count!=3) {
        
        return;
    }
    
    _areaArr = arr;
    NSString *str;
    if ([arr[0] isEqualToString:arr[1]]) {
        
        str=[NSString stringWithFormat:@"%@-%@",arr[1],arr[2]];
    }else{
        
        str=[NSString stringWithFormat:@"%@-%@-%@",arr[0],arr[1],arr[2]];
    }
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
    ImageLabelLabelArrowCell *cell = [_tableView cellForRowAtIndexPath:path];
    [cell setOnlyContent:str];
}

#pragma mark FieldPickerViewDelegate
-(void)FieldPickerViewConfirmClickWith:(NSArray *)arr{
    if (arr.count!=3) {
        
        return;
    }
    
    NSString *str = [NSString stringWithFormat:@"%@-%@-%@",arr[0],arr[1],arr[2]];
    _fieldPickerArr = arr;
    NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:0];
    ImageLabelLabelArrowCell *cell = [_tableView cellForRowAtIndexPath:path];
    [cell setOnlyContent:str];
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

//
//  FieldPickerView.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/18.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "FieldPickerView.h"
#import "FMDB.h"

static const NSInteger KFieldComponent = 0;
static const NSInteger KTypeComponent = 1;
static const NSInteger KSkillComponent = 2;

#define KFont14 [UIFont systemFontOfSize:18]

@interface FieldPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView    *_areapicker;
    NSArray         *_typeArr;
    NSArray         *_skillArr;
}

@property(nonatomic,strong)FMDatabase *db;

@property (nonatomic, strong)NSMutableArray *fieldArr;
@property (nonatomic, strong)NSMutableDictionary *typeDic;
@property (nonatomic, strong)NSMutableDictionary *skillDic;

@end

@implementation FieldPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1.设置背景色
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.29];
        
        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgViewClick)];
        
        [self addGestureRecognizer:tapGR];
        
        //2.添加UIPickerView
        [self addPickerView];
        
        //3.初始化数组
        [self initArr];
        
        //4.添加数据
        [self initDatabase];
    
    }
    return self;
}

- (void)initArr{
    _fieldArr = [NSMutableArray array];
    _typeDic = [NSMutableDictionary dictionary];
    _typeArr = @[];
    _skillDic = [NSMutableDictionary dictionary];
    _skillArr = @[];
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
            dispatch_async(dispatch_get_main_queue(), ^(){
                NSLog(@"donedone");
                [self setFieldDict];
            });
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
//        int ID = [resultSet intForColumn:@"id"];
        NSString *skill = [resultSet stringForColumn:@"skill"];
        [skillArr addObject:skill];
    }
    
    [_skillDic setObject:skillArr forKey:name];
    
}


-(void)bgViewClick{
    
    [self removeFromSuperview];
}

#pragma mark 设置领域-类型-技能的数据字典
- (void)setFieldDict
{
    [self selectedfieldIndex:0 typeIndex:0];
    [_areapicker reloadAllComponents];
}

#pragma mark 获取对应的领域-类型-技能数据
- (void)selectedfieldIndex:(NSInteger)fieldIndex typeIndex:(NSInteger)typeIndex
{
    NSString *selectedField = [_fieldArr objectAtIndex:fieldIndex];
    _typeArr = [_typeDic objectForKey:selectedField];
//    NSLog(@"select type arr:%@  %@",selectedField,  _typeArr);
    
    NSString *selectedType = [_typeArr objectAtIndex:typeIndex];
    _skillArr = [_skillDic objectForKey:selectedType];
//    NSLog(@"select skill arr:%@", _skillArr);

}

#pragma mark 添加UIPickerView
- (void)addPickerView
{
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-227-44, self.frame.size.width, 44)];
    topView.backgroundColor =kUIColorFromRGB(0xF7F7F7);
    
    topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:topView];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.titleLabel.font = KFont14;
    [cancleBtn setTitleColor:kUIColorFromRGB(0x0174FE) forState:UIControlStateNormal];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    CGFloat BtnY = 0;
    CGFloat BtnH = topView.frame.size.height;
    CGFloat BtnW = BtnH*1.5;
    cancleBtn.frame = CGRectMake(0, BtnY, BtnW, BtnH);
    [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancleBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.titleLabel.font = cancleBtn.titleLabel.font;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:kUIColorFromRGB(0x0174FE) forState:UIControlStateNormal];
    CGFloat confirmBtnX = self.frame.size.width - BtnW;
    confirmBtn.frame = CGRectMake(confirmBtnX, BtnY, BtnW, BtnH);
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:confirmBtn];
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    //    picker.frame = CGRectMake(0, CGRectGetMaxY(topView.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(topView.frame));
    //    picker.backgroundColor = [UIColor colorWithRed:213/255.0 green:216/255.0 blue:223/255.0 alpha:1.0f];
    
    picker.backgroundColor=kUIColorFromRGB(0xc8c8c8);
    [self addSubview:picker];
    
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(227);
        
    }];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    //[self addSubview:picker];
    _areapicker = picker;
}

#pragma mark 取消
- (void)cancle
{
    [self removeFromSuperview];
}

#pragma mark 确定
- (void)confirm
{
    NSInteger fieldIndex = [_areapicker selectedRowInComponent: KFieldComponent];
    NSInteger typeIndex = [_areapicker selectedRowInComponent: KTypeComponent];
    NSInteger districtIndex = [_areapicker selectedRowInComponent: KSkillComponent];
    
    NSString *provinceStr = [_fieldArr objectAtIndex: fieldIndex];
    NSString *cityStr = [_typeArr objectAtIndex: typeIndex];
    NSString *districtStr = [_skillArr objectAtIndex:districtIndex];
    
    NSMutableArray *arr=[NSMutableArray arrayWithCapacity:3];
    
    [arr addObject:provinceStr];
    [arr addObject:cityStr];
    [arr addObject:districtStr];
    
    if ([self.delegate respondsToSelector:@selector(FieldPickerViewConfirmClickWith:)]) {
        
        [self.delegate FieldPickerViewConfirmClickWith:arr.copy];
    }
    
    [self removeFromSuperview];
    
}


#pragma mark 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

#pragma mark 行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == KFieldComponent) {
        return _fieldArr.count;
    }else if (component == KTypeComponent) {
        return _typeArr.count;
    }else {
        return _skillArr.count;
    }
}

#pragma mark 每一行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == KFieldComponent) {
        return [_fieldArr objectAtIndex:row];
    }else if (component == KTypeComponent){
        return [_typeArr objectAtIndex:row];
    }else {
        return [_skillArr objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == KFieldComponent) {
        [self selectedfieldIndex:row typeIndex:0];
        
        [_areapicker selectRow:0 inComponent:KTypeComponent animated:YES];
        [_areapicker selectRow:0 inComponent:KSkillComponent animated:YES];
        [_areapicker reloadComponent:KTypeComponent];
        [_areapicker reloadComponent:KSkillComponent];
        
    }else if (component == KTypeComponent) {
        NSInteger fieldIndex = [_areapicker selectedRowInComponent: KFieldComponent];
        [self selectedfieldIndex:fieldIndex typeIndex:row];
        [_areapicker selectRow:0 inComponent:KSkillComponent animated:YES];
        [_areapicker reloadComponent:KSkillComponent];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    CGFloat myViewW = pickerView.frame.size.width *0.33;
    CGFloat myViewH = 30;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, myViewW, myViewH)];
    myView.font = [UIFont systemFontOfSize:16];
    myView.backgroundColor = [UIColor clearColor];
    myView.textAlignment = NSTextAlignmentCenter;
    if (component == KFieldComponent) {
        myView.text = [_fieldArr objectAtIndex:row];
    }
    else if (component == KTypeComponent) {
        myView.text = [_typeArr objectAtIndex:row];
    }
    else {
        myView.text = [_skillArr objectAtIndex:row];
    }
    
    return myView;
}



@end

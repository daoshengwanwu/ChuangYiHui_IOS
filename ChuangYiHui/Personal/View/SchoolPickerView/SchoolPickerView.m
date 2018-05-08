//
//  SchoolPickerView.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/29.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "SchoolPickerView.h"
#import "FMDB.h"

static const NSInteger kProvinceComponent = 0;
static const NSInteger kSchoolComponent = 1;

#define KFont14 [UIFont systemFontOfSize:18]

@interface SchoolPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView    *_areapicker;
    NSArray         *_schoolArr;
}

@property(nonatomic,strong)FMDatabase *db;

@property (nonatomic, strong)NSMutableArray *provinceArr;
@property (nonatomic, strong)NSMutableDictionary *schoolDic;

@end

@implementation SchoolPickerView

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
    _provinceArr = [NSMutableArray array];
    _schoolDic = [NSMutableDictionary dictionary];
    _schoolArr = @[];
}


- (void)initDatabase{
    //1.获得数据库文件的路径
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"school" ofType:@"db"];
    
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:fileName];
    self.db=db;
    //3.打开数据库
    if ([db open]) {
        NSLog(@"打开数据库成功");
        //后台运行
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // something
            [self queryProvince];
            dispatch_async(dispatch_get_main_queue(), ^(){
                NSLog(@"donedone");
                [self setFieldDict];
            });
        });
    }
}

- (void)queryProvince{
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM cy_city"];
    
    // 2.遍历结果
    while ([resultSet next]) {
        int ID = [resultSet intForColumn:@"id"];
        NSString *city = [resultSet stringForColumn:@"city"];
        [_provinceArr addObject:city];
        [self querySchoolByProvinceId:[NSString stringWithFormat:@"%d", ID] AndName:city];
    }
    
}

- (void)querySchoolByProvinceId: (NSString *)province_id AndName: (NSString *)name{
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:[NSString stringWithFormat:@"SELECT * FROM cy_school WHERE city_id=%@", province_id]];
    
    NSMutableArray *schoolArr = [NSMutableArray array];
    // 2.遍历结果
    while ([resultSet next]) {
        NSString *type = [resultSet stringForColumn:@"school"];
        [schoolArr addObject:type];
    }
    [_schoolDic setObject:schoolArr forKey:name];
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
    NSString *selectedField = [_provinceArr objectAtIndex:fieldIndex];
    _schoolArr = [_schoolDic objectForKey:selectedField];
    //    NSLog(@"select type arr:%@  %@",selectedField,  _typeArr);
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
    NSInteger fieldIndex = [_areapicker selectedRowInComponent: kProvinceComponent];
    NSInteger typeIndex = [_areapicker selectedRowInComponent: kSchoolComponent];
    
    NSString *provinceStr = [_provinceArr objectAtIndex: fieldIndex];
    NSString *schoolStr = [_schoolArr objectAtIndex: typeIndex];
    
    NSMutableArray *arr=[NSMutableArray arrayWithCapacity:2];
    
    [arr addObject:provinceStr];
    [arr addObject:schoolStr];
    
    if ([self.delegate respondsToSelector:@selector(SchoolPickerViewConfirmClickWith:)]) {
        
        [self.delegate SchoolPickerViewConfirmClickWith:arr.copy];
    }
    
    [self removeFromSuperview];
    
}


#pragma mark 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

#pragma mark 行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == kProvinceComponent) {
        return _provinceArr.count;
    }else {
        return _schoolArr.count;
    }
}

#pragma mark 每一行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == kProvinceComponent) {
        return [_provinceArr objectAtIndex:row];
    }else{
        return [_schoolArr objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == kProvinceComponent) {
        [self selectedfieldIndex:row typeIndex:0];
        
        [_areapicker selectRow:0 inComponent:kSchoolComponent animated:YES];
        [_areapicker reloadComponent:kSchoolComponent];
        
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
    if (component == kProvinceComponent) {
        myView.text = [_provinceArr objectAtIndex:row];
    }
    else {
        myView.text = [_schoolArr objectAtIndex:row];
    }
    
    return myView;
}


@end

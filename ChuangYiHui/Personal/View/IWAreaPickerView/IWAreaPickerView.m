//
//  IWAreaPickerView.m
//  IWanna
//
//  Created by Mini on 16/9/12.
//  Copyright © 2016年 huangshaobin. All rights reserved.
//

#import "IWAreaPickerView.h"

static const NSInteger KProvinceComponent = 0;
static const NSInteger KCityComponent = 1;
static const NSInteger KDistrictComponent = 2;

#define KFont14 [UIFont systemFontOfSize:18]

@interface IWAreaPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView    *_areapicker;
    NSArray         *_province;
    NSArray         *_city;
    NSArray         *_district;
}

@property (nonatomic,copy) NSDictionary *areaDict;

@end

@implementation IWAreaPickerView

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
        
        //3.添加数据
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
        self.areaDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    return self;
}

-(void)bgViewClick{
    
    [self removeFromSuperview];
}

#pragma mark 设置省市区的数据字典
- (void)setAreaDict:(NSDictionary *)areaDict
{
    _areaDict = areaDict;
    
    [self selectedProvinceIndex:0 cityIndex:0];
    [_areapicker reloadAllComponents];
}

#pragma mark 获取对应的省市区数据
- (void)selectedProvinceIndex:(NSInteger)provinceIndex cityIndex:(NSInteger)cityIndex
{
    //取出省
    NSArray *components = [_areaDict allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return NSOrderedAscending;
        }
        
        return NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [NSMutableArray array];
    for (int i = 0; i < sortedArray.count; i ++) {
        NSString *index = sortedArray[i];
        NSArray *tmp = [[_areaDict objectForKey:index] allKeys];
        [provinceTmp addObject:tmp[0]];
    }
    
    _province = [NSArray arrayWithArray:provinceTmp];

    //取出市
    NSString *index = sortedArray[provinceIndex];
    NSString *selected = _province[provinceIndex];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[[_areaDict objectForKey:index] objectForKey:selected]];
    NSArray *cityComponents = [dic allKeys];
    NSArray *citySortedArray = [cityComponents sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return NSOrderedAscending;
        }
        
        return NSOrderedSame;
    }];
    
    NSMutableArray *cityTmp = [NSMutableArray array];
    for (int i = 0; i < citySortedArray.count; i ++) {
        NSString *index = citySortedArray[i];
        NSArray *tmp = [[dic objectForKey:index] allKeys];
        [cityTmp addObject:tmp[0]];
    }
    
    _city = [NSArray arrayWithArray:cityTmp];
    
    //取出区
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary:[dic objectForKey:citySortedArray[cityIndex]]];
    NSArray *array = [[NSArray alloc] initWithArray:[cityDic allKeys]];

    NSString *selectedCity = array[0];
    _district = [[NSArray alloc] initWithArray:cityDic[selectedCity]];
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
    NSInteger provinceIndex = [_areapicker selectedRowInComponent: KProvinceComponent];
    NSInteger cityIndex = [_areapicker selectedRowInComponent: KCityComponent];
    NSInteger districtIndex = [_areapicker selectedRowInComponent: KDistrictComponent];
    
    NSString *provinceStr = [_province objectAtIndex: provinceIndex];
    NSString *cityStr = [_city objectAtIndex: cityIndex];
    NSString *districtStr = [_district objectAtIndex:districtIndex];
    
    NSMutableArray *arr=[NSMutableArray arrayWithCapacity:3];
    
    [arr addObject:provinceStr];
    [arr addObject:cityStr];
    [arr addObject:districtStr];

    if ([self.delegate respondsToSelector:@selector(iWAreaPickerViewConfirmClickWith:)]) {
        
        [self.delegate iWAreaPickerViewConfirmClickWith:arr.copy];
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
    if (component == KProvinceComponent) {
        return _province.count;
    }else if (component == KCityComponent) {
        return _city.count;
    }else {
        return _district.count;
    }
}

#pragma mark 每一行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == KProvinceComponent) {
        return [_province objectAtIndex:row];
    }else if (component == KCityComponent){
        return [_city objectAtIndex:row];
    }else {
        return [_district objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == KProvinceComponent) {
        [self selectedProvinceIndex:row cityIndex:0];
        
        [_areapicker selectRow:0 inComponent:KCityComponent animated:YES];
        [_areapicker selectRow:0 inComponent:KDistrictComponent animated:YES];
        [_areapicker reloadComponent:KCityComponent];
        [_areapicker reloadComponent:KDistrictComponent];
        
    }else if (component == KCityComponent) {
        NSInteger provinceIndex = [_areapicker selectedRowInComponent: KProvinceComponent];
        [self selectedProvinceIndex:provinceIndex cityIndex:row];
        [_areapicker selectRow:0 inComponent:KDistrictComponent animated:YES];
        [_areapicker reloadComponent:KDistrictComponent];
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
    if (component == KProvinceComponent) {
        myView.text = [_province objectAtIndex:row];
    }
    else if (component == KCityComponent) {
        myView.text = [_city objectAtIndex:row];
    }
    else {
        myView.text = [_district objectAtIndex:row];
    }
    
    return myView;
}

@end

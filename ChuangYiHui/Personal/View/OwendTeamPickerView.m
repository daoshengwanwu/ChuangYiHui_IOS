//
//  OwendTeamPickerView.m
//  ChuangYiHui
//
//  Created by p1p1us on 2018/6/18.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import "OwendTeamPickerView.h"

static const NSInteger OwendTeamComponent = 0;

#define KFont14 [UIFont systemFontOfSize:18]

@interface OwendTeamPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView    *_owendteampicker;
    NSArray         *_owendteamArr;
}

//@property(nonatomic,strong)FMDatabase *db;
//@property (nonatomic, strong) NSArray *teamArr;
//@property (nonatomic, strong)NSArray *owendteamArr;
//@property (nonatomic, strong)NSMutableDictionary *owendteamDic;

@end

@implementation OwendTeamPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
    _owendteamArr = @[];
//    [self setFieldDict];
//    _owendteamDic = [NSMutableDictionary dictionary];
//    _schoolArr = @[];
}


//#pragma mark 设置领域-类型-技能的数据字典
//- (void)setFieldDict
//{
//    [self selectedfieldIndex:0 typeIndex:0];
//    [_owendteampicker reloadAllComponents];
//}

//#pragma mark 获取对应的领域-类型-技能数据
//- (void)selectedfieldIndex:(NSInteger)fieldIndex typeIndex:(NSInteger)typeIndex
//{
////    NSString *selectedField = [_provinceArr objectAtIndex:fieldIndex];
////    _owendteamArr = [_schoolDic objectForKey:selectedField];
//    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_OWNED_TEAMS success:^(id data, NSString *message) {
//        _owendteamArr = [TeamModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
//        TeamModel *kkk = [_owendteamArr objectAtIndex:3];
//        NSLog(@"ssssss%@...%@",kkk,kkk.name);
//        TeamModel *lll = [_owendteamArr objectAtIndex:4];
//        NSLog(@"bbbbbb%@...%@",lll,lll.name);
//    } failed:^(id data, NSString *message) {
//        NSLog(@"eeeeee%@",message);
//        //        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
//
//    }];
//    //    NSLog(@"select type arr:%@  %@",selectedField,  _typeArr);
//}

- (void)initDatabase{
    [self queryOwendTeam];
}

- (void)queryOwendTeam{
//    _owendteamArr = @[@"大专以下", @"大专", @"本科", @"硕士", @"博士", @"博士后"];
//    NSString *url = [NSString stringWithFormat:@"%@/",URL_GET_OWNED_TEAMS];
//    [self selectedfieldIndex:0 typeIndex:0];
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_OWNED_TEAMS success:^(id data, NSString *message) {
        _owendteamArr = [TeamModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
//        TeamModel *kkk = [_owendteamArr objectAtIndex:1];
//        NSLog(@"ssssss%@...%@",kkk,kkk.name);
//        TeamModel *lll = [_owendteamArr objectAtIndex:2];
//        NSLog(@"bbbbbb%@...%@",lll,lll.name);
    } failed:^(id data, NSString *message) {
        NSLog(@"eeeeee%@",message);
//        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];

    }];
}


-(void)bgViewClick{
    
    [self removeFromSuperview];
}

//#pragma mark 设置领域-类型-技能的数据字典
//- (void)setFieldDict
//{
//    [self selectedfieldIndex:0 typeIndex:0];
//    [_areapicker reloadAllComponents];
//}

//#pragma mark 获取对应的领域-类型-技能数据
//- (void)selectedfieldIndex:(NSInteger)fieldIndex typeIndex:(NSInteger)typeIndex
//{
//    NSString *selectedField = [_owendteamArr objectAtIndex:fieldIndex];
////    _owendteamArr = [_owendteamDic objectForKey:selectedField];
//    //    NSLog(@"select type arr:%@  %@",selectedField,  _typeArr);
//}

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
    
    UIButton *title = [UIButton buttonWithType:UIButtonTypeCustom];
    title.titleLabel.font = KFont14;
    [title setTitleColor:kUIColorFromRGB(0xBDBDBD) forState:UIControlStateNormal];
    [title setTitle:@"请选择报名队伍" forState:UIControlStateNormal];
    CGFloat TitleH = topView.frame.size.height;
    CGFloat TitleW = TitleH*4;
    CGFloat confirmTitleX = (self.frame.size.width - TitleW)/2;
    title.frame = CGRectMake(confirmTitleX, 0, TitleW, TitleH);
//    [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:title];
    
//    UILabel *title =  [[UILabel alloc]init];
//    title.font = KFont14;
//    CGFloat TitleH = title.frame.size.height;
////    CGFloat TitleW = BtnH*3;
//    title.text = @"请选择报名队伍：";
//    [title setTextColor:kUIColorFromRGB(0x0174FE)];
//    CGFloat TitleW = title.frame.size.width;
//    CGFloat confirmTitleX = (self.frame.size.width - TitleW)/2;
//    title.frame = CGRectMake(confirmTitleX, 0, TitleW, TitleH);
//    [topView addSubview:title];
    
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
    _owendteampicker = picker;
}


#pragma mark 取消
- (void)cancle
{
    [self removeFromSuperview];
}

#pragma mark 确定
- (void)confirm
{
//    NSInteger fieldIndex = [_areapicker selectedRowInComponent: kProvinceComponent];
    NSInteger typeIndex = [_owendteampicker selectedRowInComponent: OwendTeamComponent];
    
//    NSString *provinceStr = [_provinceArr objectAtIndex: fieldIndex];
    TeamModel *tmpmodel = [_owendteamArr objectAtIndex: typeIndex];
    NSString *schoolStr = tmpmodel.name;
    
//    NSString *schoolStr = @"adad";
    NSLog(@"dianjile%@%@",schoolStr,tmpmodel.team_id);
    NSMutableArray *arr=[NSMutableArray arrayWithCapacity:1];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:[NSString stringWithFormat:@"请核对报名要求，将来领奖时要核实身份！确定以团队 %@ 报名?", tmpmodel.name]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              [[NetRequest sharedInstance] httpRequestWithPost:URL_GET_COMPETITION_PARTICIPATE_TEAMS(tmpmodel.team_id) parameters:@{@"team_id": tmpmodel.team_id} withToken:YES success:^(id data, NSString *message) {
                                                                  UIAlertController* alert1 = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                                                                  message:@"报名成功！"
                                                                                                                           preferredStyle:UIAlertControllerStyleAlert];
                                                                  
                                                                  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                                                                                        handler:^(UIAlertAction * action) {
                                                                                                                            //响应事件
                                                                                                                            NSLog(@"action = %@", action);
                                                                                                                        }];
                                                                  
                                                                  [alert1 addAction:defaultAction];
                                                                  //                                                                  [self presentViewController:alert1 animated:YES completion:nil];
                                                              } failed:^(id data, NSString *message) {
                                                                  //                                                                          NSString *ss = [UserManager dealError:[data valueForKey:@"statusCode"] andParam2:message];
                                                                  //                                                                          NSLog(@"datais:%@",data);
                                                                  //                                                                          NSLog(@"messageis:%@",message);
                                                                  [SVProgressHUD showErrorWithStatus:message];
                                                              }];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             NSLog(@"action = %@", action);
                                                         }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    
//    OwendTeamPickerView *testView = [[OwendTeamPickerView alloc] initWithFrame:self.bounds];
    //关键就在这里,把这里的view赋值给一个vc的view,就是一个思路的变通
    UIViewController *vc = [[UIViewController alloc] init];
    //[vc.view addSubview:testView];//有兴趣的同学可以看看这里view赋值替换和增加子视图的区别
    vc.view = self;
    
    // 最终用这个vc显示alertController:presentViewController
    [vc presentViewController:alert animated:YES completion:nil];

//    [self presentViewController:alert animated:YES completion:nil];
    
//    [arr addObject:provinceStr];
    [arr addObject:schoolStr];
    
    if ([self.delegate respondsToSelector:@selector(OwendTeamPickerViewConfirmClickWith:)]) {
        
        [self.delegate OwendTeamPickerViewConfirmClickWith:arr.copy];
    }
    
    [self removeFromSuperview];
    
//    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

#pragma mark 行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
//    NSLog(@"count:%lu",(unsigned long)[_owendteamArr count]);
//    return (unsigned long)[_owendteamArr count];
//    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_OWNED_TEAMS success:^(id data, NSString *message) {
//        _owendteamArr = [TeamModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
//        TeamModel *kkk = [_owendteamArr objectAtIndex:1];
//        NSLog(@"1ssssss%@...%@",kkk,kkk.name);
//        TeamModel *lll = [_owendteamArr objectAtIndex:2];
//        NSLog(@"1bbbbbb%@...%@,%lu",lll,lll.name,_owendteamArr.count);
//    } failed:^(id data, NSString *message) {
//        NSLog(@"eeeeee%@",message);
//        //        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
//
//    }];
//    return (unsigned int)[_owendteamArr count];
    return 6;
//    return _owendteamArr.count;
}

#pragma mark 每一行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
//    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_OWNED_TEAMS success:^(id data, NSString *message) {
//        _owendteamArr = [TeamModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
//        TeamModel *kkk = [_owendteamArr objectAtIndex:1];
//        NSLog(@"2ssssss%@...%@",kkk,kkk.name);
//        TeamModel *lll = [_owendteamArr objectAtIndex:2];
//        NSLog(@"2bbbbbb%@...%@,%lu",lll,lll.name,_owendteamArr.count);
//    } failed:^(id data, NSString *message) {
//        NSLog(@"eeeeee%@",message);
//        //        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
//
//    }];
//    TeamModel *teammodel = [_owendteamArr objectAtIndex:row];
//    NSLog(@"teammodel_name%@",teammodel.name);
//    NSLog(@"teammodel_name11%lu",(unsigned long)_owendteamArr.count);
//    return teammodel.name;
    return @"aaaa";
}

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    if (component == OwendTeamComponent) {
//        [self selectedfieldIndex:row typeIndex:0];
//
//        [_owendteampicker selectRow:0 inComponent:kSchoolComponent animated:YES];
//        [_areapicker reloadComponent:kSchoolComponent];
//
//    }
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    CGFloat myViewW = pickerView.frame.size.width *0.33;
    CGFloat myViewH = 30;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, myViewW, myViewH)];
    myView.font = [UIFont systemFontOfSize:16];
    myView.backgroundColor = [UIColor clearColor];
    myView.textAlignment = NSTextAlignmentCenter;
    
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_OWNED_TEAMS success:^(id data, NSString *message) {
        _owendteamArr = [TeamModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
        TeamModel *kkk = [_owendteamArr objectAtIndex:1];
        NSLog(@"3ssssss%@...%@",kkk,kkk.name);
        TeamModel *lll = [_owendteamArr objectAtIndex:2];
        NSLog(@"3bbbbbb%@...%@,%lu",lll,lll.name,_owendteamArr.count);
        TeamModel *smodel = [_owendteamArr objectAtIndex:row];
        NSLog(@"te%lu",(unsigned long)_owendteamArr.count);
        myView.text = smodel.name;
    } failed:^(id data, NSString *message) {
        NSLog(@"eeeeee%@",message);
        //        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];

    }];
    
//    TeamModel *smodel = [_owendteamArr objectAtIndex:row];
//    NSLog(@"te%lu",(unsigned long)_owendteamArr.count);
//    myView.text = smodel.name;
//    myView.text = @"aaaaa";
    
    return myView;
}


@end


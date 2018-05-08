//
//  PersonalInformationController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/31.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "PersonalInformationController.h"
#import <AVFoundation/AVFoundation.h>
#import "ActionSheetStringPicker.h"
#import "ActionSheetDatePicker.h"
#import "LabelFieldCell.h"
#import "IWAreaPickerView.h"
#import "LabelLabelArrowCell.h"

#define RowHeight 48
#define cellIdentifier @"labelFieldCell"
#define labelCellIdentifier @"labelLabelArrowCell"

@interface PersonalInformationController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, IWAreaPickerViewDelegate>


@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)UIImageView *headImgView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *paramsArr;
@property (nonatomic, strong)UIButton *enterButton;
@property (nonatomic, strong)UIImagePickerController *PickerVC;
@property (nonatomic, strong)NSDictionary *userDic;
@property (nonatomic, strong)NSArray *areaArr;
@property (nonatomic, strong)IWAreaPickerView *areaPickerView;



@end

@implementation PersonalInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor whiteColor];
    _userDic = _userModel.mj_keyValues;
    [self setArr];
    [self addHeaderView];
    [self setupView];
    [self addEnterButton];
    // Do any additional setup after loading the view.
}

- (void)setArr{
    _titleArr = @[@"昵称", @"性别", @"生日", @"所在地区", @"邮箱", @"QQ", @"标签"];
    _paramsArr = @[@"name", @"gender", @"birthday", @"", @"email", @"qq", @"tags"];
    _areaArr = @[];
}

- (void)addHeaderView{
    _headerView = [UIView new];
    [self.view addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(120);
        make.top.mas_equalTo(NAV_HEIGHT);
    }];
    //    _headerView.backgroundColor = [UIColor greenColor];
    
    _headImgView = [UIImageView new];
    [_headerView addSubview:_headImgView];
    [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(80);
        make.centerX.equalTo(_headerView.mas_centerX);
        make.centerY.equalTo(_headerView.mas_centerY);
    }];
    
    _headImgView.layer.cornerRadius = 40;
    _headImgView.layer.masksToBounds = YES;
    
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:URLFrame(_userModel.icon_url)] placeholderImage:[UIImage imageNamed:@"default_user_head"]];
    _headImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(IconViewClick)];
    [_headImgView addGestureRecognizer:headerTap];

}

- (void)setupView{
    UIView *lineView = [UIView new];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.top.equalTo(_headerView.mas_bottom);
    }];
    lineView.backgroundColor = LINE_COLOR;
    
    _tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = RowHeight;
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [tableView registerNib:[UINib nibWithNibName:@"LabelFieldCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
        [tableView registerNib:[UINib nibWithNibName:@"LabelLabelArrowCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:labelCellIdentifier];
        tableView.tableFooterView = [UIView new];
        tableView;
    });
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(lineView.mas_bottom);
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
    [_enterButton setTitle:@"保 存" forState:UIControlStateNormal];
    [_enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

//保存
- (void)enterButtonAction{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < _titleArr.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        if (i == 1 || i == 2 || i == 3) {
            
        }else{
            LabelFieldCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            [params setObject:[cell getOnlyContent] forKey:_paramsArr[i]];
        }
    }
    [params setObject:_userModel.birthday forKey:@"birthday"];
    [params setObject:_userModel.gender forKey:@"gender"];
    [params setObject:_userModel.province forKey:@"province"];
    [params setObject:_userModel.city forKey:@"city"];
    [params setObject:_userModel.county forKey:@"county"];
    
    NSLog(@"profile :%@", params);
    
    
    [[NetRequest sharedInstance] httpRequestWithPost:URL_GET_SELF_PROFILE parameters:params withToken:NO success:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"修改资料成功" andTime:1.0f DoneBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];

    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
    }];
}

- (BOOL)checkInput{
    return YES;
}

//弹出图片选择器
-(void)IconViewClick{
    NSLog(@"click");
    //弹出列表
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取一张",@"拍照", nil];
    
    [actionSheet showInView:self.view];
}

#pragma mark-代理方法

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    NSUInteger sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    
    switch (buttonIndex) {
        case 0:
            
            // 判断是否支持相册
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                self.PickerVC=[[UIImagePickerController alloc]init];
                self.PickerVC.delegate=self;
                self.PickerVC.allowsEditing=YES;
                self.PickerVC.sourceType=sourceType;
                
                [self presentViewController:self.PickerVC animated:YES completion:^{
                    
                }];
                
            }else{
                
                return;
                
            }
            
            break;
        case 1:
            
            // 判断是否支持相机
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
                if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                    
                    NSString *message=[NSString stringWithFormat:@"请前往设置－创易汇打开相机，以便拍照"];
                    
                    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
                    
                    [alertVC addAction:action1];
                    
                    [self presentViewController:alertVC animated:YES completion:nil];
                    
                    
                    return;
                }
                
                sourceType=UIImagePickerControllerSourceTypeCamera;
                
                self.PickerVC=[[UIImagePickerController alloc]init];
                self.PickerVC.delegate=self;
                self.PickerVC.allowsEditing=YES;
                self.PickerVC.sourceType=sourceType;
                
                [self presentViewController:self.PickerVC animated:YES completion:^{
                    
                }];
                
            }else{
                
                
                return;
            }
            
            break;
        case 2:
            
            //取消
            [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
            
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if ([navigationController isKindOfClass:[UIImagePickerController class]] && ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary ) {
        
        [[UINavigationBar appearance] setTintColor:kUIColorFromRGB(0x333333)];
        
    }
    
}


//UIImagePickerController的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    [UIApplication sharedApplication].statusBarHidden=NO;
    
    UIImage *EditedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (EditedImage) {
        [SVProgressHUD showWithStatus:@"上传中"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [[NetRequest sharedInstance] upLoad:URL_CHANGE_USER_ICON parameters:@{} imageKey:@[@"image"] imageArray:@[EditedImage] success:^(id data, NSString *message) {
            [SVProgressHUD dismiss];
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"修改头像成功" andTime:1.0f];
            [_headImgView setImage:EditedImage];
        } failed:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:message andTime:1.0f];
        }];
    }
}



#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
        LabelLabelArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:labelCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitleAndContent:[_titleArr objectAtIndex:indexPath.row] Content:@""];
        if (indexPath.row == 1) {
            //性别
            if ([_userModel.gender integerValue] == 0) {
                [cell setOnlyContent:@"保密"];
            }else if([_userModel.gender integerValue] == 1){
                [cell setOnlyContent:@"男"];
            }else{
                [cell setOnlyContent:@"女"];
            }
        }else if(indexPath.row == 2){
           //生日
            [cell setOnlyContent:_userModel.birthday];
        }else if(indexPath.row == 3){
           //地区
            [cell setOnlyContent:[NSString stringWithFormat:@"%@-%@-%@", _userModel.province, _userModel.city, _userModel.county]];
        }
        return cell;
    }else{
        LabelFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitleAndContent:[_titleArr objectAtIndex:indexPath.row] Content:@""];
        [cell setOnlyContent:_userDic[[_paramsArr objectAtIndex:indexPath.row]]];
        return cell;
    }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        [ActionSheetStringPicker showPickerWithTitle:@"选择性别" rows:@[@[@"保密", @"男", @"女"]] initialSelection:@[_userModel.gender] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
            
            LabelLabelArrowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell setOnlyContent:selectedValue[0]];
            [_userModel setGender:[NSString stringWithFormat:@"%@", selectedIndex[0]]];
        
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:self.view];
    }else if(indexPath.row == 2){
        [ActionSheetDatePicker showPickerWithTitle:@"选择生日" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            LabelLabelArrowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell setOnlyContent:[formatter stringFromDate:selectedDate]];
            
            [_userModel setBirthday:[formatter stringFromDate:selectedDate]];
        } cancelBlock:^(ActionSheetDatePicker *picker) {
            
        } origin:self.view];
    }else if(indexPath.row == 3){
        _areaPickerView = [[IWAreaPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        UIWindow *win=[UIApplication sharedApplication].keyWindow;
        [win addSubview:_areaPickerView];
        _areaPickerView.delegate=self;
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
    
    [_userModel setProvince:arr[0]];
    [_userModel setCity:arr[1]];
    [_userModel setCounty:arr[2]];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:3 inSection:0];
    LabelLabelArrowCell *cell = [_tableView cellForRowAtIndexPath:path];
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

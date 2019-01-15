//
//  CreateZjcgController.m
//  ChuangYiHui
//
//  Created by p1p1us on 2019/1/15.
//  Copyright © 2019年 litingdong. All rights reserved.
//

#import "CreateZjcgController.h"
#import <AVFoundation/AVFoundation.h>
#import "LabelFieldCell.h"

#define RowHeight 48
#define cellIdentifier @"labelFieldCell"
#define labelCellIdentifier @"labelLabelArrowCell"


@interface CreateZjcgController ()

@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)UIImageView *headImgView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *paramsArr;
@property (nonatomic, strong)UIButton *enterButton;
@property (nonatomic, strong)UIImagePickerController *PickerVC;
@property (nonatomic, strong)NSDictionary *userDic;
@property (nonatomic, strong)UIImage *EditedImage;


@end

@implementation CreateZjcgController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布专家成果";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setArr];
    [self addHeaderView];
    [self setupView];
    [self addEnterButton];
    // Do any additional setup after loading the view.
}

- (void)setArr{
    _titleArr = @[@"描述"];
    _paramsArr = @[@"description"];
}

- (void)addHeaderView{
    _headerView = [UIView new];
    [self.view addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(240);
        make.top.mas_equalTo(NAV_HEIGHT);
    }];
    //    _headerView.backgroundColor = [UIColor greenColor];
    
    _headImgView = [UIImageView new];
    [_headerView addSubview:_headImgView];
    [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(200);
        make.centerX.equalTo(_headerView.mas_centerX);
        make.centerY.equalTo(_headerView.mas_centerY);
    }];
    
    _headImgView.layer.cornerRadius = 0;
    _headImgView.layer.masksToBounds = YES;
    
//    [_headImgView sd_setImageWithURL:[NSURL URLWithString:URLFrame(_userModel.icon_url)] placeholderImage:[UIImage imageNamed:@"default_user_head"]];
    [_headImgView setImage:[UIImage imageNamed:@"add_zjcg"]];
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
    [_enterButton setTitle:@"提 交" forState:UIControlStateNormal];
    [_enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

//提交
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
//    [params setObject:@"测试" forKey:@"description"];
    [params setObject:_EditedImage forKey:@"image"];
    
    NSLog(@"profile :%@", params);
    
    if (_EditedImage) {
        [SVProgressHUD showWithStatus:@"提交中"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        
        [[NetRequest sharedInstance] httpRequestWithPost:URL_GET_ZJ_ACHIEVEMENTS([[[UserManager sharedManager] getCurrentUser] user_id]) parameters:params withToken:NO success:^(id data, NSString *message) {
            NSLog(@"profile 提交成功 :%@", [[[UserManager sharedManager] getCurrentUser] user_id]);
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"提交成功" andTime:1.0f DoneBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        } failed:^(id data, NSString *message) {
            NSLog(@"profile 提交失败 :%@", [[[UserManager sharedManager] getCurrentUser] user_id]);
            [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        }];
    }
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
    
    _EditedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [_headImgView setImage:_EditedImage];
    
//    if (_EditedImage) {
//        [SVProgressHUD showWithStatus:@"上传中"];
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
//        [[NetRequest sharedInstance] upLoad:URL_CHANGE_USER_ICON parameters:@{} imageKey:@[@"image"] imageArray:@[_EditedImage] success:^(id data, NSString *message) {
//            [SVProgressHUD dismiss];
//            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"图像上传成功" andTime:1.0f];
//            [_headImgView setImage:_EditedImage];
//        } failed:^(id data, NSString *message) {
//            [[SVHudManager sharedInstance] showSuccessHudWithTitle:message andTime:1.0f];
//        }];
//    }
}



#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LabelFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setTitleAndContent:[_titleArr objectAtIndex:indexPath.row] Content:@""];
    [cell setOnlyContent:_userDic[[_paramsArr objectAtIndex:indexPath.row]]];
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 1) {
//        [ActionSheetStringPicker showPickerWithTitle:@"选择性别" rows:@[@[@"保密", @"男", @"女"]] initialSelection:@[_userModel.gender] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
//
//            LabelLabelArrowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            [cell setOnlyContent:selectedValue[0]];
//            [_userModel setGender:[NSString stringWithFormat:@"%@", selectedIndex[0]]];
//
//        } cancelBlock:^(ActionSheetStringPicker *picker) {
//
//        } origin:self.view];
//    }else if(indexPath.row == 2){
//        [ActionSheetDatePicker showPickerWithTitle:@"选择生日" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"yyyy-MM-dd"];
//            LabelLabelArrowCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            [cell setOnlyContent:[formatter stringFromDate:selectedDate]];
//
//            [_userModel setBirthday:[formatter stringFromDate:selectedDate]];
//        } cancelBlock:^(ActionSheetDatePicker *picker) {
//
//        } origin:self.view];
//    }else if(indexPath.row == 3){
//        _areaPickerView = [[IWAreaPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//
//        UIWindow *win=[UIApplication sharedApplication].keyWindow;
//        [win addSubview:_areaPickerView];
//        _areaPickerView.delegate=self;
//    }
    
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


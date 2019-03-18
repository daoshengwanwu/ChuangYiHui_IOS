//
//  IdentityVerifyController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/29.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "RealNameVerifyController.h"
#import "SchoolPickerView.h"
#import "ActionSheetStringPicker.h"
#import "LabelFieldCell.h"
#import "LabelLabelArrowCell.h"
#import <AVFoundation/AVFoundation.h>
#import "RealNameVerifyStatusController.h"


#define RowHeight 48
#define cellIdentifier @"labelFieldCell"
#define labelCellIdentifier @"labelLabelArrowCell"

@interface RealNameVerifyController ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, SchoolPickerViewDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *paramsArr;
@property (nonatomic, strong)NSArray *rowCountArr;
@property (nonatomic, strong)SchoolPickerView *schoolPickerView;
@property (nonatomic, assign)NSInteger selectIdentity;
@property (nonatomic, strong)UIImageView *identityImageView;
@property (nonatomic, strong)UIButton *enterButton;
@property (nonatomic, strong)UIImagePickerController *PickerVC;
//是否已经上传图片
@property (nonatomic, assign)BOOL isUpload;
@property (nonatomic, strong)NSMutableDictionary *params;


@end

@implementation RealNameVerifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _selectIdentity = 0;
    _isUpload = NO;
    _params = [NSMutableDictionary dictionary];
    [self changeArr];
    [self initView];
    [self addEnterButton];
    [self setLeftButton];
    // Do any additional setup after loading the view.
}

- (void)initView{
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
        make.top.mas_equalTo(NAV_HEIGHT);
        make.height.mas_equalTo(4 * RowHeight + 3 * 14);
    }];
    
    _identityImageView = [UIImageView new];
    [self.view addSubview:_identityImageView];
    [_identityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_tableView.mas_bottom).offset(10);
    }];
//    _identityImageView.backgroundColor = [UIColor redColor];
    [_identityImageView setImage:[UIImage imageNamed:@"add_zjcg"]];
    UITapGestureRecognizer *identityTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(IconViewClick)];
    [_identityImageView addGestureRecognizer:identityTap];
    _identityImageView.userInteractionEnabled = YES;
    
}


- (void)setLeftButton{
    //设置导航栏的左边按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)backTapped{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)addEnterButton{
    _enterButton = [UIButton new];
    [self.view addSubview:_enterButton];
    [_enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(45);
        make.top.equalTo(_identityImageView.mas_bottom).offset(20);
    }];
    _enterButton.backgroundColor = MAIN_COLOR;
    [_enterButton setTitle:@"提交认证" forState:UIControlStateNormal];
    [_enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
}




//保存
- (void)enterButtonAction{
    if ([self checkInput]) {
        [[NetRequest sharedInstance] httpRequestWithPost:URL_REALNAME_VERIFY parameters:_params withToken:NO success:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"提交认证成功" andTime:1.5f DoneBlock:^{
                //跳转到审核页面
                RealNameVerifyStatusController *vc = [RealNameVerifyStatusController new];
                vc.status = 1;
                [self.navigationController pushViewController:vc animated:YES];
                
            }];
        } failed:^(id data, NSString *message) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
        }];
    }
}


//- (void)setArr{
//    _titleArr = @[@[@"身份"], @[@"学校", @"学院", @"专业"], @[@"学生证号", @"学生证扫描件"]];
//    _paramsArr = @[@"name", @"gender", @"birthday", @"", @"email", @"qq", @"tags"];
//    _rowCountArr = @[@"1", @"3", @"2"];
//}

- (void)changeArr{
    if (_selectIdentity == 0) {
        //学生
        _titleArr = @[@[@"认证方式"], @[@"真实姓名", @"身份证号"], @[ @"身份证正面照片"]];
        _rowCountArr = @[@"1", @"2", @"1"];
    }
//    else if(_selectIdentity == 1){
//        //教师
//        _titleArr = @[@[@"身份"], @[@"学校", @"学院"], @[@"教师证号", @"教师证扫描件"]];
//        _rowCountArr = @[@"1", @"2", @"2"];
//    }else{
//        //在职
//        _titleArr = @[@[@"身份"], @[@"单位", @"职业"], @[@"工作证号", @"工作证扫描件"]];
//        _rowCountArr = @[@"1", @"2", @"2"];
//    }
    [_tableView reloadData];
}

- (BOOL)checkInput{
    [_params removeAllObjects];
    if (!_isUpload) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请上传图片" andTime:1.0f];
        return NO;
    }
    
    NSIndexPath *indexPath;
    if (_selectIdentity == 0) {
        [_params setObject:@"身份证认证" forKey:@"role"];
        //学生
//        indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
//        LabelLabelArrowCell *schoolCell = [_tableView cellForRowAtIndexPath:indexPath];
//        if ([schoolCell getOnlyContent].length == 0) {
//            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请选择学校信息" andTime:1.0f];
//            return NO;
//        }
//        [_params setObject:[schoolCell getOnlyContent] forKey:@"unit1"];
        
        indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        LabelFieldCell *academyCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([academyCell getOnlyContent].length == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入真实姓名" andTime:1.0f];
            return NO;
        }
        [_params setObject:[academyCell getOnlyContent] forKey:@"real_name"];
        
        
        indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        LabelFieldCell *majorCell = [_tableView cellForRowAtIndexPath:indexPath];
        if ([majorCell getOnlyContent].length == 0) {
            [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入身份证号" andTime:1.0f];
            return NO;
        }
        
        [_params setObject:[majorCell getOnlyContent] forKey:@"id_number"];
        
        
        
    }
    
    
//    indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
//    LabelFieldCell *numberCell = [_tableView cellForRowAtIndexPath:indexPath];
//    if ([numberCell getOnlyContent].length == 0) {
//        [[SVHudManager sharedInstance] showErrorHudWithTitle:@"请输入证件号码" andTime:1.0f];
//        return NO;
//    }
//    [_params setObject:[numberCell getOnlyContent] forKey:@"other_number"];
    return YES;
    
}



#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_rowCountArr[section] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0||indexPath.section == 2) {
        LabelLabelArrowCell *cell = [tableView dequeueReusableCellWithIdentifier:labelCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitleAndContent:_titleArr[indexPath.section][indexPath.row] Content:@""];
        if (indexPath.section == 0 && _selectIdentity == 0) {
            [cell setOnlyContent:@"身份证认证"];
        }
        return cell;
    }else{
        LabelFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTitleAndContent:_titleArr[indexPath.section][indexPath.row] Content:@""];
        return cell;
    }
}


#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //身份
        [ActionSheetStringPicker showPickerWithTitle:@"请选择认证方式" rows:@[@[@"身份证认证"]] initialSelection:@[@0] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
            _selectIdentity = [[NSString stringWithFormat:@"%@", selectedIndex[0]] integerValue];
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            LabelLabelArrowCell *cell = [_tableView cellForRowAtIndexPath:path];
            [cell setOnlyContent:selectedValue[0]];
            [self changeArr];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:self.view];
        
    }
//    else if(indexPath.section == 1 && _selectIdentity != 2){
//        if (indexPath.row == 0) {
//            //学校
//            _schoolPickerView = [[SchoolPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//            _schoolPickerView.delegate = self;
//            UIWindow *win=[UIApplication sharedApplication].keyWindow;
//            [win addSubview:_schoolPickerView];
//        }else if(indexPath.row == 1){
//            //学院
//        }else{
//            //专业
//        }
//    }
    else{
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark SchoolPickerViewDelegate
-(void)SchoolPickerViewConfirmClickWith:(NSArray *)arr{
    if (arr.count!=2) {
        
        return;
    }
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
    LabelLabelArrowCell *cell = [_tableView cellForRowAtIndexPath:path];
    [cell setOnlyContent:arr[1]];
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
                    
                    NSString *message=[NSString stringWithFormat:@"请前往设置－世纪智库打开相机，以便拍照"];
                    
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
        [[NetRequest sharedInstance] upLoad:URL_UPLOAD_ID_CARD_IMAGE parameters:@{} imageKey:@[@"image"] imageArray:@[EditedImage] success:^(id data, NSString *message) {
            [SVProgressHUD dismiss];
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"上传成功" andTime:1.0f];
            [_identityImageView setImage:EditedImage];
            _isUpload = YES;
        } failed:^(id data, NSString *message) {
            _isUpload = NO;
            [[SVHudManager sharedInstance] showSuccessHudWithTitle:@"上传失败" andTime:1.0f];
        }];
    }
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


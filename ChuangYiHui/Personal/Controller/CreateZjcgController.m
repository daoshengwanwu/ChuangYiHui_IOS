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
@property (nonatomic, strong)UIImageView *headImgView2;
@property (nonatomic, strong)UIImageView *headImgView3;
//@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSArray *paramsArr;
@property (nonatomic, strong)UIButton *enterButton;
@property (nonatomic, strong)UIImagePickerController *PickerVC;
@property (nonatomic, strong)NSDictionary *userDic;
@property (nonatomic, strong)UIImage *EditedImage;
@property (nonatomic, strong)UIImage *EditedImage2;
@property (nonatomic, strong)UIImage *EditedImage3;
@property (nonatomic, strong)UITextView *textView;

@property(nonatomic, assign) NSInteger tag;


@end

@implementation CreateZjcgController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布专家成果";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self setArr];
    [self addHeaderView];
    [self setupView];
    [self addEnterButton];
    // Do any additional setup after loading the view.
}

//- (void)setArr{
//    _titleArr = @[@"描述"];
//    _paramsArr = @[@"description"];
//}

- (void)addHeaderView{
    _headerView = [UIView new];
    [self.view addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(332);
        make.top.mas_equalTo(NAV_HEIGHT);
    }];
    //    _headerView.backgroundColor = [UIColor greenColor];
    
    _headImgView = [UIImageView new];
    [_headerView addSubview:_headImgView];
    [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(100);
//        make.top.mas_equalTo(_headImgView.mas_top);
        make.top.mas_equalTo(_headerView.mas_top).offset(5);
        make.centerX.equalTo(_headerView.mas_centerX);
//        make.centerY.equalTo(_headerView.mas_centerY);
    }];
    
    _headImgView.layer.cornerRadius = 0;
    _headImgView.layer.masksToBounds = YES;
    
//    [_headImgView sd_setImageWithURL:[NSURL URLWithString:URLFrame(_userModel.icon_url)] placeholderImage:[UIImage imageNamed:@"default_user_head"]];
    [_headImgView setImage:[UIImage imageNamed:@"add_zjcg"]];
    _headImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(IconViewClick)];
    [_headImgView addGestureRecognizer:headerTap];
    
    UIView *lineView = [UIView new];
    [_headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.equalTo(_headImgView.mas_bottom).offset(5);
    }];
    lineView.backgroundColor = LINE_COLOR;
    
    
    _headImgView2 = [UIImageView new];
    [_headerView addSubview:_headImgView2];
    [_headImgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(100);
        make.top.mas_equalTo(lineView.mas_bottom).offset(5);
        make.centerX.equalTo(_headerView.mas_centerX);
//        make.centerY.equalTo(_headerView.mas_centerY);
    }];

    _headImgView2.layer.cornerRadius = 0;
    _headImgView2.layer.masksToBounds = YES;

    //    [_headImgView sd_setImageWithURL:[NSURL URLWithString:URLFrame(_userModel.icon_url)] placeholderImage:[UIImage imageNamed:@"default_user_head"]];
    [_headImgView2 setImage:[UIImage imageNamed:@"add_zjcg"]];
    _headImgView2.userInteractionEnabled = YES;

    UITapGestureRecognizer *headerTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(IconViewClick2)];
    [_headImgView2 addGestureRecognizer:headerTap2];

    
    UIView *lineView2 = [UIView new];
    [_headerView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.equalTo(_headImgView2.mas_bottom).offset(5);
    }];
    lineView2.backgroundColor = LINE_COLOR;
    
    
    _headImgView3 = [UIImageView new];
    [_headerView addSubview:_headImgView3];
    [_headImgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(100);
        make.top.mas_equalTo(lineView2.mas_bottom).offset(5);
        make.centerX.equalTo(_headerView.mas_centerX);
//        make.centerY.equalTo(_headerView.mas_centerY);
    }];

    _headImgView3.layer.cornerRadius = 0;
    _headImgView3.layer.masksToBounds = YES;

    //    [_headImgView sd_setImageWithURL:[NSURL URLWithString:URLFrame(_userModel.icon_url)] placeholderImage:[UIImage imageNamed:@"default_user_head"]];
    [_headImgView3 setImage:[UIImage imageNamed:@"add_zjcg"]];
    _headImgView3.userInteractionEnabled = YES;

    UITapGestureRecognizer *headerTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(IconViewClick3)];
    [_headImgView3 addGestureRecognizer:headerTap3];
    
}

- (void)setupView{
    UIView *lineView = [UIView new];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10);
        make.top.equalTo(_headerView.mas_bottom);
    }];
    lineView.backgroundColor = LINE_COLOR;
    
    _textView = [UITextView new];
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(100);
        make.top.equalTo(lineView.mas_bottom).offset(20);
    }];
    
    // 设置它显示的内容
    _textView.text=@"请填写描述...";
    // 设置字体名字和字体大小
    _textView.font = [UIFont fontWithName:@"Arial" size:18.0];
    // 设置textview里面的字体颜色
    _textView.textColor = [UIColor blackColor];
    // textView中的文本排列，默认靠左
//    _textView.textAlignment = NSTextAlignmentCenter;
    // 设置浅灰色的背景色，默认为白色
    _textView.backgroundColor = [UIColor whiteColor];
    // 设置代理
    _textView.delegate=self;
    _textView.clearsOnInsertion = YES;
    _textView.layer.borderColor = [[UIColor colorWithRed:0.0/255.0 green:139.0/255.0 blue:230.0/255.0 alpha:1.0]CGColor];
    _textView.layer.borderWidth = 1.0;
    _textView.layer.cornerRadius = 8.0f;
    [_textView.layer setMasksToBounds:YES];

}


- (void)addEnterButton{
    _enterButton = [UIButton new];
    [self.view addSubview:_enterButton];
    [_enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(45);
        make.top.equalTo(_textView.mas_bottom).offset(20);
    }];
    _enterButton.backgroundColor = MAIN_COLOR;
    [_enterButton setTitle:@"提 交" forState:UIControlStateNormal];
    [_enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)textViewDidChange:(UITextView *)textView
{
   if (textView.text.length > 200)
   {
       textView.text = [textView.text substringToIndex:200];
       NSString *title = NSLocalizedString(@"字数限制", nil);
       NSString *message = NSLocalizedString(@"字数限定长度为500。", nil);
       NSString *OKButtonTitle = NSLocalizedString(@"确定", nil);
       UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
       
       UIAlertAction *OKAction = [UIAlertAction actionWithTitle:OKButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
           
       }];
       [alertVC addAction:OKAction];
       [self presentViewController:alertVC animated:YES completion:nil];
//       [[[UIAlertView alloc] initWithTitle:@"提示" message:@"限定长度为30" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];}
       textView.text = [textView.text substringToIndex:200];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
	}
	return YES;
}

//提交
- (void)enterButtonAction{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    for (NSInteger i = 0; i < _titleArr.count; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//        if (i == 1 || i == 2 || i == 3) {
//            
//        }else{
//            LabelFieldCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
//            [params setObject:[cell getOnlyContent] forKey:_paramsArr[i]];
//        }
//    }

    if ((_EditedImage || _EditedImage2 || _EditedImage3) && !([_textView.text isEqualToString:@""]  || _textView.text == nil)) {
        [params setObject:_textView.text forKey:@"description"];
        if(_EditedImage){
            [params setObject:_EditedImage forKey:@"image"];
        }
        if(_EditedImage2){
            [params setObject:_EditedImage2 forKey:@"image2"];
        }
        if(_EditedImage3){
            [params setObject:_EditedImage3 forKey:@"image3"];
        }
        NSLog(@"profile :%@", params);
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
    else{
        NSString *title = NSLocalizedString(@"请先完善信息", nil);
        NSString *message = NSLocalizedString(@"请您选择图片或填写描述后再点击提交。", nil);
        NSString *OKButtonTitle = NSLocalizedString(@"确定", nil);
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:OKButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        [alertVC addAction:OKAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

- (BOOL)checkInput{
    return YES;
}

//弹出图片选择器
-(void)IconViewClick{
    NSLog(@"click");
    _tag = 1;
    //弹出列表
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取一张",@"拍照", nil];
    [actionSheet showInView:self.view];
}
//弹出图片选择器
-(void)IconViewClick2{
    NSLog(@"click2");
    _tag = 2;
    //弹出列表
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取一张",@"拍照", nil];
    [actionSheet showInView:self.view];
}
//弹出图片选择器
-(void)IconViewClick3{
    NSLog(@"click3");
    _tag = 3;
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
    if(_tag == 1){
        _EditedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        [_headImgView setImage:_EditedImage];
    }
    if(_tag == 2){
        _EditedImage2 = [info objectForKey:UIImagePickerControllerEditedImage];
        [_headImgView2 setImage:_EditedImage2];
    }
    if(_tag == 3){
        _EditedImage3 = [info objectForKey:UIImagePickerControllerEditedImage];
        [_headImgView3 setImage:_EditedImage3];
    }
    
    
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


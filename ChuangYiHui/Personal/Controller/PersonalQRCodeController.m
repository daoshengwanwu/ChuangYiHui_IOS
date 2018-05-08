//
//  PersonalQRCodeController.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/10.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "PersonalQRCodeController.h"
#import "ZXingWrapper.h"


@interface PersonalQRCodeController ()

@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImg;

@end

@implementation PersonalQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *qrcodeStr = [NSString stringWithFormat:@"%@|%@", _type, _object_id];
    _QRCodeImg.image = [ZXingWrapper createCodeWithString:qrcodeStr size:_QRCodeImg.bounds.size CodeFomart:kBarcodeFormatQRCode];
    
    // Do any additional setup after loading the view.
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

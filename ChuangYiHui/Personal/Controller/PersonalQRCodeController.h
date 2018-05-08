//
//  PersonalQRCodeController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/10.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalQRCodeController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;

@property (strong, nonatomic) NSString *object_id;

// @"user" @"team"
@property (nonatomic, strong) NSString *type;

@end

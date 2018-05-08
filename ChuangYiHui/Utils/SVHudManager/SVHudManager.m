//
//  SVHudManager.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/11.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "SVHudManager.h"

static SVHudManager *_instance;
@implementation SVHudManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}


- (void)showSuccessHudWithTitle:(NSString *)title andTime:(CGFloat)time{
    [SVProgressHUD showSuccessWithStatus:title];
    [NSTimer scheduledTimerWithTimeInterval:time target:self
                                   selector:@selector(hudDismiss) userInfo:nil repeats:NO];
}

- (void)showErrorHudWithTitle:(NSString *)title andTime:(CGFloat)time{
    [SVProgressHUD showErrorWithStatus:title];
    [NSTimer scheduledTimerWithTimeInterval:time target:self
                                   selector:@selector(hudDismiss) userInfo:nil repeats:NO];
}

- (void)showSuccessHudWithTitle:(NSString *)title andTime:(CGFloat)time DoneBlock:(void(^)())doneBlock{
    [SVProgressHUD showSuccessWithStatus:title];
    [NSTimer scheduledTimerWithTimeInterval:time repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self hudDismiss];
        if (doneBlock) {
            doneBlock();
        }
    }];
}

- (void)hudDismiss{
    [SVProgressHUD dismiss];
}



@end

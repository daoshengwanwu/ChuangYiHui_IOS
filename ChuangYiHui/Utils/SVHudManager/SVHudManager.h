//
//  SVHudManager.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/11.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVHudManager : NSObject

+ (instancetype)sharedInstance;

- (void)showSuccessHudWithTitle:(NSString *)title andTime:(CGFloat)time;
- (void)showErrorHudWithTitle:(NSString *)title andTime:(CGFloat)time;
- (void)showSuccessHudWithTitle:(NSString *)title andTime:(CGFloat)time DoneBlock:(void(^)())doneBlock;

@end

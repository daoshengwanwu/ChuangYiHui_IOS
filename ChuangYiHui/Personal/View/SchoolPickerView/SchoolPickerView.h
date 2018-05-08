//
//  SchoolPickerView.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/29.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SchoolPickerView;

@protocol SchoolPickerViewDelegate<NSObject>

-(void)SchoolPickerViewConfirmClickWith:(NSArray *)arr;

@end

@interface SchoolPickerView : UIView

@property(nonatomic,weak)id<SchoolPickerViewDelegate>delegate;

@end

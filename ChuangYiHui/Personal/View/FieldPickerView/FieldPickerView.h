//
//  FieldPickerView.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/18.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FieldPickerView;

@protocol FieldPickerViewDelegate <NSObject>

-(void)FieldPickerViewConfirmClickWith:(NSArray *)arr;

@end

@interface FieldPickerView : UIView

@property(nonatomic,weak)id<FieldPickerViewDelegate>delegate;

@end

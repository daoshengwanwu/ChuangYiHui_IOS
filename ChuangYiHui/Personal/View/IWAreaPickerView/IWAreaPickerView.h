//
//  IWAreaPickerView.h
//  IWanna
//
//  Created by Mini on 16/9/12.
//  Copyright © 2016年 huangshaobin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IWAreaPickerView;

@protocol IWAreaPickerViewDelegate <NSObject>

-(void)iWAreaPickerViewConfirmClickWith:(NSArray *)arr;

@end


@interface IWAreaPickerView : UIView

@property(nonatomic,weak)id<IWAreaPickerViewDelegate>delegate;

@end

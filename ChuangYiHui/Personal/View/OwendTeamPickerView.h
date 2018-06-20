//
//  OwendTeamPickerView.h
//  ChuangYiHui
//
//  Created by p1p1us on 2018/6/18.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OwendTeamPPickerView;

@protocol OwendTeamPPickerViewDelegate<NSObject>

-(void)OwendTeamPickerViewConfirmClickWith:(NSArray *)arr;

@end

@interface OwendTeamPickerView : UIView

@property(nonatomic,weak)id<OwendTeamPPickerViewDelegate>delegate;

@end


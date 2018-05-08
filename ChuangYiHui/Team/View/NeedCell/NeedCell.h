//
//  NeedCell.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/7.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NeedCell : UITableViewCell


@property (nonatomic, strong)void (^memberListBlock)();

- (void)setCellByNeedModel: (NeedModel *)model;
- (void)setMemberListBtnHiden: (Boolean) isHidden;

@end

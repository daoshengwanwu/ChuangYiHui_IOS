//
//  PersonActionListCell.h
//  ChuangYiHui
//
//  Created by p1p1us on 2018/5/7.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonActionModel.h"

@interface PersonActionListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *head_icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date_time;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *like_count;


- (void)setCellByPersonActionModel: (PersonActionModel *)model;

@end

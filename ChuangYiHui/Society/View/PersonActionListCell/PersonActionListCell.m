//
//  PersonActionListCell.m
//  ChuangYiHui
//
//  Created by p1p1us on 2018/5/7.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import "PersonActionListCell.h"

@implementation PersonActionListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellByPersonActionModel: (PersonActionModel *)model{
    _title.text = model.name;
    _like_count.text = model.liker_count;
    _date_time.text = model.time_started;
    _number.text = [NSString stringWithFormat:@"%@", model.team_participator_count];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

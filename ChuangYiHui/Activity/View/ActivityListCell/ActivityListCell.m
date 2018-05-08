//
//  ActivityListCell.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/8/13.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "ActivityListCell.h"

@implementation ActivityListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellByActivityModel: (ActivityModel *)model{
    _title.text = model.name;
    _like_count.text = model.liker_count;
    _date_time.text = model.time_started;
    _number.text = [NSString stringWithFormat:@"%@", model.user_participator_count];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

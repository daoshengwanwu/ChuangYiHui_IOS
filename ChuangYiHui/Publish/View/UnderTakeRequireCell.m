//
//  UnderTakeRequireCell.m
//  ChuangYiHui
//
//  Created by BaiHaoran on 2018/5/10.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import "UnderTakeRequireCell.h"

@implementation UnderTakeRequireCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindData:(PublishRequireModel *)data {
    [_title setText:data.title];
    [_status setText:data.status == 0 ? @"停止" : @"进行中"];
    [_status setTextColor:COLOR(116, 200, 237)];
    _date.text = [NSString stringWithFormat:@"%@%@", @"发布于：", data.time_created];
    [_head_pic sd_setImageWithURL:[NSURL URLWithString:URLFrame(data.icon_url)] placeholderImage:[UIImage imageNamed:@"default_team_head"]];
}

@end

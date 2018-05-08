//
//  PublishPeopleRequireCell.m
//  ChuangYiHui
//
//  Created by BaiHaoran on 2018/5/6.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import "PublishPeopleRequireCell.h"

@implementation PublishPeopleRequireCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindData:(PublishRequireModel *)data {
    _titleLabel.text = data.title;
    _statusLebel.text = data.status == 0 ? @"停止" : @"进行中";
    _statusLebel.textColor = COLOR(116, 200, 237);
    _degreeRequireLabel.text = data.degree;
    _number_membersLabel.text = [NSString stringWithFormat:@"%d/%@", 0, data.number];
    _number_membersLabel.textColor = COLOR(116, 200, 237);
    _dateLabel.text = [NSString stringWithFormat:@"%@%@", @"发布于：", data.time_created];
}

@end

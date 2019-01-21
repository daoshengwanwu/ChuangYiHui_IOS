//
//  OutSourceRequireCell.m
//  ChuangYiHui
//
//  Created by BaiHaoran on 2018/5/10.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import "OutSourceRequireCell.h"

@implementation OutSourceRequireCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindData:(PublishRequireModel *)data {
    _title.text = data.title;
    _status.text = data.status == 0 ? @"停止" : @"进行中";
    _status.textColor = COLOR(116, 200, 237);
    _require.text = data.degree;
    _num_mem.text = [NSString stringWithFormat:@"%d/%@", 0, data.number];
    _num_mem.textColor = COLOR(116, 200, 237);
    _date.text = [NSString stringWithFormat:@"%@%@", @"发布于：", data.time_created];
    [_head_pic sd_setImageWithURL:[NSURL URLWithString:URLFrame(data.icon_url)] placeholderImage:[UIImage imageNamed:@"default_team_head"]];
}

@end

//
//  SyscgTableViewCell.m
//  ChuangYiHui
//
//  Created by p1p1us on 2019/1/14.
//  Copyright © 2019年 litingdong. All rights reserved.
//实验室成果

#import "SyscgTableViewCell.h"

@implementation SyscgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)bindData:(PublishRequireModel *)data {
    [_title setText:data.Description];
    [_username setText:data.user_name];
    
    [_zan_num setText:data.yes_count];
    if([data.is_yes isEqualToString:@"true"]){
        [_zan setImage:[UIImage imageNamed:@"zan_on"]];
    }
    [_head_pic sd_setImageWithURL:[NSURL URLWithString:URLFrame(data.picture)] placeholderImage:[UIImage imageNamed:@"default_user_head"]];
    //    [_head_pic setImage:[UIImage imageNamed:@"zan_on"]]
    _date.text = [NSString stringWithFormat:@"%@%@", @"发布于：", data.time_created];
}

@end

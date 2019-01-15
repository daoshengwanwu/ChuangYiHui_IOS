//
//  ZjcgTableViewCell.m
//  ChuangYiHui
//
//  Created by p1p1us on 2019/1/14.
//  Copyright © 2019年 litingdong. All rights reserved.
//专家成果

#import "ZjcgTableViewCell.h"

@implementation ZjcgTableViewCell

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
    NSString *tmp = data.picture;
    if([data.picture containsString:@"["]){
        NSLog(@"包含【");
        NSRange startRange = [data.picture rangeOfString:@"['"];
        NSRange endRange = [data.picture rangeOfString:@"', "];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        tmp = [data.picture substringWithRange:range];
//        tmp = [data.picture stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\'\'"]];
        NSLog(@"tmp=%@",tmp);
    }
    NSLog(@"tmp1=%@",tmp);
    [_head_pic sd_setImageWithURL:[NSURL URLWithString:URLFrame(tmp)] placeholderImage:[UIImage imageNamed:@"default_user_head"]];
//    [_head_pic setImage:[UIImage imageNamed:@"zan_on"]]
    _date.text = [NSString stringWithFormat:@"%@%@", @"发布于：", data.time_created];
}

@end

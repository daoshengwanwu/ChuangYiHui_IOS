//
//  TeamActionListCell.m
//  ChuangYiHui
//
//  Created by p1p1us on 2018/5/7.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import "TeamActionListCell.h"

@implementation TeamActionListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellByTeamActionModel: (TeamActionModel *)model{
    _title.text = model.name;
    [_head_icon sd_setImageWithURL:[NSURL URLWithString:URLFrame(model.icon)] placeholderImage:[UIImage imageNamed:@"default_team_head"]];
    _like_count.text = model.liker_count;
    //    _date_time.text = model.time_created;
    _date_time.text = [model.time_created stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    _number.text = model.comment_count;
    
    if([model.action isEqual:@"join"]){
        _content.text = [[NSString alloc] initWithFormat:@"%@ 同意了 %@ 的加入申请", model.name,model.object_name];
    }else if ([model.action isEqual:@"create_team"]){
        _content.text = [[NSString alloc] initWithFormat:@"%@ 创建了 %@ 团队", model.object_name,model.name];
    }else if ([model.action isEqual:@"leave"]){
        _content.text = [[NSString alloc] initWithFormat:@"%@ 踢出了成员 %@", model.name,model.object_name];
    }else if([model.action isEqual:@"send"]){
        _content.text = [[NSString alloc] initWithFormat:@"%@ 发布了 %@", model.name,model.object_name];
    }else{
        _content.text = [[NSString alloc] initWithFormat:@"%@ *** %@", model.name,model.object_name];
    }
//    _content.text = [[NSString alloc] initWithFormat:@"%@ %@ %@", model.name, tmp,model.object_name]; 
    //    NSString * str1 = [[NSString alloc] initWithFormat:@"%@ <font color='#FF0000'><small>%@</small></font> %@", model.name, tmp ,model.object_name ];
    //    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[str1 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    //    _content.attributedText = attributedString;
    //    _content.font = [UIFont fontWithName:@"Arial" size:18];
    [[NetRequest sharedInstance] httpRequestWithGET:URL_CHECK_IF_LIKE_ACTION(@"team", model.action_id) success:^(id data, NSString *message) {
        //        NSLog(@"已点赞");
        //        _isLiked = YES;
        [_like_button setImage:[UIImage imageNamed:@"zan_on"]];
    } failed:^(id data, NSString *message) {
        //        NSLog(@"未点赞");
        //        _isLiked = NO;
        [_like_button setImage:[UIImage imageNamed:@"zan_off"]];
    }];
    [[NetRequest sharedInstance] httpRequestWithGET:URL_CHECK_IF_FAVOR_ACTION(@"team", model.action_id) success:^(id data, NSString *message) {
        //        NSLog(@"已收藏");
        //        _isLiked = YES;
        [_StarButton setImage:[UIImage imageNamed:@"star_icon_hover"]];
    } failed:^(id data, NSString *message) {
        //        NSLog(@"未收藏");
        //        _isLiked = NO;
        [_StarButton setImage:[UIImage imageNamed:@"star_icon"]];
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

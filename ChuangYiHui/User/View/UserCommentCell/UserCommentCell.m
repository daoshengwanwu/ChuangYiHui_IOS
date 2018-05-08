//
//  UserCommentCell.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/25.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "UserCommentCell.h"

@interface UserCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation UserCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellByCommentModel: (CommentModel *)commentModel{
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:URLFrame(commentModel.icon_url)] placeholderImage:[UIImage imageNamed:@"default_user_head"]];
    [_name setText:commentModel.author_name];
    [_date setText:commentModel.time_created];
    [_content setText:commentModel.content];
}

@end

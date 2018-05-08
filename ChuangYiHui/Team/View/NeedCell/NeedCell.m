//
//  NeedCell.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/7.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "NeedCell.h"

@interface NeedCell()

@property (weak, nonatomic) IBOutlet UIImageView *head_icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *degree;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UIButton *memberListBtn;


@end

@implementation NeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellByNeedModel: (NeedModel *)model{
    [_head_icon sd_setImageWithURL:[NSURL URLWithString:URLFrame(model.icon_url)] placeholderImage:[UIImage imageNamed:@"default_team_head"]];
    _title.text = model.title;
    _degree.text = model.degree;
    _number.text = [NSString stringWithFormat:@"(需要%@人)", model.number];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMemberListBtnHiden: (Boolean) isHidden{
    [_memberListBtn setHidden:isHidden];
}

- (IBAction)memberListButtonAction:(id)sender {
    if (_memberListBlock) {
        _memberListBlock();
    }
}


@end

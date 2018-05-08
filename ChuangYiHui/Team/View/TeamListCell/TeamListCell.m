//
//  TeamListCell.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/9.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "TeamListCell.h"

@interface TeamListCell()

@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *likerCount;
@property (weak, nonatomic) IBOutlet UILabel *visitorCount;

@end

@implementation TeamListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTeamCellByTeamModel: (TeamModel *)teamModel{
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:URLFrame(teamModel.icon_url)] placeholderImage:[UIImage imageNamed:@"default_team_head"]];
    [_name setText:teamModel.name];
    [_likerCount setText:teamModel.liker_count];
    [_visitorCount setText:teamModel.visitor_count];
}

@end

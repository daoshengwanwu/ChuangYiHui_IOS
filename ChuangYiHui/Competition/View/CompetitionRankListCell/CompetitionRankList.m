//
//  CompetitionRankList.m
//  ChuangYiHui
//
//  Created by p1p1us on 2018/7/1.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import "CompetitionRankList.h"

@implementation CompetitionRankList

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCellByCompetititonRankModel: (CompetitionRankModel *)model{
    _title.text = model.team_name;
    _number.text = [NSString stringWithFormat:@"第%@名", model.award];
    [_head_icon sd_setImageWithURL:[NSURL URLWithString:URLFrame(model.icon)] placeholderImage:[UIImage imageNamed:@"default_team_head"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

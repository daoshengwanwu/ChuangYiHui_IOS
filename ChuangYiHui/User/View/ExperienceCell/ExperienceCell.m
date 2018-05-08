//
//  ExperienceCell.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/15.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "ExperienceCell.h"

@interface ExperienceCell()

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *detail;

@end

@implementation ExperienceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellByExperienceCell: (ExperienceModel *)model{
    _name.text = model.unit;
    _detail.text = [NSString stringWithFormat:@"%@~%@,%@,%@",model.time_in, model.time_out, model.profession, model.degree];
    _detail.textColor = LIGHT_FONT_COLOR;
}

@end

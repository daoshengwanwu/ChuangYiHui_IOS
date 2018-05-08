//
//  ScoreCell.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/10.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "ScoreCell.h"

@interface ScoreCell()
@property (weak, nonatomic) IBOutlet UILabel *descriptionText;
@property (weak, nonatomic) IBOutlet UILabel *scoreText;
@property (weak, nonatomic) IBOutlet UILabel *typeText;
@end

@implementation ScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setScoreCellByScoreModel:(ScoreModel *)scoreModel{
    _descriptionText.text = scoreModel.score_description;
    _scoreText.text = scoreModel.score;
    _typeText.text = scoreModel.type;
}

@end

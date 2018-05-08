//
//  LabelLabelCell.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/26.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "LabelLabelCell.h"

@interface LabelLabelCell()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation LabelLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleText: (NSString *)text{
    _title.text = text;
}

- (void)setContentText: (NSString *)text{
    if (text.length == 0) {
        _content.text = @"暂无";
    }else{
        _content.text = text;
    }
}

@end

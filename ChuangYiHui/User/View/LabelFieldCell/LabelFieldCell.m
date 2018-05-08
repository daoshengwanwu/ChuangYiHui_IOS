//
//  LabelFieldCell.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/15.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "LabelFieldCell.h"

@interface LabelFieldCell()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *content;

@end

@implementation LabelFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleAndContent: (NSString *)title Content:(NSString *)content{
    _title.text = title;
//    _content.text = content;
}

- (void)setOnlyContent:(NSString *)content{
    _content.text = content;
}


- (NSString *)getOnlyContent{
    return _content.text;
}

@end

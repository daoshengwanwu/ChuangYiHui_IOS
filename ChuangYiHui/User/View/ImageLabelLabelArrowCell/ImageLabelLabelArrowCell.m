//
//  ImageLabelLabelArrowCell.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/17.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "ImageLabelLabelArrowCell.h"

@interface ImageLabelLabelArrowCell()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation ImageLabelLabelArrowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOnlyTitle: (NSString *)title{
    _title.text = title;
}


- (void)setOnlyContent: (NSString *)content{
    _content.text = content;
}


- (NSString *)getOnlyContent{
    return _content.text;
}


- (void)setOnlyImage: (NSString *)imageName{
    _image.image = [UIImage imageNamed:imageName];
}





@end

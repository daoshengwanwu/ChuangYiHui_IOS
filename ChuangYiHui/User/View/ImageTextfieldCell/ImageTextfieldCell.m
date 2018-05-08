//
//  ImageTextfieldCell.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/17.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "ImageTextfieldCell.h"

@interface ImageTextfieldCell()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ImageTextfieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOnlyImage:(NSString *)imageName{
    [_image setImage:[UIImage imageNamed:imageName]];
}

- (void)setPlaceHolder: (NSString *)placeHolder{
    _textField.placeholder = placeHolder;
}

- (NSString *)getOnlyContent{
    return _textField.text;
}

- (void)setOnlyContent: (NSString *)content{
    _textField.text = content;
}

- (void)setIfEditable: (BOOL)editable{
    _textField.enabled = editable;
}

@end

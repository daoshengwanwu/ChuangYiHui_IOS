//
//  ImageTextfieldCell.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/17.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTextfieldCell : UITableViewCell

- (void)setOnlyImage:(NSString *)imageName;

- (void)setPlaceHolder: (NSString *)placeHolder;

- (NSString *)getOnlyContent;

- (void)setOnlyContent: (NSString *)content;

- (void)setIfEditable: (BOOL)editable;

@end

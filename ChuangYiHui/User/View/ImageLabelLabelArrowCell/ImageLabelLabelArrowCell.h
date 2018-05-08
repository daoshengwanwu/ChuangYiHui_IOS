//
//  ImageLabelLabelArrowCell.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/17.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageLabelLabelArrowCell : UITableViewCell

- (void)setOnlyTitle: (NSString *)title;
- (void)setOnlyContent: (NSString *)content;
- (void)setOnlyImage: (NSString *)imageName;

- (NSString *)getOnlyContent;

@end

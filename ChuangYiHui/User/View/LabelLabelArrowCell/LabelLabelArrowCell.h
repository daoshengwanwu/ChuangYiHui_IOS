//
//  LabelLabelArrowCell.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/15.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelLabelArrowCell : UITableViewCell

- (void)setTitleAndContent: (NSString *)title Content:(NSString *)content;

- (void)setOnlyContent:(NSString *)content;

- (NSString *)getOnlyContent;


@end

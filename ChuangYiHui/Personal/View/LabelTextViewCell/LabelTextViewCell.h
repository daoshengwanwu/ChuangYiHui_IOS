//
//  LabelTextViewCell.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/10.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelTextViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextView *content;

@end

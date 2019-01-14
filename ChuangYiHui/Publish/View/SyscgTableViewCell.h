//
//  SyscgTableViewCell.h
//  ChuangYiHui
//
//  Created by p1p1us on 2019/1/14.
//  Copyright © 2019年 litingdong. All rights reserved.
//实验室成果

#import <UIKit/UIKit.h>
#import "PublishRequireModel.h"

@interface SyscgTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *head_pic;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *zan_num;
@property (strong, nonatomic) IBOutlet UIImageView *zan;

- (void)bindData:(PublishRequireModel*)data;

@end


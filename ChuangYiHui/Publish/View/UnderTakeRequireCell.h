//
//  UnderTakeRequireCell.h
//  ChuangYiHui
//
//  Created by BaiHaoran on 2018/5/10.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishRequireModel.h"

@interface UnderTakeRequireCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *head_pic;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UILabel *date;

- (void)bindData:(PublishRequireModel*)data;

@end
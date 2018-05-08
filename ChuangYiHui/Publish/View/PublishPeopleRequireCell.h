//
//  PublishPeopleRequireCell.h
//  ChuangYiHui
//
//  Created by BaiHaoran on 2018/5/6.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishRequireModel.h"

@interface PublishPeopleRequireCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLebel;
@property (strong, nonatomic) IBOutlet UILabel *degreeRequireLabel;
@property (strong, nonatomic) IBOutlet UILabel *number_membersLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;


- (void)bindData: (PublishRequireModel*)data;

@end

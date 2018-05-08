//
//  CompetitionListCell.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/8/14.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompetitionModel.h"

@interface CompetitionListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *head_icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date_time;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *like_count;


- (void)setCellByCompetititonModel: (CompetitionModel *)model;

@end

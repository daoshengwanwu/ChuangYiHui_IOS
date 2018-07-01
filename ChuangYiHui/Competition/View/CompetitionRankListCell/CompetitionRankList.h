//
//  CompetitionRankList.h
//  ChuangYiHui
//
//  Created by p1p1us on 2018/7/1.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompetitionRankModel.h"

@interface CompetitionRankList : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *head_icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *number;


- (void)setCellByCompetititonRankModel: (CompetitionRankModel *)model;

@end

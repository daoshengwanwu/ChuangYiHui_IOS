//
//  CompetitionModel.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/8/13.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompetitionModel : NSObject

@property (nonatomic, strong)NSString *competition_id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *time_started;
@property (nonatomic, strong)NSString *time_ended;
@property (nonatomic, strong)NSString *deadline;
@property (nonatomic, strong)NSString *time_created;
@property (nonatomic, strong)NSString *liker_count;

//已报名团队
@property (nonatomic, strong)NSString *team_participator_count;
//已报名人数
@property (nonatomic, strong)NSString *user_participator_count;
//可报名的总人数
@property (nonatomic, strong)NSString *allow_user;
//可报名的总团队数
@property (nonatomic, strong)NSString *allow_team;
//活动当前的状态
@property (nonatomic, strong)NSString *status;

@end

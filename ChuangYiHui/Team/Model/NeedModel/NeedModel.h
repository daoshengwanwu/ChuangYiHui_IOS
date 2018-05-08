//
//  NeedModel.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/7.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeedModel : NSObject

@property (nonatomic, copy)NSString *need_id;
@property (nonatomic, copy)NSString *team_name;
@property (nonatomic, copy)NSString *icon_url;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *number;
@property (nonatomic, copy)NSString *degree;
//发布时间
@property (nonatomic, copy)NSString *time_created;
@property (nonatomic, copy)NSString *deadline;
@property (nonatomic, copy)NSString *need_description;
@property (nonatomic, copy)NSString *age_min;
@property (nonatomic, copy)NSString *age_max;
@property (nonatomic, copy)NSString *gender;
@property (nonatomic, copy)NSString *field;
@property (nonatomic, copy)NSString *skill;
@property (nonatomic, copy)NSString *province;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *county;
@property (nonatomic, copy)NSString *major;
//毕业时间
@property (nonatomic, copy)NSString *time_graduated;


@property (nonatomic, copy)NSString *cost;
@property (nonatomic, copy)NSString *cost_unit;
@property (nonatomic, copy)NSString *time_started;
@property (nonatomic, copy)NSString *time_ended;



@end

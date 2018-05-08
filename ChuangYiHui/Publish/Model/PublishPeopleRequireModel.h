//
//  PublishPeopleRequireModel.h
//  ChuangYiHui
//
//  Created by BaiHaoran on 2018/5/5.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishPeopleRequireModel : NSObject

@property (nonatomic, strong)NSString * id;
@property (nonatomic, strong)NSString * team_id;
@property (nonatomic, strong)NSString * team_name;
@property (nonatomic, strong)NSString * status;
@property (nonatomic, strong)NSString * members; //JSONString
@property (nonatomic, strong)NSString * title;
@property (nonatomic, strong)NSString * deadline;
@property (nonatomic, strong)NSString * description;
@property (nonatomic, strong)NSString * number;
@property (nonatomic, strong)NSString * age_min;
@property (nonatomic, strong)NSString * age_max;
@property (nonatomic, strong)NSString * gender;
@property (nonatomic, strong)NSString * province;
@property (nonatomic, strong)NSString * field;
@property (nonatomic, strong)NSString * skill;
@property (nonatomic, strong)NSString * degree;
@property (nonatomic, strong)NSString * type;
@property (nonatomic, strong)NSString * major;
@property (nonatomic, strong)NSString * time_graduated;
@property (nonatomic, strong)NSString * icon_url;
@property (nonatomic, strong)NSString * time_created;

//外包需求
@property (nonatomic, strong)NSString * cost;
@property (nonatomic, strong)NSString * cost_unit;
@property (nonatomic, strong)NSString * time_started;
@property (nonatomic, strong)NSString * time_ended;

@end

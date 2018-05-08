//
//  TeamModel.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/9.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamModel : NSObject

@property (nonatomic, copy) NSString *team_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *liker_count;
@property (nonatomic, copy) NSString *fan_count;
@property (nonatomic, copy) NSString *visitor_count;
@property (nonatomic, copy) NSString *is_verified;
@property (nonatomic, copy) NSString *is_role_verified;
@property (nonatomic, copy) NSString *followed_count;
@property (nonatomic, copy) NSString *owner_id;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *county;
@property (nonatomic, copy) NSArray *fields;
@property (nonatomic, copy) NSString *team_description;
@property (nonatomic, copy) NSString *time_created;

//团队链接
@property (nonatomic, copy) NSString *url;


@end

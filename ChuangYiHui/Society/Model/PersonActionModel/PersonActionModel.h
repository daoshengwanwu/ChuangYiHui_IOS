//
//  PersonActionModel.h
//  ChuangYiHui
//
//  Created by p1p1us on 2018/5/8.
//  Copyright © 2018年 litingdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonActionModel : NSObject

@property (nonatomic, strong)NSString *time_created;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *action;
@property (nonatomic, strong)NSString *related_object_id;
@property (nonatomic, strong)NSString *liker_count;
//@property (nonatomic, strong)NSString *id;
@property (nonatomic, strong)NSString *object_id;
@property (nonatomic, strong)NSString *comment_count;
@property (nonatomic, strong)NSString *object_name;
@property (nonatomic, strong)NSString *related_object_type;
@property (nonatomic, strong)NSString *action_id;
@property (nonatomic, strong)NSString *icon;
@property (nonatomic, strong)NSString *object_type;
@property (nonatomic, strong)NSString *related_object_name;
@property (nonatomic, strong)NSString *icon_url;

@end

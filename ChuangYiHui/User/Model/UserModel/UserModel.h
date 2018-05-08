//
//  UserModel.h
//  GoldUnion
//
//  Created by GYY on 18/04/2016.
//  Copyright © 2016 LEE . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *tags;
//0 保密 1 男 2 女
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *liker_count;
@property (nonatomic, copy) NSString *follower_count;
@property (nonatomic, copy) NSString *followed_count;
@property (nonatomic, copy) NSString *friend_count;
@property (nonatomic, copy) NSString *visitor_count;
//是否通过实名认证
//0 未实名 1 待审核 2 已实名 3 实名失败 4 eID实名通过
@property (nonatomic, copy) NSString *is_verified;
//是否通过身份认证
@property (nonatomic, copy) NSString *is_role_verified;
//积分
@property (nonatomic, copy) NSString *score;
//邀请码
@property (nonatomic, copy) NSString *invitation_code;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *unit1;
@property (nonatomic, copy) NSString *unit2;
//申请发送的时间
@property (nonatomic, copy) NSString *time_created;
//验证信息
@property (nonatomic, copy) NSString *user_description;
//好友请求的id
@property (nonatomic, copy) NSString *request_id;
//团队邀请的id
@property (nonatomic, copy) NSString *invitation_id;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *profession;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *county;
@property (nonatomic, copy) NSString *birthday;







@end

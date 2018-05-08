//
//  PersonalHeaderView.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/9.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalHeaderView : UIView

+ (instancetype)personalHeaderView;

@property (nonatomic, copy)void(^QRCodeClickBlock)();
@property (nonatomic, copy)void(^FriendClickBlock)();
@property (nonatomic, copy)void(^FollowerClickBlock)();
@property (nonatomic, copy)void(^ScoreClickBlock)();
@property (nonatomic, copy)void(^FollowedClickBlock)();
@property (nonatomic, copy)void(^LikeClickBlock)();
@property (nonatomic, copy)void(^headIconClickBlock)();



- (void)setHeaderByUserModel: (UserModel *)userModel;

- (void)setLikeImg: (BOOL)likeOrNot;

- (void)setCount:(NSString *)count;

@end

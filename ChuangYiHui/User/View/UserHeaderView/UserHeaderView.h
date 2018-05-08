//
//  UserHeaderView.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/18.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHeaderView : UIView

+ (instancetype)userHeaderView;

@property (nonatomic, copy)void(^QRCodeClickBlock)();
@property (nonatomic, copy)void(^FriendClickBlock)();
@property (nonatomic, copy)void(^FollowerClickBlock)();
@property (nonatomic, copy)void(^ScoreClickBlock)();
@property (nonatomic, copy)void(^FollowedClickBlock)();
@property (nonatomic, copy)void(^LikeClickBlock)();
@property (nonatomic, copy)void(^FocusButtonClickBlock)();



- (void)setHeaderByUserModel: (UserModel *)userModel;

//设置点赞按钮的背景图
- (void)setLikeImg: (BOOL)likeOrNot;
//设置点赞的个数
- (void)setCount:(NSString *)count;
//设置关注按钮的背景图
- (void)setFocusButtonImage: (BOOL)isFocused;
//设置粉丝个数
- (void)setFollowersCount:(NSString *)count;
@end

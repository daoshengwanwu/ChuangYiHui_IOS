//
//  TeamHeaderView.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/16.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamHeaderView : UIView

+ (instancetype)teamHeaderView;

@property (nonatomic, copy)void(^QRCodeClickBlock)();
@property (nonatomic, copy)void(^FriendClickBlock)();
@property (nonatomic, copy)void(^FollowerClickBlock)();
@property (nonatomic, copy)void(^ScoreClickBlock)();
@property (nonatomic, copy)void(^FollowedClickBlock)();
@property (nonatomic, copy)void(^LikeClickBlock)();
@property (nonatomic, copy)void(^FocusButtonClickBlock)();


- (void)setHeaderByTeamModel: (TeamModel *)teamModel;

- (void)setLikeImg: (BOOL)likeOrNot;

- (void)setCount:(NSString *)count;

//设置关注按钮的背景图
- (void)setFocusButtonImage: (BOOL)isFocused;
//设置粉丝个数
- (void)setFollowersCount:(NSString *)count;

@end

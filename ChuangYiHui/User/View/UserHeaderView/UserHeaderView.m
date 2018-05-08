//
//  UserHeaderView.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/18.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "UserHeaderView.h"

@interface UserHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *likerCount;
@property (weak, nonatomic) IBOutlet UILabel *visitorCount;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UIButton *QRCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *friend_count;
@property (weak, nonatomic) IBOutlet UILabel *followed_count;
@property (weak, nonatomic) IBOutlet UILabel *follower_count;
@property (weak, nonatomic) IBOutlet UIView *friend_view;

@property (weak, nonatomic) IBOutlet UIView *follower_view;

@property (weak, nonatomic) IBOutlet UIView *followed_view;

@property (weak, nonatomic) IBOutlet UIButton *score_view;

@property (weak, nonatomic) IBOutlet UIButton *like_img;

@property (weak, nonatomic) IBOutlet UIButton *focusButton;

@end

@implementation UserHeaderView

+ (instancetype)userHeaderView
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *objs = [bundle loadNibNamed:@"UserHeaderView" owner:nil options:nil];
    return [objs lastObject];
}

- (void)setHeaderByUserModel: (UserModel *)userModel{
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:URLFrame(userModel.icon_url)] placeholderImage:[UIImage imageNamed:@"default_user_head"]];
    [_name setText:userModel.name];
    [_likerCount setText:userModel.liker_count];
    [_visitorCount setText:userModel.visitor_count];
    [_score setText:userModel.score];
    //0 保密 1 男 2 女
    if ([userModel.gender integerValue] == 0) {
        _sexImg.image = [UIImage imageNamed:@"secret_icon"];
    }else if([userModel.gender integerValue] == 1){
        _sexImg.image = [UIImage imageNamed:@"boy_icon"];
    }else{
        _sexImg.image = [UIImage imageNamed:@"girl_icon"];
    }
    [_friend_count setText:[NSString stringWithFormat:@"%@  好友", userModel.friend_count]];
    
    [_followed_count setText:[NSString stringWithFormat:@"%@  关注", userModel.followed_count]];
    
    [_follower_count setText:[NSString stringWithFormat:@"%@  粉丝", userModel.follower_count]];
    
    [_QRCodeBtn addTarget:self action:@selector(QRCodeAction) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *friendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(friendViewTap)];
    [_friend_view addGestureRecognizer:friendTap];
    
    UITapGestureRecognizer *followerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followerViewTap)];
    [_follower_view addGestureRecognizer:followerTap];
    
    UITapGestureRecognizer *followedTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followedViewTap)];
    [_followed_view addGestureRecognizer:followedTap];
    
    UITapGestureRecognizer *scoreTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scoreViewTap)];
    [_score_view addGestureRecognizer:scoreTap];
    
    [_like_img addTarget:self action:@selector(likeImgTap) forControlEvents:UIControlEventTouchUpInside];
}


- (void)QRCodeAction{
    if (_QRCodeClickBlock) {
        _QRCodeClickBlock();
    }
}

- (void)friendViewTap{
    if (_FriendClickBlock) {
        _FriendClickBlock();
    }
}

- (void)followerViewTap{
    if (_FollowerClickBlock) {
        _FollowerClickBlock();
    }
}

- (void)scoreViewTap{
    if (_ScoreClickBlock) {
        _ScoreClickBlock();
    }
}

- (void)followedViewTap{
    if (_FollowedClickBlock) {
        _FollowedClickBlock();
    }
}

- (void)likeImgTap{
    if (_LikeClickBlock) {
        _LikeClickBlock();
    }
}

- (void)setLikeImg: (BOOL)likeOrNot{
    if (likeOrNot) {
        [_like_img setBackgroundImage:[UIImage imageNamed:@"zan_on"] forState:UIControlStateNormal];
    }else{
        [_like_img setBackgroundImage:[UIImage imageNamed:@"zan_off"] forState:UIControlStateNormal];
    }
}


- (void)setCount:(NSString *)count{
    [_likerCount setText:count];
}


- (IBAction)focusButtonAction:(id)sender {
    if (_FocusButtonClickBlock) {
        _FocusButtonClickBlock();
    }
}

- (void)setFocusButtonImage: (BOOL)isFocused{
    if (isFocused) {
        [_focusButton setBackgroundImage:[UIImage imageNamed:@"focus_icon"] forState:UIControlStateNormal];
    }else{
       [_focusButton setBackgroundImage:[UIImage imageNamed:@"unfocus_icon"] forState:UIControlStateNormal];
    }
}


- (void)setFollowersCount:(NSString *)count{
    [_follower_count setText:[NSString stringWithFormat:@"%@  粉丝", count]];
}

@end

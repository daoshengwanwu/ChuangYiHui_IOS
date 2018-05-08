//
//  TeamHeaderView.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/16.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "TeamHeaderView.h"

@interface TeamHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *likerCount;
@property (weak, nonatomic) IBOutlet UILabel *visitorCount;
@property (weak, nonatomic) IBOutlet UIButton *QRCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *friend_count;
@property (weak, nonatomic) IBOutlet UILabel *followed_count;
@property (weak, nonatomic) IBOutlet UILabel *follower_count;
@property (weak, nonatomic) IBOutlet UIView *friend_view;
@property (weak, nonatomic) IBOutlet UIView *follower_view;
@property (weak, nonatomic) IBOutlet UIView *followed_view;
@property (weak, nonatomic) IBOutlet UIButton *like_img;

@property (weak, nonatomic) IBOutlet UIButton *focusButton;

@end


@implementation TeamHeaderView

+ (instancetype)teamHeaderView
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *objs = [bundle loadNibNamed:@"TeamHeaderView" owner:nil options:nil];
    return [objs lastObject];
}

- (void)setHeaderByTeamModel: (TeamModel *)teamModel{
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:URLFrame(teamModel.icon_url)] placeholderImage:[UIImage imageNamed:@"default_team_head"]];
    [_name setText:teamModel.name];
    [_likerCount setText:teamModel.liker_count];
    [_visitorCount setText:teamModel.visitor_count];
    [_follower_count setText:[NSString stringWithFormat:@"%@  粉丝", teamModel.fan_count]];
    
    [_QRCodeBtn addTarget:self action:@selector(QRCodeAction) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *friendTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(friendViewTap)];
    [_friend_view addGestureRecognizer:friendTap];
    
    UITapGestureRecognizer *followerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followerViewTap)];
    [_follower_view addGestureRecognizer:followerTap];
    
    UITapGestureRecognizer *followedTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followedViewTap)];
    [_followed_view addGestureRecognizer:followedTap];
    
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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

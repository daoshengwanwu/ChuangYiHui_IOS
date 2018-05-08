//
//  UserListCell.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/9.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "UserListCell.h"

@interface UserListCell()
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UIImageView *authImg;
@property (weak, nonatomic) IBOutlet UILabel *authText;
@property (weak, nonatomic) IBOutlet UILabel *likerCount;
@property (weak, nonatomic) IBOutlet UILabel *visitorCount;
@property (weak, nonatomic) IBOutlet UILabel *score;
@end

@implementation UserListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setUserCellByUserModel: (UserModel *)userModel{
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
    
    //0 未实名 1 待审核 2 已实名 3 实名失败 4 eID实名通过
    if ([userModel.is_verified integerValue] == 0) {
        _authImg.image = [UIImage imageNamed:@"unauth_icon"];
        _authText.text = @"未实名";
    }else if([userModel.is_verified integerValue] == 1){
        _authImg.image = [UIImage imageNamed:@"unauth_icon"];
        _authText.text = @"待审核";
    }else if([userModel.is_verified integerValue] == 2){
        _authImg.image = [UIImage imageNamed:@"auth_icon"];
        _authText.text = @"已实名";
    }else if([userModel.is_verified integerValue] == 3){
        _authImg.image = [UIImage imageNamed:@"unauth_icon"];
        _authText.text = @"实名失败";
    }else if([userModel.is_verified integerValue] == 4){
        _authImg.image = [UIImage imageNamed:@"auth_icon"];
        _authText.text = @"eID实名";
    }
}

@end

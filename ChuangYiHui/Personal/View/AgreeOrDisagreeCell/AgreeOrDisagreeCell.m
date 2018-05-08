//
//  AgreeOrDisagreeCell.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/10.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "AgreeOrDisagreeCell.h"

@interface AgreeOrDisagreeCell()

@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *verifyInformation;
@end

@implementation AgreeOrDisagreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)agreeAction:(UIButton *)sender {
    if (_AgreeBlock) {
        _AgreeBlock();
    }
}

- (IBAction)DisagreeAction:(UIButton *)sender {
    if (_DisAgreeBlock) {
        _DisAgreeBlock();
    }
}

- (void)setCellByUserModel:(UserModel*)userModel
{
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:URLFrame(userModel.icon_url)] placeholderImage:[UIImage imageNamed:@"default_user_head"]];
    [_name setText:userModel.name];
    //0 保密 1 男 2 女
    if ([userModel.gender integerValue] == 0) {
        _sexImg.image = [UIImage imageNamed:@"secret_icon"];
    }else if([userModel.gender integerValue] == 1){
        _sexImg.image = [UIImage imageNamed:@"boy_icon"];
    }else{
        _sexImg.image = [UIImage imageNamed:@"girl_icon"];
    }
    _verifyInformation.text = [NSString stringWithFormat:@"验证信息：%@", userModel.user_description];
    _date.text = userModel.time_created;

}

- (void)setNeedMemberApplyCellByModel: (UserModel *)userModel{
    
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:URLFrame(userModel.icon_url)] placeholderImage:[UIImage imageNamed:@"default_user_head"]];
    [_name setText:userModel.name];
    [_sexImg setHidden:YES];
    _verifyInformation.text = [NSString stringWithFormat:@"验证信息：%@", @"申请加入人员需求"];
    _date.text = userModel.time_created;
}


- (void)setNeedMemberApplyCellByTeamModel: (TeamModel *)teamModel{
    
    [_headIcon sd_setImageWithURL:[NSURL URLWithString:URLFrame(teamModel.icon_url)] placeholderImage:[UIImage imageNamed:@"default_team_head"]];
    [_name setText:teamModel.name];
    [_sexImg setHidden:YES];
    _verifyInformation.text = [NSString stringWithFormat:@"验证信息：%@", @"申请加入"];
    _date.text = teamModel.time_created;
}



@end

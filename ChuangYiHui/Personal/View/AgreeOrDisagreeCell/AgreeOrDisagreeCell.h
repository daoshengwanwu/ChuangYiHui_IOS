//
//  AgreeOrDisagreeCell.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/10.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgreeOrDisagreeCell : UITableViewCell

@property (nonatomic, copy)void(^AgreeBlock)();
@property (nonatomic, copy)void(^DisAgreeBlock)();

- (void)setCellByUserModel:(UserModel*)userModel;
- (void)setNeedMemberApplyCellByModel: (UserModel *)userModel;
- (void)setNeedMemberApplyCellByTeamModel: (TeamModel *)teamModel;

@end

//
//  TeamIntroductionController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/22.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

//团队简介
@interface TeamIntroductionController : UIViewController


//0 队长 1 团队成员  2路人
@property (nonatomic, assign)NSInteger identity;

@property (nonatomic, strong)TeamModel *teamModel;

@end

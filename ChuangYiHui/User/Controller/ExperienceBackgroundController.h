//
//  ExperienceBackgroundController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/15.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExperienceBackgroundController : UIViewController


// 0 教育经历  1 实习经历  2 工作经历  3 他的教育经历  4 他的实习经历  5 他的工作经历 6 研究方向、 7 社会兼职、 8 成就荣誉  9 他的研究方向、 10 他的社会兼职、 11 他的成就荣誉
@property (nonatomic, assign)NSInteger type;

@property (nonatomic, strong)NSString *user_id;

@end

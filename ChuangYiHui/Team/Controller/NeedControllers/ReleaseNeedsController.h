//
//  ReleaseNeedsController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/6/30.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReleaseNeedsController : UIViewController

//0:人员需求 1:承接需求 2:外包需求
@property (nonatomic, assign)NSInteger needType;

@property (nonatomic, strong)TeamModel *teamModel;


@end

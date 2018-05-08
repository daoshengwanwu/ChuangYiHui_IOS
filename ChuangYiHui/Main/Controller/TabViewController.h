//
//  TabViewController.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/8.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabViewController : UITabBarController<UITabBarControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) NSInteger curIndex;

@end

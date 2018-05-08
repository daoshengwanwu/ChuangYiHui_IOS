//
//  AppDelegate.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/8.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end


//
//  AppDelegate.h
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/8.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DocumentsViewController;
@class UserInfoViewController;
@class MessageBoardViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) DocumentsViewController *documentsView;
@property (nonatomic, strong) UserInfoViewController *userInfoView;
@property (nonatomic, strong) MessageBoardViewController *messageBoardView;
@property (nonatomic, assign) BOOL keyboardWasShown;

- (void)saveContext;


@end


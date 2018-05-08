//
//  UserManager.h
//  GoldUnion
//
//  Created by GYY on 18/04/2016.
//  Copyright © 2016 LEE . All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;

@interface UserManager : NSObject

@property (nonatomic, strong) UserModel *userModel;

+ (instancetype)sharedManager;

- (BOOL)checkUserIsLogin;

- (BOOL)loadUserInfo;

- (UserModel *)getCurrentUser;

- (void)saveUserInfo:(UserModel *)userModel;

- (void)deleteUserInfo;

- (void)logOut;


@end

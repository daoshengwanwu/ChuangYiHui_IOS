//
//  UserManager.m
//  GoldUnion
//
//  Created by GYY on 18/04/2016.
//  Copyright © 2016 LEE . All rights reserved.
//

#import "UserManager.h"
#import "UserModel.h"

#define USER_INFO_PATH @"userInfo.data"

static UserManager *_instance;

@implementation UserManager

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
    
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _userModel = [[UserModel alloc] init];
        });
    }
    return self;
}

- (NSString *)userInfoPath
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingPathComponent:USER_INFO_PATH];
}

- (UserModel *)getCurrentUser
{
    [self loadUserInfo];
    return _userModel;
}

- (BOOL)checkUserIsLogin
{
    NSString *savedPath = [self userInfoPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:savedPath]) {
        NSData *userInfoData = [[NSData alloc] initWithContentsOfFile:savedPath];
        if (userInfoData != nil && ![userInfoData isKindOfClass:[NSNull class]]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)loadUserInfo
{
    BOOL result = NO;
    if ([self checkUserIsLogin]) {
        NSString *path = [self userInfoPath];
        
        NSData *userData = [[NSData alloc] initWithContentsOfFile:path];
        @try {
            _userModel = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
            result = YES;
        }
        @catch (NSException *exception) {
            [self deleteUserInfo];
            result = NO;
        }
        @finally {
            
        }
    }
    return result;
}

- (void)saveUserInfo:(UserModel *)userModel
{
    _userModel = userModel;
    [self deleteUserInfo];
    
    NSString *path = [self userInfoPath];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userModel];
    [data writeToFile:path atomically:YES];
}

- (void)deleteUserInfo
{
    NSString *path = [self userInfoPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

- (void)logOut
{
    _userModel = nil;
    [self deleteUserInfo];
}

@end

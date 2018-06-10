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

- (NSString *) dealError: (int)statusCode andParam2: (NSString*)responseString {
    if (responseString!=nil && [responseString length] > 3 && ![responseString isEqualToString:@""]) {
        return responseString;
    } else {
        if (statusCode == 401) {
            return @"token错误";
        } else if (statusCode == 403) {
            return @"无法完成该操作";
        } else if (statusCode == 404) {
            return @"404找不到地址";
        } else if (statusCode == 500) {
            return @"服务器接口出现问题";
        } else if (statusCode == 0302000) {
            return @"姓名与身份证不匹配";
        } else if (statusCode == 0302001) {
            return @"eID证书已过期";
        } else if (statusCode == 0302002) {
            return @"eID签名验签失败";
        } else if (statusCode == 0302003) {
            return @"eID HMAC验签失败";
        } else if (statusCode == 0302004) {
            return @"姓名与身份证不匹配";
        } else if (statusCode == 0401000) {
            return @"服务器异常";
        } else if (statusCode == 0201004) {
            return @"data_to_sign 重复";
        } else if (statusCode == 0201006) {
            return @"appid不可用";
        } else if (statusCode == 304) {
            return @"未实名认证";
        } else if (statusCode > 100000) {
            return @"eID认证失败";
        } else {
            return @"网络异常%";
        }
    }
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

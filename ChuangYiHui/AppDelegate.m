//
//  AppDelegate.m
//  ChuangYiHui
//
//  Created by litingdong on 2017/5/8.
//  Copyright © 2017年 litingdong. All rights reserved.
//

#import "AppDelegate.h"
#import "TabViewController.h"
#import "UserGuideViewController.h"

@interface AppDelegate ()<RCIMUserInfoDataSource>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
//    UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    UINavigationController *tab1 = (UINavigationController *)loginSB.instantiateInitialViewController;
//    self.window.rootViewController = tab1;
    
    
    //已登录
    if ([[UserManager sharedManager] checkUserIsLogin]) {
         [self initRongYun];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLoad"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"FirstLoad"];
        UserGuideViewController *VC = [UserGuideViewController new];
        self.window.rootViewController = VC;
    }else{
        TabViewController *tabVC = [[TabViewController alloc] initWithNibName:nil bundle:nil];
        self.window.rootViewController = tabVC;
    }
    
    
    return YES;
}



- (void)initRongYun{
    [[RCIM sharedRCIM] initWithAppKey:RongYunAppkey];
    UserModel *model = [[UserManager sharedManager] getCurrentUser];
    //测试融云的登录
    [[RCIM sharedRCIM] connectWithToken:model.token success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        dispatch_async(dispatch_get_main_queue(), ^{
            //设置数据源代理
            [[RCIM sharedRCIM] setUserInfoDataSource:self];
            //设置当前用户的信息
            [self setRCCurrentUserProfile];
        });
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];

}

//融云用户信息的数据源
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion{
    
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_OTHER_USER_PROFILE(userId) success:^(id data, NSString *message) {
        UserModel *model = [UserModel mj_objectWithKeyValues:data];
        NSLog(@"RongYun profile: %@", data);
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:model.user_id name:model.name portrait:URLFrame(model.icon_url)];
        return completion(userInfo);
    } failed:^(id data, NSString *message) {
        
        NSLog(@"RongYun profile failed: %@", message);
        return completion(nil);
    }];
    return completion(nil);
    
}

//获取个人的资料,设置融云的当前用户
- (void)setRCCurrentUserProfile{
    [[NetRequest sharedInstance] httpRequestWithGET:URL_GET_SELF_PROFILE success:^(id data, NSString *message) {
        NSLog(@"self profile: %@", data);
        UserModel *model = [UserModel mj_objectWithKeyValues:data];
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:model.user_id name:model.name portrait:URLFrame(model.icon_url)];
        [[RCIM sharedRCIM] setCurrentUserInfo:userInfo];
    } failed:^(id data, NSString *message) {
        [[SVHudManager sharedInstance] showErrorHudWithTitle:message andTime:1.0f];
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ChuangYiHui"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end

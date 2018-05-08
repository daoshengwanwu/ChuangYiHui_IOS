//
//  CommonTool.h
//  GoldUnion
//
//  Created by GYY on 21/04/2016.
//  Copyright © 2016 LEE . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonTool : NSObject

+ (BOOL)checkPhoneNum:(NSString *)phoneNum;
+ (BOOL)checkNullString:(NSString *)str;
+ (BOOL) checkIdentityCard: (NSString *)identityCard;
//核对邮箱的有效性
+ (BOOL)isValidateEmail:(NSString *)email;

+ (UIView *)tableHeaderViewWithHeight:(CGFloat)height;


//NSDate 与 NSString 转化
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date;
//计算两个日期的时间差
+ (NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate;
+ (NSInteger) getWeekday :(NSDate *)date;
+ (NSString *)getCacheSize;
+ (long long) fileSizeAtPath:(NSString*) filePath;
//生成短信验证码
+ (NSString *)generateRandomString;
//发送验证码
+ (void)sendSMSCode :(NSString *)verifyCode phoneNumber :(NSString *)phone success:(void(^)(void))successBlock fail:(void(^)(void))failedBlock netError:(void(^)(void))errorBlock;
//检测电话是否已经注册
+ (void)checkPhoneExist :(NSString *)phone exist:(void(^)(void))existBlock notExist:(void(^)(void))notExistBlock netError:(void(^)(void))errorBlock;
//电话回拨
+ (void)callBack:(NSString *)phone success:(void(^)(void))successBlock fail:(void(^)(NSString *resultDesp))failBlock netError:(void(^)(void))errorBlock;
//返回对应的颜色
+ (UIColor *)colorAtIndex :(NSInteger) index;
//返回信息对应的颜色
+ (UIColor *)messageColorAtIndex :(NSInteger) index;
//查询号码的归属地
+ (void)getPhoneArea :(NSString*)phoneString success:(void(^)(NSString *belong))successBlock;
//检测网络是否可用
+ (void)checkNetWorkAvailable :(void(^)())successBlock failed:(void(^)())failBlock;
//从字符串中提取数字
+ (NSString *)findNumFromStr: (NSString *)originalString;
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;
+ (NSString *)getGoodsNameFrom:(NSString *)goodsType;

//采购的权限判断
+ (void)checkShoppingPermission :(NSInteger )goods_type successBlock:(void(^)())success  failedBlock:(void(^)()) fail  netWorkError:(void(^)()) networkErrBlock;

+ (void)reportWithType:(NSString *)type Content:(NSString *)content ObjectId:(NSString *)object_id  success:(void(^)())successBlock failed:(void(^)(NSString *message))failBlock;

+ (void)goToLoginController;
+ (void)goToLoginController: (UIViewController *)vc;
//判断是否登录，没登录的话跳转到登录页面
+ (BOOL)checkIfLogin: (UIViewController *)vc;

@end

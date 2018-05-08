//
//  CommonTool.m
//  GoldUnion
//
//  Created by GYY on 21/04/2016.
//  Copyright © 2016 LEE . All rights reserved.
//

#import "CommonTool.h"
#import "NSDictionary+Add.h"
#import "AppDelegate.h"
#import "LoginController.h"

@implementation CommonTool

+ (UIView *)tableHeaderViewWithHeight:(CGFloat)height
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    view.bounds = CGRectMake(0, 0, SCREEN_WIDTH, height);
    return view;
}

+ (BOOL)checkPhoneNum:(NSString *)phoneNum{
    if (phoneNum.length < 11) {
        return NO;
    } else {
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        
        /**
         *虚拟运营商正则表达式
         */
        NSString *VR_NUM = @"^(170)\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:phoneNum];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:phoneNum];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:phoneNum];
        NSPredicate *pred4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VR_NUM];
        BOOL isMatch4 = [pred4 evaluateWithObject:phoneNum];
        
        if (isMatch1 || isMatch2 || isMatch3 || isMatch4) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)checkNullString:(NSString *)str
{
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if (str == nil || str == NULL || [str isEqualToString:@""]) {
        return YES;
    }
    
    
    if ([str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        return YES;
    }
    return NO;

}

+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//验证身份证号
+ (BOOL) checkIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


+ (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
}

+ (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [df stringFromDate:date];
    return  str;
}

+ (NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}

+ (NSInteger) getWeekday :(NSDate *)date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    // 指定日历的算法 NSCalendarIdentifierGregorian,NSGregorianCalendar
    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:date];
    
    return comps.weekday;
}

//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark - 计算缓存大小
+ (NSString *)getCacheSize
{
    //定义变量存储总的缓存大小
    long long sumSize = 0;
    
    //01.获取当前图片缓存路径
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    
    //02.创建文件管理对象
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    //获取当前缓存路径下的所有子路径
    NSArray *subPaths = [filemanager subpathsOfDirectoryAtPath:cacheFilePath error:nil];
    //遍历所有子文件
    for (NSString *subPath in subPaths) {
        //1）.拼接完整路径
        NSString *filePath = [cacheFilePath stringByAppendingFormat:@"/%@",subPath];
        //2）.计算文件的大小
        long long fileSize = [[filemanager attributesOfItemAtPath:filePath error:nil]fileSize];
        //3）.加载到文件的大小
        sumSize += fileSize;
    }
    float size_m = sumSize/(1000*1000);
    return [NSString stringWithFormat:@"%.2fM",size_m];
    
}

//生成六位的随机数,用于短信验证码
+ (NSString *)generateRandomString{
    NSString *strRandom = @"";
    
    for(int i=0; i<6; i++)
    {
        strRandom = [strRandom stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    
    NSLog(@"随机数: %@", strRandom);
    return strRandom;
}

//返回对应的颜色
+ (UIColor *)colorAtIndex :(NSInteger) index{
    if (index == 1) {
        return  FIRST_COLOR;
    }else if(index == 2){
        return SECOND_COLOR;
    }else if(index == 3){
        return THIRD_COLOR;
    }else{
        return FOURTH_COLOR;
    }
}

+ (UIColor *)messageColorAtIndex :(NSInteger) index{
    if (index == 1) {
        return  THIRD_COLOR;
    }else if(index == 2){
        return FOURTH_COLOR;
    }else if(index == 3){
        return FIFTH_COLOR;
    }else{
        return FIRST_COLOR;
    }
}

//查询号码的归属地
+ (void)getPhoneArea :(NSString*)phoneString success:(void(^)(NSString *belong))successBlock{
    //url
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"a16f6d7ccb90a35a7a90176ca46aa550" forHTTPHeaderField:@"apikey"];
    NSString *URL = [NSString stringWithFormat:@"http://apis.baidu.com/apistore/mobilephoneservice/mobilephone?tel=%@",phoneString];
    
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([responseDic[@"errMsg"] isEqualToString:@"success"]) {
            NSString *belongArea = responseDic[@"retData"][@"carrier"];
            if (belongArea.length == 0) {
                successBlock(@"未知号码");
            }else{
                successBlock(belongArea);
            }
        }else{
            successBlock(@"未知号码");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        successBlock(@"未知号码");
    }];
    
}


//检测网络是否可用
+ (void)checkNetWorkAvailable :(void(^)())successBlock failed:(void(^)())failBlock{
    // Allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE!");
            successBlock();
            
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");
        failBlock();
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}

//从字符串中提取数字
+ (NSString *)findNumFromStr: (NSString *)originalString
{
    
    // Intermediate
    NSMutableString *numberString = [[NSMutableString alloc] init];
    NSString *tempStr;
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while (![scanner isAtEnd]) {
        // Throw away characters before the first number.
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        [numberString appendString:tempStr];
        tempStr = @"";
    }
    // Result.
    return numberString;
}

//字典转json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


+ (NSString *)getGoodsNameFrom:(NSString *)goodsType{
    NSArray *goodsNameArray = @[@"固定POS机", @"移动POS机", @"立刷MPOS机", @"智能卡片", @"会员金卡", @"云商年卡", @"移动SIM流量卡"];
    if ([goodsType integerValue] < goodsNameArray.count) {
        return [goodsNameArray objectAtIndex:[goodsType integerValue]];
    }else{
        return @"未知采购商品类型";
    }
}


+ (void)reportWithType:(NSString *)type Content:(NSString *)content ObjectId:(NSString *)object_id  success:(void(^)())successBlock failed:(void(^)(NSString *message))failBlock{
    NSDictionary *params = @{@"type": type, @"content": content, @"object_id": object_id};
    
    [[NetRequest sharedInstance] httpRequestWithPost:URL_REPORT parameters:params withToken:NO success:^(id data, NSString *message) {
        if (successBlock) {
            successBlock();
        }
    } failed:^(id data, NSString *message) {
        if (failBlock) {
            failBlock(message);
        }
    }];
}

+ (void)goToLoginController{
    UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UINavigationController *tab1 = (UINavigationController *)loginSB.instantiateInitialViewController;
    
    LoginController *loginVC = (LoginController *)tab1.topViewController;
    loginVC.enterType = 1;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = tab1 ;
}


+ (void)goToLoginController: (UIViewController *)vc{
    UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UINavigationController *tab1 = (UINavigationController *)loginSB.instantiateInitialViewController;
    LoginController *loginVC = (LoginController *)tab1.topViewController;
    loginVC.enterType = 0;

    [vc.self presentViewController:tab1 animated:YES completion:nil];
}


+ (BOOL)checkIfLogin: (UIViewController *)vc{
    if ([[UserManager sharedManager] checkUserIsLogin]) {
        return YES;
    }else{
        [self goToLoginController:vc];
        return NO;
    }
}

@end

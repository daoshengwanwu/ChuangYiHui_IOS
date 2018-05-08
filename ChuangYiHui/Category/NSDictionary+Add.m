//
//  NSDictionary+Add.m
//  GoldUnion
//
//  Created by GYY on 18/04/2016.
//  Copyright © 2016 LEE . All rights reserved.
//

#import "NSDictionary+Add.h"
#import "UserModel.h"
#import "UserManager.h"

@implementation NSDictionary (Add)

+ (NSDictionary *)dictionaryWithTokenOfExist:(BOOL)isToken andDict:(NSDictionary *)dataDict
{
    NSMutableDictionary *resDict = [[NSMutableDictionary alloc] initWithDictionary:dataDict];

    if (!isToken) {
        return resDict;
    }
    
    if (isToken) {
        UserModel *user = [[UserManager sharedManager] getCurrentUser];
        if (user.token != nil && ![user.token isEqualToString:@""] && ![user.token isKindOfClass:[NSNull class]] && user.token != NULL) {
            [resDict setObject:user.token forKey:@"token"];
        }
    }
    
    NSLog(@"params:%@",resDict);
    return resDict;

}

@end

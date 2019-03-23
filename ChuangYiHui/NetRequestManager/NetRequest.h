//
//  NetRequest.h
//  GoldUnion
//
//  Created by GYY on 18/04/2016.
//  Copyright © 2016 LEE . All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void (^requestSuccess) (id data, NSString *message);
typedef void (^requestFailure) (id data, NSString *message);

@interface NetRequest : AFHTTPSessionManager



+ (instancetype)sharedInstance;

- (void)httpRequestWithPost:(NSString *)url parameters:(NSDictionary *)parameters withToken:(BOOL)withToken success:(requestSuccess)success failed:(requestFailure)failed;

- (void)upLoad:(NSString *)url parameters:(NSDictionary *)parameter imageKey:(NSArray *)imageKeyArray imageArray:(NSArray *)uploadImages success:(requestSuccess)success failed:(requestFailure)failed;

- (void)httpRequestWithGET:(NSString *)url success:(requestSuccess)success failed:(requestFailure)failed;

- (void)httpRequestWithGETandSort:(NSString *)url success:(requestSuccess)success failed:(requestFailure)failed;

- (void)httpRequestWithGETandParam:(NSString *)url parameters:(NSDictionary *)parameter success:(requestSuccess)success failed:(requestFailure)failed;

- (void)httpRequestWithDELETE:(NSString *)url success:(requestSuccess)success failed:(requestFailure)failed;

@end

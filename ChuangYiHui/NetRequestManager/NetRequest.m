//
//  NetRequest.m
//  GoldUnion
//
//  Created by GYY on 18/04/2016.
//  Copyright © 2016 LEE . All rights reserved.
//

#import "NetRequest.h"
#import "NSDictionary+Add.h"

static NetRequest *_instance;

@implementation NetRequest

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
        });
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        _instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:@""] sessionConfiguration:sessionConfig];
        
        _instance.requestSerializer = [AFHTTPRequestSerializer serializer];
        _instance.responseSerializer = [AFHTTPResponseSerializer serializer];

        _instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    });
    
    UserModel *model = [[UserManager sharedManager] getCurrentUser];
    [_instance.requestSerializer setValue:model.token forHTTPHeaderField:@"X-User-Token"];
    
    return _instance;
}

- (void)httpRequestWithPost:(NSString *)url parameters:(NSDictionary *)parameters withToken:(BOOL)withToken success:(requestSuccess)success failed:(requestFailure)failed
{

    [_instance POST:url parameters:[NSDictionary dictionaryWithTokenOfExist:withToken andDict:parameters] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self callBackWithTaskInfo:task data:responseObject success:success failed:failed];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (httpResponse.statusCode == 304) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failed([NSString stringWithFormat:@"%ld", httpResponse.statusCode],@"请先去个人中心实名认证");
                });
            }else if (httpResponse.statusCode == 401) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failed([NSString stringWithFormat:@"%ld", httpResponse.statusCode],@"未授权");
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    failed([NSString stringWithFormat:@"%ld", httpResponse.statusCode],@"网络异常");
                });
            }
            NSLog(@"error:%@", error.localizedDescription);
        });
        
    }];
}

- (void)httpRequestWithGET:(NSString *)url success:(requestSuccess)success failed:(requestFailure)failed
{
    [_instance GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self callBackWithTaskInfo:task data:responseObject success:success failed:failed];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (httpResponse.statusCode == 304) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failed([NSString stringWithFormat:@"%ld", httpResponse.statusCode],@"请先去个人中心实名认证");
                });
            }else if (httpResponse.statusCode == 401) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failed([NSString stringWithFormat:@"%ld", httpResponse.statusCode],@"未授权");
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    failed([NSString stringWithFormat:@"%ld", httpResponse.statusCode],@"网络异常");
                });
            }
        });
    }];
}

- (void)httpRequestWithDELETE:(NSString *)url success:(requestSuccess)success failed:(requestFailure)failed
{
    [_instance DELETE:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self callBackWithTaskInfo:task data:responseObject success:success failed:failed];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (httpResponse.statusCode == 304) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failed([NSString stringWithFormat:@"%ld", httpResponse.statusCode],@"请先去个人中心实名认证");
                });
            }else if (httpResponse.statusCode == 401) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failed([NSString stringWithFormat:@"%ld", httpResponse.statusCode],@"未授权");
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    failed([NSString stringWithFormat:@"%ld", httpResponse.statusCode],@"网络异常");
                });
            }
        });
    }];
}


#pragma mark - 网络请求，上传图片
- (void)upLoad:(NSString *)url parameters:(NSDictionary *)parameter imageKey:(NSArray *)imageKeyArray imageArray:(NSArray *)uploadImages success:(requestSuccess)success failed:(requestFailure)failed
{
    
//    imageKey = [imageKey stringByAppendingString:@"[]"];
    
    [_instance POST:url parameters:[NSDictionary dictionaryWithTokenOfExist:1 andDict:parameter] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
//        for (int i = 0; i<uploadImages.count; i++) {
//            UIImage *uploadImage = uploadImages[i];
//            NSData *data = UIImageJPEGRepresentation(uploadImage,0.5f);
//            NSString *curWholeFileName = [NSString stringWithFormat: @"file%d.jpg", i];
//            [formData appendPartWithFileData:data name:imageKey fileName:curWholeFileName mimeType:@"image/jpeg"];
//        }
        for (int i=0; i<uploadImages.count; i++) {
            UIImage *uploadImage = uploadImages[i];
            NSData *data = UIImageJPEGRepresentation(uploadImage, 0.5f);
            NSString *curWholeFileName = [NSString stringWithFormat: @"file%d.jpg", i];
            [formData appendPartWithFileData:data name:imageKeyArray[i] fileName:curWholeFileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self callBackWithTaskInfo:task data:responseObject success:success failed:failed];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (httpResponse.statusCode == 304) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failed([NSString stringWithFormat:@"%ld", httpResponse.statusCode],@"请先去个人中心实名认证");
                });
            }else if (httpResponse.statusCode == 401) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failed([NSString stringWithFormat:@"%ld", httpResponse.statusCode],@"未授权");
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    failed([NSString stringWithFormat:@"%ld", httpResponse.statusCode],@"网络异常");
                });
            }
            NSLog(@"error:%@", error.localizedDescription);
        });
    }];
        
}


- (void)callBackWithTaskInfo:(NSURLSessionDataTask *)task
                        data:(id)responseObject
                     success:(requestSuccess)success
                      failed:(requestFailure)failed
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
    NSError *error = nil;
    responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSLog(@"错误%@",error.localizedDescription);
    }
    if (httpResponse.statusCode == 200) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            if ([responseObject[@"result"] intValue] == 1) {
//                success(responseObject[@"data"],nil);
//            }else{
//                if (responseObject[@"resultDesp"] == nil || [responseObject[@"resultDesp"] isEqualToString:@""]) {
//                    failed(nil,@"请求失败");
//                }else{
//                    failed(nil,responseObject[@"resultDesp"]);
//                }
//            }
            success(responseObject,nil);
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            failed(nil,@"请求异常");
        });
    }
}

- (void)postTo51CTO: (NSString*) methodName Params:(NSArray*)params
            success:(requestSuccess)success failed:(requestFailure)failed   {
    
    NSArray * sortedArray = [params sortedArrayUsingSelector:@selector(compare:)];
}
@end

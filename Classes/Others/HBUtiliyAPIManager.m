//
//  HBUtiliyAPIManager.m
//  HBUtils
//
//  Created by Hoang Ho on 10/30/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "HBUtiliyAPIManager.h"
#import "NSDictionary+HBUtils.h"

@implementation HBUtiliyAPIManager
+ (id)sharedInstance {
    static HBUtiliyAPIManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self manager];
    });
    return sharedInstance;
}

+ (instancetype)manager {
    HBUtiliyAPIManager *manager = [super manager];
    
    // attempt to hack-trick the server into returning 'application/json' (doesn't work)
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    [manager.requestSerializer setValue:nil forHTTPHeaderField:@"Accept-Language"];
    
    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [policy setValidatesDomainName:NO];
    [policy setAllowInvalidCertificates:YES];
    
    manager.securityPolicy = policy;
    
    // hack to allow 'text/plain' content-type to work
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableSet *contentTypes = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/plain"];
    [contentTypes addObject:@"text/html"];
    [contentTypes addObject:@"application/x-www-form-urlencoded; charset=utf-8"];
    [contentTypes addObject:@"application/json"];
    [contentTypes addObject:@"application/soap+xml"];
    [contentTypes addObject:@"text"];
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    
    [manager.requestSerializer setValue:@"VN" forHTTPHeaderField:@"countrycode"];
    
    // Enable AFNetworking System Activity Indicator
    AFNetworkActivityIndicatorManager.sharedManager.enabled = YES;
    return manager;
}

#pragma mark - Override Method

- (NSURLSessionDataTask *)GET:(NSString *_Nonnull)URLString
                            parameters:(nullable id)parameters
                            completion:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject,NSError *
                                                          _Nullable error))completion
{
    [self updateUserAgenWithUrl:URLString];
    return [super GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id responseJson = [self processResponseData:responseObject];
        LOG_API_DEBUG(task, parameters, responseJson, nil);
        
        if (completion) {
            completion(task, responseJson, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LOG_API_DEBUG(task, parameters, nil, error);
        if (completion) {
            completion(task, nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)POST:(NSString *_Nonnull)URLString
                             parameters:(nullable id)parameters
                             completion:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject,NSError * _Nullable error))completion
{
    [self updateUserAgenWithUrl:URLString];
    return [super POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id responseJson = [self processResponseData:responseObject];
        LOG_API_DEBUG(task, parameters, responseJson, nil);
        
        if (completion) {
            completion(task, responseJson, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LOG_API_DEBUG(task, parameters, nil, error);
        if (completion) {
            completion(task, nil, error);
        }
    }];
}

- (NSURLSessionDataTask *)PUT:(NSString *_Nonnull)URLString
                   parameters:(nullable id)parameters
                   completion:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject,NSError * _Nullable error))completion {
    [self updateUserAgenWithUrl:URLString];
    return [super PUT:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id responseJson = [self processResponseData:responseObject];
        LOG_API_DEBUG(task, parameters, responseJson, nil);
        
        if (completion) {
            completion(task, responseJson, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LOG_API_DEBUG(task, parameters, nil, error);
        if (completion) {
            completion(task, nil, error);
        }
    }];
}
- (void)cancelAllTasks
{
    if (self.operationQueue.operations.count > 0) {
        [self.operationQueue cancelAllOperations];
    }
}

- (void)updateUserAgenWithUrl:(NSString*)URLString {
    NSLog(@"Should implement in subclass");
}

- (void)changeUserAgent:(NSString *_Nullable)userAgent
{
    [self.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
}

- (id)processResponseData:(id)responseData
{
    id result = nil;
    if ([responseData isKindOfClass:[NSData class]]) {
        NSError *error = nil;
        result =  [NSJSONSerialization
                   JSONObjectWithData:responseData
                   options:kNilOptions
                   error:&error];
        if (error) {
            result = [[NSString alloc] initWithData:responseData
                                           encoding:NSUTF8StringEncoding];
        }
    }else{
        result = responseData;
    }
    if ([result isKindOfClass:[NSDictionary class]]) {
        result = [result repair];
    }else if ([result isKindOfClass:[NSArray class]]) {
        NSMutableArray *temp = [NSMutableArray array];
        for (id obj in result) {
            id tempObj = obj;
            if([tempObj isKindOfClass:[NSDictionary class]]){
                tempObj = [tempObj repair];
            }
            [temp addObject:tempObj];
        }
        result = temp;
    }
    return result;
}

void LOG_API_DEBUG(NSURLSessionDataTask *operation, NSDictionary *params, id responseObject, NSError* error)
{
    
#if LOG_API_STATUS
    NSString *line = @"";
    for (int i = 0; i < 40; i++) {
        line = [line stringByAppendingString:@"="];
    }
    NSString *requestKind = @"GET";
    if ([operation isKindOfClass:NSURLSessionDataTask.class]) {
        requestKind = operation.currentRequest.HTTPMethod;
    }
    NSString *urlStr = @"";
    if ([operation isKindOfClass:NSURLSessionDataTask.class]) {
        urlStr = [HBUtiliyAPIManager.sharedInstance urlStringWithRequest:operation.currentRequest];
    } else if ([operation isKindOfClass:NSString.class]) {
        urlStr = (id)operation;
    }
    if (error) {
        if (![error isCancelError]) {
            NSString *str = [NSString stringWithFormat:@"\n\n%@\n%@ API FAIL \n%@ - statusCode:%zd %@\n%@\n%@\n\n", line, requestKind, urlStr, operation.statusCode, params, [operation responseString:error], line];
            
            DLog(@"%@", str);
        }
    }else{
        NSString *str = [NSString stringWithFormat:@"\n\n%@\n%@ API Success \n%@", line, requestKind, urlStr];
#if LOG_API_REQUEST_PARAM
        if (params) {
            str= [str stringByAppendingFormat:@"\n%@", params];
        }
#endif
#if LOG_API_RESPONSE
        str= [str stringByAppendingFormat:@"\n%@", responseObject];
#endif
        str= [str stringByAppendingFormat:@"\n%@\n", line];
        DLog(@"%@", str);
    }
#endif
}

- (NSString*)urlStringWithRequest:(NSURLRequest*)request {
    NSString *urlStr = request.URL.absoluteString;
    return urlStr;
}
@end

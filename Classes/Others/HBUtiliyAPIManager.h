//
//  HBUtiliyAPIManager.h
//  HBUtils
//
//  Created by Hoang Ho on 10/30/19.
//  Copyright © 2019 HB. All rights reserved.
//

@import AFNetworking;
NS_ASSUME_NONNULL_BEGIN

@interface HBUtiliyAPIManager : AFHTTPSessionManager
+ (_Nonnull instancetype)sharedInstance;

- (NSURLSessionDataTask *)GET:(NSString *_Nonnull)URLString
                   parameters:(nullable id)parameters
                   completion:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject,NSError * _Nullable error))completion;

- (NSURLSessionDataTask *)POST:(NSString *_Nonnull)URLString
                    parameters:(nullable id)parameters
                    completion:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject,NSError * _Nullable error))completion;

- (NSURLSessionDataTask *)PUT:(NSString *_Nonnull)URLString
                   parameters:(nullable id)parameters
                   completion:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject,NSError * _Nullable error))completion;

- (void)cancelAllTasks;

- (void)changeUserAgent:(NSString *_Nullable)userAgent;

void LOG_API_DEBUG(NSURLSessionDataTask *operation, NSDictionary *params, id _Nullable  responseObject, NSError* _Nullable error);
@end

NS_ASSUME_NONNULL_END

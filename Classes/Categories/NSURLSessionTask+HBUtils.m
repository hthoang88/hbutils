//
//  NSError+HBUtils.m
//  HBUtils
//
//  Created by Hoang Ho on 10/30/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "NSURLSessionTask+HBUtils.h"

@implementation NSURLSessionTask (HBUtils)
- (nullable NSString*)responseString:(NSError*)error
{
    NSError *tempError = self.error;
    NSData *responseData = tempError.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (!responseData) {
        tempError = error;
        responseData = tempError.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    }
    
    NSString *str = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    return str;
}

- (NSInteger)statusCode
{
    NSInteger statusCode = self.error.code;
    if ([self.response isKindOfClass:[NSHTTPURLResponse class]]) {
        statusCode = ((NSHTTPURLResponse*)self.response).statusCode;
    }
    return statusCode;
}
@end

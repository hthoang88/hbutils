//
//  NSError+HBUtils.h
//  HBUtils
//
//  Created by Hoang Ho on 10/30/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AFNetworking;

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSessionTask (HBUtils)
- (nullable NSString*)responseString:(nullable NSError*)error;
- (NSInteger)statusCode;
@end


NS_ASSUME_NONNULL_END

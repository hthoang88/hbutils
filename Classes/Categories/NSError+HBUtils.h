//
//  NSError+HBUtils.h
//  HBUtils
//
//  Created by Hoang Ho on 10/30/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (HBUtils)
- (BOOL)isCancelError;
- (BOOL)isTimeOutError;
- (BOOL)isNetworkError;
@end


NS_ASSUME_NONNULL_END

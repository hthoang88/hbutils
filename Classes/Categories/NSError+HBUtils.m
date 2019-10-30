//
//  NSError+HBUtils.m
//  HBUtils
//
//  Created by Hoang Ho on 10/30/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "NSError+HBUtils.h"

@implementation NSError (HBUtils)
- (BOOL)isCancelError
{
    return self.code == NSURLErrorCancelled;
}

- (BOOL)isTimeOutError
{
    return self.code == NSURLErrorTimedOut;
}

- (BOOL)isNetworkError
{
    return self.code == NSURLErrorNotConnectedToInternet;
}
@end

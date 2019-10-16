//
//  NSObject+HBUtils.h
//  HBUtils
//
//  Created by Hoang Ho on 10/13/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HBUtils)
+ (NSString*)classNameString;
- (void)addNotification:(SEL)selector name:(NSString*)name;
@end

NS_ASSUME_NONNULL_END

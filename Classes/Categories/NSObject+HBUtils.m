//
//  NSObject+HBUtils.m
//  HBUtils
//
//  Created by Hoang Ho on 10/13/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "NSObject+HBUtils.h"
#import "HBUtilsMacros.h"

@implementation NSObject (HBUtils)
+ (NSString*)classNameString {
    return NSStringFromClass([self class]);
}

- (void)addNotification:(SEL)selector name:(NSString*)name {
    [NTF_CENTER addObserver:self selector:selector name:name object:nil];
}
@end

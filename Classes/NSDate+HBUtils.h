//
//  NSDate+HBUtils.h
//  HBMonNgonMoiNgay
//
//  Created by Hoang Ho on 4/7/18.
//  Copyright © 2018 HoangHo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)
+ (NSDateFormatter *)sharedDataFormatter;


+ (NSDateFormatter*)sharedLocalDateFormatter;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;

- (BOOL) isToday;

- (BOOL) isYesterday;

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;

- (NSDate *) dateByAddingDays: (NSInteger) dDays;

-(NSDate *)dateWithOutTime;

@end

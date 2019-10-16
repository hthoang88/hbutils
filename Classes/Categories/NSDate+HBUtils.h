//
//  NSDate+HBUtils.h
//  HBMonNgonMoiNgay
//
//  Created by Hoang Ho on 4/7/18.
//  Copyright © 2018 HoangHo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HBUtils)
+ (NSDateFormatter *)sharedDataFormatter;


+ (NSDateFormatter*)sharedLocalDateFormatter;

// Comparing dates
- (BOOL)isEqualToDateIgnoringTime: (NSDate *) aDate;

- (BOOL)isToday;

- (BOOL)isYesterday;

// Adjusting dates
- (NSDate*)dateByAddingYears:(NSInteger)dYears;
- (NSDate*)dateBySubtractingYears:(NSInteger)dYears;
- (NSDate*)dateByAddingMonths:(NSInteger)dMonths;
- (NSDate*)dateBySubtractingMonths:(NSInteger)dMonths;
- (NSDate*)dateByAddingDays:(NSInteger)dDays;
- (NSDate*)dateBySubtractingDays:(NSInteger)dDays;
- (NSDate*)dateByAddingHours:(NSInteger)dHours;
- (NSDate*)dateBySubtractingHours:(NSInteger)dHours;
- (NSDate*)dateByAddingMinutes:(NSInteger)dMinutes;
- (NSDate*)dateBySubtractingMinutes:(NSInteger)dMinutes;
- (NSDate*)dateByAddingSeconds:(NSInteger)dSeconds;

- (NSDate *)dateWithOutTime;

@end

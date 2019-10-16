//
//  NSDate+Helper.m
//  HBMonNgonMoiNgay
//
//  Created by Hoang Ho on 4/7/18.
//  Copyright © 2018 HoangHo. All rights reserved.
//

#import "NSDate+HBUtils.h"

#define D_MINUTE    60
#define D_HOUR        3600
#define D_DAY        86400
#define D_WEEK        604800
#define D_YEAR        31556926

// Thanks, AshFurrow
static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);

@implementation NSDate (HBUtils)
///Shared NSDateFormatter with dynamic format
+ (NSDateFormatter *)sharedDataFormatter {
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *formatter = [threadDictionary objectForKey:@"HBDateUtils_SharedDateFormatter"];
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        //        [formatter setLocale:[NSLocale currentLocale]];
        NSTimeZone *zone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [formatter setTimeZone:zone];
        [threadDictionary setObject:formatter forKey:@"HBDateUtils_SharedDateFormatter"];
    }
    return formatter;
}

+ (NSDateFormatter*)sharedLocalDateFormatter {
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *formatter = [threadDictionary objectForKey:@"HBDateUtils_sharedLocalDateFormatter"];
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        //        [formatter setLocale:[NSLocale currentLocale]];
        NSTimeZone *zone = [NSTimeZone localTimeZone];
        [formatter setTimeZone:zone];
        [threadDictionary setObject:formatter forKey:@"HBDateUtils_sharedLocalDateFormatter"];
    }
    return formatter;
}
+ (NSCalendar *) currentCalendar
{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}

- (BOOL)isEqualToDateIgnoringTime: (NSDate *) aDate
{
    if (![aDate isKindOfClass:[NSDate class]]) {
        return NO;
    }
    NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL)isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)isYesterday
{
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

+ (NSDate *) dateYesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithDaysBeforeNow:(NSInteger)days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateBySubtractingDays:days];
}


#pragma mark - Adjusting Dates

// Thaks, rsjohnson
- (NSDate*)dateByAddingYears:(NSInteger)dYears
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:dYears];
    NSDate *newDate = [[NSDate getDefaultCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate*)dateBySubtractingYears:(NSInteger)dYears
{
    return [self dateByAddingYears:-dYears];
}

- (NSDate*)dateByAddingMonths:(NSInteger)dMonths
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonths];
    NSDate *newDate = [[NSDate getDefaultCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate*)dateBySubtractingMonths:(NSInteger)dMonths
{
    return [self dateByAddingMonths:-dMonths];
}

// Courtesy of dedan who mentions issues with Daylight Savings
- (NSDate*)dateByAddingDays:(NSInteger)dDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSDate getDefaultCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate*)dateBySubtractingDays:(NSInteger)dDays
{
    return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate*)dateByAddingHours:(NSInteger)dHours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate*)dateBySubtractingHours:(NSInteger)dHours
{
    return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate*)dateByAddingMinutes:(NSInteger)dMinutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate*)dateBySubtractingMinutes:(NSInteger)dMinutes
{
    return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
    NSDateComponents *dTime = [[NSDate getDefaultCalendar] components:componentFlags fromDate:aDate toDate:self options:0];
    return dTime;
}

- (NSDate*)dateByAddingSeconds:(NSInteger)dSeconds
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + dSeconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSCalendar*)getDefaultCalendar
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSCalendar *gregorian = [threadDictionary objectForKey:@"DefaultGregorianCalendar"];
    
    if (!gregorian) {
        gregorian = [[NSCalendar alloc]
                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        //        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        //        [gregorian setLocale:enUSPOSIXLocale];
        [gregorian setLocale:[NSLocale currentLocale]];
        
        [threadDictionary setObject:gregorian forKey:@"DefaultGregorianCalendar"];
    }
    return gregorian;
}

- (NSDate *)dateWithOutTime {
    NSCalendar *gregorian = [NSDate getDefaultCalendar];
    
    NSDateComponents* comps = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    return [gregorian dateFromComponents:comps];
}

@end

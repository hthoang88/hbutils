//
//  NSDate+Helper.m
//  HBMonNgonMoiNgay
//
//  Created by Hoang Ho on 4/7/18.
//  Copyright © 2018 HoangHo. All rights reserved.
//

#import "NSDate+HBUtils.h"

// Thanks, AshFurrow
static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);

@implementation NSDate (Helper)
///Shared NSDateFormatter with dynamic format
+ (NSDateFormatter *)sharedDataFormatter {
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *formatter = [threadDictionary objectForKey:@"BADateHelper_SharedDateFormatter"];
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        //        [formatter setLocale:[NSLocale currentLocale]];
        NSTimeZone *zone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [formatter setTimeZone:zone];
        [threadDictionary setObject:formatter forKey:@"BADateHelper_SharedDateFormatter"];
    }
    return formatter;
}

+ (NSDateFormatter*)sharedLocalDateFormatter {
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *formatter = [threadDictionary objectForKey:@"BADateHelper_sharedLocalDateFormatter"];
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        //        [formatter setLocale:[NSLocale currentLocale]];
        NSTimeZone *zone = [NSTimeZone localTimeZone];
        [formatter setTimeZone:zone];
        [threadDictionary setObject:formatter forKey:@"BADateHelper_sharedLocalDateFormatter"];
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

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
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

- (BOOL) isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isYesterday
{
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

+ (NSDate *) dateYesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateBySubtractingDays:days];
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
    return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSDate getDefaultCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
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

-(NSDate *)dateWithOutTime {
    NSCalendar *gregorian = [NSDate getDefaultCalendar];
    
    NSDateComponents* comps = [gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    return [gregorian dateFromComponents:comps];
}

@end

//
//  NSNumber+Helper.m
//  HBMonNgonMoiNgay
//
//  Created by Ho Thai Hoang on 1/11/17.
//  Copyright © 2017 HoangHo. All rights reserved.
//

#import "NSNumber+HBUtils.h"

@implementation NSNumber (Helper)
NSString* MONEY_FORMATTER(float value)
{
    return MONEY_FORMATTER_CURRENCY(value, @"VND");
}
NSString* MONEY_FORMATTER_CURRENCY(float value, NSString *currencyCode)
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSNumberFormatter *formatter = [threadDictionary objectForKey:@"MONEY_FORMATTER_CURRENCY"];
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        [formatter setCurrencySymbol:@""];
        formatter.currencyCode = @"VND";
        [threadDictionary setObject:formatter forKey:@"MONEY_FORMATTER_CURRENCY"];
    }
    
    NSString *myNumber = [formatter stringFromNumber:@(value)];
    if (currencyCode) {
        myNumber = [myNumber stringByAppendingFormat:@" %@", currencyCode];
    }
    return myNumber;
    
}
@end

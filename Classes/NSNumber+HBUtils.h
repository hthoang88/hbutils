//
//  NSNumber+HBUtils.h
//  HBMonNgonMoiNgay
//
//  Created by Ho Thai Hoang on 1/11/17.
//  Copyright © 2017 HoangHo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Helper)
NSString* MONEY_FORMATTER(float value);
NSString* MONEY_FORMATTER_CURRENCY(float value, NSString *currencyCode);
@end

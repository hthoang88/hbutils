//
//  NSString+helpers.h
//  BridgeAthletic
//
//  Created by Paul Mans on 12/26/13.
//  Copyright (c) 2013 Bridge Athletic. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface NSString (HBUtils)

+ (NSString *)randomString:(NSInteger)lenght;

+ (NSString *)nonNilString:(id)string;

- (NSString*)trim;

/**
 *  validate email string
 *
 *  @param checkString the input value
 *
 *  @return return YES is is valid email
 */
+ (BOOL)isValidEmail:(NSString *)checkString;

- (CGFloat)contentHeightWithFont:(UIFont*)font fitWidth:(CGFloat)fitWidth;
- (CGFloat)contentWidthWithFont:(UIFont*)font fitHeight:(CGFloat)fitHeight;

- (NSNumber*)numberValue;

- (NSURL*)urlValue;

- (NSString *)objectIdFromUrl;

- (NSString *)stringByRemoveUnicode;

- (NSString *)stringByReplacePatterns:(NSArray *)paterns;

- (NSString *)stringByRemoveHtmlTag;
@end

//
//  NSString+helpers.m
//  BridgeAthletic
//
//  Created by Paul Mans on 12/26/13.
//  Copyright (c) 2013 Bridge Athletic. All rights reserved.
//

#import "NSString+HBUtils.h"

@implementation NSString (HBUtils)

+ (NSString *)randomString:(NSInteger)lenght {
    static NSString *letters = @"ABC DEFG HIKLMN OPQWXYZ12 3456789 ";
    //    static NSString *letters = @"1234567890";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: lenght];
    for (int i=0; i<lenght; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}

+ (NSString *)nonNilString:(id)string {
    NSString *temp = string;
    if (![string isKindOfClass:[NSString class]]) {
        temp = [string stringValue];
    }
    if (!temp) {
        return @"";
    } else {
        return temp;
    }
}

- (NSString*)trim
{
    if (self.length == 0) {
        return self;
    }
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(NSString *)singularCasesCheck:(NSInteger)num
{
    return num > 1 ? [NSString stringWithFormat:@"%@s", self] : self;
}

+ (NSString*)decimalStringFromFloatValue:(float)floatValue
{
    NSString *str = [NSString stringWithFormat:@"%.1f",floatValue];
    if ([str floatValue] == 0.0f) {
        str = @"0";
    }else{
        if([str floatValue] - [str intValue] == 0){
            str = [NSString stringWithFormat:@"%.0f",floatValue];
        }
    }
    return str;
}

- (CGFloat)contentHeightWithFont:(UIFont*)font fitWidth:(CGFloat)fitWidth
{
    if (self.length == 0) {
        return 0.0f;
    }
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          nil];

    CGRect frame = [self boundingRectWithSize:CGSizeMake(fitWidth, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attributesDictionary
                                           context:nil];

    return frame.size.height;
}

- (CGFloat)contentWidthWithFont:(UIFont*)font fitHeight:(CGFloat)fitHeight
{
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          nil];
    
    CGRect frame = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, fitHeight)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:attributesDictionary
                                      context:nil];
    
    return frame.size.width;
}

- (NSString*)stringValue
{
    return self;
}

- (NSNumber*)numberValue
{
    return [NSNumber numberWithInt:self.intValue];
}

- (NSURL *)urlValue
{
    if ([self rangeOfString:@"firebasestorage.googleapis.com"].location == NSNotFound) {
        return [NSURL URLWithString:[self stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLFragmentAllowedCharacterSet]];
    }else {
        return [NSURL URLWithString:self];
    }
}

- (NSString *)objectIdFromUrl {
    NSString *href = self.copy;
    NSString *contentId = [href stringByRemovingPercentEncoding];
    contentId = [contentId.lastPathComponent stringByReplacingOccurrencesOfString:@" " withString:@""].trim;
    contentId = [contentId stringByRemoveUnicode];
    return contentId;
}

- (NSString *)stringByRemoveUnicode {
    NSString *string = [self.copy trim];
    string = [string stringByReplacingOccurrencesOfString:@"Œ" withString:@"OE"];
    string = [string stringByReplacingOccurrencesOfString:@"œ" withString:@"oe"];
    string = [string stringByReplacingOccurrencesOfString:@"Đ" withString:@"D"];
    string = [string stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
    string = [string precomposedStringWithCompatibilityMapping];
    
    NSData *data = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *newString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    return newString;
}

- (NSDictionary *)dictValue {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (result) {
            return result;
        }
    }
    return @{};
}

- (NSString *_Nullable)stringByReplacePatterns:(NSArray *_Nullable)paterns  {
    NSString *result = self.copy;
    for (NSString *str in paterns) {
        if ([str isKindOfClass:[NSString class]]) {
            result = [result stringByReplacingOccurrencesOfString:str withString:@""];
        }
    }
    return result;
}

- (NSString *)stringByRemoveHtmlTag {
    if ([self.trim containsString:@"<"] ||
        [self.trim containsString:@"&amp;"] ||
        [self.trim containsString:@"&#2"]) {
        NSData *data = [self.trim dataUsingEncoding:NSUnicodeStringEncoding];
        NSAttributedString *titlteAtt = [[NSAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithData:data options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                                                                                                                      } documentAttributes:nil error:nil]];
        return titlteAtt.string.trim;
    }
    
    return self;
}


@end

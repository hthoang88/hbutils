//
//  NSAttributedString+Helper.m
//  BridgeAthletic
//
//  Created by Ho Thai Hoang on 12/2/16.
//
//

#import "NSAttributedString+HBUtils.h"
@import UIKit;

@implementation  NSAttributedString (HBUtils)
+ (NSAttributedString*)combines:(NSArray*)atts
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    for (id obj in atts) {
        [result appendAttributedString:obj];
    }
    return result;
}
@end

@implementation  NSMutableAttributedString (HBUtils)
+ (NSMutableAttributedString*)atributesStringWithData:(id)data
{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] init];
    NSArray *arr = nil;
    if ([data isKindOfClass:[NSDictionary class]]) {
        arr = @[data];
    }else if ([data isKindOfClass:[NSArray class]]) {
        arr = data;
    }else {
        NSLog(@"Invalid Atributes Data: %@", data);
    }
    if (arr) {
        for (NSDictionary *dict in arr) {
            NSString *text = dict[@"text"];
            if (text) {
                UIFont *font = dict[@"font"];
                UIColor *color = dict[@"color"];
                NSMutableDictionary *attributes = @{}.mutableCopy;
                if (font) {
                    attributes[NSFontAttributeName] = font;
                }
                if (color) {
                    attributes[NSForegroundColorAttributeName] = color;
                }
                [att appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:attributes]];
            }
        }
    }
    return att;
}
@end

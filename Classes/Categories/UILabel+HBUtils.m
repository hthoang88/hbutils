//
//  UILabel+Helper.m
//  BridgeAthletic
//
//  Created by Hoang Ho on 5/25/15.
//
//

#import "UILabel+HBUtils.h"
#import "UIView+HBUtils.h"
#import "NSString+HBUtils.h"
#import "NSAttributedString+HBUtils.h"

@implementation UILabel (HBUtils)
- (void)addKernelWithValue:(float)value
{
    if (self.attributedText) {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        [att addKernelWithValue:value];
        self.attributedText = att;
    }else if (self.text.length > 0) {
        UIFont *font = self.font;
        UIColor *color = self.textColor;
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: color}];
        [att addKernelWithValue:value];
        self.attributedText = att;
    }
}

- (void)addSpacingWithValue:(float)value
{
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.alignment = self.textAlignment;
    style.lineSpacing = value;
    if (self.attributedText) {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        [att addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, att.string.length)];
        self.attributedText = att;
    }else if (self.text.length > 0) {
        UIFont *font = self.font;
        UIColor *color = self.textColor;
        if (font && color) {
            NSAttributedString *att = [[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: style}];
            self.attributedText = att;
        }
    }
}
@end

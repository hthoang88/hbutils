//
//  UIView+HBUtils.m
//  HBUtils
//
//  Created by Hoang Ho on 9/29/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "UIView+HBUtils.h"

@implementation UIView (HBUtils)

- (UITapGestureRecognizer *)addTapGestureWithTarget:(id)targer
                                           selector:(SEL)selector
{
    if (targer && selector) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:targer action:selector];
        [self addGestureRecognizer:tap];
        return tap;
    }
    return nil;
}

- (void)border:(UIColor* _Nullable)borderColor
          with:(CGFloat)borderWidth
        radius:(CGFloat)radius
{
    if (borderColor) {
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = borderColor.CGColor;
    }else{
        self.layer.borderColor = nil;
        self.layer.borderWidth = 0.0;
    }
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

@end

//
//  UIButton+Helper.m
//  HBMonNgonMoiNgay
//
//  Created by Ho Thai Hoang on 5/9/17.
//  Copyright © 2017 HoangHo. All rights reserved.
//

#import "UIButton+HBUtils.h"
#import <objc/runtime.h>
#import "EXTScope.h"

@implementation UIButton (HBUtils)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    [self setBackgroundImage:[self imageWithColor:color] forState:state];
}

- (void)setImageTintColor:(UIColor *)color forState:(UIControlState)state
{
    if (self.imageView.image){
        UIImage *tintedImage = [self imageForState:state];
        tintedImage = [self tintedImageWithColor:color image:tintedImage];
        [self setImage:tintedImage forState:state];
    }
    else
        NSLog(@"%@ UIButton does not have any image to tint.", self);
}

- (void)setTouchAction:(void(^)(UIButton *button))action
{
    //Clear current registerd touch event
    NSSet *allTargets = self.allTargets;
    for (id target in allTargets) {
        NSArray *touchActions = [self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
        for (id action in touchActions) {
            [self removeTarget:target action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.touchActionCallBack = action;
    [self addTarget:self action:@selector(didTouchButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTouchButton:(UIButton*)sender {
    self.window.userInteractionEnabled = NO;
    self.selected = YES;
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self)
        self.window.userInteractionEnabled = YES;
        void(^touchActionCallBack)(UIButton*) = self.touchActionCallBack;
        if (touchActionCallBack) {
            touchActionCallBack(self);
        }
        self.selected = NO;
    });
}

static char TAG_TOUCH_ACTION;

- (id )touchActionCallBack {
    return (id)objc_getAssociatedObject(self, &TAG_TOUCH_ACTION);
}

- (void)setTouchActionCallBack:(id)action {
    objc_setAssociatedObject(self, &TAG_TOUCH_ACTION, action, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - Utils

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)tintedImageWithColor:(UIColor *)tintColor image:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // draw alpha-mask
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, image.CGImage);
    
    // draw tint color, preserving alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [tintColor setFill];
    CGContextFillRect(context, rect);
    
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return coloredImage;
}

@end

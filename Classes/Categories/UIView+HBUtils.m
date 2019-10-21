//
//  UIView+HBUtils.m
//  HBUtils
//
//  Created by Hoang Ho on 9/29/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "UIView+HBUtils.h"
#import <objc/runtime.h>

@implementation UIView (HBUtils)
static char TAG_LONG_GESTURE_ACTION;
static char TAG_TAP_GESTURE_ACTION;

- (id )longGestureActionCallBack {
    return (id)objc_getAssociatedObject(self, &TAG_LONG_GESTURE_ACTION);
}

- (void)setLongGestureActionCallBack:(id)action {
    objc_setAssociatedObject(self, &TAG_LONG_GESTURE_ACTION, action, OBJC_ASSOCIATION_RETAIN);
}

- (id )tapGestureActionCallBack {
    return (id)objc_getAssociatedObject(self, &TAG_TAP_GESTURE_ACTION);
}

- (void)setTapGestureActionCallBack:(id)action {
    objc_setAssociatedObject(self, &TAG_TAP_GESTURE_ACTION, action, OBJC_ASSOCIATION_RETAIN);
}


- (UITapGestureRecognizer *)addTapGesture:(void(^)(UIView *btn))action {
    NSArray *gestures = self.gestureRecognizers;
    for (id g in gestures) {
        if ([g isMemberOfClass:[UITapGestureRecognizer class]]) {
            [self removeGestureRecognizer:g];
        }
    }
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customTapGestureTap:)];
    [self addGestureRecognizer:tapGesture];
    self.tapGestureActionCallBack = action;
    return tapGesture;
}

- (UILongPressGestureRecognizer*)addLongGestureAction:(void(^)(UIView *btn))action {
    //Clear current registerd touch event
    NSArray *gestures = self.gestureRecognizers;
    for (id g in gestures) {
        if ([g isMemberOfClass:[UILongPressGestureRecognizer class]]) {
            [self removeGestureRecognizer:g];
        }
    }
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(customLongGestureTap:)];
    [self addGestureRecognizer:longGesture];
    self.longGestureActionCallBack = action;
    return longGesture;
}

- (void)customLongGestureTap:(UILongPressGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        void(^longGestureActionCallBack)(UIView*) = self.longGestureActionCallBack;
        if (longGestureActionCallBack) {
            longGestureActionCallBack(self);
        }
    }
}

- (void)customTapGestureTap:(UITapGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        void(^tapGestureActionCallBack)(UIView*) = self.tapGestureActionCallBack;
        if (tapGestureActionCallBack) {
            tapGestureActionCallBack(self);
        }
    }
}

- (void)border:(UIColor* _Nullable)borderColor
          width:(CGFloat)borderWidth
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

- (BOOL)containsSubView:(UIView *)subView
{
    for (UIView *view in [self subviews]) {
        if ([view isEqual:subView]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)containsSubViewOfClassType:(Class)class {
    for (UIView *view in [self subviews]) {
        if ([view isMemberOfClass:class]) {
            return YES;
        }
    }
    return NO;
}

- (id)subViewWithClass:(Class)cl {
    for (UIView *view in [self subviews]) {
        if ([view isMemberOfClass:cl]) {
            return view;
        }
        return [view subViewWithClass:cl];
    }
    return nil;
}


- (CGPoint)frameOrigin {
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)newOrigin {
    self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)newSize {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            newSize.width, newSize.height);
}

- (CGFloat)frameX {
    return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)newX {
    self.frame = CGRectMake(newX, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameY {
    return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)newY {
    self.frame = CGRectMake(self.frame.origin.x, newY,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameRight {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameRight:(CGFloat)newRight {
    self.frame = CGRectMake(newRight - self.frame.size.width, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameBottom:(CGFloat)newBottom {
    self.frame = CGRectMake(self.frame.origin.x, newBottom - self.frame.size.height,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameWidth {
    return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)newWidth {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            newWidth, self.frame.size.height);
}

- (CGFloat)frameHeight {
    return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)newHeight {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            self.frame.size.width, newHeight);
}

- (CGFloat)frameCenterX
{
    return self.frameX + self.frameWidth/ 2;
}

- (CGFloat)frameCenterY
{
    return (self.frameY + self.frameHeight) / 2;
}

@end

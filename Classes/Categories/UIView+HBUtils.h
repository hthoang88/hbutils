//
//  UIView+HBUtils.h
//  HBUtils
//
//  Created by Hoang Ho on 9/29/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HBUtils)
- (UITapGestureRecognizer *)addTapGesture:(void(^)(UIView *btn))action;

- (UILongPressGestureRecognizer*)addLongGestureAction:(void(^)(UIView *btn))action;

- (void)border:(UIColor* _Nullable)color
          with:(CGFloat)borderWidth
        radius:(CGFloat)radius;

@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

// Setting these modifies the origin but not the size.
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

@property (nonatomic, readonly) CGFloat frameCenterX;
@property (nonatomic, readonly) CGFloat frameCenterY;

- (BOOL)containsSubView:(UIView *)subView;
- (BOOL)containsSubViewOfClassType:(Class)class;
- (id)subViewWithClass:(Class)cl;

@end

NS_ASSUME_NONNULL_END

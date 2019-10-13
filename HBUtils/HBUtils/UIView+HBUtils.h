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
- (UITapGestureRecognizer *)addTapGestureWithTarget:(id _Nullable)targer
                                           selector:(SEL _Nullable)selector;

- (void)border:(UIColor* _Nullable)color
          with:(CGFloat)borderWidth
        radius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END

//
//  UIButton+HBUtils.h
//  HBMonNgonMoiNgay
//
//  Created by Ho Thai Hoang on 5/9/17.
//  Copyright © 2017 HoangHo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Helper)

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

- (void)setTouchAction:(void(^)(UIButton *button))action;

-(void)setImageTintColor:(UIColor *)color forState:(UIControlState)state;
@end


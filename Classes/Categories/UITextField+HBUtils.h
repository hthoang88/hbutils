//
//  UITextField+HBUtils.h
//  HBMonNgonMoiNgay
//
//  Created by Ho Thai Hoang on 12/26/16.
//  Copyright © 2016 HoangHo. All rights reserved.
//

@import UIKit;
@import Foundation;

@interface UITextField (HBUtils)
- (void)setPlaceHolderWithString:(NSString*)str color:(UIColor*)color font:(UIFont*)font;
- (void)addLeftPagingWithWidth:(CGFloat)width;
- (void)addToolbar:(id)target
         leftTitle:(NSString*)leftTitle
      leftSelector:(SEL)leftSelector
        rightTitle:(NSString*)rightTitle
     rightSelector:(SEL)rightSelector;
@end

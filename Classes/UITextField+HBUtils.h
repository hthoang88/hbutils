//
//  UITextField+HBUtils.h
//  HBMonNgonMoiNgay
//
//  Created by Ho Thai Hoang on 12/26/16.
//  Copyright © 2016 HoangHo. All rights reserved.
//

@import UIKit;
@import Foundation;

@interface UITextField (Helper)
- (void)setPlaceHolderWithString:(NSString*)str color:(UIColor*)color font:(UIFont*)font;
- (void)addLeftPagingWithWidth:(CGFloat)width;
@end

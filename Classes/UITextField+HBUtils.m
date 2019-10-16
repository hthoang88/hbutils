//
//  UITextField+Helper.m
//  HBMonNgonMoiNgay
//
//  Created by Ho Thai Hoang on 12/26/16.
//  Copyright © 2016 HoangHo. All rights reserved.
//

#import "UITextField+HBUtils.h"

@implementation UITextField (Helper)
- (void)setPlaceHolderWithString:(NSString*)str color:(UIColor*)color font:(UIFont*)font
{
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName : color}];
    [self setAttributedPlaceholder:att];
}

- (void)addLeftPagingWithWidth:(CGFloat)width
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
    paddingView.backgroundColor = [UIColor clearColor];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}
@end

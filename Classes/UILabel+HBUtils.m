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

@implementation UILabel (Helper)
- (CGFloat)getContentWidth
{
    return [self.text contentWidthWithFont:self.font fitHeight:self.frameHeight] + 5;
}

- (CGFloat)getContentHeight
{
    return [self.text contentHeightWithFont:self.font fitWidth:self.frameWidth] + 5;
}

@end

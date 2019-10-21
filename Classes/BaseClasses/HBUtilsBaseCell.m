//
//  HBUtilsBaseCell.m
//  HBUtils
//
//  Created by Hoang Ho on 10/18/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "HBUtilsBaseCell.h"

@implementation HBUtilsBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self prepareForReuse];
}

+ (CGFloat)cellHeight:(id)obj fixWidth:(CGFloat)fixWidth
{
    return 44;
}

+ (NSString*)cellId
{
    return [[self class] description];
}

+ (UINib*)nibOfCell
{
    return [UINib nibWithNibName:self.cellId bundle:[NSBundle bundleForClass:[self class]]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.window endEditing:YES];
}

@end

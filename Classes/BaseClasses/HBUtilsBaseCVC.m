//
//  HBUtilsBaseCVC.m
//  HBUtils
//
//  Created by Hoang Ho on 10/18/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "HBUtilsBaseCVC.h"

@implementation HBUtilsBaseCVC
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self prepareForReuse];
}

+ (CGSize)cellSize:(id)obj colletionView:(UICollectionView*)clv;
{
    return CGSizeMake(100, 100);
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

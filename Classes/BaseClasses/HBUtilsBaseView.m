//
//  HBUtilsBaseView.m
//  HBUtils
//
//  Created by Hoang Ho on 11/10/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "HBUtilsBaseView.h"

@implementation HBUtilsBaseView
+(instancetype)viewWithFrame:(CGRect)frame
{
    return [self viewWithNibName:nil frame:frame];
}

+(instancetype)viewWithNibName:(NSString*)nibName frame:(CGRect)frame
{
    NSString *name = nibName;
    if (!name) {
        name = [[self class] description];
    }
    HBUtilsBaseView *instance = [[[NSBundle bundleForClass:[self class]] loadNibNamed:name owner:self options:nil] lastObject];
    instance.frame = frame;
    return instance;
}
@end

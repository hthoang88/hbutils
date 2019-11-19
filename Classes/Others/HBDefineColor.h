//
//  HBDefineColor.h
//  HBUtils
//
//  Created by Hoang Ho on 10/13/19.
//  Copyright © 2019 HB. All rights reserved.
//

#ifndef HBDefineColor_h
#define HBDefineColor_h


#endif /* HBDefineColor_h */

#define kRedColor                   [UIColor redColor]
#define kGreenColor                 [UIColor greenColor]
#define kWhiteColor                 [UIColor whiteColor]
#define kBlackColor                 [UIColor blackColor]
#define kClearColor                 [UIColor clearColor]
#define kLightGrayColor             [UIColor lightGrayColor]
#define kDarkColor                  [UIColor darkGrayColor]

#define RGBCOLOR(r, g, b)             [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBCOLOR_SAME(v)             [UIColor colorWithRed:(v)/255.0f green:(v)/255.0f blue:(v)/255.0f alpha:1]
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

//
//  HBUtilsBaseView.h
//  HBUtils
//
//  Created by Hoang Ho on 11/10/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBUtilsBaseView : UIView
+ (instancetype)viewWithFrame:(CGRect)frame;
+ (instancetype)viewWithNibName:(NSString* _Nullable)nibName frame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END

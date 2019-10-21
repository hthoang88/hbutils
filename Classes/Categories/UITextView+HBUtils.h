//
//  UITextView+HBUtils.h
//  HBUtils
//
//  Created by Hoang Ho on 10/18/19.
//  Copyright © 2019 HB. All rights reserved.
//

@import UIKit;
@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (HBUtils)
- (void)addToolbar:(id)target
         leftTitle:(NSString*)leftTitle
      leftSelector:(SEL)leftSelector
        rightTitle:(NSString*)rightTitle
     rightSelector:(SEL)rightSelector;
@end

NS_ASSUME_NONNULL_END

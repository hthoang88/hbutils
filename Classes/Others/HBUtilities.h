//
//  HBUtilities.h
//  HBUtils
//
//  Created by Hoang Ho on 10/28/19.
//  Copyright © 2019 HB. All rights reserved.
//

@import UIKit;
@import Foundation;
NS_ASSUME_NONNULL_BEGIN

@interface HBUtilities : NSObject
+ (UICollectionViewFlowLayout*)horizontalCollectionFlowLayout;
+ (UICollectionViewFlowLayout*)verticalCollectionFlowLayout;
+ (CGFloat)keyboardHeighWithNotification:(NSNotification*)note;
@end

NS_ASSUME_NONNULL_END

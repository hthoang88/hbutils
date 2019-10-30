//
//  HBUtilities.m
//  HBUtils
//
//  Created by Hoang Ho on 10/28/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "HBUtilities.h"

@implementation HBUtilities
+ (UICollectionViewFlowLayout*)horizontalCollectionFlowLayout {
    UICollectionViewFlowLayout *layout = [self standardCollectionFlowLayout];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}
+ (UICollectionViewFlowLayout*)verticalCollectionFlowLayout {
    UICollectionViewFlowLayout *layout = [self standardCollectionFlowLayout];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return layout;
}

+ (CGFloat)keyboardHeighWithNotification:(NSNotification*)note {
    NSDictionary *userInfo = note.userInfo;
    NSValue *value = userInfo[UIKeyboardFrameEndUserInfoKey];
    return value.CGRectValue.size.height;
}

+ (UICollectionViewFlowLayout*)standardCollectionFlowLayout {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    return layout;
}

@end

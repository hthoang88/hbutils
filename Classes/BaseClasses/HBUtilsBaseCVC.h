//
//  HBUtilsBaseCVC.h
//  HBUtils
//
//  Created by Hoang Ho on 10/18/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBUtilsBaseCVC : UICollectionViewCell
+ (UINib*)nibOfCell;
+ (CGSize)cellSize:(id)obj colletionView:(UICollectionView*)clv;
+ (NSString*)cellId;

@property (strong, nonatomic) id model;
@property (weak, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) UICollectionView *clv;

@end

NS_ASSUME_NONNULL_END

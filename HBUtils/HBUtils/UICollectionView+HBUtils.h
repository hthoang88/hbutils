//
//  UICollectionView+HBUtils.h
//  HBUtils
//
//  Created by Hoang Ho on 9/29/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (HBUtils)
- (void)registerCellId:(NSString*)cellId;
- (void)registerHeaderId:(NSString*)headerId;
- (void)registerEmptyCell;
- (UICollectionViewCell *)emptyCell:(NSIndexPath*)indexPath;
- (UICollectionViewFlowLayout*)flowLayout;
- (BOOL)containIndexPath:(NSIndexPath*)indexPath;
@end

@interface UICollectionViewController (FixCrash) <UIViewControllerPreviewingDelegate>
- (UIViewController * _Nullable)previewingContext:(id<UIViewControllerPreviewing> _Nullable)previewingContext viewControllerForLocation:(CGPoint)location;
- (void)previewingContext:(id<UIViewControllerPreviewing> _Nullable)previewingContext
     commitViewController:(UIViewController * _Nullable)viewControllerToCommit;
@end

NS_ASSUME_NONNULL_END


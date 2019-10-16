//
//  UICollectionView+HBUtils.m
//  HBUtils
//
//  Created by Hoang Ho on 9/29/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "UICollectionView+HBUtils.h"

@implementation UICollectionView (HBUtils)
- (void)registerCellId:(NSString*)cellId
{
    UINib *nib = [UINib nibWithNibName:cellId bundle:nil];
    [self registerNib:nib forCellWithReuseIdentifier:cellId];
}

- (void)registerHeaderId:(NSString*)headerId {
    UINib *nib = [UINib nibWithNibName:headerId bundle:nil];
    [self registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
}

- (void)registerEmptyCell {
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"HBUtils_EmptyCVC"];
}

- (UICollectionViewCell *)emptyCell:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"HBUtils_EmptyCVC" forIndexPath:indexPath];
    cell.contentView.backgroundColor = UIColor.clearColor;
    cell.backgroundColor = UIColor.clearColor;
    NSLog(@"Empty cell for collection view at %@", indexPath);
    return cell;
}

- (UICollectionViewFlowLayout*)flowLayout {
    UICollectionViewFlowLayout *layout = (id)self.collectionViewLayout;
    if ([layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        return layout;
    }
    return nil;
}

- (BOOL)containIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section < self.numberOfSections &&
        indexPath.row < [self numberOfItemsInSection:indexPath.section]) {
        return true;
    }
    return false;
}
@end

@implementation UICollectionViewController (FixCrash)
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    return nil;
}
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
     commitViewController:(UIViewController *)viewControllerToCommit {
    return;
}
@end

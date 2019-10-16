//
//  UITableView+HBUtils.h
//  HBUtils
//
//  Created by Hoang Ho on 10/16/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (HBUtils)
- (void)registerCellId:(NSString*)cellId;

- (void)registerHeaderId:(NSString*)headerId;

- (void)registerEmptyCell;

- (UITableViewCell*)emptyCell:(NSIndexPath*)indexPath;

- (void)scrollToBottom:(BOOL)animated;

- (void)scrollToTop:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

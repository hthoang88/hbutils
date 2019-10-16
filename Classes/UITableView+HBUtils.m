//
//  UITableView+HBUtils.m
//  HBUtils
//
//  Created by Hoang Ho on 10/16/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "UITableView+HBUtils.h"

@implementation UITableView (HBUtils)
- (void)registerCellId:(NSString*)cellId
{
    [self registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
}

- (void)registerHeaderId:(NSString*)headerId {
    UINib *nib = [UINib nibWithNibName:headerId bundle:nil];
    [self registerNib:nib forHeaderFooterViewReuseIdentifier:headerId]; 
}

- (void)registerEmptyCell {
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HBUtils_EmptyCell"];
}

- (UITableViewCell*)emptyCell:(NSIndexPath*)indexPath {
    return [self dequeueReusableCellWithIdentifier:@"HBUtils_EmptyCell"];
}

- (void)scrollToBottom:(BOOL)animated
{
    NSInteger section = [self numberOfSections] - 1;
    NSInteger row = [self numberOfRowsInSection:section] - 1;
    if (section >= 0 &&
        row >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
    }
}

- (void)scrollToTop:(BOOL)animated
{
    [self setContentOffset:CGPointZero animated:animated];
}
@end

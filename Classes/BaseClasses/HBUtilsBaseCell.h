//
//  HBUtilsBaseCell.h
//  HBUtils
//
//  Created by Hoang Ho on 10/18/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBUtilsBaseCell : UITableViewCell
+ (UINib*)nibOfCell;
+ (CGFloat)cellHeight:(id)obj fixWidth:(CGFloat)fixWidth;
+ (NSString*)cellId;

@property (strong, nonatomic) id model;
@property (weak, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END

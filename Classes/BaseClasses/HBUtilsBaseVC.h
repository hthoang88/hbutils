//
//  HBUtilsBaseVC.h
//  HBUtils
//
//  Created by Hoang Ho on 10/18/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBUtilsBaseVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView* headerView;
@property (weak, nonatomic) IBOutlet UIView* contentView;
@property (weak, nonatomic) IBOutlet UILabel* titleHeaderLabel;
@property (weak, nonatomic) IBOutlet UIButton* backBtn;

- (void)setupUI;

- (void)prepareForRelease;

- (IBAction)backAction:(id _Nullable)sender;
- (IBAction)closeAction:(id _Nullable)sender;

@end

NS_ASSUME_NONNULL_END

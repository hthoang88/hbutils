//
//  UIViewController+HBUtils.h
//  HBUtils
//
//  Created by Hoang Ho on 10/28/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MZFormSheetPresentationViewController;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HBUtils)
- (void)removeKeyboardNotifications;

- (void)registerKeyboardNotification:(SEL _Nullable)showSelector hideSelector:(SEL _Nullable)hideSelector;

- (MZFormSheetPresentationViewController *)showSheetControllerWithController:(UIViewController*)viewController
                                                                   sheetSize:(CGSize)sheetSize
                                                             transitionStyle:(NSInteger)transitionStyle
                                                  canDissmissOnBackgroundTap:(BOOL)canDissmissONBackgroundTap;

+ (instancetype)instance:(UIStoryboard*)storyboard;

@end

NS_ASSUME_NONNULL_END

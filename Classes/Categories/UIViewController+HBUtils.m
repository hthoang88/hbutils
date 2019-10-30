//
//  UIViewController+HBUtils.m
//  HBUtils
//
//  Created by Hoang Ho on 10/28/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "UIViewController+HBUtils.h"
#import "HBUtilsMacros.h"
@import MZFormSheetPresentationController;

@implementation UIViewController (HBUtils)
- (void)removeKeyboardNotifications
{
    [NTF_CENTER removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [NTF_CENTER removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)registerKeyboardNotification:(SEL)showSelector hideSelector:(SEL)hideSelector
{
    if (showSelector) {
        [NTF_CENTER addObserver:self
                       selector:showSelector
                           name:UIKeyboardWillShowNotification
                         object:nil];
    }
    if (hideSelector) {
        [NTF_CENTER addObserver:self
                       selector:hideSelector
                           name:UIKeyboardWillHideNotification
                         object:nil];
        
    }
}

- (MZFormSheetPresentationViewController *)showSheetControllerWithController:(UIViewController*)viewController
                                                                   sheetSize:(CGSize)sheetSize
                                                             transitionStyle:(NSInteger)transitionStyle
                                                  canDissmissOnBackgroundTap:(BOOL)canDissmissONBackgroundTap
{
    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:viewController];
    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = canDissmissONBackgroundTap;
    formSheetController.presentationController.shouldCenterVertically = YES;
    formSheetController.presentationController.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppearsCenterVertically;
    formSheetController.presentationController.contentViewSize = sheetSize;
    
    __weak __typeof__(formSheetController) weakFormSheet = formSheetController;
    formSheetController.willPresentContentViewControllerHandler = ^(UIViewController *a) {
        weakFormSheet.contentViewCornerRadius = 0.0f;
        weakFormSheet.shadowRadius = 0.0f;
    };
    
    formSheetController.contentViewControllerTransitionStyle = transitionStyle;
    [self presentViewController:formSheetController animated:(transitionStyle != MZFormSheetPresentationTransitionStyleNone) completion:nil];
    
    if ([viewController respondsToSelector:@selector(frameConfigurationHandler)]) {
        formSheetController.presentationController.frameConfigurationHandler = [viewController performSelector:@selector(frameConfigurationHandler)];
    }
    return formSheetController;
}
@end

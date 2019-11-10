//
//  HBUtilsBaseFormSheetVC.m
//  HBUtils
//
//  Created by Hoang Ho on 11/10/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "HBUtilsBaseFormSheetVC.h"
#import "HBUtilsMacros.h"
@import MZFormSheetPresentationController;

@implementation HBUtilsBaseFormSheetVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

- (IBAction)closeAction:(id _Nullable)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupUI{
    
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#else
- (NSUInteger)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)dealloc
{
    [NTF_CENTER removeObserver:self];
}

- (CGSize)sheetSize
{
    return CGSizeMake(600, 600);
}

- (void)changeSizeDuration:(float)duration newSize:(CGSize)size completion:(void (^ __nullable)(BOOL finished))completion
{
    [UIView animateWithDuration:duration animations:^{
        [[[self mz_formSheetPresentingPresentationController] presentationController] setContentViewSize:size];
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

- (BOOL)prefersStatusBarHidden {
    return false;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end

@implementation BANavigationFormSheetController
- (CGRect (^)(UIView * _Nonnull presentedView, CGRect formSheetRect, BOOL isKeyboardVisible))frameConfigurationHandler
{
    HBUtilsBaseFormSheetVC *vc = self.viewControllers.lastObject;
    if ([vc respondsToSelector:@selector(frameConfigurationHandler)]) {
        return [vc frameConfigurationHandler];
    }
    return nil;
}

@end


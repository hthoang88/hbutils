//
//  HBBaseRewardVideo.m
//  HBTruyenTranh
//
//  Created by Hoang Ho on 10/26/18.
//  Copyright © 2018 HoangHo. All rights reserved.
//

#import "HBBaseRewardVideo.h"
#import "HBAdRewardProvider.h"
#import "HBUtilsMacros.h"
#import "HBDefineColor.h"
#import "UIView+HBUtils.h"
#import "UIViewController+HBUtils.h"
#import "HBUtilities+Alert.h"

@implementation HBBaseRewardVideo
- (void)configAd {
    DLog(@"HAVE TO IMPLEMENT IN SUBCLASS");
}

- (void)loadAd {
    DLog(@"HAVE TO IMPLEMENT IN SUBCLASS");
}

- (BOOL)shouldShowFullAds {
    if (!AD_PROVIDER.admodConfig.enableMagicRewardVideo.boolValue) {
        return true;
    }
    NSInteger rewardFullCount = [USER_DEFAULT integerForKey:key_RewardVideoFullCount];
    if (AD_PROVIDER.admodConfig.timeToShowFullAd.integerValue > 0 &&
        rewardFullCount >= AD_PROVIDER.admodConfig.timeToShowFullAd.integerValue) {
        return true;
    }
    return false;
}

- (BOOL)shouldShowAdClickMessage {
    if (self.shouldShowFullAds) {
        return AD_PROVIDER.admodConfig.timeToShowFullAd.integerValue > 0 &&
        AD_PROVIDER.admodConfig.rewardVideoMinimumTime.integerValue > 0;
    }
    return AD_PROVIDER.admodConfig.rewardVideoMinimumTime.integerValue > 0;
}

- (void)showAd:(BOOL)shouldReset {
    DLog(@"HAVE TO IMPLEMENT IN SUBCLASS");
}

- (void)showSheetCompletion:(void(^)(UIViewController *contentViewController))completion {
    UIViewController *rootVC = [self currentRootVC];
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = kClearColor;
    
    MZFormSheetPresentationViewController *sheet =
    [rootVC showSheetControllerWithController:vc
                                    sheetSize:rootVC.view.window.frameSize
                              transitionStyle:12
                   canDissmissOnBackgroundTap:false];
    
    sheet.presentationController.backgroundColor = kClearColor;
    self.presentingSheet = sheet;
    [sheet setDidPresentContentViewControllerHandler:^(UIViewController * _Nonnull contentViewController) {
        DISPATCH_ASYNC_AFTER(1.0, ^{
            if (vc.view.window &&
                !AD_PROVIDER.isShowingRewardVideo) {
                AD_PROVIDER.isShowingRewardVideo = true;
                
                //reset didPresentContentViewControllerHandler
                self.presentingSheet.didPresentContentViewControllerHandler = nil;
                if (completion) {
                    [HBUtilities closeAlertView:false];
                    completion(contentViewController);
                }
            }
        });
    }];
}

- (UIViewController*)currentRootVC {
    UIViewController *rootVC = [AD_PROVIDER valueWith:AD_PROVIDER.key_rootVC];
    while (rootVC.presentedViewController) {
        rootVC = rootVC.presentedViewController;
    }
    
    return rootVC;
}

- (BOOL)prepareShowAd:(BOOL)shouldReset {
    
    if (UIApplication.sharedApplication.applicationState != UIApplicationStateActive) {
        return false;
    }
    
    DLog(@"%@: showAd", NSStringFromClass([self class]));
    
    [HBUtilities closeAlertView:false];
    
    AD_PROVIDER.isLoadingRewardVideo = false;
    
    NSInteger rewardCount = [USER_DEFAULT integerForKey:key_RewardVideoCount];
    if (rewardCount < AD_PROVIDER.admodConfig.timeToShowRewardVideo.integerValue) {
        return false;
    }
    
    if (shouldReset) {
        [AD_PROVIDER resetRewardVideoCount];
    }
    return true;
}
@end

//
//  HBGoogleAdReward.m
//  HBTruyenTranh
//
//  Created by Hoang Ho on 10/25/18.
//  Copyright © 2018 HoangHo. All rights reserved.
//

#import "HBGoogleAdReward.h"
#import "HBUtilsMacros.h"
#import "HBAdRewardProvider.h"
#import "UIView+HBUtils.h"
@import GoogleMobileAds;
@import AVFoundation;

@interface HBGoogleAdReward()<GADRewardedAdDelegate>
@property(nonatomic, strong) GADRewardedAd *rewardedAd;
@end


@implementation HBGoogleAdReward
+ (nonnull HBGoogleAdReward*)shared
{
    static HBGoogleAdReward *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[HBGoogleAdReward alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self configAd];
    }
    return self;
}

#pragma mark - HBAdRewardProtocol
- (void)configAd {
    //Does not config applicationID, GADMobileAds will load from plist file
    //    [GADMobileAds configureWithApplicationID:AD_PROVIDER.admodConfig.googleAdAppId];
#ifdef DEBUG
    //Test App for reward video
//    Rewarded Video     ca-app-pub-3940256099942544/1712485313
    GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers =
    @[@"ca-app-pub-3940256099942544/1712485313"];
#endif
    
    self.rewardedAd = [[GADRewardedAd alloc]
                       initWithAdUnitID:AD_PROVIDER.admodConfig.googleAdRewardId];
    [self loadAd];
}

- (void)loadAd {

    if (AD_PROVIDER.isShowingRewardVideo) {
        return;
    }
    
    if (self.rewardedAd.isReady) {
        NSInteger rewardCount = [USER_DEFAULT integerForKey:key_RewardVideoCount];
        UIViewController *rootVC = [AD_PROVIDER valueWith:AD_PROVIDER.key_rootVC];
        if (rootVC &&
            rewardCount >= AD_PROVIDER.admodConfig.timeToShowRewardVideo.integerValue) {
            [self showAd:true];
        }
    }else {
        if (!AD_PROVIDER.isLoadingRewardVideo &&
            !AD_PROVIDER.isShowingRewardVideo) {
            AD_PROVIDER.isLoadingRewardVideo = true;
            DLog(@"%@: loadAd", NSStringFromClass([self class]));
            
            GADRequest *request = [GADRequest request];
            [self.rewardedAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
                if (error) {
                    AD_PROVIDER.isLoadingRewardVideo = false;
                    AD_PROVIDER.isShowingRewardVideo = false;
                    DLog(@"Reward based video ad failed to load. %@", error.debugDescription);
                }else {
                    if (self.rewardedAd.isReady) {
                        NSInteger rewardCount = [USER_DEFAULT integerForKey:key_RewardVideoCount];
                        UIViewController *rootVC = [AD_PROVIDER valueWith:AD_PROVIDER.key_rootVC];
                        if (rootVC &&
                            rewardCount >= AD_PROVIDER.admodConfig.timeToShowRewardVideo.integerValue) {
                            [self showAd:true];
                        }
                    }
                }
            }];
        }
    }
}

- (void)showAd:(BOOL)shouldReset {
    if (![self prepareShowAd:shouldReset]) {
        return;
    }
    
    UIViewController *rootVC = [self currentRootVC];
    
    NSString *str = [AD_PROVIDER valueWith:AD_PROVIDER.key_warningAdAppear];
    UIWindow *window = [AD_PROVIDER valueWith:AD_PROVIDER.key_window];
    if (str.length > 0 &&
        window) {
        HBProgressHUD* hub = [window showHUDText:str hideAfterSecond:2.0 completion:^{
            if (!self.shouldShowFullAds) {
                [self showSheetCompletion:^(UIViewController *contentViewController) {
                    [self.rewardedAd presentFromRootViewController:contentViewController delegate:self];
                }];
            }else {
                if (rootVC.view.window) {
                    AD_PROVIDER.isShowingRewardVideo = true;
                    [self.rewardedAd presentFromRootViewController:rootVC delegate:self];
                }
            }
        }];
        hub.labelFont = FONT_REGULAR(12);
    }else {
        if (!self.shouldShowFullAds) {
            [self showSheetCompletion:^(UIViewController *contentViewController) {
                [self.rewardedAd presentFromRootViewController:contentViewController delegate:self];
            }];
        }else {
            if (rootVC.view.window) {
                AD_PROVIDER.isShowingRewardVideo = true;
                [self.rewardedAd presentFromRootViewController:rootVC delegate:self];
            }
        }
    }
}

#pragma mark - GADRewardedAdDelegate

/// Tells the delegate that the user earned a reward.
- (void)rewardedAd:(nonnull GADRewardedAd *)rewardedAd
 userDidEarnReward:(nonnull GADAdReward *)reward {
    DLog(@"didRewardUserWithReward");
    AD_PROVIDER.isShowingRewardVideo = false;
    
    if (AD_PROVIDER.admodConfig.enableMagicRewardVideo.boolValue &&
        self.presentingSheet) {
        if (AD_PROVIDER.admodConfig.timeToDelayCloseAd.integerValue > 0) {
            AD_PROVIDER.isShowingRewardVideo = true;
            int delay = (rand() % 5) + 5;
            float delayTime = ((float)delay/10.0) * AD_PROVIDER.admodConfig.timeToDelayCloseAd.floatValue;
            DISPATCH_ASYNC_AFTER(delayTime, ^{
                UIViewController *rootVC = [self currentRootVC];
                
                if ([NSStringFromClass([rootVC class]) rangeOfString:@"GAD"].location != NSNotFound) {
                    [rootVC dismissViewControllerAnimated:false completion:nil];
                }
                if (self.presentingSheet) {
                    [self.presentingSheet dismissViewControllerAnimated:false completion:nil];
                    self.presentingSheet = nil;
                }
                AD_PROVIDER.isShowingRewardVideo = false;
            });
        }else {
            UIViewController *rootVC = [self currentRootVC];
            
            if ([NSStringFromClass([rootVC class]) rangeOfString:@"GAD"].location != NSNotFound) {
                [rootVC dismissViewControllerAnimated:false completion:nil];
            }
            if (self.presentingSheet) {
                [self.presentingSheet dismissViewControllerAnimated:false completion:nil];
                self.presentingSheet = nil;
            }
        }
    }
    if (!AD_PROVIDER.admodConfig.requireViewReward.boolValue) {
        [AD_PROVIDER.rewardVideoView removeFromSuperview];
    }
    if (AD_PROVIDER.admodConfig.enableMuteAdSound.boolValue &&
        AD_PROVIDER.volumnValue > 0) {
        [AD_PROVIDER resetVolumnValue:AD_PROVIDER.volumnValue];
    }
    [AD_PROVIDER resetStatusBarState];
}

/// Tells the delegate that the rewarded ad failed to present.
- (void)rewardedAd:(nonnull GADRewardedAd *)rewardedAd
didFailToPresentWithError:(nonnull NSError *)error {
    DLog(@"rewardedAd-didFailToPresentWithError: %@", error);
    AD_PROVIDER.isShowingRewardVideo = false;
    if (self.presentingSheet) {
        [self.presentingSheet dismissViewControllerAnimated:false completion:nil];
        self.presentingSheet = nil;
    }
    DLog(@"Reward based video ad is closed.");
    [AD_PROVIDER.rewardVideoView removeFromSuperview];
}

/// Tells the delegate that the rewarded ad was presented.
- (void)rewardedAdDidPresent:(nonnull GADRewardedAd *)rewardedAd {
    DLog(@"rewardedAdDidPresent");
    BOOL hasTranView = NO;
    UIViewController *vc = [self currentRootVC];
    
    if ([NSStringFromClass([vc class]) rangeOfString:@"GAD"].location != NSNotFound) {
        if ([self shouldShowFullAds] &&
            [self shouldShowAdClickMessage]) {
            [AD_PROVIDER showAdClickMessage:vc.view];
        }else {
            [AD_PROVIDER resetStatusBarState];
            id playerView = nil;
            UIWindow *window = [AD_PROVIDER valueWith:AD_PROVIDER.key_window];
            for (UIView *v in window.subviews) {
                if ([NSStringFromClass([v class]) rangeOfString:@"Tran"].location != NSNotFound) {
                    if (AD_PROVIDER.admodConfig.enableMuteAdSound.boolValue) {
                        if (!playerView) {
                            playerView = [v subViewWithClass:NSClassFromString(@"GADVideoPlayerView")];
                        }
                    }
                    [v.superview sendSubviewToBack:v];
                }
            }
            BOOL mutedSound = false;
            if (playerView) {
                id player = [playerView valueForKey:@"_player"];
                if ([player isKindOfClass:[AVPlayer class]]) {
                    AVPlayer *av = player;
                    av.muted = true;
                    mutedSound = true;
                }
            }
            if (!mutedSound &&
                AD_PROVIDER.admodConfig.enableMuteAdSound.boolValue) {
                [AD_PROVIDER muteSoundForShowingRewardVideo];
            }
            
            if (hasTranView) {
                DLog(@"Has Transition view.");
            }
            
            //Active AVAudioSession
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            [[AVAudioSession sharedInstance] setActive: YES error: nil];
        }
    }
}

/// Tells the delegate that the rewarded ad was dismissed.
- (void)rewardedAdDidDismiss:(nonnull GADRewardedAd *)rewardedAd {
    DLog(@"rewardedAdDidDismiss");
    AD_PROVIDER.isShowingRewardVideo = false;
    if (self.presentingSheet) {
        [self.presentingSheet dismissViewControllerAnimated:false completion:nil];
        self.presentingSheet = nil;
    }
    DLog(@"Reward based video ad is closed.");
    [AD_PROVIDER.rewardVideoView removeFromSuperview];
}

@end

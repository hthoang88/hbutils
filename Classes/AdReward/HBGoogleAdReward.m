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

@interface HBGoogleAdReward()<GADRewardBasedVideoAdDelegate>
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
    [GADMobileAds configureWithApplicationID:AD_PROVIDER.admodConfig.googleAdAppId];
    [self loadAd];
}

- (void)loadAd {
    [GADRewardBasedVideoAd sharedInstance].delegate = self;
    if (AD_PROVIDER.isShowingRewardVideo) {
        return;
    }
    
    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
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
#ifdef DEBUG
            request.testDevices = @[kGADSimulatorID];
#endif
            [[GADRewardBasedVideoAd sharedInstance] loadRequest:request
                                                   withAdUnitID:AD_PROVIDER.admodConfig.googleAdRewardId];
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
                    [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:contentViewController];
                }];
            }else {
                if (rootVC.view.window) {
                    AD_PROVIDER.isShowingRewardVideo = true;
                    [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:rootVC];
                }
            }
        }];
        hub.labelFont = FONT_REGULAR(12);
    }else {
        if (!self.shouldShowFullAds) {
            [self showSheetCompletion:^(UIViewController *contentViewController) {
                [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:contentViewController];
            }];
        }else {
            if (rootVC.view.window) {
                AD_PROVIDER.isShowingRewardVideo = true;
                [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:rootVC];
            }
        }
    }
}

#pragma mark - GADRewardBasedVideoAdDelegate
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
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
        [AD_PROVIDER.rewardVideoLabel removeFromSuperview];
    }
    if (AD_PROVIDER.admodConfig.enableMuteAdSound.boolValue &&
        AD_PROVIDER.volumnValue > 0) {
        [AD_PROVIDER resetVolumnValue:AD_PROVIDER.volumnValue];
    }
    [AD_PROVIDER resetStatusBarState];
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    DLog(@"Reward based video ad is received.");
    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
        NSInteger rewardCount = [USER_DEFAULT integerForKey:key_RewardVideoCount];
        UIViewController *rootVC = [AD_PROVIDER valueWith:AD_PROVIDER.key_rootVC];
        if (rootVC &&
            rewardCount >= AD_PROVIDER.admodConfig.timeToShowRewardVideo.integerValue) {
            [self showAd:true];
        }
    }
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    DLog(@"Opened reward based video ad.");
}


- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    DLog(@"Reward based video ad started playing.");
    
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

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    AD_PROVIDER.isShowingRewardVideo = false;
    if (self.presentingSheet) {
        [self.presentingSheet dismissViewControllerAnimated:false completion:nil];
        self.presentingSheet = nil;
    }
    DLog(@"Reward based video ad is closed.");
    [AD_PROVIDER.rewardVideoLabel removeFromSuperview];
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    AD_PROVIDER.isShowingRewardVideo = false;
    DLog(@"Reward based video ad will leave application.");
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {
    AD_PROVIDER.isLoadingRewardVideo = false;
    DLog(@"Reward based video ad failed to load. %@", error.debugDescription);
}
@end

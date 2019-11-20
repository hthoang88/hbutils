//
//  HBVungleRewardVideo.m
//  HBUtils
//
//  Created by Hoang Ho on 11/20/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "HBVungleRewardVideo.h"
#import "HBAdRewardProvider.h"
#import "HBUtilsMacros.h"
#import "UIView+HBUtils.h"
#import <VungleSDK/VungleSDK.h>
#import <VungleSDK/VungleSDKCreativeTracking.h>
#import <VungleSDK/VungleSDKHeaderBidding.h>
@import AVFoundation;
@import MZFormSheetPresentationController;

@interface HBVungleRewardVideo()<VungleSDKDelegate, VungleSDKCreativeTracking, VungleSDKHeaderBidding>
@end


@implementation HBVungleRewardVideo
+ (nonnull HBVungleRewardVideo*)shared
{
    static HBVungleRewardVideo *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[HBVungleRewardVideo alloc] init];
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
    NSError* error;
    NSString* appID = AD_PROVIDER.admodConfig.vungleAppId;
    VungleSDK* sdk = VungleSDK.sharedSDK;
    [sdk setDelegate:self];
#ifdef DEBUG
    [sdk setLoggingEnabled:true];
#endif
    if (AD_PROVIDER.admodConfig.enableMuteAdSound.boolValue) {
        sdk.muted = true;
    }else {
        sdk.muted = false;
    }
    
    [sdk startWithAppId:appID error:&error];
    if (error) {
        DLog(@"%@: configAd error %@", NSStringFromClass([self class]), error.debugDescription);
    }
    [sdk setCreativeTrackingDelegate:self];
    [sdk setHeaderBiddingDelegate:self];
}

- (void)loadAd {
    if (!VungleSDK.sharedSDK.isInitialized) {
        return;
    }
    if (AD_PROVIDER.isShowingRewardVideo) {
        return;
    }
    VungleSDK* sdk = VungleSDK.sharedSDK;
    
    UIViewController *rootVC = [self currentRootVC];
    if ([sdk isAdCachedForPlacementID:AD_PROVIDER.admodConfig.vungLeAdRewardId]) {
        NSInteger rewardCount = [USER_DEFAULT integerForKey:key_RewardVideoCount];
        if (rootVC &&
            rewardCount >= AD_PROVIDER.admodConfig.timeToShowRewardVideo.integerValue) {
            [self showAd:true];
        }
    }
    else if (!AD_PROVIDER.isLoadingRewardVideo &&
             !AD_PROVIDER.isShowingRewardVideo) {
        DLog(@"\n[===%@===]: loadAd\n", NSStringFromClass([self class]));
        AD_PROVIDER.isLoadingRewardVideo = true;
        NSError* error;
        [sdk loadPlacementWithID:AD_PROVIDER.admodConfig.vungLeAdRewardId error:&error];
    }
}

- (void)showAd:(BOOL)shouldReset {
    if (![self prepareShowAd:shouldReset]) {
        return;
    }
    
    UIViewController *rootVC = [self currentRootVC];
    
    if (self.presentingSheet) {
        [self.presentingSheet dismissViewControllerAnimated:false completion:nil];
        self.presentingSheet = nil;
    }
    if (rootVC.view.window) {
        NSString *str = [AD_PROVIDER valueWith:AD_PROVIDER.key_warningAdAppear];
        if (str && str.length > 0) {
            HBProgressHUD* hub = [rootVC.view.window showHUDText:str hideAfterSecond:2.0 completion:^{
                VungleSDK* sdk = [VungleSDK sharedSDK];
                NSError *error;
                [sdk playAd:rootVC options:nil placementID:AD_PROVIDER.admodConfig.vungLeAdRewardId error:&error];
                if (error) {
                    NSLog(@"Error encountered playing ad: %@", error);
                }else {
                    AD_PROVIDER.isShowingRewardVideo = true;
                }
            }];
            hub.labelFont = FONT_REGULAR(12);
        }else {
            VungleSDK* sdk = VungleSDK.sharedSDK;
            NSError *error;
            [sdk playAd:rootVC options:nil placementID:AD_PROVIDER.admodConfig.vungLeAdRewardId error:&error];
            if (error) {
                NSLog(@"Error encountered playing ad: %@", error);
            }else {
                AD_PROVIDER.isShowingRewardVideo = true;
            }
        }
    }
}

#pragma mark -  VungleSDKCreativeTracking

/**
 * If implemented, this will get called when the SDK has an ad ready to be displayed.
 * The parameters will indicate that an ad associated with the included creative ID is
 * ready to play for the specified placement reference ID. Both parameters should return
 * a value if an ad is ready to be played.
 * @param creativeID The creative ID of the ad unit that is ready to be played
 * @param placementID The ID of a placement which is ready to be played
 */
- (void)vungleCreative:(nullable NSString *)creativeID readyForPlacement:(nullable NSString *)placementID {
    DLog(@"vungleCreative: readyForPlacement %@", placementID);
    DISPATCH_ASYNC(^{
        NSInteger rewardCount = [USER_DEFAULT integerForKey:key_RewardVideoCount];
        if ([self currentRootVC] &&
            rewardCount >= AD_PROVIDER.admodConfig.timeToShowRewardVideo.integerValue) {
            [self showAd:true];
        }else {
            AD_PROVIDER.isLoadingRewardVideo = false;
        }
    });
}


#pragma mark -  VungleSDKHeaderBidding

- (void)placementPrepared:(NSString *)placement
             withBidToken:(NSString *)bidToken {
    DLog(@"placementPrepared: placement %@", placement);
    DISPATCH_ASYNC(^{
        NSInteger rewardCount = [USER_DEFAULT integerForKey:key_RewardVideoCount];
        if ([self currentRootVC] &&
            rewardCount >= AD_PROVIDER.admodConfig.timeToShowRewardVideo.integerValue) {
            DISPATCH_ASYNC(^{
                [self showAd:true];
            });
        }else {
            AD_PROVIDER.isLoadingRewardVideo = false;
        }
    });
}

#pragma mark -  VungleSDKDelegate

/**
 * If implemented, this will get called when the SDK has an ad ready to be displayed. Also it will
 * get called with an argument `NO` for `isAdPlayable` when for some reason, there is
 * no ad available, for instance there is a corrupt ad or the OS wiped the cache.
 * Please note that receiving a `NO` here does not mean that you can't play an Ad: if you haven't
 * opted-out of our Exchange, you might be able to get a streaming ad if you call `play`.
 * @param isAdPlayable A boolean indicating if an ad is currently in a playable state
 * @param placementID The ID of a placement which is ready to be played
 * @param error The error that was encountered.  This is only sent when the placementID is nil.
 */
- (void)vungleAdPlayabilityUpdate:(BOOL)isAdPlayable placementID:(nullable NSString *)placementID error:(nullable NSError *)error {
    DLog(@"vungleAdPlayabilityUpdate: %@ - %d", placementID, isAdPlayable);
    VungleSDK* sdk = [VungleSDK sharedSDK];
    if (!error &&
        (isAdPlayable ||
         [sdk isAdCachedForPlacementID:AD_PROVIDER.admodConfig.vungLeAdRewardId])) {
            DISPATCH_ASYNC(^{
                NSInteger rewardCount = [USER_DEFAULT integerForKey:key_RewardVideoCount];
                if ([self currentRootVC] &&
                    rewardCount >= AD_PROVIDER.admodConfig.timeToShowRewardVideo.integerValue) {
                    [self showAd:true];
                }else {
                    AD_PROVIDER.isLoadingRewardVideo = false;
                }
            });
        }
}


- (void)vungleWillShowAdForPlacementID:(nullable NSString *)placementID {
    DLog(@"vungleWillShowAdForPlacementID: %@", placementID);
    DISPATCH_ASYNC_AFTER(1.5, ^{
        UIViewController *vc = [self currentRootVC];
        while (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }
        
        if ([NSStringFromClass([vc class]) rangeOfString:@"VungleAd"].location != NSNotFound) {
            [AD_PROVIDER resetStatusBarState];
            if ([self shouldShowFullAds] &&
                [self shouldShowAdClickMessage]) {
                [AD_PROVIDER showAdClickMessage:vc.view];
            }
        }
    });
}

/**
 * If implemented, this method gets called when a Vungle Ad Unit is about to be completely dismissed.
 * At this point, it's recommended to resume your Game or App.
 */
- (void)vungleWillCloseAdWithViewInfo:(nonnull VungleViewInfo *)info placementID:(nonnull NSString *)placementID {
    DLog(@"vungleWillCloseAdWithViewInfo: %@", placementID);
    DISPATCH_ASYNC(^{
        AD_PROVIDER.isShowingRewardVideo = false;
        AD_PROVIDER.isLoadingRewardVideo = false;
        [AD_PROVIDER.rewardVideoLabel removeFromSuperview];
    });
}

/**
 * If implemented, this method gets called when a Vungle Ad Unit has been completely dismissed.
 * At this point, you can load another ad for non-auto-cahced placement if necessary.
 */
- (void)vungleDidCloseAdWithViewInfo:(nonnull VungleViewInfo *)info placementID:(nonnull NSString *)placementID {
    DLog(@"vungleDidCloseAdWithViewInfo: %@", placementID);
    if (self.presentingSheet) {
        [self.presentingSheet dismissViewControllerAnimated:false completion:nil];
        self.presentingSheet = nil;
    }
    
    AD_PROVIDER.isShowingRewardVideo = false;
    AD_PROVIDER.isLoadingRewardVideo = false;
    
    [AD_PROVIDER.rewardVideoLabel removeFromSuperview];
    DISPATCH_ASYNC_AFTER(1.0, ^{
        [[self currentRootVC].view.window endEditing:true];
    });
}

/**
 * If implemented, this will get called when VungleSDK has finished initialization.
 * It's only at this point that one can call `playAd:options:placementID:error`
 * and `loadPlacementWithID:` without getting initialization errors
 */
- (void)vungleSDKDidInitialize {
    DLog(@"vungleSDKDidInitialize");
}

/**
 * If implemented, this will get called if the VungleSDK fails to initialize.
 * The included NSError object should give some information as to the failure reason.
 * @note If initialization fails, you will need to restart the VungleSDK.
 */
- (void)vungleSDKFailedToInitializeWithError:(NSError *)error {
    DLog(@"vungleSDKFailedToInitializeWithError: %@", error.debugDescription);
}

@end

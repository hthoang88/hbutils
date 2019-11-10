//
//  HBAdRewardProvider.h
//  HBTruyenTranh
//
//  Created by Hoang Ho on 10/25/18.
//  Copyright © 2018 HoangHo. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "HBAdRewardProtocol.h"
#import "HBUtilsMacros.h"

@class HBAdRewardConfig;

#define key_RewardVideoCount            @"key_RewardVideoCount"
#define key_RewardVideoFullCount        @"key_RewardVideoFullCount"
#define key_LimitViewCount              @"key_LimitViewCount"

NS_ASSUME_NONNULL_BEGIN

#define  AD_PROVIDER       [HBAdRewardProvider shared]


@interface HBAdRewardProvider : NSObject
+ (nonnull HBAdRewardProvider*)shared;
- (id<HBAdRewardProtocol>)reward:(HBAdRewardType)type;
@property (strong, nonatomic) UILabel *rewardVideoLabel;
@property (assign, nonatomic) BOOL isLoadingRewardVideo;
@property (assign, nonatomic) BOOL isShowingRewardVideo;
@property (assign, nonatomic) float volumnValue;
@property (strong, nonatomic) HBAdRewardConfig *admodConfig;
@property (strong, nonatomic) HBValueBlock valueBlock;

- (void)updateRewardVideoCount:(NSInteger)value;

- (void)resetVolumnValue:(float)value;

- (void)resetRewardVideoCount;

- (HBAdRewardType)rewardTypeForCurrentContext;

- (void)resetStatusBarState;

- (void)showAdClickMessage:(UIView*)inView;

- (void)muteSoundForShowingRewardVideo;
@end

@interface HBAdRewardProvider (Config)
- (NSString*)key_googleAdAppId;
- (NSString*)key_googleAdRewardId;
- (NSString*)key_googleAdEnable;
- (NSString*)key_requireViewReward;

- (NSString*)key_adClickMsg;
- (NSString*)key_timeToShowFullAd;
- (NSString*)key_rewardVideoMinimumTime;
- (NSString*)key_timeToShowRewardVideo;

- (NSString*)key_timeToDelayCloseAd;
- (NSString*)key_enableMuteAdSound;
- (NSString*)key_enableMagicRewardVideo;
- (NSString*)key_volumeView;

- (NSString*)key_preferredStatusBarStyle;
- (NSString*)key_window;
- (NSString*)key_rootVC;
- (NSString*)key_warningAdAppear;

- (id)valueWith:(NSString*)key;
@end

@interface HBAdRewardConfig: NSObject
@property (strong, nonatomic) NSString *googleAdAppId;
@property (strong, nonatomic) NSString *googleAdRewardId;
@property (strong, nonatomic) NSNumber *googleAdEnable;
@property (strong, nonatomic) NSNumber *requireViewReward;

@property (strong, nonatomic) NSString *adClickMsg;
@property (strong, nonatomic) NSNumber *timeToShowFullAd;
@property (strong, nonatomic) NSNumber *rewardVideoMinimumTime;
@property (strong, nonatomic) NSNumber *timeToShowRewardVideo;

@property (strong, nonatomic) NSNumber *timeToDelayCloseAd;
@property (strong, nonatomic) NSNumber *enableMuteAdSound;
@property (strong, nonatomic) NSNumber *enableMagicRewardVideo;
@end



NS_ASSUME_NONNULL_END

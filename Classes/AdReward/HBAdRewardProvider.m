//
//  HBAdRewardProvider.m
//  HBTruyenTranh
//
//  Created by Hoang Ho on 10/25/18.
//  Copyright © 2018 HoangHo. All rights reserved.
//

#import "HBAdRewardProvider.h"
#import "HBUtilsMacros.h"
#import "UIView+HBUtils.h"
#import "HBDefineColor.h"
#import "EXTScope.h"
@import AVFoundation;
@import MediaPlayer;
@import PureLayout;

@implementation HBAdRewardProvider
+ (nonnull HBAdRewardProvider*)shared
{
    static HBAdRewardProvider *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[HBAdRewardProvider alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.admodConfig = [HBAdRewardConfig new];
    }
    return self;
}

- (void)updateRewardVideoCount:(NSInteger)value
{
    if (self.isShowingRewardVideo) {
        DLog(@"Dont update reward count because ads is showing!");
        //Don's update reward count if ads is showing
        return;
    }
    BOOL shouldUpdateRewardCount = true;
    if ([self valueWith:@"AD_PROVIDER_shouldUpdateRewardCount"]) {
        shouldUpdateRewardCount = [[self valueWith:@"AD_PROVIDER_shouldUpdateRewardCount"] boolValue];
    }
    if (!shouldUpdateRewardCount) {
        return;
    }
    if (self.admodConfig.enableMagicRewardVideo.boolValue) {
        USER_DEFAULT_UPDATE(key_RewardVideoFullCount, value, false);
    }
    USER_DEFAULT_UPDATE(key_LimitViewCount, value, false);
    
    NSInteger rewardCount = [USER_DEFAULT integerForKey:key_RewardVideoCount];
    if (rewardCount >= AD_PROVIDER.admodConfig.timeToShowRewardVideo.integerValue) {
        HBAdRewardType type = [self rewardTypeForCurrentContext];
        id<HBAdRewardProtocol> reward = [self reward:type];
        DISPATCH_ASYNC_AFTER(1.5, ^{
            [reward loadAd];
        });
    }else {
        USER_DEFAULT_UPDATE(key_RewardVideoCount, value, false);
    }
    [USER_DEFAULT synchronize];
}

- (HBAdRewardType)rewardTypeForCurrentContext {
    if (AD_PROVIDER.admodConfig.googleAdEnable.boolValue) {
        return HBAdRewardTypeGoogle;
    }
    id val = [self valueWith:self.key_adRewardType];
    if (val) {
        return [val intValue];
    }
    
    
    return HBAdRewardTypeUnknown;
}

- (void)saveCurrentVolumnValue {
    UISlider *systemVolumeSlider = nil;
    UIView *volumeView = [self valueWith:self.key_volumeView];
    for(UIView *subview in volumeView.subviews)
    {
        if ([subview isKindOfClass:[UISlider class]]) {
            systemVolumeSlider = (UISlider *)subview;
            break;
        }
    }
    self.volumnValue = systemVolumeSlider.value;
}

- (void)resetVolumnValue:(float)value {
    UISlider *systemVolumeSlider = nil;
    UIView *volumeView = [self valueWith:self.key_volumeView];
    for(UIView *subview in volumeView.subviews)
    {
        if ([subview isKindOfClass:[UISlider class]]) {
            systemVolumeSlider = (UISlider *)subview;
            break;
        }
    }
    systemVolumeSlider.value = value;
}

- (void)resetRewardVideoCount {
    USER_DEFAULT_SET(key_RewardVideoCount, 0, true);
}

- (id<HBAdRewardProtocol>)reward:(HBAdRewardType)type {
    NSString *className = nil;
    if (type == HBAdRewardTypeGoogle) {
        className = @"HBGoogleAdReward";
    }
    else {
        id val = [self valueWith:self.key_adClassName];
        if (val) {
            className = val;
        }
    }
    
    if (className) {
        return (id)([NSClassFromString(className) shared]);
    }
    return nil;
}

- (void)resetStatusBarState {
    [[UIApplication sharedApplication] setStatusBarHidden:false];
    UIStatusBarStyle style = [[self valueWith:self.key_preferredStatusBarStyle] intValue];
    [[UIApplication sharedApplication] setStatusBarStyle:style animated:YES];
}

- (void)showAdClickMessage:(UIView*)inView {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, inView.frameWidth, 80)];
    NSString *str = [NSString stringWithFormat:@"Rất mong các bạn dành chút thời gian click vào quảng cáo để ủng hộ chúng tôi.\nRất cảm ơn các bạn."];
    if (AD_PROVIDER.admodConfig.adClickMsg.length > 0) {
        str = AD_PROVIDER.admodConfig.adClickMsg;
    }
    UILabel *lbl = [[UILabel alloc] initWithFrame:v.bounds];
    lbl.text = nil;
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.text = str;
    lbl.font = FONT_REGULAR(14);
    lbl.backgroundColor = kClearColor;
    lbl.textColor = kBlackColor;
    lbl.numberOfLines = 0;
    lbl.minimumScaleFactor = 0.5;
    [v addSubview:lbl];
    if (HAS_NOTCH_HEADER()) {
        [lbl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(30, 5, 5, 5)];
    }else {
        [lbl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(20, 5, 5, 5)];
    }
    if (self.admodConfig.enableMagicRewardVideo.boolValue) {
        USER_DEFAULT_SET(key_RewardVideoFullCount, 0, true);        
    }
    [inView addSubview:v];
    [v autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
    v.layer.cornerRadius = 4.0;
    v.layer.masksToBounds = YES;
    v.userInteractionEnabled = AD_PROVIDER.admodConfig.requireViewReward.boolValue;
    v.backgroundColor = [UIColorFromRGB(0x5BBECA) colorWithAlphaComponent:0.5];
    if (AD_PROVIDER.admodConfig.requireViewReward.boolValue) {
        v.backgroundColor = UIColorFromRGB(0x5BBECA);
    }
    @weakify(v)
    DISPATCH_ASYNC_AFTER(AD_PROVIDER.admodConfig.rewardVideoMinimumTime.integerValue, ^{
        @strongify(v)
        if (v) {
            [v removeFromSuperview];
        }
    });
    AD_PROVIDER.rewardVideoView = v;
}

- (void)muteSoundForShowingRewardVideo {
    //reset vol first
    self.volumnValue = 0.0;
    if (AD_PROVIDER.admodConfig.enableMuteAdSound.boolValue) {
        [self saveCurrentVolumnValue];
        [self resetVolumnValue:0];
    }
}
@end


@implementation HBAdRewardProvider (Config)
#pragma mark - Google Ads
- (NSString*)key_googleAdAppId {
    return @"key_googleAdAppId";
}

- (NSString*)key_googleAdRewardId {
    return @"key_googleAdRewardId";
}

- (NSString*)key_googleAdEnable {
    return @"key_googleAdEnable";
}

#pragma mark - Time
- (NSString*)key_timeToShowRewardVideo {
    return @"key_timeToShowRewardVideo";
}

- (NSString*)key_timeToShowFullAd {
    return @"key_timeToShowFullAd";
}

- (NSString*)key_rewardVideoMinimumTime {
    return @"key_timeToShowFullAd";
}

- (NSString*)key_timeToDelayCloseAd {
    return @"key_timeToDelayCloseAd";
}

#pragma mark - Enable/Disable
- (NSString*)key_adClickMsg {
    return @"key_adClickMsg";
}

- (NSString*)key_requireViewReward {
    return @"key_requireViewReward";
}


- (NSString*)key_enableMuteAdSound {
    return @"key_enableMuteAdSound";
}

- (NSString*)key_enableMagicRewardVideo {
    return @"key_enableMagicRewardVideo";
}

#pragma mark - Additional
- (NSString*)key_volumeView {
    return @"key_volumeView";
}

- (NSString*)key_preferredStatusBarStyle {
    return @"key_preferredStatusBarStyle";
}

- (NSString*)key_window{
    return @"key_window";
}
- (NSString*)key_rootVC{
    return @"key_rootVC";
}

- (NSString*)key_warningAdAppear {
    return @"key_warningAdAppear";
}

- (NSString*)key_adClassName {
    return @"key_adClassName";
}

- (NSString*)key_adRewardType {
    return @"key_adRewardType";
}

- (id)valueWith:(NSString*)key {
    return self.valueBlock(self, key, nil);
}

@end

@implementation HBAdRewardConfig
#pragma mark - Google Ads
- (NSString *)googleAdAppId {
    return [AD_PROVIDER valueWith:AD_PROVIDER.key_googleAdAppId];
}

- (NSString *)googleAdRewardId {
    return [AD_PROVIDER valueWith:AD_PROVIDER.key_googleAdRewardId];
}

- (NSNumber *)googleAdEnable {
    return [AD_PROVIDER valueWith:AD_PROVIDER.key_googleAdEnable];
}

#pragma mark - Others
- (NSNumber *)requireViewReward{
    return [AD_PROVIDER valueWith:AD_PROVIDER.key_requireViewReward];
}

- (NSString *)adClickMsg {
    return [AD_PROVIDER valueWith:AD_PROVIDER.key_adClickMsg];
}

- (NSNumber *)timeToShowFullAd{
    return [AD_PROVIDER valueWith:AD_PROVIDER.key_timeToShowFullAd];
}

- (NSNumber *)rewardVideoMinimumTime{
    return [AD_PROVIDER valueWith:AD_PROVIDER.key_rewardVideoMinimumTime];
}

- (NSNumber *)timeToShowRewardVideo{
    return [AD_PROVIDER valueWith:AD_PROVIDER.key_timeToShowRewardVideo];
}

- (NSNumber *)timeToDelayCloseAd{
    return [AD_PROVIDER valueWith:AD_PROVIDER.key_timeToDelayCloseAd];
}

- (NSNumber *)enableMuteAdSound {
    return [AD_PROVIDER valueWith:AD_PROVIDER.key_enableMuteAdSound];
}

- (NSNumber *)enableMagicRewardVideo{
    return [AD_PROVIDER valueWith:AD_PROVIDER.key_enableMagicRewardVideo];
}

@end

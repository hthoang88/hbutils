//
//  HBAdRewardProtocol.h
//  HBTruyenTranh
//
//  Created by Hoang Ho on 10/25/18.
//  Copyright © 2018 HoangHo. All rights reserved.
//

#ifndef HBAdRewardProtocol_h
#define HBAdRewardProtocol_h

typedef NS_ENUM(int, HBAdRewardType){
    HBAdRewardTypeUnknown = 0,
    HBAdRewardTypeGoogle = 1,
    HBAdRewardTypeMopub = 2,
    HBAdRewardTypeAdColony = 3,
    HBAdRewardTypeStartApp = 4,
    HBAdRewardTypeVungle = 5
};

#endif /* HBAdRewardProtocol_h */

@protocol HBAdRewardProtocol <NSObject>
- (void)configAd;
- (void)loadAd;
- (BOOL)shouldShowFullAds;
- (BOOL)shouldShowAdClickMessage;
- (void)showAd:(BOOL)shouldReset;
@end

@interface HBAdReward: NSObject<HBAdRewardProtocol>
@end

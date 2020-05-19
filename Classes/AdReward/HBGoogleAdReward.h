//
//  HBGoogleAdReward.h
//  HBTruyenTranh
//
//  Created by Hoang Ho on 10/25/18.
//  Copyright © 2018 HoangHo. All rights reserved.
//

#import "HBBaseRewardVideo.h"

@interface HBGoogleAdReward : HBBaseRewardVideo
+ (nonnull HBGoogleAdReward*)shared;
@end

/*
 Should call this function in app delete
 [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
 */

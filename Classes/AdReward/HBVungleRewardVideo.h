//
//  HBVungleRewardVideo.h
//  HBUtils
//
//  Created by Hoang Ho on 11/20/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "HBBaseRewardVideo.h"

NS_ASSUME_NONNULL_BEGIN
/*
 - Magic reward video:          true
 - Mute sound:                  true
 - Force rotate (to portrait):  checking
 */
@interface HBVungleRewardVideo : HBBaseRewardVideo
+ (nonnull HBVungleRewardVideo*)shared;
@end


NS_ASSUME_NONNULL_END

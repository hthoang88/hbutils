//
//  HBBaseRewardVideo.h
//  HBTruyenTranh
//
//  Created by Hoang Ho on 10/26/18.
//  Copyright © 2018 HoangHo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBAdRewardProtocol.h"
@import MZFormSheetPresentationController;

@interface HBBaseRewardVideo : NSObject<HBAdRewardProtocol>
@property (weak, nonatomic) MZFormSheetPresentationViewController *presentingSheet;
- (void)showSheetCompletion:(void(^)(UIViewController *contentViewController))completion;
- (UIViewController*)currentRootVC;
- (BOOL)prepareShowAd:(BOOL)shouldReset;
@end

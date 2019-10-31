//
//  FirebaseHelper.h
//  HBLoiGiaiHay
//
//  Created by Hoang Ho on 8/27/17.
//  Copyright © 2017 HoangHo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBUtilsMacros.h"

@import Firebase;
@import FirebaseCore;
@import FirebaseDatabase;

NS_ASSUME_NONNULL_BEGIN

@interface HBUtilsFirebaseHelper : NSObject
+ (nullable instancetype)sharedInstance;
@property (strong, nonatomic) HBValueBlock valueBlock;

- (void)configureFirebase:(BOOL)hasMainApp;

- (void)logDeviceToken:(NSString* )token;

- (void)logUserActive;

- (void)sendFeedbackWithTitle:(NSString *_Nullable)title
                      message:(NSString *_Nullable)message
                   completion:(HBAnyBlock)completion;

@end

NS_ASSUME_NONNULL_END

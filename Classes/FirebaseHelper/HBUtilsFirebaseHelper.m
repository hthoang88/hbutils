//
//  HBUtilsFirebaseHelper.m
//  HBLoiGiaiHay
//
//  Created by Hoang Ho on 8/27/17.
//  Copyright © 2017 HoangHo. All rights reserved.
//

#import "HBUtilsFirebaseHelper.h"
#import "NSDate+HBUtils.h"
@import FirebaseAnalytics;

#define key_UserOnline  @"key_UserOnline"

//static NSString * const userOnlinesPath = @"userOnlines/cailuongviet";
//static NSString * const deviceTokenPath = @"deviceTokens/cailuongviet";

@interface HBUtilsFirebaseHelper()
{
    FIRDataSnapshot *userOnlineSnapshot;
    FIRDatabaseReference *deviceTokenRef;
}
@end

@implementation HBUtilsFirebaseHelper
+ (instancetype)sharedInstance
{
    static HBUtilsFirebaseHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HBUtilsFirebaseHelper alloc] init];
    });
    return instance;
}


- (void)configureFirebase:(BOOL)hasMainApp {
    if (hasMainApp) {
        //Require GoogleService-Info.plist file
        [FIRApp configure];
    }
    
//Setup secondary database
    FIROptions *secondaryOptions = [[FIROptions alloc] initWithGoogleAppID:@"1:261458681758:ios:23dfd3ecc7d3a998" GCMSenderID:@"261458681758"];
    secondaryOptions.bundleID = @"com.hthoang88.app.radionetnews";
    secondaryOptions.clientID = @"261458681758-3eg192i8m9gbocdm2dprfi84t05qkhmk.apps.googleusercontent.com";
    secondaryOptions.databaseURL = @"https://habutechsdata.firebaseio.com";
    secondaryOptions.storageBucket = @"habutechsdata.appspot.com";
    [FIRApp configureWithName:@"habutechsdata" options:secondaryOptions];
    
    FIROptions *onlineOptions = [[FIROptions alloc] initWithGoogleAppID:@"1:261458681758:ios:3979361a89a1daa8" GCMSenderID:@"261458681758"];
    onlineOptions.bundleID = [[NSBundle mainBundle] bundleIdentifier];
    onlineOptions.clientID = @"261458681758-3eg192i8m9gbocdm2dprfi84t05qkhmk.apps.googleusercontent.com";
    onlineOptions.databaseURL = @"https://useractive-cb6fa.firebaseio.com";
    onlineOptions.storageBucket = @"useractive-cb6fa.appspot.com";
    [FIRApp configureWithName:@"useractive" options:onlineOptions];
    
    FIRApp *app = [FIRApp appNamed:@"useractive"];
    if (app) {
        NSString *userOnlinesPath = self.valueBlock(self, @"userOnlinesPath", nil);
        FIRDatabase *database = [FIRDatabase databaseForApp:app];
        FIRDatabaseQuery *userQuery = [database referenceWithPath:userOnlinesPath];
        
        [userQuery observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if ([snapshot.value isKindOfClass:[NSNumber class]]) {
                self->userOnlineSnapshot = snapshot;
            }else {
                FIRDatabaseReference *conRef = [database referenceWithPath:userOnlinesPath];
                [conRef setValue:@(1)];
            }
        }];
        
        NSString *deviceTokenPath = self.valueBlock(self, @"deviceTokenPath", nil);
        FIRDatabaseQuery *deviveQuery = [database referenceWithPath:deviceTokenPath];
        [deviveQuery observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if (snapshot.value) {
                self->deviceTokenRef = snapshot.ref;
            }
        }];
    }
}

- (FIRDatabase *)mainDatabase
{
    return [FIRDatabase database];
}

- (FIRDatabase* _Nullable)secondaryDatabase
{
    FIRApp *app = [FIRApp appNamed:@"habutechsdata"];
    FIRDatabase *database = [FIRDatabase databaseForApp:app];
    return database;
}

- (void)logEvent:(NSString *)eventName obj:(id)obj {
    if (obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            [FIRAnalytics logEventWithName:eventName
                                parameters:@{@"name": obj}];
        }else if ([obj isKindOfClass:[NSDictionary class]]) {
            [FIRAnalytics logEventWithName:eventName
                                parameters:(id)obj];
        }
    }else {
        [FIRAnalytics logEventWithName:eventName
                            parameters:nil];
    }
}

- (void)logDeviceToken:(NSString *)token {
    BOOL shouldLogDeviceToken = true;
    if (self.valueBlock(self, @"shouldLogDeviceToken", nil)) {
        shouldLogDeviceToken = [self.valueBlock(self, @"shouldLogDeviceToken", nil) boolValue];
    }
    
    if (!shouldLogDeviceToken) {
        return;
    }
    if (deviceTokenRef) {
        NSString *key = @"001-updatedAt";
        NSDateFormatter *df = [NSDate sharedDataFormatter];
        df.dateFormat = @"yyyy-MM-dd";
        NSMutableDictionary *dict = @{}.mutableCopy;
        dict[@"updatedAt"] = [df stringFromDate:TO_DAY];
        dict[@"appVersion"] = NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
        if (DEVICE_MODEL()) {
            dict[@"device"] = DEVICE_MODEL();
        }
        if (UIDevice.currentDevice.name) {
            dict[@"deviceName"] = UIDevice.currentDevice.name;
        }
        [deviceTokenRef updateChildValues:@{key : [df stringFromDate:TO_DAY],
                                             token : dict
                                             }];
    }else {
        FIRApp *app = [FIRApp appNamed:@"useractive"];
        if (app) {
            NSString *deviceTokenPath = self.valueBlock(self, @"deviceTokenPath", nil);
            FIRDatabase *database = [FIRDatabase databaseForApp:app];
            FIRDatabaseQuery *conRef = [database referenceWithPath:deviceTokenPath];
            [conRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                if (snapshot.value) {
                    self->deviceTokenRef = snapshot.ref;
                    [self logDeviceToken:token];
                }
            }];
        }
    }
}

- (void)logUserActive {
    if (![USER_DEFAULT objectForKey:key_UserOnline]) {
        [self updateActiveUserOnline:true];
    }else {
        NSNumber *val = [USER_DEFAULT objectForKey:key_UserOnline];
        if (!val.boolValue) {
            [self updateActiveUserOnline:true];
        }
    }
}

- (void)sendFeedbackWithTitle:(NSString *_Nullable)title
                      message:(NSString *_Nullable)message
                   completion:(HBAnyBlock)completion {
    FIRApp *app = [FIRApp appNamed:@"useractive"];
    FIRDatabase *database = [FIRDatabase databaseForApp:app];
    FIRDatabaseReference *classRef = [database referenceWithPath:@"feedbacks/cailuongviet"];
    classRef = [classRef childByAutoId];
    NSMutableDictionary *value = @{}.mutableCopy;
    if (title) {
        value[@"title"] = title;
    }
    if (message) {
        value[@"message"] = message;
    }
    if (self.valueBlock(self, @"deviceToken", nil)) {
        value[@"deviceToken"] = self.valueBlock(self, @"deviceToken", nil);
    }
    if (DEVICE_MODEL()) {
        value[@"device"] = DEVICE_MODEL();
    }
    if (UIDevice.currentDevice.name) {
        value[@"deviceName"] = UIDevice.currentDevice.name;
    }
    NSDateFormatter *df = [NSDate sharedDataFormatter];
    df.dateFormat = @"yyyy-MM-dd";
    value[@"dateTime"] = [df stringFromDate:TO_DAY];
    [classRef setValue:value];
    if (completion) {
        completion(value, nil);
    }
}

#pragma mark - Helpers

- (void)updateActiveUserOnline:(BOOL)isActive {
    if (userOnlineSnapshot) {
        NSInteger value = 0;
        if ([userOnlineSnapshot.value isKindOfClass:[NSNumber class]]) {
            value = [userOnlineSnapshot.value integerValue];
        }
        value += isActive ? 1 : -1;
        value = MAX(value, 0);
        [userOnlineSnapshot.ref setValue:@(value)];
        [USER_DEFAULT setObject:@(isActive) forKey:key_UserOnline];
        [USER_DEFAULT synchronize];
    }else {
        FIRApp *app = [FIRApp appNamed:@"useractive"];
        if (app) {
            NSString *userOnlinesPath = self.valueBlock(self, @"userOnlinesPath", nil);
            FIRDatabase *database = [FIRDatabase databaseForApp:app];
            FIRDatabaseQuery *conRef = [database referenceWithPath:userOnlinesPath];
            
            [conRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                if (snapshot.value) {
                    self->userOnlineSnapshot = snapshot;
                    [self updateActiveUserOnline:isActive];
                }
            }];
        }
    }
}

@end

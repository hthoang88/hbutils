//
//  HBUtilities+Alert.h
//  HBUtils
//
//  Created by Hoang Ho on 10/30/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "HBUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBUtilities (Alert)
void ALERT(NSString* _Nullable title, NSString* _Nullable  message);
void alertView(NSString *title, NSString *message,NSString *dismissString);
void HANDLE_ERROR(NSError* _Nullable err);

+ (void)showDialogWithTitle:(NSString* _Nullable)title
                    message:(NSString* _Nullable)message
                 completion:(void (^ _Nullable)(BOOL cancelled, NSInteger buttonIndex))completion
          cancelButtonTitle:(NSString* _Nullable)cancelBtn
          otherButtonTitles:(NSArray* _Nullable)otherButtonTitles;

+ (void)showInputDialogWithTitle:(NSString* _Nullable)title
                         message:(NSString* _Nullable)message
                          secure:(BOOL)secure
                      completion:(void (^_Nullable)(BOOL cancelled, NSInteger buttonIndex, NSString *inputText))completion
               cancelButtonTitle:(NSString*_Nullable)cancelBtn
               otherButtonTitles:(NSArray*_Nullable)otherButtonTitles;

+ (void)closeAlertView:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

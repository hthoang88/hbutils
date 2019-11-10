//
//  HBUtilities+Alert.m
//  HBUtils
//
//  Created by Hoang Ho on 10/30/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "HBUtilities+Alert.h"
#import "SIAlertView.h"
#import "HBUtilsMacros.h"
#import "NSError+HBUtils.h"
@import AFNetworking;

@implementation HBUtilities (Alert)

void ALERT(NSString* title, NSString* message) {
    alertView(title, message, @"OK");
}

void alertView(NSString *title, NSString *message,NSString *dismissString) {
    [HBUtilities showDialogWithTitle:title
                             message:message
                          completion:nil
                   cancelButtonTitle:dismissString
                   otherButtonTitles:nil];
}

void HANDLE_ERROR(NSError* _Nullable err) {
    if (err.code != - 999 &&
        err.code != - 1005){
        if (err.code == -1009) {//no internet
//            [Utils showNoInternetConnectionErrorIfNeed:YES];
        }else{
            if ([err isKindOfClass:[NSError class]]) {
#ifdef DEBUG
                NSInteger statusCode =  [[[err userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
                
                DLog(@"statusCode: %zd", statusCode);
#endif
                if (err.code == NSURLErrorNotConnectedToInternet) {
                    
                }else{
                    if ([err isCancelError]) {
                        //Ignore cancel error request
                    }else{
                        NSString *msg = DefaultErrorMessage;
                        if (err.userInfo &&
                            [err.userInfo[@"message"] length] > 0) {
                            msg = err.userInfo[@"message"];
                        }
                        ALERT(DefaultErrorAlertTitle, msg);
                    }
                }
            }else{
                ALERT(DefaultErrorAlertTitle, DefaultErrorMessage);
            }
        }
    }
}

+ (void)showDialogWithTitle:(NSString*)title
                    message:(NSString*)message
                 completion:(void (^)(BOOL cancelled, NSInteger buttonIndex))completion
          cancelButtonTitle:(NSString*)cancelBtn
          otherButtonTitles:(NSArray*)otherButtonTitles {
    SIAlertView *av = [[SIAlertView alloc] initWithTitle:title andMessage:message];
    [av addButtonWithTitle:cancelBtn?:@"OK" type:SIAlertViewButtonTypeCancel handler:nil];
    if (otherButtonTitles.count) {
        for (NSString *title in otherButtonTitles) {
            [av addButtonWithTitle:title type:SIAlertViewButtonTypeDefault handler:nil];
        }
    }
    [av setWillDismissHandler:^(SIAlertView *alertView, NSInteger buttonIndex) {
        if (completion) {
            completion(buttonIndex == 0, buttonIndex);
        }
    }];
    [av show];
    [NTF_CENTER postNotificationName:kNTFDidShowAlertView object:av];
}

+ (void)showInputDialogWithTitle:(NSString*)title
                         message:(NSString*)message
                          secure:(BOOL)secure
                      completion:(void (^)(BOOL cancelled, NSInteger buttonIndex, NSString *inputText))completion
               cancelButtonTitle:(NSString*)cancelBtn
               otherButtonTitles:(NSArray*)otherButtonTitles {
    SIAlertView *av = [[SIAlertView alloc] initWithTitle:title andMessage:message];
    
    [av addButtonWithTitle:cancelBtn?:cancelBtn type:SIAlertViewButtonTypeCancel handler:nil];
    if (otherButtonTitles.count) {
        for (NSString *title in otherButtonTitles) {
            [av addButtonWithTitle:title type:SIAlertViewButtonTypeDefault handler:nil];
        }
    }
    [av setWillDismissHandler:^(SIAlertView *alertView, NSInteger buttonIndex) {
        if (completion) {
            completion(buttonIndex == 0, buttonIndex, [[alertView.textFields firstObject] text]);
        }
    }];
    
    [av addTextFieldWithPlaceHolder:@"..." andText:nil secure:secure];
    [av show];
    [NTF_CENTER postNotificationName:kNTFDidShowAlertView object:av];
}

+ (void)closeAlertView:(BOOL)animated {
    POST_NTF(kNTFShouldCloseAlertView);
}

@end

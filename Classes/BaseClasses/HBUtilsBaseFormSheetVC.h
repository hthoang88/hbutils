//
//  HBUtilsBaseFormSheetVC.h
//  HBUtils
//
//  Created by Hoang Ho on 11/10/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBUtilsBaseFormSheetVC : UIViewController
@property (nonatomic, copy, nullable) CGRect(^frameConfigurationHandler)(UIView * __nonnull presentedView, CGRect currentFrame, BOOL isKeyboardVisible);

- (CGSize)sheetSize;

- (IBAction)closeAction:(id _Nullable)sender;

- (void)setupUI;
- (void)changeSizeDuration:(float)duration newSize:(CGSize)size completion:(void (^ __nullable)(BOOL finished))completion;
@end

@interface BANavigationFormSheetController : UINavigationController
@property (nonatomic, copy, nullable) CGRect(^frameConfigurationHandler)(UIView * __nonnull presentedView, CGRect currentFrame, BOOL isKeyboardVisible);
@end


NS_ASSUME_NONNULL_END

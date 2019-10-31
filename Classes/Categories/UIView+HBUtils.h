//
//  UIView+HBUtils.h
//  HBUtils
//
//  Created by Hoang Ho on 9/29/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MBProgressHUD;
@class HBProgressHUD;

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HBUtils)
- (UITapGestureRecognizer *)addTapGesture:(void(^)(UIView *btn))action;

- (UILongPressGestureRecognizer*)addLongGestureAction:(void(^)(UIView *btn))action;

- (void)border:(UIColor* _Nullable)color
         width:(CGFloat)borderWidth
        radius:(CGFloat)radius;

@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

// Setting these modifies the origin but not the size.
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

@property (nonatomic, readonly) CGFloat frameCenterX;
@property (nonatomic, readonly) CGFloat frameCenterY;

- (BOOL)containsSubView:(UIView *)subView;
- (BOOL)containsSubViewOfClassType:(Class)class;
- (id)subViewWithClass:(Class)cl;

@end

@interface UIView (HUD)
//HUD
- (HBProgressHUD*)showHUD;
- (HBProgressHUD*)showHUD:(NSString* _Nullable)title;
- (HBProgressHUD*)showHUD:(NSString* _Nullable)title lockUI:(BOOL)lockUI;
- (HBProgressHUD*)showSmartHUD;
- (void)hideHUD;
- (HBProgressHUD*)showHUDHubWithText:(NSString*_Nullable)text hideAfterSecond:(NSInteger)delayTimeToHide completion:(void(^ _Nullable)(void))completion;
- (HBProgressHUD*)showHUDText:(NSString*_Nullable)text hideAfterSecond:(NSInteger)delayTimeToHide completion:(void(^ _Nullable)(void))completion;
- (HBProgressHUD*)showHUDCustomWithText:(NSString*_Nullable)text image:(UIImage*_Nullable)image hideAfterSecond:(NSInteger)delayTimeToHide completion:(void(^)(void))completion;
@end

@interface HBProgressHUD : MBProgressHUD

@end

NS_ASSUME_NONNULL_END

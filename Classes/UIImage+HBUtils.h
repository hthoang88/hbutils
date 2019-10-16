//
//  UIImageView+HBUtils.h
//  BridgeAthletic
//
//  Created by Hoang Ho on 9/30/15.
//
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (HBUils)
+ (UIImage *_Nullable)imageWithImage:(UIImage *_Nullable)image scaledToSize:(CGSize)size;
+ (UIImage *_Nullable)imageWithColor:(UIColor *_Nullable)color andSize:(CGSize)size;

- (UIImage *_Nullable)imageByRenderTemplate;
- (UIImage *_Nullable)fixOrientation;
- (UIImage *_Nullable)imageByApplyingAlpha:(CGFloat)alpha;
@end


@interface UIImageView (Helper)
- (void)updateImageWithRatingValue:(NSInteger)ratingValue;
@end


@interface UIImageView (FacebookAnimation)
- (void)setupFacebookViewAnimation;
@end

NS_ASSUME_NONNULL_END

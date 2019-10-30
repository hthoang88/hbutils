//
//  UIImageView+Helper.m
//  BridgeAthletic
//
//  Created by Hoang Ho on 9/30/15.
//
//

#import "UIImage+HBUtils.h"
#import "UIView+HBUtils.h"
#import "HBUtilsMacros.h"
#import <objc/runtime.h>

@implementation UIImage (HBUtils)

- (UIImage*)imageByRenderTemplate
{
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height {
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return [self imageWithImage:image scaledToSize:newSize];
}

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end


@implementation UIImageView (HBUtils)
- (void)updateImageWithRatingValue:(NSInteger)ratingValue
{
    self.image = [UIImage imageNamed:[NSString stringWithFormat:@"rating%zd", ratingValue]].imageByRenderTemplate;
}
@end

static char TAG_CONTAINER_VIEW;
static char TAG_SCROLL_VIEW;

@interface UIImageView (Private)
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation UIImageView (FacebookAnimation)

- (UIScrollView *)scrollView {
    return (UIScrollView *)objc_getAssociatedObject(self, &TAG_SCROLL_VIEW);
}

- (void)setScrollView:(UIScrollView *)scrollView {
    objc_setAssociatedObject(self, &TAG_SCROLL_VIEW, scrollView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)containerView {
    return (UIView *)objc_getAssociatedObject(self, &TAG_CONTAINER_VIEW);
}

- (void)setContainerView:(UIView *)containerView
{
    objc_setAssociatedObject(self, &TAG_CONTAINER_VIEW, containerView, OBJC_ASSOCIATION_RETAIN);
}

- (void)setupFacebookViewAnimation
{
    self.userInteractionEnabled = YES;
    for (id gesture in self.gestureRecognizers) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [self removeGestureRecognizer:gesture];
        }
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImage:)];
    [self addGestureRecognizer:tap];
}


- (void)tapOnContainer:(UITapGestureRecognizer*)tap {
    [self zoomOut:self.containerView];
}

- (void)tapOnImage:(UITapGestureRecognizer*)tap {
    [self zoomIn];
}

- (void)zoomIn {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window endEditing:YES];
    window.userInteractionEnabled = NO;
    
    UIScrollView *scrollView = self.scrollView;
    if (scrollView) {
        [scrollView removeFromSuperview];
        scrollView = nil;
        [self.containerView removeFromSuperview];
        self.containerView = nil;
    }
    
    UIView *containerView = [[UIView alloc] initWithFrame:window.bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnContainer:)];
    [containerView addGestureRecognizer:tap];
    containerView.backgroundColor = UIColor.clearColor;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:containerView.bounds];
    backgroundView.backgroundColor = UIColor.blackColor;
    backgroundView.tag = 1;
    backgroundView.alpha = 0.0;
    backgroundView.userInteractionEnabled = false;
    
    scrollView = [[UIScrollView alloc] initWithFrame:window.bounds];
    scrollView.backgroundColor = UIColor.clearColor;
    [scrollView addSubview:backgroundView];
    [scrollView addSubview:containerView];
    [window addSubview:scrollView];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:containerView.bounds];
    img.tag = 2;
    CGRect startingFrame = [self convertRect:self.bounds toView:nil];
    img.frame = startingFrame;
    img.clipsToBounds = YES;
    //    img.center = containerView.center;
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.image = self.image;
    [containerView addSubview:img];
    self.containerView = containerView;
    self.scrollView = scrollView;
    
    //Add close button
    UIImageView *closeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(containerView.frameWidth - 35, 25, 30, 30)];
    closeIcon.tag = 3;
    closeIcon.image = [UIImage imageNamed:@"ico-close-white"];
    [self.containerView addSubview:closeIcon];
    
    closeIcon.alpha = 0.0;
    
    self.alpha = 0.0;
    //Animating
    
    [UIView animateWithDuration:0.75 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        float height = self.image.size.height * WIDTH_SCREEN / self.image.size.width;
        float y = 0;
        BOOL scrollEnabled = false;
        if (height > containerView.frameHeight) {
            scrollEnabled = true;
            y = 0;
            
            [containerView removeGestureRecognizer:tap];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnContainer:)];
            [img addGestureRecognizer:tap];
            img.userInteractionEnabled = true;
        }else {
            y = (containerView.frameHeight - height)/2.0;
        }
        containerView.frameHeight = height;
        img.frame = CGRectMake(0, y, containerView.frameWidth, height);
        backgroundView.alpha = 1.0;
        closeIcon.alpha = 1.0;
        scrollView.scrollEnabled = scrollEnabled;
        scrollView.contentSize = CGSizeMake(0, height);
    } completion:^(BOOL finished) {
        backgroundView.frame = CGRectMake(0, 0, WIDTH_SCREEN, MAX(scrollView.contentSize.height, HEIGHT_SCREEN));
        window.userInteractionEnabled = YES;
    }];
}

- (void)zoomOut:(UIView*)containerView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = NO;
    
    UIView *backgroundView = [self.scrollView viewWithTag:1];
    UIImageView *img = (UIImageView*)[containerView viewWithTag:2];
    UIImageView *closeIcon = (UIImageView*)[containerView viewWithTag:3];
    
    CGRect startingFrame = [self convertRect:self.bounds toView:nil];
    img.contentMode = self.contentMode;
    float height = (containerView.frameWidth / startingFrame.size.width) * startingFrame.size.height;
    float y = (containerView.frameHeight - height)/2.0;
    img.frame = CGRectMake(0, y, containerView.frameWidth, height);
    
    UIScrollView *scrollView = self.scrollView;
    [UIView animateWithDuration:0.75 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        backgroundView.alpha = 0.0;
        closeIcon.alpha = 0.0;
        img.frame = startingFrame;
    } completion:^(BOOL finished) {
        [containerView removeFromSuperview];
        self.alpha = 1.0;
        window.userInteractionEnabled = YES;
        [scrollView removeFromSuperview];
    }];
}
@end

@implementation HBTemplateImageView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];        
    }
    return self;
}

- (void)setupUI {
    self.image = self.image.imageByRenderTemplate;
}
@end

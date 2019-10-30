//
//  HBMacros.h
//  HBUtils
//
//  Created by Hoang Ho on 9/29/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

typedef void(^_Nullable HBAnyBlock)(id _Nullable result, NSError * _Nullable error);
typedef void(^_Nullable HBJsonBlock)(NSDictionary * _Nullable result, NSError * _Nullable error);
typedef void(^_Nullable HBActionBlock)(id _Nullable sender, NSString * _Nullable actionType, id _Nullable obj);
typedef id _Nullable(^_Nullable HBValueBlock)(id _Nullable sender, NSString * _Nullable type, id _Nullable obj);

static NSString * _Nullable const kNTFAppConfigDidChanged       = @"kNTFAppConfigDidChanged";
static NSString * _Nullable const kNTFShouldCloseAlertView      = @"kNTFShouldCloseAlertView";
static NSString * _Nullable const kNTFDidShowAlertView          = @"kNTFDidShowAlertView";

static NSString * _Nullable const DefaultErrorAlertTitle        = @"Lỗi";
static NSString * _Nullable const DefaultErrorMessage           = @"Không thể thực hiện yêu cầu ở thời điểm hiện tại.\n\nXin vui lòng thử lại sau.";
static NSString * _Nullable const DefaultErrorNoNetwork         = @"Không có kết nối internet!";


NSString *STRINGIFY_BOOL(BOOL x);
NSString *STRINGIFY_INT(NSInteger x);
NSString *STRINGIFY_SHORT(short x);
NSString *STRINGIFY_LONG(long x);
NSString *STRINGIFY_UINT(NSUInteger x);
NSString *STRINGIFY_FLOAT(float x);
NSString *STRINGIFY_DOUBLE(double x);
NSString *STRINGIFY_FRAME(CGRect rect);
NSString *STRINGIFY_SIZE(CGSize size);
NSString *STRINGIFY_POINT(CGPoint point);
NSString *STRINGIFY_INDEXPATH(NSIndexPath* ip);

// BOUNDS
CGRect RECT_WITH_X(CGRect rect, float x);
CGRect RECT_WITH_Y(CGRect rect, float y);
CGRect RECT_WITH_X_Y(CGRect rect, float x, float y);

CGRect RECT_WITH_X_WIDTH(CGRect rect, float x, float width);
CGRect RECT_WITH_Y_HEIGHT(CGRect rect, float y, float height);

CGRect RECT_WITH_WIDTH_HEIGHT(CGRect rect, float width, float height);
CGRect RECT_WITH_WIDTH(CGRect rect, float width);
CGRect RECT_WITH_HEIGHT(CGRect rect, float height);
CGRect RECT_WITH_HEIGHT_FROM_BOTTOM(CGRect rect, float height);

CGRect RECT_INSET_BY_LEFT_TOP_RIGHT_BOTTOM(CGRect rect, float left, float top, float right, float bottom);
CGRect RECT_INSET_BY_TOP_BOTTOM(CGRect rect, float top, float bottom);
CGRect RECT_INSET_BY_LEFT_RIGHT(CGRect rect, float left, float right);

CGRect RECT_STACKED_OFFSET_BY_X(CGRect rect, float offset);
CGRect RECT_STACKED_OFFSET_BY_Y(CGRect rect, float offset);

CGRect RECT_ADD_X(CGRect rect, float value);
CGRect RECT_ADD_Y(CGRect rect, float value);
CGRect RECT_ADD_WIDTH(CGRect rect, float value);
CGRect RECT_ADD_HEIGHT(CGRect rect, float value);

#define IS_IPAD    (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPhone)
#define dCurrentStatusBarOrientation [[UIApplication sharedApplication] statusBarOrientation]

#define IS_PORTRAIT  (dCurrentStatusBarOrientation == UIInterfaceOrientationPortrait || dCurrentStatusBarOrientation ==UIInterfaceOrientationPortraitUpsideDown)
#define IS_LANDSCAPE  (dCurrentStatusBarOrientation == UIInterfaceOrientationLandscapeLeft || dCurrentStatusBarOrientation ==UIInterfaceOrientationLandscapeRight)

#define DDebug 0

#if DDebug
#define DLog(fmt, ...) DLoga((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(fmt, ...) DLoga(fmt, ##__VA_ARGS__);
#endif

void DLoga(NSString *format,...);

BOOL HAS_NOTCH_HEADER(void);
NSString* DEVICE_MODEL(void);

void POST_NTF(NSString *_Nullable name);

void DISPATCH_ASYNC(dispatch_block_t block);

void DISPATCH_ASYNC_AFTER(double second, dispatch_block_t block);

#define TO_DAY [NSDate date]
#define HEIGHT_SCREEN      UIScreen.mainScreen.bounds.size.height
#define WIDTH_SCREEN      UIScreen.mainScreen.bounds.size.width
#define NTF_CENTER              [NSNotificationCenter defaultCenter]
#define USER_DEFAULT              [NSUserDefaults standardUserDefaults]


NSString *DOCUMENTS_DIR(void);
NSString *LIBRARY_DIR(void);
NSString *TEMP_DIR(void);
NSString *BUNDLE_DIR(void);
NSString *NSDCIM_DIR(void);

void USER_DEFAULT_SET(NSString *key,NSInteger value, BOOL synchronize);

void USER_DEFAULT_UPDATE(NSString *key,NSInteger value, BOOL synchronize);



UIFont* _Nullable FONT_REGULAR(float pointSize);
UIFont* _Nullable FONT_BOLD(float pointSize);
UIFont* _Nullable FONT_LIGHT(float pointSize);
UIFont* _Nullable FONT_MEDIUM(float pointSize);


NS_ASSUME_NONNULL_END

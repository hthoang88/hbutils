//
//  BAMacros.m
//  BridgeAthletic
//
//  Created by Hoang Ho on 12/22/14.
//
//

#import "HBUtilsMacros.h"
#import <sys/utsname.h>

// STRINGIFY

NSString *STRINGIFY_BOOL(BOOL x) { return (x ? @"true" : @"false"); }
NSString *STRINGIFY_INT(NSInteger x) { return [NSString stringWithFormat:@"%li", (long)x]; }
NSString *STRINGIFY_SHORT(short x) { return [NSString stringWithFormat:@"%i", x]; }
NSString *STRINGIFY_LONG(long x) { return [NSString stringWithFormat:@"%li", x]; }
NSString *STRINGIFY_UINT(NSUInteger x) { return [NSString stringWithFormat:@"%lu", (unsigned long)x]; }
NSString *STRINGIFY_FLOAT(float x) { return [NSString stringWithFormat:@"%f", x]; }
NSString *STRINGIFY_DOUBLE(double x) { return [NSString stringWithFormat:@"%f", x]; }
NSString *STRINGIFY_FRAME(CGRect rect) { return [NSString stringWithFormat:@"(%.0f - %.0f) (%.0f - %.0f)", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height]; }
NSString *STRINGIFY_SIZE(CGSize size) { return [NSString stringWithFormat:@"(%.0f - %.0f)", size.width, size.height]; }
NSString *STRINGIFY_POINT(CGPoint point) { return [NSString stringWithFormat:@"(%.0f - %.0f)", point.x, point.y]; }
NSString *STRINGIFY_INDEXPATH(NSIndexPath* ip) { return [NSString stringWithFormat:@"(%zd - %zd)",ip.section, ip.row]; }

// BOUNDS

CGRect RECT_WITH_X(CGRect rect, float x) { return CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height); }
CGRect RECT_WITH_Y(CGRect rect, float y) { return CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height); }
CGRect RECT_WITH_X_Y(CGRect rect, float x, float y) { return CGRectMake(x, y, rect.size.width, rect.size.height); }

CGRect RECT_WITH_X_WIDTH(CGRect rect, float x, float width) { return CGRectMake(x, rect.origin.y, width, rect.size.height); }
CGRect RECT_WITH_Y_HEIGHT(CGRect rect, float y, float height) { return CGRectMake(rect.origin.x, y, rect.size.width, height); }

CGRect RECT_WITH_WIDTH_HEIGHT(CGRect rect, float width, float height) { return CGRectMake(rect.origin.x, rect.origin.y, width, height); }
CGRect RECT_WITH_WIDTH(CGRect rect, float width) { return CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height); }
CGRect RECT_WITH_HEIGHT(CGRect rect, float height) { return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height); }
CGRect RECT_WITH_HEIGHT_FROM_BOTTOM(CGRect rect, float height) { return CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - height, rect.size.width, height); }

CGRect RECT_INSET_BY_LEFT_TOP_RIGHT_BOTTOM(CGRect rect, float left, float top, float right, float bottom) { return CGRectMake(rect.origin.x + left, rect.origin.y + top, rect.size.width - left - right, rect.size.height - top - bottom); }
CGRect RECT_INSET_BY_TOP_BOTTOM(CGRect rect, float top, float bottom) { return CGRectMake(rect.origin.x, rect.origin.y + top, rect.size.width, rect.size.height - top - bottom); }
CGRect RECT_INSET_BY_LEFT_RIGHT(CGRect rect, float left, float right) { return CGRectMake(rect.origin.x + left, rect.origin.y, rect.size.width - left - right, rect.size.height); }

CGRect RECT_STACKED_OFFSET_BY_X(CGRect rect, float offset) { return CGRectMake(rect.origin.x + rect.size.width + offset, rect.origin.y, rect.size.width, rect.size.height); }
CGRect RECT_STACKED_OFFSET_BY_Y(CGRect rect, float offset) { return CGRectMake(rect.origin.x, rect.origin.y + rect.size.height + offset, rect.size.width, rect.size.height); }

CGRect RECT_ADD_X(CGRect rect, float value)
{
    return RECT_WITH_X(rect, rect.origin.x + value);
}

CGRect RECT_ADD_Y(CGRect rect, float value)
{
    return RECT_WITH_Y(rect, rect.origin.y + value);
}
CGRect RECT_ADD_WIDTH(CGRect rect, float value)
{
    return RECT_WITH_WIDTH(rect, rect.size.width + value);
}
CGRect RECT_ADD_HEIGHT(CGRect rect, float value)
{
    return RECT_WITH_HEIGHT(rect, rect.size.height + value);
}

#pragma mark - Debug log
void DLoga(NSString *format,...)
{
#ifdef DEBUG
    {
        //#if DDebug
        //#define DLog(fmt, ...) DLoga((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
        //#else
        //#define DLog(fmt, ...) DLoga(fmt, ##__VA_ARGS__);
        //#endif
        va_list args;
        va_start(args,format);
        NSLogv(format, args);
        va_end(args);
    }
#endif
}

void DISPATCH_ASYNC(dispatch_block_t block)
{
    dispatch_async(dispatch_get_main_queue(), block);
}

void DISPATCH_ASYNC_AFTER(double second, dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}


BOOL HAS_NOTCH_HEADER()
{
    if (IS_IPHONE) {
        //detech iphone x
        static BOOL isiPhoneX = NO;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                NSString *model = DEVICE_MODEL();
                /*
                 iPhone10,3 : iPhone X Global
                 iPhone10,6 : iPhone X GSM
                 iPhone11,2 : iPhone XS
                 iPhone11,4 : iPhone XS Max
                 iPhone11,6 : iPhone XS Max Global
                 iPhone11,8 : iPhone XR
                 iPhone12,1 : iPhone 11
                 iPhone12,3 : iPhone 11 Pro
                 iPhone12,5 : iPhone 11 Pro Max
                 */
                
                isiPhoneX = [model isEqualToString:@"iPhone10,3"] ||
                [model isEqualToString:@"iPhone10,6"] ||
                [model rangeOfString:@"iPhone11,"].location == 0 ||//for iPhone Xs, Xr, Xs Max...
                [model rangeOfString:@"iPhone12,"].location == 0;//for iPhone 11, 11 Pro, 11 Pro Max
            });
        });
        return isiPhoneX;
    }
    return NO;
}

NSString* DEVICE_MODEL() {
    //detech iphone x
    static NSString *model = @"";
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
#if TARGET_IPHONE_SIMULATOR
            model = NSProcessInfo.processInfo.environment[@"SIMULATOR_MODEL_IDENTIFIER"];
#else
            
            struct utsname systemInfo;
            uname(&systemInfo);
            
            model = [NSString stringWithCString:systemInfo.machine
                                       encoding:NSUTF8StringEncoding];
#endif
        });
    });
    return model;
}

void POST_NTF(NSString *name)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}


NSString *DOCUMENTS_DIR(void) { return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]; }
NSString *LIBRARY_DIR(void) { return [NSHomeDirectory() stringByAppendingPathComponent:@"Library"]; }
NSString *TEMP_DIR(void) { return  [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]; }
NSString *BUNDLE_DIR(void) { return  [[NSBundle mainBundle] bundlePath]; }
NSString *NSDCIM_DIR(void) { return  @"/var/mobile/Media/DCIM"; }


void USER_DEFAULT_SET(NSString *key,NSInteger value, BOOL synchronize) {
    [USER_DEFAULT setInteger:value forKey:key];
    if (synchronize) {
        [USER_DEFAULT synchronize];
    }
}

void USER_DEFAULT_UPDATE(NSString *key,NSInteger value, BOOL synchronize) {
    NSInteger val = [USER_DEFAULT integerForKey:key];
    val += value;
    [USER_DEFAULT setInteger:val forKey:key];
    DLog(@"%@ - %ld", key, val);
    if (synchronize) {
        [USER_DEFAULT synchronize];
    }
}

UIFont* FONT_REGULAR(float pointSize)
{
    return [UIFont systemFontOfSize:pointSize];
}
UIFont* FONT_BOLD(float pointSize)
{
    return [UIFont boldSystemFontOfSize:pointSize];
}
UIFont* FONT_LIGHT(float pointSize)
{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:pointSize];
}

UIFont* FONT_MEDIUM(float pointSize)
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:pointSize];
}

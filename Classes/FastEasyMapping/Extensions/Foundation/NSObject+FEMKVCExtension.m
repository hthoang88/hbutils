// For License please refer to LICENSE file in the root of FastEasyMapping project

#import "NSObject+FEMKVCExtension.h"
#import "HBUtilsMacros.h"

@implementation NSObject (FEMKVCExtension)

- (void)fem_setValueIfDifferent:(id)value forKey:(NSString *)key {
	[self fem_setValueIfDifferent:value forKey:key type:nil];
}

- (void)fem_setValueIfDifferent:(id)value forKey:(NSString *)key type:(NSString *)type {
    id _value = [self valueForKey:key];
    
    if (_value != value && ![_value isEqual:value]) {
        //Hoang: Try/Catch
        @try {
            if (type) {
                if ([value isKindOfClass:[NSString class]] &&
                    [type isEqualToString:@"NSNumber"]) {
                    NSString *st = value;
                    if (st.length > 0) {
                        [self setValue:@([st integerValue]) forKey:key];
                    }else{
                        [self setValue:nil forKey:key];
                    }
                }
                else if ([value isKindOfClass:[NSNumber class]] &&
                         [type isEqualToString:@"NSString"]) {
                    [self setValue:[value stringValue] forKey:key];
                }else {
                    [self setValue:value forKey:key];
                }
            }else {
                [self setValue:value forKey:key];
            }
        }
        @catch (NSException *exception) {
            @try {
                if([value isKindOfClass:[NSNumber class]]){
                    [self setValue:[value stringValue] forKey:key];
                }else if([value isKindOfClass:[NSString class]]){
                    NSString *st = value;
                    if (st.length > 0) {
                        [self setValue:@([st integerValue]) forKey:key];
                    }else{
                        [self setValue:nil forKey:key];
                    }
                }
            }
            @catch (NSException *exception)
            {
                DLog(@"Mapping fail for key %@",key);
            }
        }
    }
}

@end

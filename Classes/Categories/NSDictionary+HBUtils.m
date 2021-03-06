//
//  NSDictionary+Helper.m
//  BridgeAthletic
//
//  Created by Hoang Ho on 4/21/15.
//
//

#import "NSDictionary+HBUtils.h"
#import "NSString+HBUtils.h"

@implementation NSDictionary (HBUtils)

- (NSDictionary*)repair
{
    NSMutableDictionary *muDictionary = [[NSMutableDictionary alloc] init];
    NSArray *allKeys = [self allKeys];
    for (int i = 0; i < [allKeys count]; i ++) {
        NSMutableDictionary *childDictionary = [self objectForKey:[allKeys objectAtIndex:i]];
        NSString *key = [allKeys objectAtIndex:i];
        if ([childDictionary isKindOfClass:[NSDictionary class]]) {
            NSDictionary *tempItem = [self objectForKey:[allKeys objectAtIndex:i]];
            tempItem = [tempItem repair];
            [muDictionary setValue:tempItem forKey:key];
        }else if([childDictionary isKindOfClass:[NSArray class]]){
            NSMutableArray *tempItems = [NSMutableArray arrayWithArray:(NSArray*)childDictionary];
            for (int i = 0; i < tempItems.count; i++) {
                id obj = tempItems[i];
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    [tempItems replaceObjectAtIndex:i withObject:[obj repair]];
                }
            }
            [muDictionary setObject:tempItems forKey:[allKeys objectAtIndex:i]];
        }else {
            if ((NSNull *)[self objectForKey:[allKeys objectAtIndex:i]] == [NSNull null]) {
                [muDictionary setObject:@"" forKey:[allKeys objectAtIndex:i]];
            }
            else {
                id tempValue = [self objectForKey:[allKeys objectAtIndex:i]];
                if ([tempValue isKindOfClass:NSString.class]){
                    NSString *lowerString = [tempValue lowercaseString];
                    if ([lowerString isEqualToString:@"null"] ||
                        [lowerString isEqualToString:@"<null>"])
                        tempValue = @"";
                }
                [muDictionary setObject:tempValue forKey:[allKeys objectAtIndex:i]];
            }
        }
    }
    return muDictionary;
}

- (NSString*)stringValue:(NSString*)key
{
    id obj = self[key];
    if ([obj isKindOfClass:NSString.class]) {
        return [obj trim];
    }else if([obj isKindOfClass:NSNumber.class]){
        return [[obj stringValue] trim];
    }else if([obj isKindOfClass:[NSNull class]]){
        return @"";
    }
    return nil;
}

- (NSNumber*)numberValue:(NSString*)key
{
    id obj = self[key];
    if ([obj isKindOfClass:NSNumber.class]) {
        return obj;
    }else if([obj isKindOfClass:NSString.class]){
        return @([obj integerValue]);
    }else if([obj isKindOfClass:[NSNull class]]){
        return @(0);
    }
    return nil;
}

- (NSDictionary*)dictValue:(NSString*)key {
    NSDictionary *result = self[key];
    if ([result isKindOfClass:NSDictionary.class]) {
        return result;
    }
    return nil;
}

- (NSMutableDictionary*)toMutable
{
    return [NSMutableDictionary dictionaryWithDictionary:self];
}
@end

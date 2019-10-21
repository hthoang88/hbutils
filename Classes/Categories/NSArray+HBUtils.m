//
//  NSArray+Utils.m
//  HBMonNgonMoiNgay
//
//  Created by Hoang Ho on 7/28/17.
//  Copyright © 2017 HoangHo. All rights reserved.
//

#import "NSArray+HBUtils.h"

@implementation NSArray (HBUtils)
- (NSMutableArray *)toMutable
{
    return [[NSMutableArray alloc] initWithArray:self];
}

- (NSArray* _Nullable)minusArray:(NSArray*)otherArray
{
    NSArray *arr1 = [self sortedArrayUsingSelector:@selector(compare:)];
    NSArray *arr2 = [otherArray sortedArrayUsingSelector:@selector(compare:)];
    NSMutableSet* mutableSet1 = [NSMutableSet setWithArray:arr1];
    NSMutableSet* mutableSet2 = [NSMutableSet setWithArray:arr2];
    [mutableSet1 minusSet:mutableSet2]; //this will give objects existed in mutableSet1 but not in mutableSet2
    return [mutableSet1 allObjects];
}

- (NSDictionary* _Nullable)findFirstDictionaryInArrayWithValue:(id)value forKey:(NSString*)key
{
    if (!value ||
        !key) {
        return nil;
    }
    NSArray *mappedItems = [self filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSDictionary *dict = (NSDictionary *)evaluatedObject;
        id selfValue = dict[key];
        if ([selfValue isKindOfClass:[NSString class]]) {
            return [selfValue isEqualToString:value];
        }
        return [selfValue integerValue] == [value integerValue];
    }]];
    if (mappedItems.count > 0) {
        return mappedItems.firstObject;
    }
    return nil;
}

@end

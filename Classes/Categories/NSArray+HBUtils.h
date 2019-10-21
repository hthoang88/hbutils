//
//  NSArray+HBUtils.h
//  HBMonNgonMoiNgay
//
//  Created by Hoang Ho on 7/28/17.
//  Copyright © 2017 HoangHo. All rights reserved.
//
@import Foundation;

NS_ASSUME_NONNULL_BEGIN
@interface NSArray (HBUtils)
- (NSMutableArray*)toMutable;

- (NSArray* _Nullable)minusArray:(NSArray*)otherArray;

- (NSDictionary* _Nullable)findFirstDictionaryInArrayWithValue:(id)value
                                                        forKey:(NSString*)key;
@end

NS_ASSUME_NONNULL_END

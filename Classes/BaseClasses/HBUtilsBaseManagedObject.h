//
//  HBUtilsBaseManagedObject.h
//  HBUtils
//
//  Created by Hoang Ho on 10/21/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;
@class FEMManagedObjectMapping;

NS_ASSUME_NONNULL_BEGIN

@interface HBUtilsBaseManagedObject : NSManagedObject

+ (void)deleteAllObjecs;

+ (FEMManagedObjectMapping*)objectMapping;

+ (NSDictionary*)mappingDictionary;

+ (NSDictionary*)getMapping:(Class)class exceptionProperties:(NSArray*_Nullable)array;

+ (instancetype _Nullable)createObjectWithData:(id _Nullable)data;

- (void)mappingDataFromJson:(NSDictionary*_Nullable)jsonValue;

- (NSMutableDictionary*)toDictionary;

- (void)deleteMe;

+ (NSString*)primaryKey;

+ (instancetype)findFirst:(id)value;

+ (instancetype)findFirst:(id)value source:(NSString* _Nullable)source;

+ (instancetype)findFirst:(id)value source:(NSString*)source context:(NSManagedObjectContext*)context;
@end

NS_ASSUME_NONNULL_END

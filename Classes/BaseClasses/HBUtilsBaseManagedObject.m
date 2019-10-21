//
//  HBUtilsBaseManagedObject.m
//  HBUtils
//
//  Created by Hoang Ho on 10/21/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "HBUtilsBaseManagedObject.h"
#import <objc/runtime.h>
#import "FastEasyMapping.h"
#import "FEMTypeIntrospection.h"
#import "NSDictionary+HBUtils.h"
#import "HBUtilsMacros.h"
@import MagicalRecord;

@implementation HBUtilsBaseManagedObject
+ (void)deleteAllObjecs
{
    for (id obj in [self MR_findAll]) {
        [NSManagedObjectContext.MR_defaultContext deleteObject:obj];
    }
}

+(FEMManagedObjectMapping *)objectMapping
{
    return [FEMManagedObjectMapping mappingForEntityName:NSStringFromClass([self class]) configuration:^(FEMManagedObjectMapping *mapping) {
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSString *key = [NSString stringWithFormat:@"mapping_%@", NSStringFromClass(self)];
        NSDictionary *dict = threadDictionary[key];
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            [mapping addAttributesFromDictionary:dict];
        }else{
            dict = [self mappingDictionary];
            NSMutableDictionary *typeDict = @{}.mutableCopy;
            for (NSString *key in dict) {
                objc_property_t property = class_getProperty([self class], [key UTF8String]);
                NSString *type = property ? FEMPropertyTypeStringRepresentation(property) : nil;
                if ([type isEqualToString:@"NSString"] ||
                    [type isEqualToString:@"NSNumber"]) {
                    NSDictionary *dict = @{[NSString stringWithFormat:@"HBUtilsType_%@", key] : type};
                    [typeDict addEntriesFromDictionary:dict];
                    //                    DLog(@"%@ => %@", key, type);
                }
            }
            if (typeDict.allKeys.count > 0) {
                NSMutableDictionary *finalMapping = typeDict.mutableCopy;
                if (dict) {
                    [finalMapping addEntriesFromDictionary:dict];
                }
                threadDictionary[key] = finalMapping;
                [mapping addAttributesFromDictionary:finalMapping];
            }else {
                if (dict) {
                    threadDictionary[key] = dict;
                }
                [mapping addAttributesFromDictionary:dict];
            }
        }
    }];
}

+ (NSDictionary *)mappingDictionary {
    return [self getMapping:[self class] exceptionProperties:nil];
}

- (void)mappingDataFromJson:(NSDictionary*)jsonValue
{
    NSString *name = [jsonValue stringValue:@"name"];
    NSString *title = [jsonValue stringValue:@"title"];
    if (title.length > 0 &&
        (!name ||
         name.length == 0)) {
            DLog(@"MAPPING WRONG TITLE %@", NSStringFromClass([self class]));
        }
    [FEMManagedObjectDeserializer fillObject:self
                  fromExternalRepresentation:jsonValue
                                usingMapping:[self.class objectMapping]];
}

+ (NSEntityDescription*)entity
{
    return [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:NSManagedObjectContext.MR_defaultContext];
}

+ (NSDictionary *)getMapping:(Class)class exceptionProperties:(NSArray*)array
{
    NSMutableDictionary *mapDict = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    if (count == 0) {
        NSArray *keys = [[[self entity] attributesByName] allKeys];
        for (NSString *key in keys) {
            NSString *keyValue =  [NSString stringWithFormat:@"%@",[key description]];
            if (![array containsObject:keyValue]) {
                [mapDict setObject:keyValue forKey:keyValue];
            }
        }
        return mapDict;
    }
    return mapDict;
}

- (NSMutableDictionary *)toDictionary
{  NSArray *keys = [[[self entity] attributesByName] allKeys];
    NSMutableDictionary *dict = [self dictionaryWithValuesForKeys:keys].toMutable;
    return dict;
}

- (void)deleteMe {
    [self.managedObjectContext deleteObject:self];
}

+ (instancetype)createObjectWithData:(id)data
{
    return nil;
}

+ (NSString *)primaryKey {
    return @"id";
}

+ (instancetype)findFirst:(id)value {
    return [self findFirst:value source:nil];
}

+ (instancetype)findFirst:(id)value source:(NSString*)source {
    if (value && source) {
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K = %@ AND source = %@", [self primaryKey], value,  source];
        NSArray *items = [self MR_findAllWithPredicate:pre];
        if (items.count > 1) {
            DLog(@"OHHHHHH, Something went wrong: %@: %@", NSStringFromClass([self class]), [self primaryKey]);
            NSArray *subArray = [items subarrayWithRange:NSMakeRange(0, items.count - 1)];
            for (NSManagedObject *obj in subArray) {
                [obj.managedObjectContext deleteObject:obj];
            }
        }
        return items.lastObject;
    }
    else if (value) {
        NSArray *items = [self MR_findByAttribute:[self primaryKey] withValue:value inContext:NSManagedObjectContext.MR_defaultContext];
        if (items.count > 1) {
            DLog(@"OHHHHHH, Something went wrong: %@: %@", NSStringFromClass([self class]), [self primaryKey]);
            NSArray *subArray = [items subarrayWithRange:NSMakeRange(0, items.count - 1)];
            for (NSManagedObject *obj in subArray) {
                [obj.managedObjectContext deleteObject:obj];
            }
        }
        return items.lastObject;
    }
    return nil;
}

@end

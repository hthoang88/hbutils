//
//  HBUtilities.m
//  HBUtils
//
//  Created by Hoang Ho on 10/28/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "HBUtilities.h"
@import MagicalRecord;

@implementation HBUtilities
+ (UICollectionViewFlowLayout*)horizontalCollectionFlowLayout {
    UICollectionViewFlowLayout *layout = [self standardCollectionFlowLayout];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}
+ (UICollectionViewFlowLayout*)verticalCollectionFlowLayout {
    UICollectionViewFlowLayout *layout = [self standardCollectionFlowLayout];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return layout;
}

+ (CGFloat)keyboardHeighWithNotification:(NSNotification*)note {
    NSDictionary *userInfo = note.userInfo;
    NSValue *value = userInfo[UIKeyboardFrameEndUserInfoKey];
    return value.CGRectValue.size.height;
}

+ (UICollectionViewFlowLayout*)standardCollectionFlowLayout {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    return layout;
}

@end

@implementation HBUtilities (CoreData)
+ (void)saveCoreData
{
    [NSManagedObjectContext.MR_defaultContext MR_saveToPersistentStoreAndWait];
}

+ (void)setupCoreData
{
    NSString *dataVersionKey = [NSUserDefaults.standardUserDefaults objectForKey:@"HBUtilities_dataVersionKey"];
    NSString *dataVersion = [NSUserDefaults.standardUserDefaults objectForKey:@"HBUtilities_dataVersion"];
    NSString *dataName = [NSUserDefaults.standardUserDefaults objectForKey:@"HBUtilities_dataName"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:dataVersionKey]) {
        NSString *currentVersion = [user objectForKey:dataVersionKey];
        if (![currentVersion isEqualToString:dataVersion]) {
            [self resetData];
        }else{
            [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:dataName];
        }
    }else{
        [self resetData];
    }
    
    //Disable log
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelOff];
}

+ (void)resetData
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *dataVersionKey = [NSUserDefaults.standardUserDefaults objectForKey:@"HBUtilities_dataVersionKey"];
    NSString *dataVersion = [NSUserDefaults.standardUserDefaults objectForKey:@"HBUtilities_dataVersion"];
    [user setObject:dataVersion forKey:dataVersionKey];
    [user synchronize];
    
    [self resetCachedLocalData];
}

+ (void)resetCachedLocalData
{
    //reset core data
#if TARGET_IPHONE_SIMULATOR
    //Simulator
    [self deleteCoreDataForSimulator];
#else
    [self deleteCoreDataForRealDevice];
#endif
    NSString *dataName = [NSUserDefaults.standardUserDefaults objectForKey:@"HBUtilities_dataName"];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:dataName];
}

+ (BOOL)deleteCoreDataForSimulator
{
    [MagicalRecord cleanUp];
    
    NSString *dbStore = [MagicalRecord defaultStoreName];
    
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:dbStore];
    NSURL *walURL = [[storeURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"sqlite-wal"];
    NSURL *shmURL = [[storeURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"sqlite-shm"];
    NSString *dataName = [NSUserDefaults.standardUserDefaults objectForKey:@"HBUtilities_dataName"];
    NSURL *fileURL = [NSPersistentStore MR_urlForStoreName:dataName];
    NSError *error = nil;
    BOOL result = NO;
    
    for (NSURL *url in @[storeURL, walURL, shmURL, fileURL]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
            result = [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
        }
    }
    return result;
}

+ (BOOL)deleteCoreDataForRealDevice
{
    [MagicalRecord cleanUp];
    NSString *dataName = [NSUserDefaults.standardUserDefaults objectForKey:@"HBUtilities_dataName"];
    // delete database file
    NSError *error;
    NSURL *fileURL = [NSPersistentStore MR_urlForStoreName:dataName];
    [[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error];
    return error == nil;
}
@end

//
//  NSDictionary+HBUtils.h
//  BridgeAthletic
//
//  Created by Hoang Ho on 4/21/15.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (HBUtils)
- (NSDictionary*)repair;
- (NSString*)stringValue:(NSString*)key;
- (NSNumber*)numberValue:(NSString*)key;
- (NSMutableDictionary*)toMutable;
@end

@interface NSDictionary (Encrypt)
- (NSDictionary*)encrypt;
- (NSDictionary*)decrypt;

- (NSDictionary*)encryptIgnoreKeys:(NSArray *)keys;
- (NSDictionary*)decryptIgnoreKeys:(NSArray *)keys;
@end

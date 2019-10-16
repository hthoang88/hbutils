//
//  NSAttributedString+HBUtils.h
//  BridgeAthletic
//
//  Created by Ho Thai Hoang on 12/2/16.
//
//

#import <Foundation/Foundation.h>

@interface  NSAttributedString (HBUtils)
+ (NSAttributedString*)combines:(NSArray*)atts;
@end

@interface  NSMutableAttributedString (HBUtils)
+ (NSMutableAttributedString*)atributesStringWithData:(id)data;
@end

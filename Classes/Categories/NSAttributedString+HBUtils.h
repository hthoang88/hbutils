//
//  NSAttributedString+HBUtils.h
//  BridgeAthletic
//
//  Created by Ho Thai Hoang on 12/2/16.
//
//

@import Foundation;
@import UIKit;

@interface  NSAttributedString (HBUtils)
+ (NSAttributedString*)combines:(NSArray*)atts;
@end

@interface  NSMutableAttributedString (HBUtils)
+ (NSMutableAttributedString*)atributesStringWithData:(id)data;
- (void)addKernelWithValue:(float)value;
- (void)setSpacingWithValue:(float)value align:(NSTextAlignment)align;
@end

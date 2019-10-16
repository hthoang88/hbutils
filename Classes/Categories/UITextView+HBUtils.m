//
//  UITextView+HBUtils.m
//  HBUtils
//
//  Created by Hoang Ho on 10/18/19.
//  Copyright © 2019 HB. All rights reserved.
//

#import "UITextView+HBUtils.h"
#import "HBDefineColor.h"
#import "HBUtilsMacros.h"

@implementation UITextView (HBUtils)

- (void)addToolbar:(id)target
         leftTitle:(NSString*)leftTitle
      leftSelector:(SEL)leftSelector
        rightTitle:(NSString*)rightTitle
     rightSelector:(SEL)rightSelector {
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.tintColor = self.window.tintColor;
    
    UIBarButtonItem *donelItem = nil;
    if (rightSelector) {
        donelItem = [self createButtonItem:target
                                     title:rightTitle
                                     color:self.window.tintColor
                                  selector:rightSelector];
    }else {
        donelItem = [self createButtonItem:self
                                     title:rightTitle
                                     color:self.window.tintColor
                                  selector:@selector(endEditing:)];
    }
    
    NSMutableArray *items = @[].mutableCopy;
    if (leftTitle) {
        UIBarButtonItem *cancelItem = [self createButtonItem:target
                                                       title:leftTitle
                                                       color:UIColorFromRGB(0xBDBDBD)
                                                    selector:leftSelector];
        [items addObject:cancelItem];
    }
    UIBarButtonItem *flexiable1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [items addObject:flexiable1];
    [items addObject:donelItem];
    numberToolbar.items = items;
    [numberToolbar sizeToFit];
    self.inputAccessoryView = numberToolbar;
}

- (UIBarButtonItem*)createButtonItem:(id)target
                               title:(NSString*)title
                               color:(UIColor*)color
                            selector:(SEL)selector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 50);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

@end

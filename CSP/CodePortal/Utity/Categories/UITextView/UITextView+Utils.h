//
//  UITextView+Util.h
//  TextFieldTestProject
//
//  Created by JasonLu on 16/11/1.
//  Copyright © 2016年 JasonLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGTextInput.h"
#import "FGUtils.h"
static NSString *NOTIFICATION_UPDATECONTENT = @"NOTIFICATION_UPDATECONTENT";
@interface UITextView (Utils) <FGTextInput>
- (void)setupAttributesWithFont:(UIFont *)font LineSpacing:(CGFloat)lineSpacing textAlignment:(NSTextAlignment)textAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode textColor:(UIColor *)color;
@end

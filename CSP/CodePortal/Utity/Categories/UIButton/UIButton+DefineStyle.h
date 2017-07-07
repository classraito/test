//
//  UIButton+DefineStyle.h
//  CSP
//
//  Created by JasonLu on 16/9/22.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (DefineStyle)
- (void)updateStyleWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color isUnderLineStyle:(BOOL)isUnderLineStyle contentAlignment:(UIControlContentHorizontalAlignment)contentAlignment;
@end

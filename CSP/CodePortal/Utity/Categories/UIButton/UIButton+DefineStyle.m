//
//  UIButton+DefineStyle.m
//  CSP
//
//  Created by JasonLu on 16/9/22.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "UIButton+DefineStyle.h"

@implementation UIButton (DefineStyle)
- (void)updateStyleWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color isUnderLineStyle:(BOOL)isUnderLineStyle contentAlignment:(UIControlContentHorizontalAlignment)contentAlignment {
  NSString *oneStr               = title;
  NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", oneStr]];
  NSRange strRange               = NSMakeRange(0, [str length]);
  //修改某个范围内的字体大小
  [str addAttribute:NSFontAttributeName value:font range:strRange];
  //修改某个范围内字的颜色
  [str addAttribute:NSForegroundColorAttributeName value:color range:strRange /*NSMakeRange(7,2)*/];
  if (isUnderLineStyle) {
    //在某个范围内增加下划线
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
  }

  [self setContentHorizontalAlignment:contentAlignment];
  [self setAttributedTitle:str forState:UIControlStateNormal];
  [self setNeedsDisplay];
}

@end

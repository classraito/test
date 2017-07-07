//
//  UILabel+UILabel_LineSpace.h
//  DunkinDonuts
//
//  Created by Ryan Gong on 15/12/24.
//  Copyright © 2015年 Ryan Gong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LineSpace)
-(void)setLineSpace:(CGFloat)_lineSpace;
-(void)setLineSpace:(CGFloat)_lineSpace alignment:(NSTextAlignment)_alightment;
-(void)setCustomColor:(UIColor *)_color searchText:(NSString *)_str_matchedText font:(UIFont *)_font;
-(void)setCustomColor:(UIColor *)_color searchText:(NSString *)_str_matchedText font:(UIFont *)_font addToAttrText:(NSAttributedString *)attributedString;
@end

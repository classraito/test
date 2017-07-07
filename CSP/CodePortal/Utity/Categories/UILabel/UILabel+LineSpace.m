//
//  UILabel+UILabel_LineSpace.m
//  DunkinDonuts
//
//  Created by Ryan Gong on 15/12/24.
//  Copyright © 2015年 Ryan Gong. All rights reserved.
//

#import "UILabel+LineSpace.h"

@implementation UILabel (LineSpace)
-(void)setLineSpace:(CGFloat)_lineSpace
{
    [self setLineSpace:_lineSpace alignment:NSTextAlignmentLeft];
}

-(void)setLineSpace:(CGFloat)_lineSpace alignment:(NSTextAlignment)_alightment
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = _lineSpace;//调整行间距
    paragraphStyle.alignment = _alightment;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.text.length)];
    self.attributedText = attributedString;
    attributedString = nil;
    paragraphStyle = nil;
}

-(void)setCustomColor:(UIColor *)_color searchText:(NSString *)_str_matchedText font:(UIFont *)_font
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSRange range = [self.text rangeOfString:_str_matchedText];
    [attributedString addAttribute:NSForegroundColorAttributeName value:_color range:range];
    [attributedString addAttribute:NSFontAttributeName value:_font range:range];
    self.attributedText = attributedString;
    attributedString = nil;
}

-(void)setCustomColor:(UIColor *)_color searchText:(NSString *)_str_matchedText font:(UIFont *)_font addToAttrText:(NSAttributedString *)_attributedString
{
    NSMutableAttributedString *attributedString = [_attributedString mutableCopy];
    NSRange range = [self.text rangeOfString:_str_matchedText];
    [attributedString addAttribute:NSForegroundColorAttributeName value:_color range:range];
    [attributedString addAttribute:NSFontAttributeName value:_font range:range];
    self.attributedText = attributedString;
    attributedString = nil;
}
@end

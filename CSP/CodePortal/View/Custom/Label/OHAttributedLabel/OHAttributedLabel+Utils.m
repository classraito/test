//
//  OHAttributedLabel+Utils.m
//  CSP
//
//  Created by JasonLu on 16/10/27.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "OHASBasicHTMLParser.h"
#import "OHAttributedLabel+Utils.h"
@implementation OHAttributedLabel (Utils)
- (void)OHALB_setupAttributes:(CGFloat)lineSpacing textAlignment:(CTTextAlignment)textAlignment lineBreakMode:(CTLineBreakMode)lineBreakMode textColor:(UIColor *)color {
  NSMutableAttributedString *mas = [self.attributedText mutableCopy];
  [mas modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.lineSpacing   = lineSpacing;
    paragraphStyle.textAlignment = textAlignment;
  }];
  [mas setTextColor:color];
  self.attributedText = mas;
  CGSize size = self.bounds.size;
  [self refreshDisplayWithInSize:size];
}

- (void)OHALB_setupLineBreakMode:(CTLineBreakMode)lineBreakMode {
  NSMutableAttributedString *mas = [self.attributedText mutableCopy];
  [mas modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
    paragraphStyle.lineBreakMode = lineBreakMode;
  }];
  self.attributedText = mas;

  CGSize size = self.bounds.size;
  [self refreshDisplayWithInSize:size];
}

- (void)OHALB_setupLineSpacing:(CGFloat)lineSpacing {
  NSMutableAttributedString *mas = [self.attributedText mutableCopy];
  [mas modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
    paragraphStyle.lineSpacing = lineSpacing;
  }];
  self.attributedText = mas;
  CGSize size         = self.bounds.size;
  [self refreshDisplayWithInSize:size];
}

- (void)OHALB_setupTextAlignment:(CTTextAlignment)textAlignment {
  NSMutableAttributedString *mas = [self.attributedText mutableCopy];
  [mas modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
    paragraphStyle.textAlignment = textAlignment;
  }];
  self.attributedText = mas;

  CGSize size = self.bounds.size;
  [self refreshDisplayWithInSize:size];
}

- (void)OHALB_setupTextColor:(UIColor *)color {
  NSMutableAttributedString *mas = [self.attributedText mutableCopy];
  [mas setTextColor:color];
  self.attributedText = mas;
}

- (void)OHALB_setupTextColor:(UIColor *)color range:(NSRange)range {
  NSMutableAttributedString *mas = [self.attributedText mutableCopy];
  [mas setTextColor:color range:range];
  self.attributedText = mas;
}

//- (CGSize)OHLB_setupHTMLParserWithContent:(NSString *)content width:(CGFloat)width {
//  NSAttributedString *str_attrs = [[NSAttributedString alloc] initWithString:content];
//  self.attributedText           = str_attrs;
//  self.attributedText           = [OHASBasicHTMLParser attributedStringByProcessingMarkupInAttributedString:self.attributedText];
//  CGSize size                   = CGSizeMake(width, 0);
//  [self refreshDisplayWithInSize:size];
//  str_attrs = nil;
//
//  return self.bounds.size;
//}

- (CGSize)OHLB_setupHTMLParserWithContent:(NSString *)content width:(CGFloat)width linkFont:(UIFont *)font{
  return  [self OHLB_setupHTMLParserWithContent:content width:width linkFont:font normalFont:font(FONT_TEXT_REGULAR,17)];
}
    
- (CGSize)OHLB_setupHTMLParserWithContent:(NSString *)content width:(CGFloat)width linkFont:(UIFont *)font normalFont:(UIFont *)_font
{
    NSMutableAttributedString *str_attrs = [[NSMutableAttributedString alloc] initWithString:content];
    [str_attrs setFont:_font];
    self.attributedText           = str_attrs;
    [self OHALB_setupLinkFont:font];
    self.linkUnderlineStyle = kCTUnderlineStyleNone;
    self.attributedText           = [OHASBasicHTMLParser attributedStringByProcessingMarkupInAttributedString:self.attributedText];
    CGSize size                   = CGSizeMake(width, 0);
    [self refreshDisplayWithInSize:size];
    str_attrs = nil;
        
    return self.bounds.size;
}

- (void)OHALB_setupLinkColor:(UIColor *)color{
  self.linkColor = color == nil ? [UIColor blueColor] : color;
}

- (void)OHALB_setupLinkFont:(UIFont *)font{
  self.linkFont = font == nil ? [UIFont systemFontOfSize:12] : font;
}



- (void)refreshDisplay {
  CGSize size = [self sizeThatFits:CGSizeMake(self.frame.size.width, 0)];
  self.frame  = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

- (void)refreshDisplayWithInSize:(CGSize)size {
  CGSize size_new = [self sizeThatFits:CGSizeMake(size.width, 0)];
  self.frame      = CGRectMake(self.frame.origin.x, self.frame.origin.y, size_new.width, size_new.height);
}

- (CGFloat)sizeThatAttributeString:(NSString *)content width:(CGFloat)width fontsize:(CGFloat)fontSize lineSpacing:(CGFloat)lineSpacing {
  [self OHLB_setupHTMLParserWithContent:content width:width linkFont:font(FONT_TEXT_REGULAR, fontSize)];
  [self OHALB_setupLineSpacing:lineSpacing];
  return self.bounds.size.height;
}
@end

//
//  OHAttributedLabel+Utils.h
//  CSP
//
//  Created by JasonLu on 16/10/27.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "OHAttributedLabel.h"

@interface OHAttributedLabel (Utils)
- (void)OHALB_setupAttributes:(CGFloat)lineSpacing textAlignment:(CTTextAlignment)textAlignment lineBreakMode:(CTLineBreakMode)lineBreakMode textColor:(UIColor *)color;
- (void)OHALB_setupLineBreakMode:(CTLineBreakMode)lineBreakMode;
- (void)OHALB_setupLineSpacing:(CGFloat)lineSpacing;
- (void)OHALB_setupTextAlignment:(CTTextAlignment)textAlignment;
- (void)OHALB_setupTextColor:(UIColor *)color;
- (void)OHALB_setupLinkColor:(UIColor *)color;
- (void)OHALB_setupLinkFont:(UIFont *)font;
- (void)OHALB_setupTextColor:(UIColor *)color range:(NSRange)range;
//- (CGSize)OHLB_setupHTMLParserWithContent:(NSString *)content width:(CGFloat)width;
- (CGSize)OHLB_setupHTMLParserWithContent:(NSString *)content width:(CGFloat)width linkFont:(UIFont *)font;
    - (CGSize)OHLB_setupHTMLParserWithContent:(NSString *)content width:(CGFloat)width linkFont:(UIFont *)font normalFont:(UIFont *)_font;
- (CGFloat)sizeThatAttributeString:(NSString *)content width:(CGFloat)width fontsize:(CGFloat)fontSize lineSpacing:(CGFloat)lineSpacing;
@end

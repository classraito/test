//
//  NSMutableAttributedString+Util.m
//  CSP
//
//  Created by JasonLu on 16/10/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NSMutableAttributedString+Util.h"

@implementation NSMutableAttributedString (Util)
+ (NSMutableAttributedString *)
initHTMLAttributedStringWithString:(NSString *)str
                              info:(NSDictionary *)info {
  NSMutableAttributedString *htmlString = [[NSMutableAttributedString alloc]
            initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
                 options:@{
                   NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType
                 }
      documentAttributes:nil
                   error:nil];

  [htmlString addAttributes:info range:NSMakeRange(0, htmlString.length)];

  return htmlString;
}

+ (NSMutableAttributedString *)
initHTMLAttributedStringWithString:(NSString *)str
                              font:(UIFont *)font
                         lineSpace:(CGFloat)lineSpace
                         alignment:(NSTextAlignment)alignment {
  NSMutableAttributedString *aStr;
  NSMutableParagraphStyle *paragraphStyle =
      [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.lineSpacing = lineSpace; //调整行间距
  paragraphStyle.alignment   = alignment;
  NSDictionary *info         = @{
    NSFontAttributeName : font,
    NSParagraphStyleAttributeName : paragraphStyle
  };
  aStr = [[NSMutableAttributedString alloc]
            initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
                 options:@{
                   NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType
                 }
      documentAttributes:nil
                   error:nil];
  [aStr addAttributes:info range:NSMakeRange(0, aStr.length)];
  //  info = @{
  //    NSFontAttributeName : font,
  //    NSParagraphStyleAttributeName : paragraphStyle,
  //    NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType
  //  };
  //  aStr = [[NSMutableAttributedString alloc] initWithString:str attributes:info];
  //  [aStr addAttributes:info range:NSMakeRange(0, aStr.length)];

  return aStr;
}
@end

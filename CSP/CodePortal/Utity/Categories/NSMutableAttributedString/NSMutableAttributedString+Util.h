//
//  NSMutableAttributedString+Util.h
//  CSP
//
//  Created by JasonLu on 16/10/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (Util)
+ (NSMutableAttributedString *)
initHTMLAttributedStringWithString:(NSString *)str
                              info:(NSDictionary *)info;
+ (NSMutableAttributedString *)
initHTMLAttributedStringWithString:(NSString *)str
                              font:(UIFont *)font
                         lineSpace:(CGFloat)lineSpace
                         alignment:(NSTextAlignment)alignment;
@end

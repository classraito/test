//
//  UITextView+AttributedHTMLString.h
//  HtmlParse
//
//  Created by JasonLu on 16/10/24.
//  Copyright © 2016年 JasonLu. All rights reserved.
//
/*
 NSMutableAttributedString *htmlString;
 htmlString = [NSMutableAttributedString
 initHTMLAttributedStringWithString:content
 font:[UIFont systemFontOfSize:14]
 lineSpace:12
 alignment:NSTextAlignmentLeft];
 CGRect rect =
 [self.tv_content setupAttributedHTMLStringWithAttributedString:htmlString
 inWidth:300];
 self.tv_content.frame = rect;
 self.tv_content.backgroundColor = [UIColor lightGrayColor];
 self.tv_content.delegate = self; //需要代理

 
 - (BOOL)textView:(UITextView *)textView
 shouldInteractWithURL:(NSURL *)URL
 inRange:(NSRange)characterRange {
 NSString *requestURLString = URL.absoluteString;
 NSString *string = [requestURLString parseHTML];
 return YES;
 }
 */

#import <UIKit/UIKit.h>

@interface UITextView (AttributedHTMLString)
- (CGRect)setupAttributedHTMLStringWithAttributedString:
              (NSAttributedString *)aStr
                                                inWidth:(CGFloat)width;
- (CGRect)setupAttributedHTMLStringWithAttributedString:
              (NSAttributedString *)aStr
                                                inWidth:(CGFloat)width
                                             isEditable:(BOOL)isEditable
                                          scrollEnabled:(BOOL)scrollEnabled;
@end

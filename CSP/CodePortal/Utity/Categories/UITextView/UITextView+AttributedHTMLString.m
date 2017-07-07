//
//  UITextView+AttributedHTMLString.m
//  HtmlParse
//
//  Created by JasonLu on 16/10/24.
//  Copyright © 2016年 JasonLu. All rights reserved.
//

#import "CUtils.h"
#import "NSString+HTML.h"
#import "UITextView+AttributedHTMLString.h"

@implementation UITextView (AttributedHTMLString)
- (CGRect)setupAttributedHTMLStringWithAttributedString:
              (NSAttributedString *)aStr
                                                inWidth:(CGFloat)width {
  return [self setupAttributedHTMLStringWithAttributedString:aStr
                                                     inWidth:width
                                                  isEditable:NO
                                               scrollEnabled:NO];
}

- (CGRect)setupAttributedHTMLStringWithAttributedString:
              (NSAttributedString *)aStr
                                                inWidth:(CGFloat)width
                                             isEditable:(BOOL)isEditable
                                          scrollEnabled:(BOOL)scrollEnabled {
  self.textContainer.lineFragmentPadding = 0;
  self.textContainerInset = UIEdgeInsetsZero;
  self.backgroundColor = [UIColor clearColor];
  self.editable = isEditable;
  self.scrollEnabled = scrollEnabled;
  self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
  self.attributedText = aStr;

  CGFloat height;
  height = [self heightForString:self andWidth:width];

  CGRect rect = self.frame;
  self.frame = CGRectMake(rect.origin.x, rect.origin.y, width, height);

  rect = self.frame;
  return rect;
}

- (float)heightForString:(UITextView *)textView andWidth:(float)width {
  CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
  return sizeToFit.height;
}

#pragma mark - 需要代理类中判断点击的类型
//- (BOOL)textView:(UITextView *)textView
//    shouldInteractWithURL:(NSURL *)URL
//                  inRange:(NSRange)characterRange {
//  NSString *requestURLString = URL.absoluteString;
//  NSString *string = [requestURLString parseHTML];
//  return YES;
//}
@end

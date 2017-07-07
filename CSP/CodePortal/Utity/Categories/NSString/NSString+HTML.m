//
//  NSString+HTML.m
//  HtmlParse
//
//  Created by JasonLu on 16/10/24.
//  Copyright © 2016年 JasonLu. All rights reserved.
//

#import "NSString+HTML.h"

@implementation NSString (HTML)
- (NSString *)parseHTML {
  NSString *trimmedString = [self
      stringByReplacingOccurrencesOfString:@"^(?:applewebdata://[0-9A-Z-]*/?)"
                                withString:@""
                                   options:NSRegularExpressionSearch
                                     range:NSMakeRange(0, self.length)];
  trimmedString = [trimmedString stringByReplacingOccurrencesOfString:@"%22"
                                                           withString:@""];

  return trimmedString;
}
@end

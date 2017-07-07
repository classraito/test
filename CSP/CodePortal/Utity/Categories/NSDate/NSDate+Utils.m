//
//  NSDate+Utils.m
//  CSP
//
//  Created by JasonLu on 16/11/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)
- (NSString *)dateFormatStringYYYYMMDD {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  NSString *strDate = [dateFormatter stringFromDate:self];
  return strDate;
}

- (NSString *)dateFormatStringMMDD{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"MM/dd"];
  NSString *strDate = [dateFormatter stringFromDate:self];
  return strDate;
}
@end

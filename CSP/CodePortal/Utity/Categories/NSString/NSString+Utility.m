//
//  NSString+Utility.m
//  CSP
//
//  Created by JasonLu on 16/8/29.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)
// MARK: -Utility Mehotds
/*!
 *  @brief 判断是否是空字符串
 *
 *  @return 判断是否是空字符串
 */
- (BOOL)isEmptyStr {
    if ([self isNullStr])
        return YES;
    
    if ([self isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}
/*!
 *  @brief 判断是否是null字符串
 *
 *  @return 判断是否是null字符串
 */
- (BOOL)isNullStr {
    if ([self isEqual:[NSNull null]] || self == nil)
        return YES;
    
    if ([self isEqualToString:@"null"] || [self isEqualToString:@"(null)"])
        return YES;
    
    return NO;
}
/*!
 *  @brief 判断是否包含或者等于所传入字符串
 *
 *  @param aString        对比的字符串
 *  @param ignorCease     是否忽略敏感大小写
 *
 *  @return 判断是否包含或者等于所传入字符串
 */
- (BOOL)contains:(NSString *)aString withIgnoreCase:(BOOL)ignorCease{
    NSRange range = [self rangeOfString:aString options:!ignorCease?0:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound)
        return YES;
    return NO;
}
/*!
 *  @brief 判断字符串是否相等
 *
 *  @param aString        对比的字符串
 *  @param ignorCease     是否忽略敏感大小写
 *
 *  @return 判断字符串是否相等
 */
- (BOOL)isEqualTo:(NSString *)aString withIgnoreCase:(BOOL)ignoreCase{
    if (ignoreCase) {
        if ([self caseInsensitiveCompare:aString] == NSOrderedSame) {
            return YES;
        }
    }
    else {
        if ([self isEqualToString:aString]){
            return YES;
        }
    }
    return NO;
}
/*!
 *  @brief 判断数字是否是一位小数
 *
 *  @return 数字是否是一位小数
 */
- (BOOL)isNumberWithOnlyOneBit {
    BOOL islimitOneBit = YES;
    NSString *searchstring = [NSString stringWithFormat:@"%@",self];
    NSRange aa=[searchstring rangeOfString:@"."];
    if (aa.location == NSNotFound) {
        NSLog(@"searchstring:%@",@"没有小数点");
    }
    else {
        NSString *subString = [searchstring substringFromIndex:aa.location+1];
        NSLog(@"subString=====r%@",subString);
        if (subString.length>1) {
            islimitOneBit = NO;
            //            [self limitAreaInputAlert];
        }
    }
    return islimitOneBit;
}
/*!
 *  @brief 判断字符串数字后面小数点几位
 *
 *  @param bit        小数点位数
 *
 *  @return 字符串数字小数点是否符合输入条件
 */
- (BOOL)isDecimalNumberWithBit:(NSInteger)bit {
    BOOL islimitOneBit = YES;
    NSString *searchstring = [NSString stringWithFormat:@"%@",self];
    NSRange aa=[searchstring rangeOfString:@"."];
    if (aa.location == NSNotFound) {
        NSLog(@"searchstring:%@",@"没有小数点");
    }
    else {
        NSString *subString = [searchstring substringFromIndex:aa.location+1];
        NSLog(@"subString=====r%@",subString);
        if (subString.length>bit) {
            islimitOneBit = NO;
        }
        
        NSRange aa=[subString rangeOfString:@"."];
        if (aa.location != NSNotFound) {
            islimitOneBit = NO;
        }
    }
    return islimitOneBit;
}
/*!
 *  @brief 格式化11位手机号码，中间4位隐藏
 *
 *  @return 隐藏中间4位的手机号码
 */
- (NSString *)formatSecretMobile {
    NSString *a=[self substringToIndex:3];
    NSString *b=[self substringFromIndex:7];
    return [a stringByAppendingFormat:@"%@%@",@"****",b];
}
/*!
 *  @brief 格式化邮箱，隐藏@之前4位
 *
 *  @return 隐藏@之前4位的邮箱地址
 */
- (NSString *)formatSecretEmail {
    NSString *a=[self substringToIndex:3];
    NSRange range2=[self rangeOfString:@"@"];
    NSString *b=[self substringFromIndex:range2.location];
    return [a stringByAppendingFormat:@"%@%@",@"****",b];
}

- (NSString *)trimmingWhitespace {
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end

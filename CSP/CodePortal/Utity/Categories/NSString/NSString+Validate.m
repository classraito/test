//
//  NSString+Validate.m
//  CSP
//
//  Created by JasonLu on 16/8/29.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NSString+Validate.h"
#import "RegexKitLite.h"

NSString* REG_EMAIL = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
NSString* REG_MOBILE = @"^(13[0-9]|15[0-9]|18[0-9])\\d{8}$";
NSString* REG_PHONE = @"^(([0\\+]\\d{2,3}-?)?(0\\d{2,3})-?)?(\\d{7,8})(-(\\d{3,}))?$";

//////////////////////////////////判断密码强度///////////////////////////////////
NSString *REG1 = @"\\d{6,}";//数字
NSString *REG2 = @"[a-zA-Z]{6,}";//字母
NSString *REG3 = @"[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]+";//特殊字符
NSString *REG4 = @"[\\da-zA-Z]*\\d+[a-zA-Z]+[\\da-zA-Z]*";//字母＋数字
NSString *REG5 = @"[-\\d`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*\\d+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]+[-\\d`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*";//特殊字符＋数字
NSString *REG6 = @"[-a-zA-Z`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*[a-zA-Z]+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]+[-a-zA-Z`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*";//字符＋特殊字符
NSString *REG7 = @"[-\\da-zA-Z`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*((\\d+[a-zA-Z]+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]+)|(\\d+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]+[a-zA-Z]+)|([a-zA-Z]+\\d+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]+)|([a-zA-Z]+[-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]+\\d+)|([-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]+\\d+[a-zA-Z]+)|([-`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]+[a-zA-Z]+\\d+))[-\\da-zA-Z`=\\\[\\];',./~!@#$%^&*()_+|{}:\"<>?]*";//字符＋特殊字母＋数字
//////////////////////////////////判断密码强度///////////////////////////////////

@implementation NSString (Validate)
// MARK: -Utility Mehotds
/*!
 *  @brief 判断是否email格式
 *
 *  @return 判断是否email格式
 */
- (BOOL)isEmail {
    return [self isMatchedByRegex:REG_EMAIL];
}
/*!
 *  @brief 判断是否电话格式
 *
 *  @return 判断是否电话格式
 */
- (BOOL)isPhoneNum {
    return [self isMatchedByRegex:REG_PHONE];
}
/*!
 *  @brief 判断是否移动电话格式
 *
 *  @return 判断是否移动电话格式
 */
- (BOOL)isMobileNum{
    // 1700: 中国电信
    // 1705: 中国移动
    // 1709: 中国联通
    //    NSString *CT1700 = @"^1700\\d{7}$";
    //    NSString *CM1705 = @"^1705\\d{7}$";
    //    NSString *CU1709 = @"^1709\\d{7}$";
    NSString *MOBILE170 = @"^170([059])\\d{7}$";
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[1278])\\d)\\d{7}$";
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString * CT = @"^1((33|53|8[039])[0-9]|349)\\d{7}$";
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextest170 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE170];
    
    BOOL res1 = [regextestmobile evaluateWithObject:self];
    BOOL res2 = [regextestcm evaluateWithObject:self];
    BOOL res3 = [regextestcu evaluateWithObject:self];
    BOOL res4 = [regextestct evaluateWithObject:self];
    BOOL res5 = [regextest170 evaluateWithObject:self];
    
    return (res1 || res2 || res3 || res4 || res5);
//    return [self isMatchedByRegex:REG_MOBILE];
}
/*!
 *  @brief 判断密码字符串的强度
 *
 *  @return 返回密码字符串的强度，强度从0-3
 */
- (int)passwordLevel {
    if([self isMatchedByRegex:REG7])
    {
        return 3;
    }
    if([self isMatchedByRegex:REG6])
    {
        return 3;
    }
    
    if([self isMatchedByRegex:REG5])
    {
        return 2;
    }
    
    if([self isMatchedByRegex:REG4])
    {
        return 2;
    }
    if([self isMatchedByRegex:REG3])
    {
        return 2;
    }
    
    if([self isMatchedByRegex:REG2])
    {
        return 1;
    }
    
    if([self isMatchedByRegex:REG1])
    {
        return 1;
    }
    return 0;
}
/*!
 *  @brief 判断是否纯数字
 *
 *  @return 是否纯数字
 */
- (BOOL)isStandardOnlyNumber{
    NSString *regex = @"^[0-9]*$";
    NSPredicate *numTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [numTest evaluateWithObject:self];
}
/*!
 *  @brief 正则表达式验证中文，字母，数字
 *
 *  @return 字符串是否中文，字母，数字
 */
- (BOOL)isStandarChineseOrNumber{
    NSString *regex = @"[a-zA-Z0-9\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pwdTest evaluateWithObject:self];
}
/*!
 *  @brief 判断字符串范围: 汉字2-12 字母4-24
 *
 *  @return 字符串是否汉字2-12 字母4-24
 */
- (BOOL)isLengthLimitFrom4To24Char{
    NSString *pwdRegex = @"^(((?![A-Za-z0-9]+$)(?![\u4e00-\u9fa5]+$)[[A-Za-z0-9]\u4e00-\u9fa5]{4,24})|([\u4e00-\u9fa5]{2,12})|([A-Za-z0-9]{4,24}))$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pwdRegex];
    return [pwdTest evaluateWithObject:self];
    
}
- (NSString *)numberFormat:(float)_number type:(int)_type
{
    //NSLog(@"::::::numberFormat:(float)%f formater:(NSString *)%@ type:(int)%d",_number,_format,_type);
    assert(_type==kCFNumberIntType||_type==kCFNumberFloatType);
    assert(_number>=0);
    assert(self);
    
    CFLocaleRef currentLocale = CFLocaleCopyCurrent();
    CFNumberFormatterRef numberFormatter = CFNumberFormatterCreate
    (NULL, currentLocale, kCFNumberFormatterNoStyle);
    CFStringRef formatString =(__bridge CFStringRef)self;
    CFNumberFormatterSetFormat(numberFormatter, formatString);
    CFStringRef formattedNumberString;
    if(_type==kCFNumberIntType)
    {
        int _numberInt=(int)_number;
        formattedNumberString = CFNumberFormatterCreateStringWithValue(NULL, numberFormatter, _type, &_numberInt);
    }
    else if(_type==kCFNumberFloatType)
    {
        float _numberFloat=(float)_number;
        formattedNumberString = CFNumberFormatterCreateStringWithValue
        (NULL, numberFormatter, _type, &_numberFloat);
    }
    // Memory management
    CFRelease(currentLocale);
    CFRelease(numberFormatter);
    NSString *retVal = (__bridge_transfer NSString *)formattedNumberString;
    return retVal;
}

- (NSString *)flattenHTMLWithTrimWhiteSpace:(BOOL)trim {
    NSScanner *theScanner = [NSScanner scannerWithString:self];
    NSString *text = nil;
    NSString* html = self;
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    // trim off whitespace
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}
@end

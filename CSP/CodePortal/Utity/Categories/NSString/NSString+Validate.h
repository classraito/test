//
//  NSString+Validate.h
//  CSP
//
//  Created by JasonLu on 16/8/29.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validate)

- (int)passwordLevel;
- (BOOL)isEmail;
- (BOOL)isPhoneNum;
- (BOOL)isMobileNum;
- (BOOL)isStandardOnlyNumber;
- (BOOL)isStandarChineseOrNumber;
- (BOOL)isLengthLimitFrom4To24Char;

+(NSString *)numberFormat:(float)_number formater:(NSString * )_format type:(int)_type;
+ (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;
@end

//
//  NSString+Utility.h
//  CSP
//
//  Created by JasonLu on 16/8/29.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)
- (BOOL)isEmptyStr;
- (BOOL)isNullStr;
- (BOOL)contains:(NSString *)aString withIgnoreCase:(BOOL)ignorCease;
- (BOOL)isEqualTo:(NSString *)aString withIgnoreCase:(BOOL)ignoreCase;
- (BOOL)isNumberWithOnlyOneBit;
- (BOOL)isDecimalNumberWithBit:(NSInteger)bit;
- (NSString *)trimmingWhitespace;
- (NSString *)formatSecretMobile;
- (NSString *)formatSecretEmail;
@end

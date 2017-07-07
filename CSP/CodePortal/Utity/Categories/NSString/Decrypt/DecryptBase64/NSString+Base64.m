//
//  NSString+Base64.m
//  DecryptTestProject
//
//  Created by JasonLu on 16/8/30.
//  Copyright © 2016年 JasonLu. All rights reserved.
//

#import "NSString+Base64.h"
#import "GTMBase64.h"

@implementation NSString (Base64)
//Base64加密
- (NSString *)encodeBase64 {
    return [GTMBase64 encodeBase64String:self];
    
}
//Based64解密
- (NSString *)decodeBase64 {
    return [GTMBase64 decodeBase64String:self];
}
@end

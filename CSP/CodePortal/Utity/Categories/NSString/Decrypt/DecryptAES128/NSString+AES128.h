//
//  NSString+AES128.h
//  DecryptTestProject
//
//  Created by JasonLu on 16/8/30.
//  Copyright © 2016年 JasonLu. All rights reserved.
//
//  iOS AES128 CBC No Padding加密解密
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@interface NSString (AES128)
-(NSString *)aes128_encryptWithKey:(NSString *)key;
-(NSString *)aes128_decryptWithKey:(NSString *)key;
@end

//
//  NSString+DES_Base64.h
//  DecryptTestProject
//
//  Created by JasonLu on 16/8/30.
//  Copyright © 2016年 JasonLu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@interface NSString (DES_Base64)
-(NSString *)des_encryptWithKey:(NSString *)key;
-(NSString *)des_decryptWithKey:(NSString *)key;
@end

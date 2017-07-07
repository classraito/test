//
//  NSString+Base64.h
//  DecryptTestProject
//
//  Created by JasonLu on 16/8/30.
//  Copyright © 2016年 JasonLu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)
- (NSString *)encodeBase64;
- (NSString *)decodeBase64;
@end

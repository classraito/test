//
//  NSString+ThreeDES_Base64.h
//  DecryptTestProject
//
//  Created by JasonLu on 16/8/30.
//  Copyright © 2016年 JasonLu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (ThreeDES_Base64)
-(NSString *)threeDes_encryptWithKey:(NSString *)key;
-(NSString *)threeDes_decryptWithKey:(NSString *)key;
@end

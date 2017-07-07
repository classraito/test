//
//  NSData+Utility.h
//  CSP
//
//  Created by JasonLu on 16/8/31.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Utility)
- (NSString*)encodeBase64String;
- (NSString*)decodeBase64String;
@end

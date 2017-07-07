//
//  NSData+Utility.m
//  CSP
//
//  Created by JasonLu on 16/8/31.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NSData+Utility.h"
#import "GTMBase64.h"

@implementation NSData (Utility)
// MARK: -Utility Methods
- (NSString*)encodeBase64String {
    NSData * data = [GTMBase64 encodeData:self];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

- (NSString*)decodeBase64String{
    NSData * data = [GTMBase64 decodeData:self];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}
@end

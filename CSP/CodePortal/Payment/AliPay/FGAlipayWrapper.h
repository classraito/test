//
//  FGAlipayWrapper.h
//  CSP
//
//  Created by Ryan Gong on 16/12/30.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGAlipayWrapper : NSObject
{
    
}
+ (FGAlipayWrapper *)shareInstance;
- (void)doAlipayPay:(NSString *)_str_signed;
@end

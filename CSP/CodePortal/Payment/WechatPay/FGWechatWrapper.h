//
//  FGWechatWrapper.h
//  CSP
//
//  Created by Ryan Gong on 17/2/6.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface FGWechatWrapper : NSObject
{
    
}
+ (FGWechatWrapper *)shareInstance;
- (void)doWechatPay:(NSString *)_str_response;
@end

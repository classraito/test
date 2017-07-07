//
//  FGCustomAlertView+Util.h
//  CSP
//
//  Created by JasonLu on 17/2/13.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGCustomAlertView.h"

@interface FGCustomAlertView (Util)
-(void)setupWithTitle:(NSString*)title message:(NSString*)message buttons:(NSArray*)buttons andCallBack:(void (^)(FGCustomAlertView *alertView, NSInteger buttonIndex))callBackBlock dismissWithButtonIndex:(NSInteger)_int_idx;
@end

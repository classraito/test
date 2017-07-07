//
//  FGCustomAlertView+Util.m
//  CSP
//
//  Created by JasonLu on 17/2/13.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGCustomAlertView+Util.h"

@implementation FGCustomAlertView (Util)
-(void)setupWithTitle:(NSString*)title message:(NSString*)message buttons:(NSArray*)buttons andCallBack:(void (^)(FGCustomAlertView *alertView, NSInteger buttonIndex))callBackBlock dismissWithButtonIndex:(NSInteger)_int_idx {
  [self setupWithTitle:title message:message buttons:buttons andCallBack:callBackBlock];
  
  self.int_dismissButtonIndex = _int_idx;
}
@end

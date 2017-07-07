//
//  NSString+LoadingDot.h
//  CSP
//
//  Created by Ryan Gong on 17/2/1.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITextField (LoadingDot)
{
    
}
@property(nonatomic,strong)NSTimer *timer_loadingDot;
-(void)showLoadingAnimationWithText:(NSString *)_str_text;
-(void)hideLoadingAnimation;
@end

//
//  NSString+LoadingDot.m
//  CSP
//
//  Created by Ryan Gong on 17/2/1.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "UILabel+LoadingDot.h"
static char timer_loadingDot;//对象类型
static const void *str_original = &str_original;//字符串类型
static char currentDotCount;//基本类型
@implementation UILabel (LoadingDot)

-(void)showLoadingAnimationWithText:(NSString *)_str_text
{
        if(!self.timer_loadingDot)
        {
            self.text = _str_text;
            self.timer_loadingDot = [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
            [self setCurrentDotCount:1];
            [self setStr_original:self.text];
        }
}

-(void)hideLoadingAnimation
{
    [self clearMemmory];
}

-(void)updateTimer:(id)_sender
{
    int _dotCount = [self currentDotCount];
    _dotCount = _dotCount < 3 ? _dotCount + 1 : 1;
    [self setCurrentDotCount:_dotCount];
    self.text = [self str_original];
    for(int i =0;i<_dotCount;i++)
    {
        self.text = [self.text stringByAppendingString:@"."];
    }
    
}

- (NSString *)str_original {
    return objc_getAssociatedObject(self, str_original);
}

- (void)setStr_original:(NSString *)aStr_original {
    objc_setAssociatedObject(self, str_original, aStr_original, OBJC_ASSOCIATION_RETAIN);
}



- (NSTimer *)timer_loadingDot {
    return objc_getAssociatedObject(self, &timer_loadingDot);
}

- (void)setTimer_loadingDot:(NSTimer *)_timer_loadingDot{
    objc_setAssociatedObject(self, &timer_loadingDot, _timer_loadingDot,
                             OBJC_ASSOCIATION_RETAIN);
}

- (void)setCurrentDotCount:(int)_cout {
    if (_cout < 0) {
        objc_setAssociatedObject(self, &currentDotCount, nil, OBJC_ASSOCIATION_RETAIN);
        return;
    }//用于置空
    objc_setAssociatedObject(self, &currentDotCount, [NSNumber numberWithFloat:_cout], OBJC_ASSOCIATION_RETAIN);
}

- (int)currentDotCount {
    return [objc_getAssociatedObject(self, &currentDotCount) intValue];
}

-(void)clearMemmory
{
    NSTimer *_timer = [self timer_loadingDot];
    [_timer invalidate];
    [self setTimer_loadingDot:nil];
    [self setStr_original:nil];
    [self setCurrentDotCount:-1];
}
@end

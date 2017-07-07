//
//  UIScrollView+FGWindowsStyleRefreshHeader.h
//  CSP
//
//  Created by Ryan Gong on 16/10/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGWindowsStyleProgressView.h"
#import <AvailabilityMacros.h>
#import <objc/runtime.h>
@interface UIScrollView (FGWindowsStyleRefreshHeader)
{
    
}
@property (nonatomic, strong, readonly) FGWindowsStyleProgressView *pullToRefreshWindowsStyleView;
- (void)addPullToRefreshWindowsStyleWithActionHandler:(void (^)(void))actionHandler;
- (void)triggerStartRefresh ;
-(void)triggerStopRefresh;
-(void)triggerSetProgressTintColor:(UIColor *)_color;
-(void)triggerRecoveryAnimationIfNeeded;
- (void)setPullToRefreshWindowsStyleView:(FGWindowsStyleProgressView *)pullToRefreshView;
@end

//
//  UIScrollView+FGWindowsStyleRefreshHeader.m
//  CSP
//
//  Created by Ryan Gong on 16/10/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "UIScrollView+FGWindowsStyleRefreshHeader.h"
static char UIScrollViewPullToRefreshView;
@implementation UIScrollView (FGWindowsStyleRefreshHeader)
@dynamic pullToRefreshWindowsStyleView;
- (void)addPullToRefreshWindowsStyleWithActionHandler:(void (^)(void))actionHandler {
    
    if (!self.pullToRefreshWindowsStyleView) {
        CGFloat yOrigin = 0;
        FGWindowsStyleProgressView *progressView = [[FGWindowsStyleProgressView alloc] initWithFrame:CGRectMake(0,yOrigin,W  ,4)];
        progressView.trackTintColor = [UIColor clearColor];
      progressView.progressTintColor = [UIColor whiteColor];
        
        
        progressView.pullToRefreshActionHandler = actionHandler;
        progressView.scrollView = self;
        [self addSubview:progressView];
        [self bringSubviewToFront:progressView];
        
        self.pullToRefreshWindowsStyleView = progressView;
//        self.pullToRefreshWindowsStyleView.backgroundColor = [UIColor blackColor];
        [self addObserver:self.pullToRefreshWindowsStyleView
               forKeyPath:@"contentOffset"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    }
}

- (void)triggerStartRefresh {
    [self.pullToRefreshWindowsStyleView startAnimating];
}

-(void)triggerStopRefresh
{
    [self.pullToRefreshWindowsStyleView stopAnimating];
}

-(void)triggerRecoveryAnimationIfNeeded
{
    [self.pullToRefreshWindowsStyleView recoveryAnimtaionIfNeeded];
}

-(void)triggerSetProgressTintColor:(UIColor *)_color;
{
    [self.pullToRefreshWindowsStyleView setProgressTintColor:_color] ;
}

- (void)setPullToRefreshWindowsStyleView:(FGWindowsStyleProgressView *)pullToRefreshWindowsStyleView {
    
    if(!pullToRefreshWindowsStyleView)
    {
        [self removeObserver:self.pullToRefreshWindowsStyleView forKeyPath:@"contentOffset" context:nil];
    }
    
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             pullToRefreshWindowsStyleView, OBJC_ASSOCIATION_ASSIGN);
}


- (FGWindowsStyleProgressView *)pullToRefreshWindowsStyleView {
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

@end

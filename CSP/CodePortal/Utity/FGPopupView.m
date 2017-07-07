//
//  FGPopupView.m
//  DurexBaby
//
//  Created by luyang on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FGPopupView.h"

static CGFloat kTransitionDuration = 0.3;
@implementation FGPopupView
@synthesize view_bg;
@synthesize blurView;
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    view_bg = [[UIView alloc] initWithFrame:self.bounds];
    view_bg.backgroundColor = rgba(0, 0, 0, .8);
    [self addSubview:view_bg];
    [self sendSubviewToBack:view_bg];
    [self startAnim];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    view_bg.frame  = self.bounds;
}

- (void)bounce1AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    self.transform = CGAffineTransformMakeScale(1, 1);
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView commitAnimations];
    
}

-(void)startAnim
{
    self.transform = CGAffineTransformMakeScale(.7, .7);;
    self.alpha = 1;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/3.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    [UIView commitAnimations];
    
   // self.blurView = [[DRNRealTimeBlurView alloc] initWithFrame:CGRectMake(60, 110, 200, 200)];
}

-(void)closePopup
{
    [UIView animateWithDuration:1.2 animations:^{
        [UIView setAnimationDuration:kTransitionDuration/2];
       // self.transform = CGAffineTransformMakeScale(.01, .01);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished)
        {
             [self removeFromSuperview];
        }
    }];
   
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    view_bg = nil;
}
@end


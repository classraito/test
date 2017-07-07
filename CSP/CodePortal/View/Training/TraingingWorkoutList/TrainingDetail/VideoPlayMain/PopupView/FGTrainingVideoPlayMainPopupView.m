//
//  FGTrainingVideoPlayMainPopupView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/30.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingVideoPlayMainPopupView.h"
#import "Global.h"


#pragma mark -FGTrainingVideoPlayMainPopupView_WatchVideo
@implementation FGTrainingVideoPlayMainPopupView_WatchVideo
@synthesize lb_commingup;
@synthesize lb_makesure;
@synthesize lb_count;
@synthesize cub_watchVideo;
@synthesize iv_playIcon;
@synthesize btn_watchVideo;
@synthesize delegate;
@synthesize numCount;
@synthesize cub_skip;
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [commond useDefaultRatioToScaleView:lb_commingup];
    [commond useDefaultRatioToScaleView:lb_makesure];
    [commond useDefaultRatioToScaleView:lb_count];
    [commond useDefaultRatioToScaleView:cub_watchVideo];
    [commond useDefaultRatioToScaleView:iv_playIcon];
    [commond useDefaultRatioToScaleView:btn_watchVideo];
    [commond useDefaultRatioToScaleView:cub_skip];
    
    lb_commingup.font = font(FONT_TEXT_BOLD, 20);
    lb_makesure.font = font(FONT_TEXT_BOLD, 30);
    lb_count.font = font(FONT_NUM_MEDIUM, 100);
    cub_watchVideo.btn.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    
    [cub_watchVideo.btn setTitle:multiLanguage(@"Watch the warm up video") forState:UIControlStateNormal];
    [cub_watchVideo.btn setTitle:multiLanguage(@"Watch the warm up video") forState:UIControlStateHighlighted];
    btn_watchVideo.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn_watchVideo.titleLabel.font = font(FONT_TEXT_REGULAR, 20);
    
    [cub_watchVideo.btn setTitleColor:rgb(70, 135, 133) forState:UIControlStateNormal];
    [cub_watchVideo.btn setTitleColor:rgb(70, 135, 133) forState:UIControlStateHighlighted];
    cub_watchVideo.view_line.backgroundColor = cub_watchVideo.btn.titleLabel.textColor;
    
    cub_skip.btn.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    [cub_skip.btn setTitle:multiLanguage(@"Skip") forState:UIControlStateNormal];
    [cub_skip.btn setTitle:multiLanguage(@"Skip") forState:UIControlStateHighlighted];
    [cub_skip.btn setTitleColor:rgb(70, 135, 133) forState:UIControlStateNormal];
    [cub_skip.btn setTitleColor:rgb(70, 135, 133) forState:UIControlStateHighlighted];
    cub_skip.view_line.backgroundColor = cub_skip.btn.titleLabel.textColor;
    
    lb_commingup.text = multiLanguage(@"Here we go!");
    lb_makesure.text = multiLanguage(@"Don't forget\nto warm up!");
    lb_makesure.numberOfLines = 0;
    
    numCount = 5;
    
    
    
}

-(void)setupTimer
{
    lb_count.text = [NSString stringWithFormat:@"%d",numCount];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCount) userInfo:nil repeats:YES];
}

-(void)updateCount
{
    numCount = numCount > 0 ? numCount - 1 : 0;
    lb_count.text = [NSString stringWithFormat:@"%d",numCount];
    if(numCount == 0)
    {
        [self invalidateTimer];
        if(delegate && [delegate respondsToSelector:@selector(timerDisCountFinished_warmup)])
        {
            [delegate timerDisCountFinished_warmup];
        }
    }
}

-(void)invalidateTimer
{
    SAFE_INVALIDATE_TIMER(timer);
}


-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end


#pragma mark -FGTrainingVideoPlayMainPopupView_GetReady
@implementation FGTrainingVideoPlayMainPopupView_GetReady
@synthesize delegate;
@synthesize lb_getReady;
@synthesize lb_count;
@synthesize numCount;
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:lb_getReady];
    [commond useDefaultRatioToScaleView:lb_count];
    
    numCount = 10;
    
    lb_getReady.font = font(FONT_TEXT_BOLD, 30);
    lb_count.font = font(FONT_NUM_REGULAR, 100);
    
    lb_getReady.text = multiLanguage(@"GET READY!");
}

-(void)setupTimer
{
    lb_count.text = [NSString stringWithFormat:@"%d",numCount];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCount) userInfo:nil repeats:YES];
}

-(void)updateCount
{
    numCount = numCount > 0 ? numCount - 1 : 0;
    lb_count.text = [NSString stringWithFormat:@"%d",numCount];
    if(numCount == 0)
    {
        [self invalidateTimer];
        FGVideoModel *model = [FGVideoModel sharedModel];
        [model playVideoByCurrentPlayerItemInVideoQueue];
        if(delegate && [delegate respondsToSelector:@selector(timerDisCountFinished)])
        {
            [delegate timerDisCountFinished];
        }
    }
}

-(void)invalidateTimer
{
    SAFE_INVALIDATE_TIMER(timer);
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

#pragma mark -FGTrainingVideoPlayMainPopupView_Pause
@implementation FGTrainingVideoPlayMainPopupView_Pause
@synthesize cirB_play;
@synthesize cirB_stop;
@synthesize lb_shakeToPause;
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:cirB_play];
    [commond useDefaultRatioToScaleView:cirB_stop];
    [commond useDefaultRatioToScaleView:lb_shakeToPause];
    
    lb_shakeToPause.text = multiLanguage(@"Shake your phone\nto continue");
    lb_shakeToPause.userInteractionEnabled = NO;
    lb_shakeToPause.font = font(FONT_TEXT_REGULAR, 20);
    lb_shakeToPause.numberOfLines = 0;
    
    [cirB_stop setupCircularButtonByBgColor:[UIColor whiteColor] bgHighlightColor:[UIColor blackColor] textColor:[UIColor blackColor] textHighlightColor:[UIColor whiteColor] btnText:multiLanguage(@"STOP") btnHighlightedText:multiLanguage(@"STOP") buttonFont:font(FONT_TEXT_REGULAR, 20)];
    
    [cirB_play setupCircularButtonByBgColor:[UIColor whiteColor] bgHighlightColor:[UIColor blackColor] textColor:[UIColor blackColor] textHighlightColor:[UIColor whiteColor] btnText:multiLanguage(@"PLAY") btnHighlightedText:multiLanguage(@"PLAY") buttonFont:font(FONT_TEXT_REGULAR, 20)];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

//
//  FGTrainingVideoPlayMainView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingVideoPlayMainView.h"
#import "Global.h"
#import "FGVideoModel.h"
#import "FGTrainingVideoPlayMainPopupView.h"
#import "FGTrainingVideoPlayMainViewController.h"
#include <CoreMotion/CoreMotion.h>
@interface FGTrainingVideoPlayMainView()
{
    
    NSTimer *timer_updateUI;
    
    
}
@end

@implementation FGTrainingVideoPlayMainView
@synthesize lb_videoCount;
@synthesize lb_totalVideoTime;
@synthesize view_processBar;
@synthesize view_processBarBG;
@synthesize cirB_currentVideTome;
@synthesize view_videoContainer;
@synthesize lb_pressToPause;
@synthesize popupView_pause;
@synthesize popupView_watchVideo;
@synthesize popupView_getReady;
@synthesize model_video;
#pragma mark - 生命周期
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    [self becomeFirstResponder];
    [commond useDefaultRatioToScaleView:lb_videoCount];
    [commond useDefaultRatioToScaleView:lb_totalVideoTime];
    [commond useDefaultRatioToScaleView:view_processBar];
    [commond useDefaultRatioToScaleView:view_processBarBG];
    [commond useDefaultRatioToScaleView:cirB_currentVideTome];
    [commond useDefaultRatioToScaleView:view_videoContainer];
    [commond useDefaultRatioToScaleView:lb_pressToPause];
    
    lb_totalVideoTime.font = font(FONT_NUM_MEDIUM, 30);
    lb_videoCount.font = font(FONT_NUM_MEDIUM, 30);
    
    [cirB_currentVideTome setupCircularButtonByBgColor:rgb(53, 113, 110) bgHighlightColor:rgb(53, 113, 110) textColor:[UIColor whiteColor] textHighlightColor:[UIColor whiteColor] btnText:@"00:00" btnHighlightedText:@"00:00" buttonFont:font(FONT_NUM_MEDIUM, 30)];
    lb_pressToPause.text = multiLanguage(@"Shake your phone\nto pause");
    lb_pressToPause.userInteractionEnabled = NO;
    lb_pressToPause.font = font(FONT_TEXT_REGULAR, 20);
    lb_pressToPause.numberOfLines = 0;
    
    cirB_currentVideTome.btn.userInteractionEnabled = NO;
    
    
    view_videoContainer.userInteractionEnabled = NO;
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_pause:)];
    _tap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:_tap];
    
    [self hideTipsIfNeeded];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:)
                                                 name:UIApplicationWillTerminateNotification object:nil];//监听是否触发home键挂起程序.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];//监听是否重新进入程序程序.
}

-(void)hideTipsIfNeeded
{
    id obj = [commond getUserDefaults:KEY_VIDEOMAIN_HIDETIPS];
    if(obj)
    {
        lb_pressToPause.hidden = YES;
    }
}

-(void)setupModel
{
    model_video = [FGVideoModel sharedModel];
    model_video.currentPlayerItemIndex = 0;
    [model_video internalInitalFilePathsByUrls:model_video.arr_urls];
    [model_video internalInitalAudioFilePathsByUrls:model_video.arr_audioUrls];//TODO:rui.gong update it
    [model_video initalAllPlayerItemsByCurrentFilePaths];
    [model_video initalVideoQueuePlayerLayer];
    [model_video addPlayerLayerToVideoContainerView:view_videoContainer];
    
    [self restartTimer];
}

-(void)restartTimer
{
    [self cancelTimer];
    timer_updateUI = [NSTimer scheduledTimerWithTimeInterval:.06 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [model_video finishVideoQueue];
    popupView_pause = nil;
    popupView_getReady = nil;
    popupView_watchVideo = nil;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - 更新界面
-(void)updateUI
{
    lb_totalVideoTime.text = [model_video giveMeTotalVideoRemainingTimeInQueue];
    lb_videoCount.text = [model_video giveMeCurrentPlayerItemIndexInAllItems];
    if(model_video.isVideoRollbacking)//避免因为视频回滚导致的进度倒转问题
    {
        NSLog(@"::::::::>video is rollbacking please wait...");
        return;
    }
    
    
    
    NSString *_str_currentVideoTime = [model_video giveMeCurrentRemainingTimeWithClockFormat];
    [cirB_currentVideTome.btn setTitle:_str_currentVideoTime forState:UIControlStateNormal];
    [cirB_currentVideTome.btn setTitle:_str_currentVideoTime forState:UIControlStateHighlighted];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    float _progressPercent = [model_video giveMeCurrentVideoPlayedProcessInQueue];
    CGRect _frame = view_processBar.frame;
    _frame.size.width = view_processBarBG.frame.size.width * _progressPercent;
    view_processBar.frame = _frame;
    [UIView commitAnimations];
}

-(void)cancelTimer
{
    SAFE_INVALIDATE_TIMER(timer_updateUI);
    timer_updateUI = nil;
}


-(void)popup_pauseView
{
    if(popupView_pause)
        return;
    
    popupView_pause = [[[NSBundle mainBundle] loadNibNamed:@"FGTrainingVideoPlayMainPopupView" owner:nil options:nil] objectAtIndex:PopUpType_Training_PlayMainVideo_Pause];
    [commond useDefaultRatioToScaleView:popupView_pause];
    [self addSubview:popupView_pause];
    
    [popupView_pause.cirB_stop.btn addTarget:self action:@selector(buttonAction_stop:) forControlEvents:UIControlEventTouchUpInside];
    [popupView_pause.cirB_play.btn addTarget:self action:@selector(buttonAction_play:) forControlEvents:UIControlEventTouchUpInside];
    
    [model_video.playerLayer_playVideoQueue.player pause];
    [model_video pauseAudio];
}

#pragma mark - buttonAction
-(void)buttonAction_stop:(id)_sender
{
    if(popupView_pause)
    {
        [popupView_pause closePopup];
        popupView_pause = nil;
    }
    
    [self cancelTimer];
    
    FGTrainingVideoPlayMainViewController *vc = (FGTrainingVideoPlayMainViewController *)[self viewController];
    [vc resetTrainingModelIfNeeded];//如果换成了warmup视频的模型则重置回training video的模型
    
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager popViewControllerInNavigation:&nav_current animated:YES];
    
    
}

-(void)buttonAction_play:(id)_sender
{
    if(popupView_pause)
    {
        [popupView_pause closePopup];
        popupView_pause = nil;
        [model_video.playerLayer_playVideoQueue.player play];
        [model_video playAudio];
        
    }
}

-(void)tap_pause:(id)_sender;
{
    static BOOL isPopup = NO;
    isPopup = isPopup ? NO : YES;
    if(isPopup)
    {
        [self popup_pauseView];
        lb_pressToPause.hidden = YES;
        [commond setUserDefaults:[NSNumber numberWithBool:YES] forKey:KEY_VIDEOMAIN_HIDETIPS];
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

//开始摇一摇
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    FGTrainingVideoPlayMainViewController *vc = (FGTrainingVideoPlayMainViewController *)[self viewController];
    
    if(!popupView_pause && !vc.view_training_watchVideo && !vc.view_training_getReady )
        [self tap_pause:nil];
    else
        [self buttonAction_play:nil];
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    //摇一摇被打断(比如摇的过程中来电话)
    
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    //摇一摇结束的时候操作
    
}

#pragma mark - 处理程序生命周期  如果程序中断 那么暂停视频
-(void)applicationWillResignActive:(UIApplication *)application
{
    FGTrainingVideoPlayMainViewController *vc = (FGTrainingVideoPlayMainViewController *)[self viewController];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    if(!popupView_pause && !vc.view_training_watchVideo && !vc.view_training_getReady )
        [self tap_pause:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    FGTrainingVideoPlayMainViewController *vc = (FGTrainingVideoPlayMainViewController *)[self viewController];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   
    if(!popupView_pause && !vc.view_training_watchVideo && !vc.view_training_getReady )
        [self tap_pause:nil];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}
@end

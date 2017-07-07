//
//  FGTimerViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/8/31.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTimerViewController.h"
#import "Global.h"
@interface FGTimerViewController (Private)

@end

@implementation FGTimerViewController
@synthesize btn_roundTimer;
@synthesize btn_stopWatch;
@synthesize view_separatorLine;
@synthesize view_clockContent;
@synthesize view_roundTmer;
@synthesize view_stopWatch;
@synthesize model_roundTimer;
@synthesize model_stopWatch;
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];//监听是否触发home键挂起程序.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];//监听是否重新进入程序程序.
    
    
    
    self.view_topPanel.str_title = multiLanguage(@"TIMER");
    
    self.view_topPanel.view_separator.hidden = NO;
    [self hideBottomPanelWithAnimtaion:NO];
    
    [btn_roundTimer setTitle:multiLanguage(@"ROUND TIMER") forState:UIControlStateNormal];
    [btn_roundTimer setTitle:multiLanguage(@"ROUND TIMER") forState:UIControlStateHighlighted];
    [btn_stopWatch setTitle:multiLanguage(@"STOPWATCH") forState:UIControlStateNormal];
    [btn_stopWatch setTitle:multiLanguage(@"STOPWATCH") forState:UIControlStateHighlighted];
    
    btn_roundTimer.titleLabel.font = font(FONT_TEXT_BOLD, 16);
    btn_stopWatch.titleLabel.font = font(FONT_TEXT_BOLD, 16);
    
    [self internalInitalModel];
    
    [self buttonAction_roundTimer:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view_topPanel.backgroundColor = rgb(38, 38, 38);
}

-(void)internalInitalModel
{
    model_roundTimer = [FGRoundTimerLogicModel sharedRoundTimerModel];
    model_stopWatch = [FGStopWatchLogicModel sharedStopWatchModel];
}

-(void)internalInitalRoundTimer
{
    if(view_roundTmer)
        return;
    
   
    view_roundTmer = (FGRoundTimerView *)[[[NSBundle mainBundle] loadNibNamed:@"FGRoundTimerView" owner:nil options:nil] objectAtIndex:0];
    [view_clockContent addSubview:view_roundTmer];
    [commond useDefaultRatioToScaleView:view_roundTmer];
    [view_roundTmer loadModel:model_roundTimer];
}

-(void)internalInitalStopWatch
{
    if(view_stopWatch)
        return;
    
    
    
    view_stopWatch = (FGStopWatchView *)[[[NSBundle mainBundle] loadNibNamed:@"FGStopWatchView" owner:nil options:nil] objectAtIndex:0];
    [view_clockContent addSubview:view_stopWatch];
    [commond useDefaultRatioToScaleView:view_stopWatch];
    [view_stopWatch loadModel:model_stopWatch];
   
}

-(void)manullyFixSize
{
    [super manullyFixSize];
    
    [commond useDefaultRatioToScaleView:btn_roundTimer];
    [commond useDefaultRatioToScaleView:btn_stopWatch];
    [commond useDefaultRatioToScaleView:view_separatorLine];
    [commond useDefaultRatioToScaleView:view_clockContent];
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [model_stopWatch cleanModel];
    [model_roundTimer cleanModel];
    
    
    model_roundTimer.delegate = nil;
    model_stopWatch = nil;
    model_roundTimer = nil;
    
    if(view_roundTmer)
        [view_roundTmer clearTimer];
    
    if(view_stopWatch)
        [view_stopWatch clearTimer];
}

#pragma mark - 从父类继承的方法
-(void)buttonAction_left:(id)_sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)buttonAction_right:(id)_sender//setting
{
    FGTimerSettingViewController *vc_timer_setting = [[FGTimerSettingViewController alloc] initWithNibName:@"FGTimerSettingViewController" bundle:nil model:model_roundTimer];
    [self presentViewController:vc_timer_setting animated:YES completion:nil];
    
    if(view_roundTmer)
    {
        [view_roundTmer pause];
    }
}

#pragma mark - buttonAction
-(IBAction)buttonAction_roundTimer:(id)_sender;
{
    [btn_roundTimer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_roundTimer setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn_stopWatch setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn_stopWatch setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [self internalInitalRoundTimer];
    if(view_stopWatch)
    {
        view_stopWatch.hidden = YES;
        view_roundTmer.hidden = NO;
        self.view_topPanel.btn_right.hidden = NO;
        self.view_topPanel.iv_right.hidden = NO;
        [view_stopWatch stop];
    }
}

-(IBAction)buttonAction_stopWatch:(id)_sender;
{
    [btn_roundTimer setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn_roundTimer setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn_stopWatch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_stopWatch setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self internalInitalStopWatch];
    if(view_roundTmer)
    {
        [view_roundTmer pause];
        view_roundTmer.hidden = YES;
        view_stopWatch.hidden = NO;
        self.view_topPanel.btn_right.hidden = YES;
        self.view_topPanel.iv_right.hidden = YES;
    }
}

#pragma mark - 处理程序生命周期
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if(view_roundTmer)
    {
        [view_roundTmer pause];
    }
    if(view_stopWatch)
    {
        [view_stopWatch stop];
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  
}

@end

//
//  FGRoundTimerView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGRoundTimerView.h"
#import "Global.h"

@interface FGRoundTimerView()
{
    NSTimer *timer_updateUI;
    CGRect originalFrame_roundName;
    CGRect originalFrame_title;
    FGRoundTimerLogicModel *model_roundTimer;
}
@end

@implementation FGRoundTimerView
@synthesize view_clock;
@synthesize cirB_reset;
@synthesize cirB_start_pause;
@synthesize lb_key_elapsed;
@synthesize lb_key_remaining;
@synthesize lb_value_elapsed;
@synthesize lb_value_remaining;

@synthesize iv_arr_left;
@synthesize iv_arr_right;
@synthesize lb_timeCount;
@synthesize lb_title;
@synthesize lb_roundName;

@synthesize btn_arr_left;
@synthesize btn_arr_right;

@synthesize roundTimerStatus;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [commond useDefaultRatioToScaleView:view_clock];
    [commond useDefaultRatioToScaleView:cirB_start_pause];
    [commond useDefaultRatioToScaleView:cirB_reset];
    [commond useDefaultRatioToScaleView:lb_key_elapsed];
    [commond useDefaultRatioToScaleView:lb_key_remaining];
    [commond useDefaultRatioToScaleView:lb_value_elapsed];
    [commond useDefaultRatioToScaleView:lb_value_remaining];
    
    [commond useDefaultRatioToScaleView:iv_arr_left];
    [commond useDefaultRatioToScaleView:iv_arr_right];
    [commond useDefaultRatioToScaleView:lb_timeCount];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_roundName];
    
    [commond useDefaultRatioToScaleView:btn_arr_right];
    [commond useDefaultRatioToScaleView:btn_arr_left];
    
    lb_timeCount.font = font(FONT_NUM_MEDIUM, 200);
    lb_title.font = font(FONT_TEXT_REGULAR, 21);
    lb_roundName.font = font(FONT_TEXT_REGULAR, 21);
    lb_key_elapsed.font = font(FONT_TEXT_REGULAR, 16);
    lb_key_remaining.font = font(FONT_TEXT_REGULAR, 16);
    lb_value_elapsed.font = font(FONT_NUM_REGULAR, 26);
    
    lb_value_remaining.font = font(FONT_NUM_REGULAR, 26);
    
    lb_key_elapsed.text = multiLanguage(@"Elapsed");
    lb_key_remaining.text = multiLanguage(@"Remaining");
    
    originalFrame_title = lb_title.frame;
    originalFrame_roundName = lb_roundName.frame;
    
    [cirB_start_pause setupCircularButtonByBgColor:color_deepgreen bgHighlightColor:color_lightgreen textColor:[UIColor whiteColor] textHighlightColor:[UIColor whiteColor] btnText:multiLanguage(@"START") btnHighlightedText:multiLanguage(@"PAUSE") buttonFont:font(FONT_TEXT_BOLD, 18)];
    
    [cirB_reset setupCircularButtonByBgColor:color_lightgreen bgHighlightColor:color_deepgreen textColor:[UIColor whiteColor] textHighlightColor:[UIColor whiteColor] btnText:multiLanguage(@"RESET") btnHighlightedText:multiLanguage(@"RESET") buttonFont:font(FONT_TEXT_BOLD, 18)];
    
    [cirB_start_pause.btn addTarget:self action:@selector(buttonAction_start_pause:) forControlEvents:UIControlEventTouchUpInside];
    [cirB_reset.btn addTarget:self action:@selector(buttonAction_reset:) forControlEvents:UIControlEventTouchUpInside];
    
    roundTimerStatus = RoundTimerStatus_Inital;
    
    timer_updateUI = [NSTimer scheduledTimerWithTimeInterval:.06 target:self selector:@selector(bindDataToUI) userInfo:nil repeats:YES];
    
}

-(void)clearTimer
{
    SAFE_INVALIDATE_TIMER(timer_updateUI);
}

-(void)loadModel:(FGRoundTimerLogicModel *)_model
{
    model_roundTimer = _model;
    model_roundTimer.delegate = self;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

#pragma mark - 更新时钟界面主循环
-(void)bindDataToUI
{
    if(!model_roundTimer)
        return;
    
    NSMutableDictionary *_dic_infoAboutUI = [model_roundTimer updateTimerCount];
    if(!_dic_infoAboutUI)
        return;
    
    
    NSString *str_CurrentSecs = [_dic_infoAboutUI objectForKey:KEY_SHOWTOUI_CurrentSecs];
    NSString *str_remainTime = [_dic_infoAboutUI objectForKey:KEY_SHOWTOUI_RemainTime];
    NSString *str_elapsedTime = [_dic_infoAboutUI objectForKey:KEY_SHOWTOUI_ElapsedTime];
    NSInteger totalRound = [[_dic_infoAboutUI objectForKey:KEY_SHOWTOUI_TotalRound] integerValue];
    NSInteger currentRound = [[_dic_infoAboutUI objectForKey:KEY_SHOWTOUI_CurrentRound] integerValue];
    TimerType timerType = (TimerType)[[_dic_infoAboutUI objectForKey:KEY_SHOWTOUI_CurrentTimerType] integerValue];
    RoundTimerType roundTimerType = (RoundTimerType)[[_dic_infoAboutUI objectForKey:KEY_SHOWTOUI_CurrentRoundTimerType] integerValue];

    lb_value_elapsed.text = str_elapsedTime;
    lb_value_remaining.text = str_remainTime;
    if(timerType == TimerType_Round)
    {
        lb_title.text = [model_roundTimer giveMeRoundTimerTypeNameByType:roundTimerType];
        lb_roundName.text = [NSString stringWithFormat:@"%@ %ld - %ld",multiLanguage(@"Round"),currentRound,totalRound ];
        lb_roundName.hidden = NO;
        lb_roundName.frame = originalFrame_roundName;
        lb_title.frame = originalFrame_title;
    }
    else
    {
        lb_roundName.hidden = YES;
        lb_title.center = CGPointMake(lb_title.center.x, iv_arr_left.center.y);
        lb_title.text = [model_roundTimer giveMeTimerTypeNameByType:timerType];
    }
    lb_timeCount.text = str_CurrentSecs;
    
//    NSLog(@"str_CurrentSecs = %@",str_CurrentSecs);
}

-(void)start
{
    [cirB_start_pause setHighlighted];//文本START 换为 PAUSE
    
    [model_roundTimer start];
    roundTimerStatus = RoundTimerStatus_Play;
}

-(void)pause
{
    
        if(roundTimerStatus == RoundTimerStatus_Inital)
        {
            [cirB_start_pause.btn setTitle:multiLanguage(@"START") forState:UIControlStateNormal];
            [cirB_start_pause.btn setTitle:multiLanguage(@"START") forState:UIControlStateHighlighted];//文本PAUSE 换为RESUME
        }
        else if(roundTimerStatus == RoundTimerStatus_Play || roundTimerStatus == RoundTimerStatus_Resume)
        {
             [cirB_start_pause setNormal];
            [cirB_start_pause.btn setTitle:multiLanguage(@"RESUME") forState:UIControlStateNormal];
            [cirB_start_pause.btn setTitle:multiLanguage(@"RESUME") forState:UIControlStateHighlighted];//文本PAUSE 换为RESUME
           
        }
    
        [model_roundTimer pause];
        roundTimerStatus = RoundTimerStatus_Pause;
    
}

-(void)resume
{
    
    
    [model_roundTimer resume];
    roundTimerStatus = RoundTimerStatus_Resume;
    [cirB_start_pause setHighlighted];//文本START 换为 PAUSE
}

-(void)reset
{
    [cirB_start_pause setNormal];//文本换为 START
    
    roundTimerStatus = RoundTimerStatus_Inital;
    [model_roundTimer reset];
}

#pragma mark - 按钮更新roundTimerStatus
-(void)updateRoundTimerStatus
{
    switch (roundTimerStatus) {
        case RoundTimerStatus_Inital:
            [self start];
            break;
        
        case RoundTimerStatus_Play:
            [self pause];
            break;
        
        case RoundTimerStatus_Pause:
            [self resume];
            break;
        case RoundTimerStatus_Resume:
            [self pause];
            break;
        case RoundTimerStatus_Reset:
            [self reset];
            break;
        default:
            break;
    }
}

#pragma mark - FGRoundTimerLogicModelDelegate
-(void)roundTimerDidFinishEachRound:(FGRoundTimerLogicModel *)model
{
    [self pause];
}

#pragma mark - 按钮事件
-(IBAction)buttonAction_arr_left:(id)_sender;
{
    [model_roundTimer previousPage];
}

-(IBAction)buttonAction_arr_right:(id)_sender;
{
    [model_roundTimer nextPage];
}

-(void)buttonAction_start_pause:(id)_sender;
{
    [self updateRoundTimerStatus];
}

-(void)buttonAction_reset:(id)_sender;
{
    roundTimerStatus = RoundTimerStatus_Reset;
    [self updateRoundTimerStatus];
}
@end
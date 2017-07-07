//
//  FGStopWatchView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGStopWatchView.h"
#import "Global.h"
#import "FGStopWatchLogicModel.h"
#import "FGStopWatchLogCellView.h"
#define DEFAULT_CELL 3


@interface FGStopWatchView()
{
    FGStopWatchLogicModel *model_stopWatch;
    NSTimer *timer_updateUI;
    StopWatchStatus currentStopWatchStatus;
    
}
@end

@implementation FGStopWatchView
@synthesize cirB_lap_reset;
@synthesize cirB_play_stop;
@synthesize tb_clock;
@synthesize view_clock;
@synthesize lb_lapTime;
@synthesize lb_totalTime;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:cirB_play_stop];
    [commond useDefaultRatioToScaleView:cirB_lap_reset];
    [commond useDefaultRatioToScaleView:view_clock];
    [commond useDefaultRatioToScaleView:tb_clock];
    [commond useDefaultRatioToScaleView:lb_lapTime];
    [commond useDefaultRatioToScaleView:lb_totalTime];
    
    [cirB_play_stop setupCircularButtonByBgColor:color_deepgreen bgHighlightColor:color_lightgreen textColor:[UIColor whiteColor] textHighlightColor:[UIColor whiteColor] btnText:multiLanguage(@"START") btnHighlightedText:multiLanguage(@"STOP") buttonFont:font(FONT_TEXT_BOLD, 20)];
    
    [cirB_lap_reset setupCircularButtonByBgColor:color_lightgreen bgHighlightColor:color_lightgreen textColor:[UIColor whiteColor] textHighlightColor:[UIColor whiteColor] btnText:multiLanguage(@"LAP") btnHighlightedText:multiLanguage(@"RESET") buttonFont:font(FONT_TEXT_BOLD, 20)];
   // [cirB_lap_reset setMyBackgroundColor:color_lap_unclick];
    
    [cirB_lap_reset.btn addTarget:self  action:@selector(buttonAction_lap_reset:) forControlEvents:UIControlEventTouchUpInside];
    [cirB_play_stop.btn addTarget:self action:@selector(buttonAction_start_stop:) forControlEvents:UIControlEventTouchUpInside];
    
    
    lb_totalTime.font = font(FONT_NUM_MEDIUM, 200);
    lb_lapTime.font = font(FONT_NUM_REGULAR, 45);
    
    currentStopWatchStatus = StopWatchStatus_Inital;
    
    [self startTimer];
}

-(void)startTimer
{
    timer_updateUI = [NSTimer scheduledTimerWithTimeInterval:.06 target:self selector:@selector(bindDataToUI) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer_updateUI forMode:NSRunLoopCommonModes];
}

-(void)bindDataToUI
{
    if(!model_stopWatch)
        return;
    NSMutableDictionary *_dic_infoAboutUI = [model_stopWatch updateTimerCount];
    if(!_dic_infoAboutUI)
        return;
    
    NSString *str_clockformat = [_dic_infoAboutUI objectForKey:KEY_SHOWTOUI_CLOCKFORMAT];
    NSString *str_clockformat_lap = [_dic_infoAboutUI objectForKey:KEY_SHOWTOUI_CLOCKFORMAT_LAP];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        lb_totalTime.text = str_clockformat;
        lb_lapTime.text = str_clockformat_lap;
        
    });
//    NSLog(@"2.str_clockformat = %@",str_clockformat);
    
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(void)clearTimer
{
    SAFE_INVALIDATE_TIMER(timer_updateUI);
}

#pragma mark - 加载模型
-(void)loadModel:(FGStopWatchLogicModel *)_model
{
    model_stopWatch = _model;
    [self internalInitalHistory];
}

#pragma mark - 初始化计时记录的scrollview
-(void)internalInitalHistory
{
    [tb_clock loadModel:model_stopWatch];
}



#pragma mark - 计时操作
-(void)start
{
    if(currentStopWatchStatus == StopWatchStatus_Inital||
       currentStopWatchStatus == StopWatchStatus_Stop)
    {
        currentStopWatchStatus = StopWatchStatus_Start;
        [cirB_play_stop setHighlighted];
        [cirB_lap_reset setNormal];
        
        [model_stopWatch start];
    }
}

-(void)stop
{
    if(currentStopWatchStatus == StopWatchStatus_Start)
    {
        currentStopWatchStatus = StopWatchStatus_Stop;
        [cirB_play_stop setNormal];
        [cirB_lap_reset setHighlighted];
        
        [model_stopWatch stop];
    }
}

-(void)reset
{
    if(currentStopWatchStatus == StopWatchStatus_Stop)
    {
        currentStopWatchStatus = StopWatchStatus_Inital;
        [cirB_play_stop setNormal];
        [cirB_lap_reset setNormal];
        [cirB_lap_reset setMyBackgroundColor:color_lap_unclick];
        
        [model_stopWatch reset];
        [tb_clock loadModel:model_stopWatch];
    }
}

-(void)lap
{
    if(currentStopWatchStatus == StopWatchStatus_Start)
    {
        [model_stopWatch lap];
        [tb_clock loadModel:model_stopWatch];
    }
}

#pragma mark - 按钮事件
-(void)buttonAction_start_stop:(id)_sender;
{
    switch (currentStopWatchStatus) {
        case StopWatchStatus_Inital:
            [self start];
            break;
            
        case StopWatchStatus_Start:
            [self stop];
            break;
            
        case StopWatchStatus_Stop:
            [self start];
            break;
        default:
            break;
    }

}

-(void)buttonAction_lap_reset:(id)_sender;
{
    switch (currentStopWatchStatus) {
        case StopWatchStatus_Inital:
            break;
            
        case StopWatchStatus_Start:
            [self lap];
            break;
            
        case StopWatchStatus_Stop:
            [self reset];
            break;
        default:
            break;
    }

}


@end

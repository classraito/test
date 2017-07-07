//
//  FGRoundTimerLogicModel.m
//  CSP
//
//  Created by Ryan Gong on 16/9/6.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGRoundTimerLogicModel.h"
#import "Global.h"
FGRoundTimerLogicModel *model_roundTimer;

static SystemSoundID soundID_round;
@interface FGRoundTimerLogicModel()
{
    NSDate *systemStartDate;
    
    NSDate *systemEndDate;
    NSInteger currentPage;
    NSInteger totalPages;
    
    NSInteger timeAfterCurrentSecs;//在当前计时之后的所有时间的总和
    NSInteger startPointSecs;//用于记录每次计时的起始秒数
    NSInteger currentSecs;//计时开始后当前的秒数
    RoundTimerStatus currentTimerStatus;
    
    BOOL isViberateOn;
    BOOL isSoundEffectOn;
}
@end

@implementation FGRoundTimerLogicModel
@synthesize delegate;
@synthesize ap_soundEffect;
@synthesize arr_modelData;
@synthesize currentRound;
@synthesize totalRounds;
@synthesize currentTimerType;
@synthesize currentRoundTimerType;
@synthesize str_total_remainTime;
@synthesize str_total_elapsedTime;
@synthesize dic_showToUI;
@synthesize totalTime;
@synthesize arr_allTimes;
#pragma mark - 生命周期
+(FGRoundTimerLogicModel *)sharedRoundTimerModel
{
    @synchronized(self)     {
        if(!model_roundTimer)
        {
            
            model_roundTimer=[[FGRoundTimerLogicModel alloc]init];
            model_roundTimer.dic_showToUI = [[NSMutableDictionary alloc] init];
            model_roundTimer.arr_allTimes = [[NSMutableArray alloc] init];
//            model_roundTimer.ap_soundEffect = [commond initBackgroundSound:@"timer_sound1" loop:0 player:model_roundTimer.ap_soundEffect type:@"mp3"];
            [commond initSystemSound:@"timer_sound1" type:@"mp3" tmpID:(SystemSoundID *)&soundID_round];
            [model_roundTimer internalInitalModel];
            
            return model_roundTimer;
        }
    }
    return model_roundTimer;
}

+(id)alloc
{
    @synchronized(self)     {
        NSAssert(model_roundTimer == nil, @"企圖創建一個singleton模式下的FGRoundTimerLogicModel");
        return [super alloc];
    }
    return nil;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_modelData = nil;
    dic_showToUI = nil;
}

-(void)cleanModel
{
    model_roundTimer = nil;
}
#pragma mark - 填充模型数据
-(void)fillModelDataByWarmUp:(NSString *)_str_warmupFormat numOfRounds:(NSInteger)_numOfRounds roundTime:(NSString *)_str_roundTime
                 warnningTime:(NSString *)_str_warningTime restTime:(NSString *)_str_restTime coolDown:(NSString *)_str_coolDown
{
    [arr_modelData removeAllObjects];
    
    
    NSInteger secs_warmup = [commond secondsByClockFormat:_str_warmupFormat];
    NSInteger secs_roundTime = [commond secondsByClockFormat:_str_roundTime];
    NSInteger secs_warningTime = [commond secondsByClockFormat:_str_warningTime];
    NSInteger secs_restTime = [commond secondsByClockFormat:_str_restTime];
    NSInteger secs_coolDown = [commond secondsByClockFormat:_str_coolDown];
    
    [arr_modelData addObject:[NSNumber numberWithInteger:secs_warmup]];
    NSMutableArray *arr_roundsData = [NSMutableArray arrayWithCapacity:1];
    for(NSInteger round = 0; round < _numOfRounds;round++)
    {
        NSMutableArray *arr_singleRoundsData = [NSMutableArray arrayWithCapacity:1];
        [arr_singleRoundsData addObject:[NSNumber numberWithInteger:secs_roundTime]];
        [arr_singleRoundsData addObject:[NSNumber numberWithInteger:secs_warningTime]];
        [arr_singleRoundsData addObject:[NSNumber numberWithInteger:secs_restTime]];
        [arr_roundsData addObject:arr_singleRoundsData];
        
    }
    [arr_modelData addObject:arr_roundsData];
    [arr_modelData addObject:[NSNumber numberWithInteger:secs_coolDown]];
    
    [self saveSettings];
    
    
}

#pragma mark - 填充计算模型
-(void)fillAllTimeModel
{
    if(!arr_modelData)
        return;
    if([arr_modelData count]<=0)
        return;
    
    [arr_allTimes removeAllObjects];
    NSInteger secs_warmup = [[arr_modelData objectAtIndex:0] integerValue];
    NSInteger secs_roundTime = [[[[arr_modelData objectAtIndex:1] objectAtIndex:0] objectAtIndex:0] integerValue];
    NSInteger secs_warningTime = [[[[arr_modelData objectAtIndex:1] objectAtIndex:0] objectAtIndex:1] integerValue];
    NSInteger secs_restTime = [[[[arr_modelData objectAtIndex:1] objectAtIndex:0] objectAtIndex:2] integerValue];
    NSInteger secs_coolDown = [[arr_modelData objectAtIndex:2] integerValue];
    
    [arr_allTimes addObject:[NSNumber numberWithInteger:secs_warmup]];
    for(int i=0;i<totalRounds;i++)
    {
        [arr_allTimes addObject:[NSNumber numberWithInteger:secs_roundTime]];
        [arr_allTimes addObject:[NSNumber numberWithInteger:secs_warningTime]];
        [arr_allTimes addObject:[NSNumber numberWithInteger:secs_restTime]];
    }
    [arr_allTimes addObject:[NSNumber numberWithInteger:secs_coolDown]];
    NSLog(@"arr_allTimes = %@",arr_allTimes);
}

#pragma mark - 初始化模型数据
-(void)setupModel
{
    NSInteger secs_warmup = [[arr_modelData objectAtIndex:0] integerValue];
    NSInteger secs_coolDown = [[arr_modelData objectAtIndex:2] integerValue];
    
    NSInteger secs_roundTime = [[[[arr_modelData objectAtIndex:1] objectAtIndex:0] objectAtIndex:0] integerValue];
    NSInteger secs_warningTime = [[[[arr_modelData objectAtIndex:1] objectAtIndex:0] objectAtIndex:1] integerValue];
    NSInteger secs_restTime = [[[[arr_modelData objectAtIndex:1] objectAtIndex:0] objectAtIndex:2] integerValue];
    
   
    
    totalRounds = [[arr_modelData objectAtIndex:1] count];
    currentPage = 1;
    totalPages = 1 + totalRounds * 3 + 1;
    totalTime = secs_warmup + (secs_roundTime + secs_warningTime + secs_restTime) * totalRounds + secs_coolDown;
    
    [self setupTypeAndRoundsByPages];
    [self fillAllTimeModel];
    [self calculateTimeAfterCurrentSecs];
    [self setupStartPoint];
    
    
}

#pragma mark - 根据模型数据 设置 变量
-(void)bindModelToWarmUp:(NSString **)_str_warmupFormat toNumOfRounds:(NSInteger *)_numOfRounds toRoundTime:(NSString **)_str_roundTime toWarnningTime:(NSString **)_str_warningTime toRestTime:(NSString **)_str_restTime toCoolDown:(NSString **)_str_coolDown
{
    if(!arr_modelData)
        return;
    if([arr_modelData count]<=0)
        return;
    
    NSInteger warmup = [[arr_modelData objectAtIndex:0] integerValue];
    
    NSInteger numOfRounds = [[arr_modelData objectAtIndex:1] count];
    NSInteger roundTime = [[[[arr_modelData objectAtIndex:1] objectAtIndex:0] objectAtIndex:0] integerValue];
    NSInteger warningTime = [[[[arr_modelData objectAtIndex:1] objectAtIndex:0] objectAtIndex:1] integerValue];
    NSInteger restTime = [[[[arr_modelData objectAtIndex:1] objectAtIndex:0] objectAtIndex:2] integerValue];
    
    NSInteger coolDown = [[arr_modelData objectAtIndex:2]  integerValue];
    
    NSString *str_warmUp = [commond clockFormatBySeconds:warmup];
    NSString *str_roundTime = [commond clockFormatBySeconds:roundTime];
    NSString *str_warningTime = [commond clockFormatBySeconds:warningTime];
    NSString *str_restTime = [commond clockFormatBySeconds:restTime];
    NSString *str_coolDown = [commond clockFormatBySeconds:coolDown];
    
    *_str_warmupFormat = str_warmUp;
    *_numOfRounds = numOfRounds;
    *_str_roundTime = str_roundTime;
    *_str_warningTime = str_warningTime;
    *_str_restTime = str_restTime;
    *_str_coolDown = str_coolDown;
}

#pragma mark - 初始化模型数据
-(void)internalInitalModel
{
    [arr_modelData removeAllObjects];
    arr_modelData = nil;
    arr_modelData = [[self getSettings] mutableCopy];
    
    if(!arr_modelData)
    {
        self.arr_modelData = [[NSMutableArray alloc] init];
        [self fillModelDataByWarmUp:@"01:00" numOfRounds:5 roundTime:@"01:00" warnningTime:@"00:30" restTime:@"00:10" coolDown:@"00:20"];
    }
    
    [self setupModel];
    [self internalInitalSoundAndViberate];
}

#pragma mark - 初始化声音震动设置
-(void)internalInitalSoundAndViberate
{
    NSNumber *num_viberate = (NSNumber *)[commond getUserDefaults:KEY_SETTING_ROUNDTIMER_VIBERATE];
    
    if(!num_viberate)
    {
        [self setViberateOn:NO];
    }
    else
    {
        isViberateOn = [num_viberate boolValue];
    }
    NSNumber *num_soundeffect = (NSNumber *)[commond getUserDefaults:KEY_SETTING_ROUNDTIMER_SOUNDEFFECT];
    
    if(!num_soundeffect)
    {
        [self setSoundEffectOn:NO];
    }
    else
    {
        isSoundEffectOn = [num_soundeffect boolValue];
    }
}

#pragma mark - 标记计时开始
-(void)markSystemStartTime
{
    systemStartDate = [NSDate date];
    
}

#pragma mark - 标记结束时间
-(void)markSystemEndTime
{
    systemEndDate = [NSDate date];
}

#pragma mark - 获得过了多少时间
-(NSTimeInterval)timePassed
{
    NSTimeInterval timepassed = [systemEndDate timeIntervalSinceDate:systemStartDate];
    return timepassed;
}

#pragma mark - 将设置保存
-(void)saveSettings
{
    if(!arr_modelData)
        return;
    if([arr_modelData count]<=0)
        return;
    
    [commond  setUserDefaults:arr_modelData forKey:KEY_SETTING_ROUNDTIMER];
}

#pragma mark - 计算当前正在计时的时间之后的所有时间的总和
-(void)calculateTimeAfterCurrentSecs
{
    
    timeAfterCurrentSecs = 0;
    for(NSInteger i = (currentPage - 1) + 1; i < totalPages;i++)
    {
        timeAfterCurrentSecs += [[arr_allTimes objectAtIndex:i] integerValue];
        
    }
}

#pragma mark - 根据当前页数获取类型和回合
-(void)setupTypeAndRoundsByPages
{
    if(currentPage == totalPages)
    {
        currentTimerType = TimerType_CoolDown;
        currentRound = 0;
    }
    else if(currentPage == 1)
    {
        currentTimerType = TimerType_WarmUp;
        currentRound = 0;
    }
    else
    {
        currentTimerType = TimerType_Round;
        currentRound = (NSInteger)(ceilf( (float)(currentPage - 1) / 3.0f ) );
        NSInteger currentPageIndex = currentPage - 1;
        currentRoundTimerType = (currentPageIndex - 1) % 3;
    }
}

#pragma mark - setup startpoint
-(void)setupStartPoint
{
    if(currentTimerType == TimerType_Round)
    {
        startPointSecs = [[[[arr_modelData objectAtIndex:TimerType_Round] objectAtIndex:currentRound-1] objectAtIndex:currentRoundTimerType] integerValue];
    }
    else
    {
        startPointSecs = [[arr_modelData objectAtIndex:currentTimerType] integerValue];
    }
    currentSecs = startPointSecs;
}

#pragma mark - 根据类型获得名称
-(NSString *)giveMeTimerTypeNameByType:(TimerType)_timerType
{
    NSString *str_retval = @"";
    switch ((int)_timerType) {
        case TimerType_WarmUp:
            str_retval = multiLanguage(@"Warm Up");
            break;
         
        case TimerType_CoolDown:
            
            str_retval = multiLanguage(@"Cool Down");
        
        default:
            break;
    }
    return str_retval;
}

#pragma mark - 根据类型获得名称
-(NSString *)giveMeRoundTimerTypeNameByType:(RoundTimerType)_roundTimerType
{
    NSString *str_retval = @"";
    switch ((int)_roundTimerType) {
        case RoundTimerType_RoundTime:
            str_retval = multiLanguage(@"Round Time");
            break;
            
        case RoundTimerType_RestTime:
            str_retval = multiLanguage(@"Rest Time");
            break;
            
        case RoundTimerType_WarningTime:
            
            str_retval = multiLanguage(@"Warning Time");
            break;
            
        default:
            break;
    }
    return str_retval;
}

#pragma mark - UI线程 循环调用这个方法获得最新的信息
-(NSMutableDictionary *)updateTimerCount{

    [self markSystemEndTime];//一直更新当前时间
    if(currentTimerStatus == RoundTimerStatus_Play || currentTimerStatus == RoundTimerStatus_Resume)
    {
       currentSecs = startPointSecs - [self timePassed];
        if(currentSecs<0)
        {
            if(currentTimerType == TimerType_CoolDown)
            {
                currentSecs = 0;
                if(delegate && [delegate respondsToSelector:@selector(roundTimerDidFinishEachRound:)])
                {
                    [delegate roundTimerDidFinishEachRound:self];
                }
            }
            else
            {
                [self nextPage];
            }
            
            return nil;
        }
    }
    
    NSInteger remainTime = timeAfterCurrentSecs + currentSecs;
    NSInteger elapsedTime = totalTime - remainTime;
    
    
    str_total_remainTime = [commond clockFormatBySeconds:remainTime];
    str_total_elapsedTime = [commond clockFormatBySeconds:elapsedTime];
    NSString *str_currentSecs = [commond clockFormatBySeconds:currentSecs];
    [dic_showToUI setObject:str_currentSecs forKey:KEY_SHOWTOUI_CurrentSecs];
    [dic_showToUI setObject:str_total_remainTime forKey:KEY_SHOWTOUI_RemainTime];
    [dic_showToUI setObject:str_total_elapsedTime forKey:KEY_SHOWTOUI_ElapsedTime];
    [dic_showToUI setObject:[NSNumber numberWithInteger:totalRounds] forKey:KEY_SHOWTOUI_TotalRound];
    [dic_showToUI setObject:[NSNumber numberWithInteger:currentRound] forKey:KEY_SHOWTOUI_CurrentRound];
    [dic_showToUI setObject:[NSNumber numberWithInteger:currentTimerType] forKey:KEY_SHOWTOUI_CurrentTimerType];
    [dic_showToUI setObject:[NSNumber numberWithInteger:currentRoundTimerType] forKey:KEY_SHOWTOUI_CurrentRoundTimerType];
    
    return dic_showToUI;
}

#pragma mark - 播放震动
-(void)playViberate
{
    if(isViberateOn)
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

#pragma mark - 播放音效
-(void)playSoundEffect
{
    if(isSoundEffectOn)
    {
        /*if(ap_soundEffect)
        {
            [ap_soundEffect play];
            
        }*/
        if(soundID_round)
        {
           AudioServicesPlaySystemSound(soundID_round);
        }
    }
}


-(BOOL)isMyViberateOn
{
    return isViberateOn;
}

-(BOOL)isMySoundEffectOn
{
    return isSoundEffectOn;
}

#pragma mark - 设置震动
-(void)setViberateOn:(BOOL)_isViberateOn;
{
    isViberateOn = _isViberateOn;
    [commond setUserDefaults:[NSNumber numberWithInteger:_isViberateOn] forKey:KEY_SETTING_ROUNDTIMER_VIBERATE];
}

#pragma mark - 设置声音
-(void)setSoundEffectOn:(BOOL)_isSoundEffectOn;
{
    isSoundEffectOn = _isSoundEffectOn;
    [commond setUserDefaults:[NSNumber numberWithInteger:_isSoundEffectOn] forKey:KEY_SETTING_ROUNDTIMER_SOUNDEFFECT];
}

#pragma mark - 下一个计时
-(void)nextPage
{
    if(currentPage == totalPages)
        return;
    
    currentPage = currentPage < totalPages? currentPage + 1 : totalPages;
    [self setupTypeAndRoundsByPages];
    [self calculateTimeAfterCurrentSecs];
    [self setupStartPoint];
    [self markSystemStartTime];
    if(currentTimerStatus == RoundTimerStatus_Play||currentTimerStatus == RoundTimerStatus_Resume)
    {
        startPointSecs += 1;//切换界面时已经开始计时了，所以要补一秒
        [self performSelector:@selector(playViberate) withObject:nil afterDelay:.1];
        [self playSoundEffect];
    }
   
}

#pragma mark - 上一个计时
-(void)previousPage
{
    if(currentPage == 1)
        return;
    
    currentPage = currentPage > 1 ? currentPage - 1 : 1;
    [self setupTypeAndRoundsByPages];
    [self calculateTimeAfterCurrentSecs];
    [self setupStartPoint];
    [self markSystemStartTime];
    if(currentTimerStatus == RoundTimerStatus_Play||currentTimerStatus == RoundTimerStatus_Resume)
    {
        startPointSecs += 1;//切换界面时已经开始计时了，所以要补一秒
        [self performSelector:@selector(playViberate) withObject:nil afterDelay:.1];
        [self playSoundEffect];
    }
}

#pragma mark - start
-(void)start
{
    currentTimerStatus = RoundTimerStatus_Play;
    [self setupTypeAndRoundsByPages];
    [self calculateTimeAfterCurrentSecs];
    [self setupStartPoint];
    [self markSystemStartTime];
    [self performSelector:@selector(playViberate) withObject:nil afterDelay:.1];
    [self playSoundEffect];
}

#pragma mark - pause
-(void)pause
{
    currentTimerStatus = RoundTimerStatus_Pause;
    startPointSecs = currentSecs;
    [self markSystemEndTime];
    [self markSystemStartTime];
    
}

#pragma mark - resume
-(void)resume
{
    currentTimerStatus = RoundTimerStatus_Resume;
    [self markSystemStartTime];
}

#pragma mark - reset
-(void)reset
{
    currentTimerStatus = RoundTimerStatus_Reset;
    [self internalInitalModel];
}

#pragma mark - 读取设置
-(NSMutableArray *)getSettings
{
    return (NSMutableArray *)[commond getUserDefaults:KEY_SETTING_ROUNDTIMER];
}



@end

//
//  FGStopWatchLogicModel.m
//  CSP
//
//  Created by Ryan Gong on 16/9/6.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGStopWatchLogicModel.h"
#import "Global.h"
FGStopWatchLogicModel *model_stopwatch;
@interface FGStopWatchLogicModel()
{
    
    NSDate *systemStartDate;
    NSDate *systemLapStartDate;
    NSDate *systemEndDate;
    NSDate *systemLapEndDate;
    CGFloat startPoint_microSecs;
    CGFloat startPoint_microSecs_LAP;
    CGFloat currentMicroSecs;//当前毫秒
    CGFloat currentMicroSecs_lap;//当前小记毫秒
    
}
@end

@implementation FGStopWatchLogicModel
@synthesize arr_stopWatchHistory;
@synthesize currentStopWatchStatus;
@synthesize dic_showToUI;
#pragma mark - 生命周期
+(FGStopWatchLogicModel *)sharedStopWatchModel
{
    @synchronized(self)     {
        if(!model_stopwatch)
        {
             NSLog(@"init FGStopWatchLogicModel");
            model_stopwatch=[[FGStopWatchLogicModel alloc]init];
            model_stopwatch.dic_showToUI = [[NSMutableDictionary alloc] init];
            [model_stopwatch internalInitalStopWatch];
            [model_stopwatch fillStopWatchHistory];
            
            return model_stopwatch;
        }
    }
    return model_stopwatch;
}

+(id)alloc
{
    @synchronized(self)     {
        NSAssert(model_stopwatch == nil, @"企圖創建一個singleton模式下的FGStopWatchLogicModel");
        return [super alloc];
    }
    return nil;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_stopWatchHistory = nil;
    dic_showToUI = nil;
}

-(void)cleanModel
{
    model_stopwatch = nil;
}

#pragma mark - UI线程 循环调用这个方法获得最新的信息
-(NSMutableDictionary *)updateTimerCount{
    if(currentStopWatchStatus == StopWatchStatus_Start)
    {
        [self markSystemEndTime];//一直更新当前时间
        [self markSystemLapEndTime];//一直更新当前时间
    }
    
    currentMicroSecs = startPoint_microSecs + [self timePassed];
    currentMicroSecs_lap = startPoint_microSecs_LAP + [self timePassed_LAP];
    NSString *str_clockformat = [commond clockFormatByMicroSeconds:currentMicroSecs];
    NSString *str_clockformat_lap = [commond clockFormatByMicroSeconds:currentMicroSecs_lap];
        
    [dic_showToUI setObject:str_clockformat forKey:KEY_SHOWTOUI_CLOCKFORMAT];
    [dic_showToUI setObject:str_clockformat_lap forKey:KEY_SHOWTOUI_CLOCKFORMAT_LAP];
    return dic_showToUI;
}


#pragma mark - 标记计时开始
-(void)markSystemStartTime
{
    systemStartDate = [NSDate date];
    
}

#pragma mark - 标记小记计时开始
-(void)markSystemLapStartTime
{
    systemLapStartDate = [NSDate date];
    
}

#pragma mark - 标记结束时间
-(void)markSystemEndTime
{
    systemEndDate = [NSDate date];
}

#pragma mark - 标记小记计时结束
-(void)markSystemLapEndTime
{
    systemLapEndDate = [NSDate date];
    
}

#pragma mark - 获得总共过了多少时间
-(NSTimeInterval)timePassed
{
    NSTimeInterval timepassed = [systemEndDate timeIntervalSinceDate:systemStartDate] ;
    
    return timepassed;
}

#pragma mark - 获得Lap过了多少时间
-(NSTimeInterval)timePassed_LAP
{
    NSTimeInterval timepassed = [systemLapEndDate timeIntervalSinceDate:systemLapStartDate] ;
    return timepassed;
}

#pragma mark - 初始化stopwatch
-(void)internalInitalStopWatch
{
    startPoint_microSecs = 0;
    startPoint_microSecs_LAP = 0;
    currentMicroSecs=0;
    currentMicroSecs_lap = 0;
    currentStopWatchStatus = StopWatchStatus_Inital;
    [self markSystemStartTime];
    [self markSystemLapStartTime];
    [self markSystemEndTime];
    [self markSystemLapEndTime];
}

#pragma mark - 填充历史纪录
-(void)fillStopWatchHistory
{
    if(arr_stopWatchHistory)
    {
        [arr_stopWatchHistory removeAllObjects];
        arr_stopWatchHistory = nil;
    }
   
    if([self getHistory])
        arr_stopWatchHistory = [[self getHistory] mutableCopy];
    else
        arr_stopWatchHistory = [[NSMutableArray alloc] init];
}

#pragma mark - 删除所有历史纪录
-(void)removeStopWatchHistory
{
    if(arr_stopWatchHistory)
    {
        [arr_stopWatchHistory removeAllObjects];
        [self saveHistory];
    }
}

#pragma mark - 读取历史纪录
-(NSMutableArray *)getHistory
{
    NSLog(@"get %@",(NSMutableArray *)[commond getUserDefaults:KEY_StopWatch_History]);
    return (NSMutableArray *)[commond getUserDefaults:KEY_StopWatch_History];
}

#pragma mark - 设置历史纪录
-(void)saveHistory
{
    if(!arr_stopWatchHistory)
        return;
    
    [commond  setUserDefaults:arr_stopWatchHistory forKey:KEY_StopWatch_History];
    
    NSLog(@"save %@",arr_stopWatchHistory);
}

#pragma mark - 开始逻辑
-(void)start
{
    currentStopWatchStatus = StopWatchStatus_Start;
    [self markSystemStartTime];
    [self markSystemLapStartTime];
   
}

#pragma mark - 结束逻辑
-(void)stop
{
    currentStopWatchStatus = StopWatchStatus_Stop;
    startPoint_microSecs_LAP = currentMicroSecs_lap;
    startPoint_microSecs = currentMicroSecs;
    [self markSystemStartTime];
    [self markSystemLapStartTime];
    [self markSystemEndTime];
    [self markSystemLapEndTime];
    
}

#pragma mark - 复位逻辑
-(void)reset
{
    currentStopWatchStatus = StopWatchStatus_Inital;
    [self internalInitalStopWatch];
    [self removeStopWatchHistory];
}

#pragma mark - 小记逻辑
-(void)lap
{
    [self markSystemLapEndTime];
    startPoint_microSecs_LAP = 0;
    if(arr_stopWatchHistory)
    {
        [arr_stopWatchHistory addObject:[NSNumber numberWithDouble:currentMicroSecs_lap]];
        [self saveHistory];
    }
    [self markSystemLapStartTime];
}

@end

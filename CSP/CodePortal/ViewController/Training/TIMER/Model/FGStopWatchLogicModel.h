//
//  FGStopWatchLogicModel.h
//  CSP
//
//  Created by Ryan Gong on 16/9/6.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_StopWatch_History @"KEY_StopWatch_History"

#define KEY_SHOWTOUI_CLOCKFORMAT @"KEY_SHOWTOUI_CLOCKFORMAT"
#define KEY_SHOWTOUI_CLOCKFORMAT_LAP @"KEY_SHOWTOUI_CLOCKFORMAT_LAP"
typedef enum{
    StopWatchStatus_Inital = 0,
    StopWatchStatus_Start = 1,
    StopWatchStatus_Stop = 2
}StopWatchStatus;

@interface FGStopWatchLogicModel : NSObject
{
   
}

@property(nonatomic,strong)NSMutableDictionary *dic_showToUI;
@property  StopWatchStatus currentStopWatchStatus;
@property(nonatomic,strong)NSMutableArray *arr_stopWatchHistory;
+(FGStopWatchLogicModel *)sharedStopWatchModel;

#pragma mark - UI线程 循环调用这个方法获得最新的信息
-(NSMutableDictionary *)updateTimerCount;
#pragma mark - 开始逻辑
-(void)start;
#pragma mark - 结束逻辑
-(void)stop;
#pragma mark - 复位逻辑
-(void)reset;
#pragma mark - 小记逻辑
-(void)lap;

-(void)cleanModel;
@end

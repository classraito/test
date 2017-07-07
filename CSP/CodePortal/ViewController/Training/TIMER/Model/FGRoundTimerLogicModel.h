//
//  FGRoundTimerLogicModel.h
//  CSP
//
//  Created by Ryan Gong on 16/9/6.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#define KEY_SHOWTOUI_ElapsedTime @"KEY_SHOWTOUI_ElapsedTime"
#define KEY_SHOWTOUI_RemainTime @"KEY_SHOWTOUI_RemainTime"
#define KEY_SHOWTOUI_TotalRound @"KEY_SHOWTOUI_TotalRound"
#define KEY_SHOWTOUI_CurrentRound @"KEY_SHOWTOUI_CurrentRound"
#define KEY_SHOWTOUI_CurrentRoundTimerType @"KEY_SHOWTOUI_CurrentRoundTimerType"
#define KEY_SHOWTOUI_CurrentTimerType @"KEY_SHOWTOUI_CurrentTimerType"
#define KEY_SHOWTOUI_CurrentSecs @"KEY_SHOWTOUI_CurrentSecs"

@class FGRoundTimerLogicModel;

typedef enum
{
    TimerType_WarmUp = 0,
    TimerType_Round = 1,
    TimerType_CoolDown = 2
}TimerType;

typedef enum{
    RoundTimerType_RoundTime = 0,
    RoundTimerType_WarningTime = 1,
    RoundTimerType_RestTime = 2,
}RoundTimerType;

typedef enum{
    RoundTimerStatus_Inital = 0,
    RoundTimerStatus_Play = 1,
    RoundTimerStatus_Pause = 2,
    RoundTimerStatus_Resume = 3,
    RoundTimerStatus_Reset = 4
}RoundTimerStatus;

@protocol FGRoundTimerLogicModelDelegate <NSObject>
-(void)roundTimerDidFinishEachRound:(FGRoundTimerLogicModel *)model;

@end

#define KEY_SETTING_ROUNDTIMER @"KEY_SETTING_ROUNDTIMER"
#define KEY_SETTING_ROUNDTIMER_VIBERATE @"KEY_SETTING_ROUNDTIMER_VIBERATE"
#define KEY_SETTING_ROUNDTIMER_SOUNDEFFECT @"KEY_SETTING_ROUNDTIMER_SOUNDEFFECT"
@interface FGRoundTimerLogicModel : NSObject
{
    
}
@property(nonatomic,assign)id<FGRoundTimerLogicModelDelegate> delegate;
@property(nonatomic,strong)AVAudioPlayer *ap_soundEffect;
@property(nonatomic,strong)NSMutableArray *arr_allTimes;//把所有时间加起来存放的数组（用于方便计算remain time）
@property (nonatomic,strong)NSMutableDictionary *dic_showToUI;//这个字典里包含了UI需要的所有信息;
@property NSInteger currentRound; //当前回合
@property NSInteger totalRounds;  //总回合
@property TimerType currentTimerType; //计时类型
@property RoundTimerType currentRoundTimerType;//回合计时类型
@property (nonatomic,strong)NSString *str_total_elapsedTime; //总计流逝的时间
@property (nonatomic,strong)NSString *str_total_remainTime; //总计剩余时间
@property NSInteger totalTime;//总时间
@property(nonatomic,strong)NSMutableArray *arr_modelData;//结构: [warmup,[[roundtime,warningtime,resttime],[roundtime,warningtime,resttime]],cooldown ] (2轮的情况)
+(FGRoundTimerLogicModel *)sharedRoundTimerModel;

#pragma mark - UI线程 循环调用这个方法获得最新的信息
-(NSMutableDictionary *)updateTimerCount;

#pragma mark - 将设置保存
-(void)saveSettings;

#pragma mark - 读取设置
-(NSMutableArray *)getSettings;

#pragma mark - 填充模型数据
-(void)fillModelDataByWarmUp:(NSString *)_str_warmupFormat numOfRounds:(NSInteger)_numOfRounds roundTime:(NSString *)_str_roundTime
                warnningTime:(NSString *)_str_warningTime restTime:(NSString *)_str_restTime coolDown:(NSString *)_str_coolDown;
#pragma mark - 初始化模型数据
-(void)setupModel;
#pragma mark - 根据模型数据 设置 变量
-(void)bindModelToWarmUp:(NSString **)_str_warmupFormat toNumOfRounds:(NSInteger *)_numOfRounds toRoundTime:(NSString **)_str_roundTime toWarnningTime:(NSString **)_str_warningTime toRestTime:(NSString **)_str_restTime toCoolDown:(NSString **)_str_coolDown;
#pragma mark - 下一个计时
-(void)nextPage;
#pragma mark - 上一个计时
-(void)previousPage;
#pragma mark - start
-(void)start;
#pragma mark - pause
-(void)pause;
#pragma mark - resume
-(void)resume;
#pragma mark - reset
-(void)reset;
-(BOOL)isMyViberateOn;
-(BOOL)isMySoundEffectOn;
#pragma mark - 设置震动
-(void)setViberateOn:(BOOL)_isViberateOn;

#pragma mark - 设置声音
-(void)setSoundEffectOn:(BOOL)_isSoundEffectOn;

-(void)cleanModel;
-(NSString *)giveMeTimerTypeNameByType:(TimerType)_timerType;
-(NSString *)giveMeRoundTimerTypeNameByType:(RoundTimerType)_roundTimerType;
@end

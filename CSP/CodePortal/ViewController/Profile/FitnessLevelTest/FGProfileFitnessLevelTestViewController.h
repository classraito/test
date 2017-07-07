//
//  FGProfileFitnessLevelTestViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGFitnessLevelTestPopupView_Inquiry.h"
#import "FGFitnessLevelTestPopupView_FillBodyData.h"
#import "FGFitnessLevelTestPopupView_HowManayPushUps.h"
#import "FGFitnessLevelTestPopupView_PlankExerciseFinished.h"
#import "FGFitnessLevelTestPopupView_HowLongInsist.h"
#import "FGFitnessLevelTestPopupView_CaloriesBurned.h"
#import "FGTrainingVideoPlayMainPopupView.h"
#import "FGFitnessVideoPlayMainView.h"
#import "FGTrainingVideoPlayMainPopupView.h"
#import "FGFitnessLevelTestPopupView_WonBadge.h"
#import "FGFitnessLevelTestPopupView_TakePic.h"
@interface FGProfileFitnessLevelTestViewController : FGBaseViewController<FGTrainingVideoPlayMainPopupView_GetReadyDelegate,FGVideoModelPlayQueueVideoDelegate,FGFitnessVideoPlayMainViewDelegate,FGTrainingVideoPlayMainPopupView_WatchVideoDelegate>
{
    
}
@property(nonatomic,strong)FGFitnessLevelTestPopupView_Inquiry *view_fitness_inquiry;
@property(nonatomic,strong)FGFitnessLevelTestPopupView_FillBodyData *view_fitness_fillBodyData;
@property(nonatomic,strong)FGFitnessLevelTestPopupView_HowManayPushUps *view_fitness_pushUps;
@property(nonatomic,strong)FGFitnessLevelTestPopupView_PlankExerciseFinished *view_fitness_plankFinished;
@property(nonatomic,strong)FGFitnessLevelTestPopupView_HowLongInsist *view_fitness_howLongInsist;
@property(nonatomic,strong)FGFitnessLevelTestPopupView_CaloriesBurned *view_fitness_caloriesBurned;
@property(nonatomic,strong)FGTrainingVideoPlayMainPopupView_GetReady *view_training_getReady;
@property(nonatomic,strong)FGTrainingVideoPlayMainPopupView_WatchVideo *view_training_watchVideo;
@property(nonatomic,strong)FGFitnessLevelTestPopupView_WonBadge *view_fitness_wonBadge;
@property(nonatomic,strong)FGFitnessLevelTestPopupView_TakePic *view_fitness_takePic;
@property(nonatomic,strong)FGFitnessVideoPlayMainView *view_playVideoQueue;
#pragma mark - 初始化各个view
-(void)internalInital_inquiry;
-(void)internalInital_fillBodyData;
-(void)internalInital_howManyPushUps;
-(void)internalInital_plankFinished;
-(void)internalInital_howLongInsist;
-(void)internalInital_caloriesBurned;
@end

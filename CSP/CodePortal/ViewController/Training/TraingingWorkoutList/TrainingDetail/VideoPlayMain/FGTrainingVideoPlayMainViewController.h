//
//  FGTrainingVideoPlayMainViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGTrainingVideoPlayMainView.h"
#import "FGTrainingVideoPlayMainPopupView.h"

#define WARMUPVIDEONAME @"test1"
#define COOLDOWNVIDEONAME @"test1"

@interface FGTrainingVideoPlayMainViewController : FGBaseViewController<FGTrainingVideoPlayMainPopupView_GetReadyDelegate,FGVideoModelPlayQueueVideoDelegate,FGTrainingVideoPlayMainPopupView_WatchVideoDelegate>
{
    
}
@property(nonatomic,strong)NSString *str_workoutID;
@property(nonatomic,strong)NSString *str_userCalories;
@property(nonatomic,strong)FGTrainingVideoPlayMainView *view_playVideoQueue;
@property(nonatomic,strong)FGTrainingVideoPlayMainPopupView_WatchVideo *view_training_watchVideo;
@property(nonatomic,strong)FGTrainingVideoPlayMainPopupView_GetReady *view_training_getReady;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil workoutID:(id)_workoutID;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil workoutID:(id)_workoutID userCalories:(NSString *)_str_userCalories;
-(void)internalInitalPlayVideoQueueView;
-(void)resetTrainingModelIfNeeded;
@end

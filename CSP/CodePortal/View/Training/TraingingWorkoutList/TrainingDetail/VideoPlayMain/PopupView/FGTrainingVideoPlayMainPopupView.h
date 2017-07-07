//
//  FGTrainingVideoPlayMainPopupView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/30.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"
#import "FGCustomUnderlineButton.h"
#import "FGCircularButton.h"
typedef enum
{
    PopUpType_Training_PlayMainVideo_WatchVideo = 0,
    PopUpType_Training_PlayMainVideo_GetReady = 1,
    PopUpType_Training_PlayMainVideo_Pause = 2,
    
}PopUpType_Training;

@protocol FGTrainingVideoPlayMainPopupView_WatchVideoDelegate <NSObject>
-(void)timerDisCountFinished_warmup;
@end

@interface FGTrainingVideoPlayMainPopupView_WatchVideo : FGPopupView
{
    NSTimer *timer;
}
@property(nonatomic,weak)IBOutlet UILabel *lb_commingup;
@property(nonatomic,weak)IBOutlet UILabel *lb_makesure;
@property(nonatomic,weak)IBOutlet UILabel *lb_count;
@property(nonatomic,weak)IBOutlet FGCustomUnderlineButton *cub_skip;
@property(nonatomic,weak)IBOutlet FGCustomUnderlineButton *cub_watchVideo;
@property(nonatomic,weak)IBOutlet UIImageView *iv_playIcon;
@property(nonatomic,weak)IBOutlet UIButton *btn_watchVideo;
@property(nonatomic,weak)id<FGTrainingVideoPlayMainPopupView_WatchVideoDelegate> delegate;
@property int numCount;
-(void)invalidateTimer;
-(void)setupTimer;
@end


@protocol FGTrainingVideoPlayMainPopupView_GetReadyDelegate <NSObject>

-(void)timerDisCountFinished;

@end

@interface FGTrainingVideoPlayMainPopupView_GetReady : FGPopupView
{
    NSTimer *timer;
    
}
@property int numCount;
@property(nonatomic,weak)id<FGTrainingVideoPlayMainPopupView_GetReadyDelegate> delegate;
@property(nonatomic,weak)IBOutlet UILabel *lb_getReady;
@property(nonatomic,weak)IBOutlet UILabel *lb_count;
-(void)invalidateTimer;
-(void)setupTimer;
@end

@interface FGTrainingVideoPlayMainPopupView_Pause : FGPopupView
{
    
}
@property(nonatomic,weak)IBOutlet FGCircularButton *cirB_stop;
@property(nonatomic,weak)IBOutlet FGCircularButton *cirB_play;
@property(nonatomic,weak)IBOutlet UILabel *lb_shakeToPause;
@end

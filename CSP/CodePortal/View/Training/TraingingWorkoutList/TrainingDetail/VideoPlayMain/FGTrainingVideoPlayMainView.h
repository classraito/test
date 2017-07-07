//
//  FGTrainingVideoPlayMainView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGCircularButton.h"
#import "FGVideoModel.h"
#import "FGTrainingVideoPlayMainPopupView.h"

#define KEY_VIDEOMAIN_HIDETIPS @"KEY_VIDEOMAIN_HIDETIPS"

@interface FGTrainingVideoPlayMainView : UIView
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_videoCount;
@property(nonatomic,weak)IBOutlet UILabel *lb_totalVideoTime;
@property(nonatomic,weak)IBOutlet  UIView *view_processBarBG;
@property(nonatomic,weak)IBOutlet UIView *view_processBar;
@property(nonatomic,weak)IBOutlet UIView *view_videoContainer;
@property(nonatomic,weak)IBOutlet FGCircularButton *cirB_currentVideTome;
@property(nonatomic,weak)IBOutlet UILabel *lb_pressToPause;
@property(nonatomic,strong)FGTrainingVideoPlayMainPopupView_Pause *popupView_pause;
@property(nonatomic,strong)FGTrainingVideoPlayMainPopupView_WatchVideo *popupView_watchVideo;
@property(nonatomic,strong)FGTrainingVideoPlayMainPopupView_GetReady *popupView_getReady;
@property(nonatomic,weak)FGVideoModel *model_video;
-(void)setupModel;
-(void)restartTimer;
-(void)cancelTimer;
-(void)tap_pause:(id)_sender;
-(void)updateUI;
-(void)buttonAction_stop:(id)_sender;
@end

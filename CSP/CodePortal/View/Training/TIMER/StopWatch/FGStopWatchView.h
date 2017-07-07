//
//  FGStopWatchView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGCircularButton.h"
#import "FGStopWatchLogicModel.h"
#import "FGStopWatchHistoryTableView.h"

@interface FGStopWatchView : UIView
{
    
}
@property(nonatomic,assign)IBOutlet FGCircularButton *cirB_play_stop;
@property(nonatomic,assign)IBOutlet FGCircularButton *cirB_lap_reset;
@property(nonatomic,assign)IBOutlet FGStopWatchHistoryTableView *tb_clock;
@property(nonatomic,assign)IBOutlet UIView *view_clock;

@property(nonatomic,assign)IBOutlet UILabel *lb_totalTime;
@property(nonatomic,assign)IBOutlet UILabel *lb_lapTime;

-(void)loadModel:(FGStopWatchLogicModel *)_model;
-(void)buttonAction_start_stop:(id)_sender;
-(void)buttonAction_lap_reset:(id)_sender;

#pragma mark - 计时操作
-(void)start;
-(void)stop;
-(void)reset;
-(void)lap;

-(void)clearTimer;
@end

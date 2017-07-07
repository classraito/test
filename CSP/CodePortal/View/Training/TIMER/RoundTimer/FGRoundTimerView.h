//
//  FGRoundTimerView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGCircularButton.h"
#import "FGRoundTimerLogicModel.h"
@interface FGRoundTimerView : UIView<FGRoundTimerLogicModelDelegate>
{
    
}
@property RoundTimerStatus roundTimerStatus;

@property(nonatomic,assign)IBOutlet UIView *view_clock;
@property(nonatomic,assign)IBOutlet FGCircularButton *cirB_start_pause;
@property(nonatomic,assign)IBOutlet FGCircularButton *cirB_reset;
@property(nonatomic,assign)IBOutlet UILabel *lb_key_elapsed;
@property(nonatomic,assign)IBOutlet UILabel *lb_key_remaining;
@property(nonatomic,assign)IBOutlet UILabel *lb_value_elapsed;
@property(nonatomic,assign)IBOutlet UILabel *lb_value_remaining;

@property(nonatomic,assign)IBOutlet UIImageView *iv_arr_left;
@property(nonatomic,assign)IBOutlet UIImageView *iv_arr_right;
@property(nonatomic,assign)IBOutlet UILabel *lb_timeCount;
@property(nonatomic,assign)IBOutlet UILabel *lb_title;
@property(nonatomic,assign)IBOutlet UILabel *lb_roundName;

@property(nonatomic,assign)IBOutlet UIButton *btn_arr_left;
@property(nonatomic,assign)IBOutlet UIButton *btn_arr_right;


-(void)loadModel:(FGRoundTimerLogicModel *)_model;
-(IBAction)buttonAction_arr_left:(id)_sender;
-(IBAction)buttonAction_arr_right:(id)_sender;
-(void)buttonAction_start_pause:(id)_sender;
-(void)buttonAction_reset:(id)_sender;
-(void)start;
-(void)pause;
-(void)resume;
-(void)reset;
-(void)clearTimer;
@end

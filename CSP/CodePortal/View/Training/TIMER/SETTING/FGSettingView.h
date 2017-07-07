//
//  FGSettingView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/3.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGUserInputPageBaseView.h"
#import "FGHHMMSSPickerView.h"
#import "FGDataPickeriView.h"
#import "FGRoundTimerLogicModel.h"
typedef enum{
    HHMMSSPickerType_WarmUp = 1,
    HHMMSSPickerType_NumberOfRound = 2,
    HHMMSSPickerType_RoundTime = 3,
    HHMMSSPickerType_WarningTime = 4,
    HHMMSSPickerType_RestTime = 5,
    HHMMSSPickerType_CoolDown = 6
}HHMMSSPickerType;

@interface FGSettingView : FGUserInputPageBaseView<FGDataPickerViewDelegate>
{
    FGHHMMSSPickerView *dp_hhmmss;
    FGDataPickeriView *dp_singleData;
    
    HHMMSSPickerType hhmmssPickerType;
}
@property(nonatomic,assign)IBOutlet UILabel *lb_key_warmUp;
@property(nonatomic,assign)IBOutlet UILabel *lb_key_numOfRounds;
@property(nonatomic,assign)IBOutlet UILabel *lb_key_roundTime;
@property(nonatomic,assign)IBOutlet UILabel *lb_key_warningTime;
@property(nonatomic,assign)IBOutlet UILabel *lb_key_restTime;
@property(nonatomic,assign)IBOutlet UILabel *lb_key_coolDown;
@property(nonatomic,assign)IBOutlet UILabel *lb_key_timerSound;
@property(nonatomic,assign)IBOutlet UILabel *lb_key_vibration;

@property(nonatomic,assign)IBOutlet UILabel *lb_value_warmUp;
@property(nonatomic,assign)IBOutlet UILabel *lb_value_numOfRounds;
@property(nonatomic,assign)IBOutlet UILabel *lb_value_roundTime;
@property(nonatomic,assign)IBOutlet UILabel *lb_value_warningTime;
@property(nonatomic,assign)IBOutlet UILabel *lb_value_restTime;
@property(nonatomic,assign)IBOutlet UILabel *lb_value_coolDown;
@property(nonatomic,assign)IBOutlet UIView *view_switch_timerSound_placeholder;
@property(nonatomic,assign)IBOutlet UIView *view_switch_viberation_placehlder;

@property(nonatomic,assign)IBOutlet UIButton *btn_warmUp;
@property(nonatomic,assign)IBOutlet UIButton *btn_numOfRounds;
@property(nonatomic,assign)IBOutlet UIButton *btn_roundTime;
@property(nonatomic,assign)IBOutlet UIButton *btn_warningTime;
@property(nonatomic,assign)IBOutlet UIButton *btn_restTime;
@property(nonatomic,assign)IBOutlet UIButton *btn_coolDown;

@property(nonatomic,assign)IBOutlet UIView *view_separatorLine1;
@property(nonatomic,assign)IBOutlet UIView *view_separatorLine2;
@property(nonatomic,assign)IBOutlet UIView *view_separatorLine3;
@property(nonatomic,assign)IBOutlet UIView *view_separatorLine4;

@property(nonatomic,assign)IBOutlet UIView *view_whiteBg1;
@property(nonatomic,assign)IBOutlet UIView *view_whiteBg2;
@property(nonatomic,assign)IBOutlet UIView *view_whiteBg3;
@property(nonatomic,assign)IBOutlet UIView *view_whiteBg4;

-(IBAction)buttonAction_warmUp:(id)_sender;
-(IBAction)buttonAction_numberOfRound:(id)_sender;
-(IBAction)buttonAction_roundTime:(id)_sender;
-(IBAction)buttonAction_warningTime:(id)_sender;
-(IBAction)buttonAction_restTime:(id)_sender;
-(IBAction)buttonAction_coolDown:(id)_sender;

-(void)loadModel:(FGRoundTimerLogicModel *)_model;
@end

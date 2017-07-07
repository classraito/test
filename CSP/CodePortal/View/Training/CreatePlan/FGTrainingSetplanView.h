//
//  FGTrainingSetplanView.h
//  CSP
//
//  Created by Ryan Gong on 16/12/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGUserInputPageBaseView.h"
#import "FGDataPickeriView.h"
typedef enum
{
    SetPlanPickType_yourLevel = 1,
    SetPlanPickType_equipment = 2,
    SetPlanPickType_goal = 3,
    SetPlanPickType_startDate = 4,
    SetPlanPickType_week = 5,
    SetPlanPickType_workoutPerWeek = 6
    
}SetPlanPickType;

@interface FGTrainingSetplanView : FGUserInputPageBaseView<FGDataPickerViewDelegate>
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_key_level;
@property(nonatomic,weak)IBOutlet UILabel *lb_value_level;
@property(nonatomic,weak)IBOutlet UILabel *lb_key_equipment;
@property(nonatomic,weak)IBOutlet UILabel *lb_value_equipment;
@property(nonatomic,weak)IBOutlet UILabel *lb_key_goal;
@property(nonatomic,weak)IBOutlet UILabel *lb_value_goal;
@property(nonatomic,weak)IBOutlet UILabel *lb_key_startdate;
@property(nonatomic,weak)IBOutlet UILabel *lb_value_startdate;
@property(nonatomic,weak)IBOutlet UILabel *lb_Key_week;
@property(nonatomic,weak)IBOutlet UILabel *lb_value_week;
@property(nonatomic,weak)IBOutlet UILabel *lb_key_workoutPerWeek;
@property(nonatomic,weak)IBOutlet UILabel *lb_value_workoutPerWeek;
@property(nonatomic,weak)IBOutlet UIButton *btn_next;

@property(nonatomic,weak)IBOutlet UIView *view_separator1_h;
@property(nonatomic,weak)IBOutlet UIView *view_separator2_h;
@property(nonatomic,weak)IBOutlet UIView *view_separator3_h;
@property(nonatomic,weak)IBOutlet UIView *view_separator4_h;
@property(nonatomic,weak)IBOutlet UIView *view_separator5_h;
@property(nonatomic,weak)IBOutlet UIView *view_separator6_h;

@property(nonatomic,weak)IBOutlet UIButton *btn_level;
@property(nonatomic,weak)IBOutlet UIButton *btn_equipment;
@property(nonatomic,weak)IBOutlet UIButton *btn_goal;
@property(nonatomic,weak)IBOutlet UIButton *btn_startDate;
@property(nonatomic,weak)IBOutlet UIButton *btn_week;
@property(nonatomic,weak)IBOutlet UIButton *btn_workoutPerWeek;

@property(nonatomic,strong)FGDataPickeriView *dp_picker;

-(IBAction)buttonAction_yourLevel:(id)_sender;
-(IBAction)buttonAction_equipment:(id)_sender;
-(IBAction)buttonAction_goal:(id)_sender;
-(IBAction)buttonAction_startDate:(id)_sender;
-(IBAction)buttonAction_week:(id)_sender;
-(IBAction)buttonAction_workoutPerWeek:(id)_sender;

-(IBAction)buttonAction_next:(id)_sender;
@end

//
//  FGFitnessLevelTestPopupView_CaloriesBurned.h
//  CSP
//
//  Created by Ryan Gong on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"
#import "FGUserInputPageBaseView.h"
#import "FGCustomButton.h"
@interface FGFitnessLevelTestPopupView_CaloriesBurned : FGPopupView
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_congratulations;
@property(nonatomic,weak)IBOutlet UILabel *lb_caloriesBurned;
@property(nonatomic,weak)IBOutlet UILabel *lb_key_pushups;
@property(nonatomic,weak)IBOutlet UILabel *lb_value_pushups;
@property(nonatomic,weak)IBOutlet UILabel *lb_key_situps;
@property(nonatomic,weak)IBOutlet UILabel *lb_value_situps;
@property(nonatomic,weak)IBOutlet UILabel *lb_key_squats;
@property(nonatomic,weak)IBOutlet UILabel *lb_value_squats;
@property(nonatomic,weak)IBOutlet UILabel *lb_key_burpees;
@property(nonatomic,weak)IBOutlet UILabel *lb_value_burpees;
@property(nonatomic,weak)IBOutlet UILabel *lb_key_plank;
@property(nonatomic,weak)IBOutlet UILabel *lb_value_plank;
@property(nonatomic,weak)IBOutlet UIView *view_separator1;
@property(nonatomic,weak)IBOutlet UIView *view_separator2;
@property(nonatomic,weak)IBOutlet UIView *view_separator3;
@property(nonatomic,weak)IBOutlet UIView *view_separator4;
@property(nonatomic,weak)IBOutlet FGCustomButton *cb_finished;
@end

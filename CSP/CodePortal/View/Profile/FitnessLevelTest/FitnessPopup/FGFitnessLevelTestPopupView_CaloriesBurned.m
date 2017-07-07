//
//  FGFitnessLevelTestPopupView_CaloriesBurned.m
//  CSP
//
//  Created by Ryan Gong on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGFitnessLevelTestPopupView_CaloriesBurned.h"
#import "Global.h"
@implementation FGFitnessLevelTestPopupView_CaloriesBurned
@synthesize lb_congratulations;
@synthesize lb_caloriesBurned;
@synthesize lb_key_pushups;
@synthesize lb_value_pushups;
@synthesize lb_key_situps;
@synthesize lb_value_situps;
@synthesize lb_key_squats;
@synthesize lb_value_squats;
@synthesize lb_key_burpees;
@synthesize lb_value_burpees;
@synthesize lb_key_plank;
@synthesize lb_value_plank;
@synthesize view_separator1;
@synthesize view_separator2;
@synthesize view_separator3;
@synthesize view_separator4;
@synthesize cb_finished;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView: lb_congratulations];
    [commond useDefaultRatioToScaleView: lb_caloriesBurned];
    [commond useDefaultRatioToScaleView: lb_key_pushups];
    [commond useDefaultRatioToScaleView: lb_value_pushups];
    [commond useDefaultRatioToScaleView: lb_key_situps];
    [commond useDefaultRatioToScaleView: lb_value_situps];
    [commond useDefaultRatioToScaleView: lb_key_squats];
    [commond useDefaultRatioToScaleView: lb_value_squats];
    [commond useDefaultRatioToScaleView: lb_key_burpees];
    [commond useDefaultRatioToScaleView: lb_value_burpees];
    [commond useDefaultRatioToScaleView: lb_key_plank];
    [commond useDefaultRatioToScaleView: lb_value_plank];
    CGRect raito_separator = CGRectMake(ratioW, ratioH, ratioW, 1);
    [commond useRatio:raito_separator toScaleView:view_separator1] ;
    [commond useRatio:raito_separator toScaleView: view_separator2];
    [commond useRatio:raito_separator toScaleView: view_separator3];
    [commond useRatio:raito_separator toScaleView: view_separator4];
    [commond useDefaultRatioToScaleView: cb_finished];
    
    lb_congratulations.font = font(FONT_TEXT_REGULAR, 28);
    lb_caloriesBurned.font = font(FONT_TEXT_REGULAR, 20);
    
    lb_key_pushups.font = font(FONT_TEXT_REGULAR, 16);
    lb_value_pushups.font = font(FONT_TEXT_REGULAR, 16);
    lb_key_situps.font = font(FONT_TEXT_REGULAR, 16);
    lb_value_situps.font = font(FONT_TEXT_REGULAR, 16);
    lb_key_squats.font = font(FONT_TEXT_REGULAR, 16);
    lb_value_squats.font = font(FONT_TEXT_REGULAR, 16);
    lb_key_burpees.font = font(FONT_TEXT_REGULAR, 16);
    lb_value_burpees.font = font(FONT_TEXT_REGULAR, 16);
    lb_key_plank.font = font(FONT_TEXT_REGULAR, 16);
    lb_value_plank.font = font(FONT_TEXT_REGULAR, 16);
    
    [cb_finished setFrame:cb_finished.frame title:multiLanguage(@"FINISHED") arrimg:nil borderColor:nil textColor:[UIColor whiteColor] bgColor:color_red_panel];
    
    cb_finished.layer.cornerRadius = cb_finished.frame.size.height / 2;
    cb_finished.layer.masksToBounds = YES;
    
    FGProfileFitnessTestModel *model = [FGProfileFitnessTestModel sharedModel];
    lb_value_pushups.text = [NSString stringWithFormat:@"%d",model.pushupsCount];
    lb_value_situps.text = [NSString stringWithFormat:@"%d",model.situpsCount];
    lb_value_squats.text = [NSString stringWithFormat:@"%d",model.squatsCount];
    lb_value_burpees.text = [NSString stringWithFormat:@"%d",model.burpees];
    lb_value_plank.text = [NSString stringWithFormat:@"%@",[commond clockFormatBySeconds:model.plankSecs]];
    
    lb_congratulations.text = multiLanguage(@"CONGRATULATIONS!");
    lb_caloriesBurned.text = [NSString stringWithFormat:@"%d %@",model.calorious,multiLanguage(@"Calories Burned")];
    [lb_caloriesBurned setCustomColor:color_red_panel searchText:[NSString stringWithFormat:@"%d",model.calorious] font:font(FONT_TEXT_BOLD, 34)];
    
    lb_key_pushups.text = multiLanguage(@"Push-ups");
    lb_key_situps.text = multiLanguage(@"Situps");
    lb_key_squats.text = multiLanguage(@"Squats");
    lb_key_plank.text = multiLanguage(@"Plank");
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

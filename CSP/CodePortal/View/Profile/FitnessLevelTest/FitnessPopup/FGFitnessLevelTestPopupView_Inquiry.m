//
//  FGFitnessLevelTestPopupView_Inquiry.m
//  CSP
//
//  Created by Ryan Gong on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGFitnessLevelTestPopupView_Inquiry.h"
#import "Global.h"
@implementation FGFitnessLevelTestPopupView_Inquiry
@synthesize lb_title;
@synthesize lb_subtitle;
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
@synthesize cb_yes;
@synthesize btn_notNow;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView: lb_subtitle];
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
     CGRect ratio_separator = CGRectMake(ratioW, ratioH, ratioW, 1);
    [commond useRatio:ratio_separator toScaleView:view_separator1] ;
    [commond useRatio:ratio_separator toScaleView: view_separator2];
    [commond useRatio:ratio_separator toScaleView: view_separator3];
    [commond useRatio:ratio_separator toScaleView: view_separator4];
    [commond useDefaultRatioToScaleView: cb_yes];
    [commond useDefaultRatioToScaleView: btn_notNow];
    
    
    
    lb_title.font = font(FONT_TEXT_REGULAR, 24);
    lb_subtitle.font = font(FONT_TEXT_REGULAR, 15);
    
    lb_key_pushups.font = font(FONT_TEXT_REGULAR, 15);
    lb_value_pushups.font = font(FONT_TEXT_REGULAR, 15);
    lb_key_situps.font = font(FONT_TEXT_REGULAR, 15);
    lb_value_situps.font = font(FONT_TEXT_REGULAR, 15);
    lb_key_squats.font = font(FONT_TEXT_REGULAR, 15);
    lb_value_squats.font = font(FONT_TEXT_REGULAR, 15);
    lb_key_burpees.font = font(FONT_TEXT_REGULAR, 15);
    lb_value_burpees.font = font(FONT_TEXT_REGULAR, 15);
    lb_key_plank.font = font(FONT_TEXT_REGULAR, 15);
    lb_value_plank.font = font(FONT_TEXT_REGULAR, 15);
    
    btn_notNow.titleLabel.font = font(FONT_TEXT_REGULAR, 15);
    [cb_yes setFrame:cb_yes.frame title:multiLanguage(@"YES") arrimg:nil borderColor:nil textColor:[UIColor whiteColor] bgColor:color_red_panel];
    
    cb_yes.layer.cornerRadius = cb_yes.frame.size.height / 2;
    cb_yes.layer.masksToBounds = YES;
    cb_yes.button.titleLabel.font = font(FONT_TEXT_REGULAR, 15);
    
    
    lb_title.text = multiLanguage(@"Take the fitness test!");
    lb_subtitle.text = multiLanguage(@"It takes just a few minutes to assess your current fitness level.");
    
    lb_key_pushups.text = multiLanguage(@"Push-ups");
    lb_key_situps.text = multiLanguage(@"Situps");
    lb_key_squats.text = multiLanguage(@"Squats");
    lb_key_plank.text = multiLanguage(@"Plank");
    
    lb_value_pushups.text = [NSString stringWithFormat:@"1 %@",multiLanguage(@"min")];
    lb_value_situps.text = [NSString stringWithFormat:@"1 %@",multiLanguage(@"min")];
    lb_value_squats.text = [NSString stringWithFormat:@"1 %@",multiLanguage(@"min")];
    lb_value_plank.text = multiLanguage(@"unlimited");
    
    [cb_yes setFrame:cb_yes.frame title:multiLanguage(@"YES") arrimg:nil borderColor:[UIColor clearColor] textColor:[UIColor whiteColor] bgColor:color_red_panel];
    
    [btn_notNow setTitle:multiLanguage(@"NOT NOW") forState:UIControlStateNormal];
    [btn_notNow setTitle:multiLanguage(@"NOT NOW") forState:UIControlStateHighlighted];
    
    
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

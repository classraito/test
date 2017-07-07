//
//  FGFitnessLevelTestPopupView_PlankExerciseFinished.m
//  CSP
//
//  Created by Ryan Gong on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGFitnessLevelTestPopupView_PlankExerciseFinished.h"
#import "Global.h"
@implementation FGFitnessLevelTestPopupView_PlankExerciseFinished
@synthesize lb_timeUsed;
@synthesize lb_title;
@synthesize cb_yes;
@synthesize btn_no;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView: lb_timeUsed];
    [commond useDefaultRatioToScaleView: lb_title];
    [commond useDefaultRatioToScaleView: cb_yes];
    [commond useDefaultRatioToScaleView: btn_no];
    
    lb_timeUsed.font = font(FONT_NUM_MEDIUM, 30);
    lb_title.font = font(FONT_TEXT_REGULAR, 18);
    cb_yes.button.titleLabel.font = font(FONT_TEXT_REGULAR, 15);
    
    lb_title.text = multiLanguage(@"Are you sure you\nfinished your plank?");
    
    [cb_yes setFrame:cb_yes.frame title:multiLanguage(@"YES") arrimg:nil borderColor:nil textColor:[UIColor whiteColor] bgColor:color_red_panel];
    [btn_no setTitle:multiLanguage(@"NO") forState:UIControlStateNormal];
    [btn_no setTitle:multiLanguage(@"NO") forState:UIControlStateHighlighted];
    
    cb_yes.layer.cornerRadius = cb_yes.frame.size.height / 2;
    cb_yes.layer.masksToBounds = YES;
    
    FGProfileFitnessTestModel *model = [FGProfileFitnessTestModel sharedModel];
    NSLog(@"1.model.plankSecs = %ld",model.plankSecs);
    lb_timeUsed.text = [commond clockFormatBySeconds:model.plankSecs];
    
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

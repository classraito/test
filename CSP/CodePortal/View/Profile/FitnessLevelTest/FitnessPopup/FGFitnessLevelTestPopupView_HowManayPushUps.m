//
//  FGFitnessLevelTestPopupView_HowManayPushUps.m
//  CSP
//
//  Created by Ryan Gong on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGFitnessLevelTestPopupView_HowManayPushUps.h"
#import "Global.h"
@implementation FGFitnessLevelTestPopupView_HowManayPushUps
@synthesize lb_title;
@synthesize cirB_pushups;
@synthesize btn_minus;
@synthesize btn_plus;
@synthesize iv_minus;
@synthesize iv_plus;
@synthesize cb_done;
@synthesize pushupsCount;
@synthesize type;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    pushupsCount = 30;
    
    [commond useDefaultRatioToScaleView: lb_title];
    [commond useDefaultRatioToScaleView:  cirB_pushups];
    [commond useDefaultRatioToScaleView:  btn_minus];
    [commond useDefaultRatioToScaleView:  btn_plus];
    [commond useDefaultRatioToScaleView:  iv_minus];
    [commond useDefaultRatioToScaleView:  iv_plus];
    [commond useDefaultRatioToScaleView:  cb_done];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 24);
    NSString *str_pushupsCount = [NSString stringWithFormat:@"%ld",pushupsCount];
    [cirB_pushups setupCircularButtonByBgColor:[UIColor clearColor] bgHighlightColor:[UIColor clearColor] textColor:[UIColor whiteColor] textHighlightColor:[UIColor whiteColor] btnText:str_pushupsCount btnHighlightedText:str_pushupsCount buttonFont:font(FONT_NUM_REGULAR, 110)];
    cirB_pushups.btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    cirB_pushups.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cirB_pushups.layer.borderWidth = 2;
    cirB_pushups.btn.titleLabel.adjustsFontSizeToFitWidth = YES;//调整基线位置需将此属性设置为YES
    cirB_pushups.btn.titleLabel.baselineAdjustment = UIBaselineAdjustmentNone;
    
    
    [cb_done setFrame:cb_done.frame title:multiLanguage(@"DONE") arrimg:nil borderColor:nil textColor:[UIColor whiteColor] bgColor:color_red_panel];
    
    cb_done.layer.cornerRadius = cb_done.frame.size.height / 2;
    cb_done.layer.masksToBounds = YES;
    
    cb_done.button.titleLabel.font = font(FONT_TEXT_REGULAR, 15);
    
    cb_done.button.tag = type;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

#pragma mark - 按钮事件
-(IBAction)buttonAction_minus:(id)_sender;
{
    pushupsCount = pushupsCount > 0 ? pushupsCount - 1 : 0;
    NSString *str_pushupsCount = [NSString stringWithFormat:@"%ld",pushupsCount];
    [cirB_pushups.btn setTitle:str_pushupsCount forState:UIControlStateNormal];
    [cirB_pushups.btn setTitle:str_pushupsCount forState:UIControlStateHighlighted];
}

-(IBAction)buttonAction_plus:(id)_sender;{
    
    pushupsCount = pushupsCount < 99?pushupsCount + 1 : 99;
    NSString *str_pushupsCount = [NSString stringWithFormat:@"%ld",pushupsCount];
    [cirB_pushups.btn setTitle:str_pushupsCount forState:UIControlStateNormal];
    [cirB_pushups.btn setTitle:str_pushupsCount forState:UIControlStateHighlighted];
}
@end

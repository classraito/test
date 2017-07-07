//
//  FGFitnessLevelTestPopupView_HowLongInsist.m
//  CSP
//
//  Created by Ryan Gong on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGFitnessLevelTestPopupView_HowLongInsist.h"
#import "Global.h"
@implementation FGFitnessLevelTestPopupView_HowLongInsist
@synthesize lb_title;
@synthesize dp_hhmmss;
@synthesize cb_done;
@synthesize view_pickerContainer;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:cb_done];
    [commond useDefaultRatioToScaleView:view_pickerContainer];
    
    view_pickerContainer.backgroundColor = [UIColor clearColor];
    
    
    
    lb_title.font = font(FONT_TEXT_REGULAR, 26);
    cb_done.button.titleLabel.font = font(FONT_TEXT_REGULAR, 15);
    
    [cb_done setFrame:cb_done.frame title:multiLanguage(@"DONE") arrimg:nil borderColor:nil textColor:[UIColor whiteColor] bgColor:color_red_panel];
    
    cb_done.layer.cornerRadius = cb_done.frame.size.height / 2;
    cb_done.layer.masksToBounds = YES;
    
    [self internalInitalHHMMSSPickerView];
    
    lb_title.text = multiLanguage(@"How long did you last?");
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    dp_hhmmss = nil;
}
#pragma mark - 初始化 FGHHMMSSPickerView
-(void)internalInitalHHMMSSPickerView
{
    if(dp_hhmmss)
        return;
    
    FGProfileFitnessTestModel *model = [FGProfileFitnessTestModel sharedModel];
    
    
    dp_hhmmss = (FGHHMMSSPickerView *)[[[NSBundle mainBundle] loadNibNamed:@"FGHHMMSSPickerView" owner:nil options:nil] objectAtIndex:0];
    dp_hhmmss.delegate = self;
    dp_hhmmss.frame = view_pickerContainer.bounds;
    [view_pickerContainer addSubview:dp_hhmmss];
    NSLog(@"2.model.plankSecs = %ld",model.plankSecs);
    [dp_hhmmss setupTimeByStringFormat:[commond clockFormatBySeconds:model.plankSecs] dataTextColor:[UIColor whiteColor]];
    
    dp_hhmmss.view_titlePanel.hidden = YES;
    dp_hhmmss.backgroundColor = [UIColor clearColor];
    
    
 
}

#pragma mark - FGDataPickerViewDelegate
-(void)didSelectData:(NSString *)_str_selected picker:(id)_dataPicker;
{
    NSLog(@"_str_selected = %@",_str_selected);
    FGProfileFitnessTestModel *model = [FGProfileFitnessTestModel sharedModel];
    model.plankSecs = [commond secondsByClockFormat:_str_selected];
}

-(void)didCloseDataPicker:(NSString *)_str_selected picker:(id)_dataPicker
{
    NSLog(@"_str_selected = %@",_str_selected);
    FGProfileFitnessTestModel *model = [FGProfileFitnessTestModel sharedModel];
    model.plankSecs = [commond secondsByClockFormat:_str_selected];
}
@end

//
//  FGLocationMyGroupCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationMyGroupCellView.h"
#import "Global.h"
@implementation FGLocationMyGroupCellView
@synthesize btn_leave;
@synthesize btn_checkIn;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:btn_checkIn];
    [commond useDefaultRatioToScaleView:btn_leave];
    
    [btn_checkIn setTitle:multiLanguage(@"CHECK IN") forState:UIControlStateNormal];
    [btn_checkIn setTitle:multiLanguage(@"CHECK IN") forState:UIControlStateHighlighted];
    [btn_leave setTitle:multiLanguage(@"LEAVE") forState:UIControlStateNormal];
    [btn_leave setTitle:multiLanguage(@"LEAVE") forState:UIControlStateHighlighted];
    
    btn_checkIn.backgroundColor = color_red_panel;
    btn_leave.backgroundColor = rgb(207, 213, 213);
    
    btn_leave.titleLabel.font = font(FONT_TEXT_REGULAR, 14);
    btn_checkIn.titleLabel.font = font(FONT_TEXT_REGULAR, 14);
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
    [super updateCellViewWithInfo:_dataInfo];
   
}
@end

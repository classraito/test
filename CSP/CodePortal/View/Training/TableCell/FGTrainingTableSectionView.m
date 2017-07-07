//
//  FGTrainingTableSectionView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingTableSectionView.h"
#import "Global.h"
@implementation FGTrainingTableSectionView
@synthesize btn_vip;
@synthesize btn_featured;
@synthesize btn_workouts;
@synthesize view_separator1;
@synthesize view_separator2;
@synthesize delegate;
@synthesize currentSectionType;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:btn_vip];
    [commond useDefaultRatioToScaleView:btn_featured];
    [commond useDefaultRatioToScaleView:btn_workouts];
    [commond useRatio:CGRectMake(ratioW, ratioH, 1, ratioH) toScaleView:view_separator1];
    [commond useRatio:CGRectMake(ratioW, ratioH, 1, ratioH) toScaleView:view_separator2];
    
    btn_featured.titleLabel.font = font(FONT_TEXT_REGULAR, 15);
    btn_vip.titleLabel.font = font(FONT_TEXT_REGULAR, 15);
    btn_workouts.titleLabel.font = font(FONT_TEXT_REGULAR, 15);
    
    [btn_featured setTitle:multiLanguage(@"FEATURED") forState:UIControlStateNormal];
    [btn_featured setTitle:multiLanguage(@"FEATURED") forState:UIControlStateHighlighted];
    [btn_vip setTitle:multiLanguage(@"VIP") forState:UIControlStateNormal];
    [btn_vip setTitle:multiLanguage(@"VIP") forState:UIControlStateHighlighted];
    [btn_workouts setTitle:multiLanguage(@"WORKOUTS") forState:UIControlStateNormal];
    [btn_workouts setTitle:multiLanguage(@"WORKOUTS") forState:UIControlStateHighlighted];
//    [self buttonAction_workouts:nil];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

#pragma mark - 所有字体都设成灰色
-(void)setAllButtonTextDisable
{
    UIColor *color_disable = [UIColor lightGrayColor];
    [btn_featured setTitleColor:color_disable forState:UIControlStateNormal];
    [btn_featured setTitleColor:color_disable forState:UIControlStateHighlighted];
    [btn_vip setTitleColor:color_disable forState:UIControlStateNormal];
    [btn_vip setTitleColor:color_disable forState:UIControlStateHighlighted];
    [btn_workouts setTitleColor:color_disable forState:UIControlStateNormal];
    [btn_workouts setTitleColor:color_disable forState:UIControlStateHighlighted];
}

#pragma mark - 按钮事件
-(IBAction)buttonAction_featured:(id)_sender
{
    currentSectionType = TraingHomePage_SectionType_Featured;
    [self setAllButtonTextDisable];
    [btn_featured setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_featured setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    if(delegate && [delegate respondsToSelector:@selector(didSelectedSection:)])
    {
        [delegate didSelectedSection:currentSectionType];
        
    }
}

-(IBAction)buttonAction_vip:(id)_sender
{
    currentSectionType = TraingHomePage_SectionType_VIP;
    [self setAllButtonTextDisable];
    [btn_vip setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_vip setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    if(delegate && [delegate respondsToSelector:@selector(didSelectedSection:)])
    {
        [delegate didSelectedSection:currentSectionType];
    }
}

-(IBAction)buttonAction_workouts:(id)_sender
{
    currentSectionType = TraingHomePage_SectionType_WorkOuts;
    [self setAllButtonTextDisable];
    [btn_workouts setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_workouts setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    if(delegate && [delegate respondsToSelector:@selector(didSelectedSection:)])
    {
        [delegate didSelectedSection:currentSectionType];
    }
}
@end

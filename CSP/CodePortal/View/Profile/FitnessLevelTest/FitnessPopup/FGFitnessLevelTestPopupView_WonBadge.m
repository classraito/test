//
//  FGFitnessLevelTestPopupView_WonBadge.m
//  CSP
//
//  Created by Ryan Gong on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGFitnessLevelTestPopupView_WonBadge.h"
#import "Global.h"
@implementation FGFitnessLevelTestPopupView_WonBadge
@synthesize view_badgeBG;
@synthesize lb_title;
@synthesize iv_badge;
@synthesize lb_subtitle;
@synthesize btn_share;
@synthesize btn_close;
@synthesize iv_close;
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:view_badgeBG];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:iv_badge];
    [commond useDefaultRatioToScaleView:lb_subtitle];
    [commond useDefaultRatioToScaleView:btn_share];
    [commond useDefaultRatioToScaleView:btn_close];
    [commond useDefaultRatioToScaleView:iv_close];
    
    lb_title.font = font(FONT_TEXT_BOLD, 22);
    lb_subtitle.font = font(FONT_TEXT_BOLD, 16);
    
    btn_share.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    
    lb_title.text = multiLanguage(@"You’ve won a new fitness badge!");
    NSString *_str_share = multiLanguage(@"SHARE");
    
    [btn_share setTitle:_str_share forState:UIControlStateNormal];
    [btn_share setTitle:_str_share forState:UIControlStateHighlighted];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

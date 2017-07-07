//
//  FGLocationJoinGroupPopView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationJoinGroupPopView.h"
#import "Global.h"

@interface FGLocationJoinGroupPopView()
{
    
    
}
@end

@implementation FGLocationJoinGroupPopView
@synthesize lb_title;
@synthesize lb_subtitle;
@synthesize iv_share;
@synthesize lb_share;
@synthesize btn_share;
@synthesize btn_done;
@synthesize view_whiteBG;


#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.view_bg.backgroundColor = [UIColor clearColor];
    [commond useDefaultRatioToScaleView:view_whiteBG];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_subtitle];
    [commond useDefaultRatioToScaleView:iv_share];
    [commond useDefaultRatioToScaleView:lb_share];
    [commond useDefaultRatioToScaleView:btn_share];
    [commond useDefaultRatioToScaleView:btn_done];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 24);
    lb_subtitle.font = font(FONT_TEXT_REGULAR, 18);
    lb_share.font = font(FONT_TEXT_REGULAR, 18);
    btn_done.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    
    lb_title.text = multiLanguage(@"See you at training!");
    lb_subtitle.text = multiLanguage(@"You can view group details by clicking “My Group” on the “Join a Group” page.");
    
    lb_share.text = multiLanguage(@"SHARE");
    
    NSString *_str_done = multiLanguage(@"DONE");
    [btn_done setTitle:_str_done forState:UIControlStateNormal];
    [btn_done setTitle:_str_done forState:UIControlStateHighlighted];
    
    
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

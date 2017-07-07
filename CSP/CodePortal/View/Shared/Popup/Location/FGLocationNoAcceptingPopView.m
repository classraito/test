//
//  FGLocationNoAcceptingPopView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationNoAcceptingPopView.h"

@implementation FGLocationNoAcceptingPopView
@synthesize lb_title;
@synthesize lb_subTitle;
@synthesize view_whiteBG;
@synthesize btn_sendAgain;
@synthesize btn_cancel;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.view_bg.backgroundColor = [UIColor clearColor];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_subTitle];
    [commond useDefaultRatioToScaleView:view_whiteBG];
    [commond useDefaultRatioToScaleView:btn_sendAgain];
    [commond useDefaultRatioToScaleView:btn_cancel];
    
    lb_title.text = multiLanguage(@"Ouch! We’re sorry about this!");
    lb_subTitle.numberOfLines = 0;
    lb_subTitle.text = multiLanguage(@"It looks like all our trainers are booked right now. You can send the same request again or cancel to try again later.");
    [btn_sendAgain setTitle:multiLanguage(@"SEND AGAIN") forState:UIControlStateNormal];
    [btn_sendAgain setTitle:multiLanguage(@"SEND AGAIN") forState:UIControlStateHighlighted];
    
    [btn_cancel setTitle:multiLanguage(@"CANCEL") forState:UIControlStateNormal];
    [btn_cancel setTitle:multiLanguage(@"CANCEL") forState:UIControlStateHighlighted];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 20);
    lb_subTitle.font = font(FONT_TEXT_REGULAR, 16);
    
    btn_sendAgain.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    btn_cancel.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    
    
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

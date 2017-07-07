//
//  FGAdviceBuyBundlePopView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGAdviceBuyBundlePopView.h"
#import "Global.h"
@implementation FGAdviceBuyBundlePopView
@synthesize lb_title;
@synthesize lb_subtitle;
@synthesize lb_description;
@synthesize btn_go2BuyBundle;
@synthesize btn_no;
@synthesize view_whiteBg;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.view_bg.backgroundColor = [UIColor clearColor];
    
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_subtitle];
    [commond useDefaultRatioToScaleView:lb_description];
    [commond useDefaultRatioToScaleView:btn_go2BuyBundle];
    [commond useDefaultRatioToScaleView:btn_no];
    [commond useDefaultRatioToScaleView:view_whiteBg];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 24);
    lb_subtitle.font = font(FONT_TEXT_REGULAR, 24);
    lb_description.font = font(FONT_TEXT_REGULAR, 18);
    btn_go2BuyBundle.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    btn_no.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    
    lb_title.text = multiLanguage(@"Buy a bundle");
    lb_subtitle.text = multiLanguage(@"Buy 10 sessions and get 1 session free!");
    lb_description.text = multiLanguage(@"Redeem your sessions whenever you want.");
    NSString *_str_bundlePrice = @"￥1800";
    [btn_go2BuyBundle setTitle:_str_bundlePrice forState:UIControlStateNormal];
    [btn_go2BuyBundle setTitle:_str_bundlePrice forState:UIControlStateHighlighted];
    
    NSString *_str_no = multiLanguage(@"Not right now");
    [btn_no setTitle:_str_no forState:UIControlStateNormal];
    [btn_no setTitle:_str_no forState:UIControlStateHighlighted];
    
    
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

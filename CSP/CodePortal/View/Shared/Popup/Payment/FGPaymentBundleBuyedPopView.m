//
//  FGPaymentBundleBuyedPopView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPaymentBundleBuyedPopView.h"
#import "Global.h"
@implementation FGPaymentBundleBuyedPopView
@synthesize lb_title;
@synthesize lb_subTitle;
@synthesize btn_use1BundleSession;
@synthesize btn_cancelRequest;
@synthesize view_whiteBg;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.view_bg.backgroundColor = [UIColor clearColor];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_subTitle];
    [commond useDefaultRatioToScaleView:btn_use1BundleSession];
    [commond useDefaultRatioToScaleView:btn_cancelRequest];
    [commond useDefaultRatioToScaleView:view_whiteBg];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 24);
    lb_subTitle.font = font(FONT_TEXT_REGULAR, 18);
    btn_use1BundleSession.titleLabel.font = font(FONT_TEXT_REGULAR, 20);
    btn_cancelRequest.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    
    NSString *_str_use1Bundle = multiLanguage(@"USE 1 BUNDLE SESSION");
    NSString *_str_cancelReqeust = multiLanguage(@"CANCEL REQUEST");
    [btn_use1BundleSession setTitle:_str_use1Bundle forState:UIControlStateNormal];
    [btn_use1BundleSession setTitle:_str_use1Bundle forState:UIControlStateHighlighted];
    
    [btn_cancelRequest setTitle:_str_cancelReqeust forState:UIControlStateNormal];
    [btn_cancelRequest setTitle:_str_cancelReqeust forState:UIControlStateHighlighted];
    
    lb_title.text = multiLanguage(@"Payment Success!");
    lb_subTitle.text = multiLanguage(@"You’ve bought a 10-session bundle. You can redeem your sessions at any time!");
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

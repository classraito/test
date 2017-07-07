//
//  FGSettingForFeedbackPopupView.m
//  CSP
//
//  Created by JasonLu on 17/1/19.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGSettingForFeedbackPopupView.h"

@implementation FGSettingForFeedbackPopupView

@synthesize lb_title;
@synthesize lb_subtitle;
@synthesize lb_email;
@synthesize iv_email;
@synthesize btn_email;
@synthesize str_emailSubject;
-(void)awakeFromNib
{
  [super awakeFromNib];
  self.view_bg.backgroundColor = [UIColor clearColor];
  
  [commond useDefaultRatioToScaleView:lb_title];
  [commond useDefaultRatioToScaleView:lb_subtitle];
  [commond useDefaultRatioToScaleView:lb_email];
  [commond useDefaultRatioToScaleView:iv_email];
  [commond useDefaultRatioToScaleView:btn_email];
  
  lb_title.font = font(FONT_TEXT_REGULAR, 20);
  lb_subtitle.font = font(FONT_TEXT_REGULAR, 16);
  lb_email.font = font(FONT_TEXT_REGULAR, 16);
  
  btn_email.layer.cornerRadius = btn_email.frame.size.width / 2;
  btn_email.layer.masksToBounds = YES;
  
  lb_title.text = multiLanguage(@"Feedback");
  lb_subtitle.text = multiLanguage(@"Please email feedback to us at");
  lb_email.text = multiLanguage(@"feedback@weboxapp.com");
  
  btn_email.layer.cornerRadius = self.btn_email.frame.size.width / 2;
  btn_email.layer.masksToBounds = YES;
  
}

-(void)layoutSubviews
{
  [super layoutSubviews];
}

-(void)dealloc
{
  NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
  str_emailSubject = nil;
}

@end

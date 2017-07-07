//
//  FGBadgeInfoPopView.m
//  CSP
//
//  Created by JasonLu on 16/12/29.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBadgeInfoPopView.h"

@implementation FGBadgeInfoPopView
@synthesize view_whiteBG;
@synthesize iv_badge;
@synthesize lb_badgeInfo;
@synthesize view_badgeProgressBar;
@synthesize lb_progressTip;
@synthesize btn_cancel;
#pragma mark - 生命周期
-(void)awakeFromNib
{
  [super awakeFromNib];
  self.view_bg.backgroundColor = [UIColor clearColor];
  [commond useDefaultRatioToScaleView:self.view_blackBG];
  [commond useDefaultRatioToScaleView:view_whiteBG];
  [commond useDefaultRatioToScaleView:lb_badgeInfo];
   [commond useDefaultRatioToScaleView:lb_progressTip];
  [commond useDefaultRatioToScaleView:iv_badge];
  [commond useDefaultRatioToScaleView:view_badgeProgressBar];
  [commond useDefaultRatioToScaleView:btn_cancel];

  
  view_badgeProgressBar.progressDirection = M13ProgressViewBorderedBarProgressDirectionLeftToRight;
  
  self.lb_progressTip.font = font(FONT_TEXT_REGULAR, 22);
  self.lb_badgeInfo.font = font(FONT_TEXT_REGULAR, 28);
  
  self.lb_progressTip.textColor = color_homepage_black;
  self.lb_badgeInfo.textColor = color_homepage_black;
  
  [view_badgeProgressBar setBorderWidth:0];
  [view_badgeProgressBar setCornerType:M13ProgressViewBorderedBarCornerTypeCircle];
  [view_badgeProgressBar setBackgroundColor:rgba(173, 177, 178, .5)];
  [view_badgeProgressBar setPrimaryColor:color_workoutlog_darkGreen];
  
  view_badgeProgressBar.layer.cornerRadius = view_badgeProgressBar.bounds.size.height/2;
  view_badgeProgressBar.layer.masksToBounds = YES;
}

- (void)setupViewWithInfo:(NSDictionary *)_dic_info {
  if (ISNULLObj(_dic_info))
    return;
  NSString *_str_img = _dic_info[@"Thumbnail"];
  [self.iv_badge sd_setImageWithURL:[NSURL URLWithString:_str_img] placeholderImage:IMG_PLACEHOLDER];
  
  NSString *_str_brief = _dic_info[@"Brief"];
  _str_brief = [_str_brief stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
  NSString *_str_progress = [NSString stringWithFormat:@"%@",_dic_info[@"Progress"]];
  NSString *_str_achieve = [NSString stringWithFormat:@"%@",_dic_info[@"Achieve"]];
  
  NSString *_str_showProgress = @"";
  if (![_str_progress isEqualToString:_str_achieve]) {
    _str_showProgress = [NSString stringWithFormat:@"%@/%@",_str_progress,_str_achieve];
  }
  
  self.lb_badgeInfo.text = _str_brief;
  self.lb_progressTip.text = _str_showProgress;
  CGFloat _flt_progress = [_str_progress floatValue] / [_str_achieve floatValue];
  //更新进度条
  [view_badgeProgressBar setProgress:_flt_progress animated:NO];
  
  NSString *_str_color = _dic_info[@"BoxColor"];
  self.view_whiteBG.backgroundColor = [UIColor colorWithHexString:_str_color];
  
}

@end

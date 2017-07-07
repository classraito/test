//
//  FGNewBadgeInfoPopupView.m
//  CSP
//
//  Created by JasonLu on 17/1/23.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGNewBadgeInfoPopupView.h"

@implementation FGNewBadgeInfoPopupView
@synthesize view_badgeProgressBar;
@synthesize lb_progressTip;
@synthesize lb_content;
#pragma mark - 生命周期
-(void)awakeFromNib
{
  [super awakeFromNib];
  self.view_bg.backgroundColor = [UIColor clearColor];
  [commond useDefaultRatioToScaleView:lb_progressTip];
  [commond useDefaultRatioToScaleView:lb_content];
  [commond useDefaultRatioToScaleView:view_badgeProgressBar];
  
  view_badgeProgressBar.progressDirection = M13ProgressViewBorderedBarProgressDirectionLeftToRight;
  
  self.lb_progressTip.font = font(FONT_TEXT_REGULAR, 22);
  self.lb_progressTip.textColor = color_homepage_black;
  
  self.lb_content.font = font(FONT_TEXT_REGULAR, 18);
  self.lb_progressTip.textColor = color_homepage_black;
  
  [view_badgeProgressBar setBorderWidth:0];
  [view_badgeProgressBar setCornerType:M13ProgressViewBorderedBarCornerTypeCircle];
  [view_badgeProgressBar setBackgroundColor:rgba(173, 177, 178, .5)];
  [view_badgeProgressBar setPrimaryColor:color_workoutlog_darkGreen];
  
  view_badgeProgressBar.layer.cornerRadius = view_badgeProgressBar.bounds.size.height/2;
  view_badgeProgressBar.layer.masksToBounds = YES;
  
  self.cub_shareNow.hidden = YES;
  
  [self.btn_seeMyBadges removeTarget:self action:@selector(buttonAction_seeMyBadges:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupViewWithInfo:(NSDictionary *)_dic_info {
  if (ISNULLObj(_dic_info))
    return;
  NSString *_str_img = _dic_info[@"Thumbnail"];
  [self.iv_badgeThumbnail sd_setImageWithURL:[NSURL URLWithString:_str_img] placeholderImage:IMGWITHNAME(@"dot")];
  
  NSString *_str_brief = _dic_info[@"Brief"];
  _str_brief = [_str_brief stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
  NSString *_str_progress = [NSString stringWithFormat:@"%@",_dic_info[@"Progress"]];
  NSString *_str_achieve = [NSString stringWithFormat:@"%@",_dic_info[@"Achieve"]];
  
  NSString *_str_showProgress = @"";
//  if (![_str_progress isEqualToString:_str_achieve])
  {
    _str_showProgress = [NSString stringWithFormat:@"(%@/%@)",_str_progress,_str_achieve];
  }
  
  NSString *_str_description = _dic_info[@"Description"];
  self.lb_title.text = _str_brief;
  self.lb_content.text = _str_description;
  
  if ([_str_achieve integerValue] > 1) {
    self.lb_progressTip.text = _str_showProgress;
    CGFloat _flt_progress = [_str_progress floatValue] / [_str_achieve floatValue];
    //更新进度条
    [view_badgeProgressBar setProgress:_flt_progress animated:NO];
    self.view_badgeProgressBar.hidden = NO;
    self.lb_progressTip.hidden = NO;
  } else {
    self.view_badgeProgressBar.hidden = YES;
    self.lb_progressTip.hidden = YES;
  }
  
  NSString *_str_color = _dic_info[@"BoxColor"];
  self.backgroundColor = [UIColor colorWithHexString:_str_color];
  NSString *_str_buttonColor = _dic_info[@"ButtonColor"];
  self.btn_seeMyBadges.backgroundColor = [UIColor colorWithHexString:_str_buttonColor];
  
  if ([_str_color isEqualToString:@"13345b"]) {
    //其它字体颜色需要设置成白色
    self.lb_title.textColor = [UIColor whiteColor];
    self.lb_content.textColor = [UIColor whiteColor];
    self.lb_progressTip.textColor = [UIColor whiteColor];
    self.lb_subtitle.textColor = [UIColor whiteColor];
    
    [self.btn_seeMyBadges setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn_seeMyBadges setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
  }
}

@end

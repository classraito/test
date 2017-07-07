//
//  FGBadgeDetailInfoPopView.m
//  CSP
//
//  Created by JasonLu on 16/12/11.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBadgeDetailInfoPopView.h"

@implementation FGBadgeDetailInfoPopView
@synthesize view_whiteBG;
@synthesize iv_badge;
@synthesize lb_badgeInfo;
#pragma mark - 生命周期
-(void)awakeFromNib
{
  [super awakeFromNib];
  self.view_bg.backgroundColor = [UIColor clearColor];
  [commond useDefaultRatioToScaleView:view_whiteBG];
  [commond useDefaultRatioToScaleView:lb_badgeInfo];
  [commond useDefaultRatioToScaleView:iv_badge];
  
  
  
//  btn_done.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
//  NSString *_str_done = multiLanguage(@"DONE");
//  [btn_done setTitle:_str_done forState:UIControlStateNormal];
//  [btn_done setTitle:_str_done forState:UIControlStateHighlighted];
  
}

- (void)setupBadgeWithInfo:(NSDictionary *)_dic_info{
  if (ISNULLObj(_dic_info))
    return;
  NSString *_str_img = _dic_info[@"Thumbnail"];
  [self.iv_badge sd_setImageWithURL:[NSURL URLWithString:_str_img] placeholderImage:IMG_PLACEHOLDER];
  
  NSString *_str_brief = _dic_info[@"Brief"];
  NSString *_str_progress = [NSString stringWithFormat:@"%@",_dic_info[@"Progress"]];
  NSString *_str_achieve = [NSString stringWithFormat:@"%@",_dic_info[@"Achieve"]];
  
  NSString *_str_showProgress = @"";
  if (![_str_progress isEqualToString:_str_achieve]) {
    _str_showProgress = [NSString stringWithFormat:@"%@/%@",_str_progress,_str_achieve];
  }
  
  NSArray *_arr_infos = @[
                             [FGUtils createAttributeTextInfo:_str_brief font:font(FONT_TEXT_REGULAR, 28) color:color_homepage_black paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"\n"],
                             [FGUtils createAttributeTextInfo:_str_showProgress font:font(FONT_TEXT_REGULAR, 22) color:color_homepage_black paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"\n"]];
  NSMutableAttributedString *mattr_str = [FGUtils createAttributedStringWithContentInfo:_arr_infos];
  self.lb_badgeInfo.attributedText = mattr_str;
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

//
//  FGBadgeCompeleteInfoPopView.m
//  CSP
//
//  Created by JasonLu on 17/1/10.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGBadgeCompeleteInfoPopView.h"

@implementation FGBadgeCompeleteInfoPopView

#pragma mark - 生命周期
-(void)awakeFromNib
{
  [super awakeFromNib];
  
  self.lb_progressTip.hidden = YES;
  self.view_badgeProgressBar.hidden = YES;
}

- (void)setupViewWithInfo:(NSDictionary *)_dic_info {
  if (ISNULLObj(_dic_info))
    return;
  NSString *_str_img = _dic_info[@"Thumbnail"];
  [self.iv_badge sd_setImageWithURL:[NSURL URLWithString:_str_img] placeholderImage:IMG_PLACEHOLDER];
  
  NSString *_str_brief = _dic_info[@"Brief"];
  _str_brief = [_str_brief stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
  self.lb_badgeInfo.text = _str_brief;
}

@end

//
//  FGCustomBadgeView.m
//  CSP
//
//  Created by JasonLu on 17/1/24.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGCustomBadgeView.h"
#import "UIView+CornerRaduis.h"

@implementation FGCustomBadgeView

#pragma mark - 生命周期
-(void)awakeFromNib
{
  [super awakeFromNib];
  
  [self makeWithCornerRadius:self.bounds.size.width/2];
  [self.view_bg makeWithCornerRadius:self.view_bg.bounds.size.width/2];
  self.clipsToBounds = YES;
  
  [commond useDefaultRatioToScaleView:self.view_bg];
  [commond useDefaultRatioToScaleView:self.lb_title];
  
  self.view_content.backgroundColor = [UIColor clearColor];
  
  self.lb_title.font = font(FONT_TEXT_REGULAR, 16);
  self.lb_title.textColor = [UIColor whiteColor];
  
  self.view_bg.backgroundColor = color_red_panel;
  
  self.lb_title.hidden = YES;
}

-(void)dealloc
{
  NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

- (void)setupViewWithInfo:(NSDictionary *)_dic {
  if (_dic == nil)
    return;
  
  NSNumber *_number_cnt = _dic[@"cnt"];
  if ([_number_cnt integerValue] >= 100)
    self.lb_title.text = @"..";
  else
    self.lb_title.text = [NSString stringWithFormat:@"%@", _dic[@"cnt"]];
}
@end

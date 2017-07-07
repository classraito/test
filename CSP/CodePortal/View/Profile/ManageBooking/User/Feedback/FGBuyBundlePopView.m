//
//  FGBuyBundlePopView.m
//  CSP
//
//  Created by JasonLu on 16/12/27.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBuyBundlePopView.h"

@implementation FGBuyBundlePopView

-(void)awakeFromNib
{
  [super awakeFromNib];
  
  self.lb_warningTitle.textColor = color_homepage_black;
  self.lb_warningTitle.font = font(FONT_TEXT_BOLD, 28);
  self.lb_warningTitle.textAlignment = NSTextAlignmentCenter;
  
  self.lb_warningTip.textColor = color_deepgreen;
  self.lb_warningTip.font = font(FONT_TEXT_BOLD, 26);
  self.lb_warningTip.textAlignment = NSTextAlignmentCenter;
  
  self.view_bg.backgroundColor = rgba(255, 255, 255, 1.0);
  
  self.lb_warningTitle.text = multiLanguage(@"Buy a bundle");
  self.lb_warningTip.text = multiLanguage(@"Buy 10 sessions and get 1 session free!");
  
  self.lb_content.textColor = color_homepage_lightGray;
  self.lb_warningTip.font = font(FONT_TEXT_REGULAR, 24);
  self.lb_content.text = @"Redeem your sessions whenever you want.";
  
  [self.btn_done setBackgroundColor:color_deepgreen];
  [self.btn_done.titleLabel setTextColor:[UIColor whiteColor]];
  
  [self.btn_cancel setTitle:multiLanguage(@"Not right now") forState:UIControlStateNormal];
  [self.btn_cancel.titleLabel setTextColor:color_deepgreen];
}

- (void)setupViewWithInfo:(NSDictionary *)_dic_info {
  NSDictionary *_dic_bundleLessons = _dic_info[@"BundleLessons"][0];
  NSInteger int_bundlePrice = [_dic_bundleLessons[@"BundlePrice"] integerValue];
  [self.btn_done setTitle:[NSString stringWithFormat:@"¥ %ld",int_bundlePrice] forState:UIControlStateNormal];
}

@end

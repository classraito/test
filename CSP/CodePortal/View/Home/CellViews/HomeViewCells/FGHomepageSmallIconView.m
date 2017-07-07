//
//  FGHomepageSmallIconView.m
//  CSP
//
//  Created by JasonLu on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGHomepageSmallIconView.h"
#import "UIImageView+Circle.h"
@interface FGHomepageSmallIconView () {
}

@end

@implementation FGHomepageSmallIconView
@synthesize iv_icon;
@synthesize lb_title;
@synthesize btn_info;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];

  [commond useDefaultRatioToScaleView:lb_title];
  [commond useDefaultRatioToScaleView:btn_info];
  [commond useDefaultRatioToScaleView:iv_icon];
  [iv_icon makeCicleWithRaduis:iv_icon.frame.size.width / (2)];

  lb_title.font = font(FONT_TEXT_REGULAR, 14);
  lb_title.textColor = color_homepage_lightGray;
}

- (void)updateViewWithIconLink:(NSString *)link title:(NSString *)title {
  [self.iv_icon sd_setImageWithURL:[NSURL URLWithString:link]];
  [self.iv_icon sd_setImageWithURL:[NSURL URLWithString:link] placeholderImage:IMG_PLACEHOLDER];
  self.lb_title.text = title;
}
@end

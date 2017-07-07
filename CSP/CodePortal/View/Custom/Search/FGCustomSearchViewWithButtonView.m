//
//  FGCustomSearchViewWithButtonView.m
//  CSP
//
//  Created by JasonLu on 16/10/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCustomSearchViewWithButtonView.h"

@interface FGCustomSearchViewWithButtonView () {
  CGRect rect_originViewBg;
  CGRect rect_originTF;
  CGRect rect_orginIcon;
  TFSTATUS currentTFStatus;
}
@end

@implementation FGCustomSearchViewWithButtonView
@synthesize iv_searchIcon;
@synthesize view_bg;
@synthesize tf_search;
@synthesize btn_right;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  [commond useDefaultRatioToScaleView:iv_searchIcon];
  [commond useDefaultRatioToScaleView:tf_search];
  [commond useDefaultRatioToScaleView:btn_right];

  [self internalInitalView];
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

- (void)internalInitalView {
  self.view_bg.layer.cornerRadius  = self.view_bg.bounds.size.height / 2;
  self.view_bg.layer.masksToBounds = YES;
  self.view_bg.layer.borderColor   = color_homepage_lightGray.CGColor;
  self.view_bg.layer.borderWidth   = 1.0f;

  tf_search.textColor = color_homepage_lightGray;
  tf_search.font      = font(FONT_TEXT_REGULAR, 16);

  rect_originViewBg = self.view_bg.frame;
  rect_originTF     = self.tf_search.frame;
  rect_orginIcon    = self.iv_searchIcon.frame;

  [self setupSearchViewWithStatus:TF_NORMAL withAnimation:NO];
}

- (void)setupViewOriginStyleWithAnimation:(BOOL)isAnimated {
  [self setupSearchViewWithStatus:TF_NORMAL withAnimation:isAnimated];
  self.tf_search.text = @"";
}

- (void)setupSearchViewWithButton:(NSString *)title buttonColor:(UIColor *)buttonColor searchIcon:(NSString *)iconName {
  if (!iconName) {
    [self setupSearchViewWithButton:title buttonColor:buttonColor];
  }
  if (iconName) {
    self.iv_searchIcon.image = IMGWITHNAME(iconName);
  }
}

- (void)setupSearchViewWithButton:(NSString *)title buttonColor:(UIColor *)buttonColor {
  [self.btn_right setTitle:title forState:UIControlStateNormal];
  [self.btn_right setTitleColor:buttonColor forState:UIControlStateNormal];
}

- (void)setupSearchViewWithStatus:(TFSTATUS)status withAnimation:(BOOL)isAnimation {
  currentTFStatus = status;
  //不是搜索状态
  if (status == TF_NORMAL) {
    self.btn_right.hidden = YES;
    if (!isAnimation) {
      self.view_bg.frame   = rect_originViewBg;
      self.tf_search.frame = rect_originTF;
    } else {
      [UIView animateWithDuration:0.3f animations:^{
        self.view_bg.frame   = rect_originViewBg;
        self.tf_search.frame = rect_originTF;
      }
          completion:^(BOOL finished){
          }];
    }
  } else {
    //搜索状态
    if (!isAnimation) {
      self.view_bg.frame    = CGRectMake(rect_originViewBg.origin.x, rect_originViewBg.origin.y, rect_originViewBg.size.width - 60, rect_originViewBg.size.height);
      self.tf_search.frame  = CGRectMake(rect_originTF.origin.x, rect_originTF.origin.y, rect_originTF.size.width - 60 - 5, rect_originTF.size.height);
      self.btn_right.hidden = YES;
    } else {
      [UIView animateWithDuration:0.3f animations:^{
        self.view_bg.frame   = CGRectMake(rect_originViewBg.origin.x, rect_originViewBg.origin.y, rect_originViewBg.size.width - 60, rect_originViewBg.size.height);
        self.tf_search.frame = CGRectMake(rect_originTF.origin.x, rect_originTF.origin.y, rect_originTF.size.width - 60 - 5, rect_originTF.size.height);
      }
          completion:^(BOOL finished) {
            self.btn_right.hidden = NO;
          }];
    }
  }
}

@end

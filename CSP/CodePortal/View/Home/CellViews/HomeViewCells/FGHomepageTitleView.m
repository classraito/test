//
//  FGHomepageTitleView.m
//  CSP
//
//  Created by JasonLu on 16/9/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGHomepageTitleView.h"

@interface FGHomepageTitleView () {
  NSInteger int_tag;
}
@end

@implementation FGHomepageTitleView
@synthesize lb_left;
@synthesize lb_right;
@synthesize btn_right;
@synthesize delegate;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];

  [commond useDefaultRatioToScaleView:lb_left];
  [commond useDefaultRatioToScaleView:lb_right];
  [commond useDefaultRatioToScaleView:btn_right];


  lb_left.font  = font(FONT_TEXT_REGULAR, 20);
  lb_right.font = font(FONT_TEXT_REGULAR, 14);
  
  btn_right.hidden = YES;
}

#pragma mark - 成员方法
- (void)updateLeftTitleHidden:(BOOL)lhidden withTitle:(id)lTitle color:(UIColor *)lcolor andRightTitleHidden:(BOOL)rhidden withTitle:(NSString *)rTitle color:(UIColor *)rcolor rightButtonHidden:(BOOL)_bool_hidden tag:(NSInteger)_int_tag {
  
  
  [self updateLeftTitleHidden:lhidden withTitle:lTitle color:lcolor andRightTitleHidden:rhidden withTitle:rTitle color:rcolor];
  
  self.btn_right.hidden = _bool_hidden;
  self.btn_right.tag = _int_tag;
  
  if (_bool_hidden == NO) {
    [self.btn_right addTarget:self action:@selector(buttonAction_rightAction:) forControlEvents:UIControlEventTouchUpInside];
  }
}

- (void)buttonAction_rightAction:(id)sender {
  if (self.delegate) {
    [self.delegate action_didSelectTitle:self.lb_left.text];
  }
}

- (void)updateLeftTitleHidden:(BOOL)lhidden withTitle:(id)lTitle color:(UIColor *)lcolor andRightTitleHidden:(BOOL)rhidden withTitle:(NSString *)rTitle color:(UIColor *)rcolor {
  lb_left.textColor  = lcolor;
  lb_right.textColor = rcolor;

  [self updateLeftTitleWith:lTitle rightTitleWith:rTitle];
  [self updateLeftTitleStatus:lhidden rightTitleStatus:rhidden];
}

- (void)setupWithBgColor:(UIColor *)color leftTitleFont:(UIFont *)lfont rightTitleFont:(UIFont *)rfont {
  self.backgroundColor = color;
  if (lfont)
    self.lb_left.font    = lfont;
  if (rfont)
    self.lb_right.font   = rfont;
}

#pragma mark - 私有方法
- (void)updateLeftTitleStatus:(BOOL)lhidden rightTitleStatus:(BOOL)rhidden {
  self.lb_left.hidden  = lhidden;
  self.lb_right.hidden = rhidden;
}

- (void)updateLeftTitleWith:(id)leftTitle rightTitleWith:(NSString *)rightTitle {
  //  self.lb_left.text           = @"";
  //  self.lb_left.attributedText = [[NSAttributedString alloc] initWithString:@""];
  if ([leftTitle isKindOfClass:[NSString class]]) {
    self.lb_left.text = leftTitle;
  } else if ([leftTitle isKindOfClass:[NSAttributedString class]]) {
    self.lb_left.attributedText = leftTitle;
  }
  self.lb_right.text = rightTitle;
}

@end

//
//  FGProfileInfoDetailCellView.m
//  CSP
//
//  Created by JasonLu on 16/10/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGProfileInfoDetailCellView.h"
#import "UIView+CornerRaduis.h"
@interface FGProfileInfoDetailCellView ()

@end

@implementation FGProfileInfoDetailCellView

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  [commond useDefaultRatioToScaleView:self.lb_leftTitle];
  [commond useDefaultRatioToScaleView:self.lb_rightTitle];
  [commond useDefaultRatioToScaleView:self.iv_icon];
  [commond useDefaultRatioToScaleView:self.tf_content];

  self.lb_rightTitle.hidden = YES;
  self.tf_content.textColor = color_homepage_black;
  self.tf_content.font      = font(FONT_TEXT_REGULAR, 14);
  
  [self.iv_icon makeWithCornerRadius:self.iv_icon.bounds.size.width/2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)setupCellInfoWithHidden:(BOOL)hidden {
  self.iv_icon.hidden       = hidden;
  self.lb_rightTitle.hidden = hidden;
  self.tf_content.hidden    = hidden;
}

- (void)setupCellInfoWithLeftFont:(UIFont *)lfont leftColor:(UIColor *)lcolor rightFont:(UIFont *)rfont rightColor:(UIColor *)rcolor {
  self.lb_leftTitle.font      = lfont;
  self.lb_leftTitle.textColor = lcolor;

  self.lb_rightTitle.font      = rfont;
  self.lb_rightTitle.textColor = rcolor;

  self.tf_content.font      = rfont;
  self.tf_content.textColor = rcolor;
}

- (void)updateCellViewWithInfo:(id)_dataInfo {
  NSString *title   = _dataInfo[@"title"];
  NSString *content = _dataInfo[@"content"];
  NSString *type    = _dataInfo[@"type"];

  
  if ([type isEqualToString:@"actionsheet"]) {
    self.lb_rightTitle.hidden = YES;
    self.tf_content.hidden    = YES;
    self.iv_icon.hidden       = NO;
    
    self.iv_icon.image = _dataInfo[@"userIcon"];

    self.lb_leftTitle.text  = title;
    return;
  }
  
  self.lb_leftTitle.text  = title;
  self.lb_rightTitle.text = content;
  
  if ([type isEqualToString:@"picker"]) {
    self.lb_rightTitle.hidden = NO;
    self.tf_content.hidden    = YES;
    self.iv_icon.hidden       = YES;
    
    self.tf_content.text    = content;
    
    if ([title isEqualToString:multiLanguage(@"Goal")] ||
        [title isEqualToString:multiLanguage(@"Boxing Level")]){
      
      if ([content isEqualToString:multiLanguage(@"undefined")])
        self.lb_rightTitle.text    = @"";
    }
    else if ([title isEqualToString:multiLanguage(@"Age")]) {
      if ([content isEqualToString:@"0"]) {
        self.lb_rightTitle.text = @"";
      }
    }
  }
  else if ([type isEqualToString:@"input"]) {
    self.lb_rightTitle.hidden = YES;
    self.tf_content.hidden    = NO;
    self.iv_icon.hidden       = YES;
    
    self.tf_content.text    = content;
    [self.tf_content setUserInteractionEnabled:YES];
    self.tf_content.textColor = color_homepage_black;
    self.tf_content.keyboardAppearance = UIKeyboardAppearanceDark;
    if ([title isEqualToString:multiLanguage(@"Height")] ||
        [title rangeOfString:multiLanguage(@"Height")].location != NSNotFound) {
      self.tf_content.keyboardType = UIKeyboardTypeNumberPad;
      
      if ([content isEqualToString:@"0"]) {
        self.tf_content.text = @"";
      }
      
    } else if ([title isEqualToString:multiLanguage(@"Weight")] ||
               [title rangeOfString:multiLanguage(@"Weight")].location != NSNotFound) {
      self.tf_content.keyboardType = UIKeyboardTypeNumberPad;
      if ([content isEqualToString:@"0"]) {
        self.tf_content.text = @"";
      }
      
    } else if ([title isEqualToString:multiLanguage(@"Phone Number")]) {
      [self.tf_content setUserInteractionEnabled:NO];
      self.tf_content.keyboardType = UIKeyboardTypePhonePad;
      self.tf_content.textColor = color_homepage_lightGray;
      }

  }
}

@end

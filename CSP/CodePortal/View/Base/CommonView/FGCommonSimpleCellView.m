//
//  FGHomepageSearchSimpleCellView.m
//  CSP
//
//  Created by JasonLu on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCommonSimpleCellView.h"
#import "UIImageView+Circle.h"
#import "UIImageView+WebCache.h"
@interface FGCommonSimpleCellView ()

@property (weak, nonatomic) IBOutlet UIImageView *iv_icon;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@end

@implementation FGCommonSimpleCellView
@synthesize iv_icon;
@synthesize lb_name;
@synthesize lb_title;
@synthesize btn_right;

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  [commond useDefaultRatioToScaleView:lb_name];
  [commond useDefaultRatioToScaleView:lb_title];
  [commond useDefaultRatioToScaleView:iv_icon];
  [commond useDefaultRatioToScaleView:btn_right];

  [iv_icon makeCicleWithRaduis:iv_icon.frame.size.width / (2)];

  lb_name.font      = font(FONT_TEXT_REGULAR, 14);
  lb_name.textColor = color_homepage_black;

  lb_title.font      = font(FONT_TEXT_REGULAR, 14);
  lb_title.textColor = color_homepage_black;

  self.btn_right.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)setupViewWithIcon:(NSString *)imgStr name:(NSString *)name {
  [self.iv_icon sd_setImageWithURL:[NSURL URLWithString:imgStr]];
  self.lb_name.text = name;

  self.lb_title.hidden  = YES;
  self.iv_icon.hidden   = NO;
  self.lb_name.hidden   = NO;
}

- (void)setupViewWithTitle:(NSString *)title color:(UIColor *)color {
  self.lb_title.text = title;
  if (color) {
    self.lb_title.textColor = color;
  }

  self.lb_title.hidden  = NO;
  self.iv_icon.hidden   = YES;
  self.lb_name.hidden   = YES;
}

- (void)setupViewWithRightButtonTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)btnColor borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)bgColor {
  self.btn_right.hidden = NO;
  [self.btn_right setTitle:title forState:UIControlStateNormal];
  [self.btn_right setTitleColor:btnColor forState:UIControlStateNormal];
  [self.btn_right.titleLabel setFont:font];
  self.btn_right.layer.borderColor = borderColor.CGColor;
  self.btn_right.layer.borderWidth = borderWidth;
  self.btn_right.backgroundColor   = bgColor;
}

- (void)setupViewWithRightButtonTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)btnColor borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)bgColor cornerRadius:(CGFloat)radius {
  self.btn_right.layer.cornerRadius = radius;
  [self setupViewWithRightButtonTitle:title font:font color:btnColor borderWidth:borderWidth borderColor:borderColor backgroundColor:bgColor];
}

- (void)setupViewHiddenRightBtn:(BOOL)isHidden {
  self.btn_right.hidden = isHidden;
}

- (void)updateCellViewWithInfo:(id)_dataInfo {
  NSString *title = _dataInfo[@"title"];
  if ([title isEqualToString:@"newsfeed"]) {
    NSString *content = _dataInfo[@"content"];
    [self setupViewWithTitle:content color:_dataInfo[@"color"]];
  }
  else if ([title isEqualToString:@"topic"]) {
    NSString *content = [NSString stringWithFormat:@"#%@", _dataInfo[@"content"]];
    [self setupViewWithTitle:content color:_dataInfo[@"color"]];
  }
  else if ([title isEqualToString:@"trainer"] ||
             [title isEqualToString:@"user"]) {
    NSString *name   = _dataInfo[@"name"];
    NSString *imgStr = _dataInfo[@"url"];
    [self setupViewWithIcon:imgStr name:name];
  }
  else if ([title isEqualToString:@"follower"] ||
           [title isEqualToString:@"follow"]) {
    NSString *name   = _dataInfo[@"name"];
    NSString *imgStr = _dataInfo[@"url"];
    [self setupViewWithIcon:imgStr name:name];
  }

}

@end

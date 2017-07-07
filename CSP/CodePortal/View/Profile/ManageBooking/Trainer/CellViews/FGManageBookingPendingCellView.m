//
//  FGManageBookingPendingCellView.m
//  CSP
//
//  Created by JasonLu on 16/11/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGManageBookingPendingCellView.h"
#import "UIView+CornerRaduis.h"
@implementation FGManageBookingPendingCellView
@synthesize delegate;

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [commond useDefaultRatioToScaleView:self.btn_rebook];
  [commond useDefaultRatioToScaleView:self.lb_date];
  [commond useDefaultRatioToScaleView:self.lb_dateTime];
  [commond useDefaultRatioToScaleView:self.lb_location];
  [commond useDefaultRatioToScaleView:self.lb_locationDetail];
  
  self.lb_date.font = font(FONT_TEXT_REGULAR, 15);
  self.lb_dateTime.font = font(FONT_TEXT_REGULAR, 15);
  self.lb_location.font = font(FONT_TEXT_REGULAR, 15);
  self.lb_locationDetail.font = font(FONT_TEXT_REGULAR, 15);
  self.lb_content.font = font(FONT_TEXT_REGULAR, 15);
  
  self.lb_date.textColor = color_homepage_lightGray;
  self.lb_dateTime.textColor = color_homepage_lightGray;
  self.lb_location.textColor = color_homepage_lightGray;
  self.lb_locationDetail.textColor = color_homepage_lightGray;
  self.lb_content.textColor = color_homepage_lightGray;

  [self.btn_rebook setTitle:multiLanguage(@"ACCEPT") forState:UIControlStateNormal];
  [self.btn_rebook setBackgroundColor:color_red_panel];
  [self.btn_rebook makeWithCornerRadius:5.0];
  [self.btn_rebook addTarget:self action:@selector(buttonAction_Accepted:) forControlEvents:UIControlEventTouchUpInside];
  
  [self.btn_userIcon addTarget:self action:@selector(buttonAction_gotoTrainerDetailInfo:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updateCellViewWithInfo:(NSDictionary *)_dataInfo {
  NSDictionary *_dic_userInfo = _dataInfo[@"user"];
  if (ISNULLObj(_dic_userInfo))
    return;
  
  NSString *_str_userIcon = _dic_userInfo[@"UserIcon"];
  if (!ISNULLObj(_str_userIcon))
    [self.iv_thumbnail sd_setImageWithURL:[NSURL URLWithString:_str_userIcon] placeholderImage:IMG_PLACEHOLDER];
  
  NSString *_str_userName = _dic_userInfo[@"UserName"];
  if (!ISNULLObj(_str_userName)) {
    self.lb_username.text = [_str_userName isEmptyStr] ? @"---":_str_userName;
  }
  
  self.lb_date.text = _dataInfo[@"date"];
  self.lb_dateTime.text = _dataInfo[@"dateTime"];
  self.lb_location.text = _dataInfo[@"location"];
  self.lb_locationDetail.text = _dataInfo[@"locationDetail"];
  self.lb_content.attributedText = _dataInfo[@"content"];
}

- (void)buttonAction_Accepted:(UIButton *)_btn {
  [self.delegate didSelectedAcceptedWithButtonView:_btn];
}

- (void)buttonAction_gotoTrainerDetailInfo:(UIButton *)_btn {
  [self.delegate didSelectedUserIconWithButtonView:_btn];
}
@end

//
//  FGMyBookingPendingCellView.m
//  CSP
//
//  Created by JasonLu on 16/11/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGMyBookingPendingCellView.h"
#import "UIView+CornerRaduis.h"
@implementation FGMyBookingPendingCellView
@synthesize btn_contact;
@synthesize btn_cancel;

- (void)awakeFromNib {
  [super awakeFromNib];

  [commond useDefaultRatioToScaleView:self.btn_contact];
  [commond useDefaultRatioToScaleView:self.btn_cancel];
  
  [btn_contact setTitle:multiLanguage(@"CONTACT") forState:UIControlStateNormal];
  [btn_cancel setTitle:multiLanguage(@"CANCEL") forState:UIControlStateNormal];
  [self.btn_cancel setTitleColor:color_homepage_lightGray forState:UIControlStateNormal];
  
  
  [btn_contact setBackgroundColor:color_red_panel];
  [btn_contact makeWithCornerRadius:5.0];
  
  [self.btn_contact addTarget:self action:@selector(buttonAction_Contact:) forControlEvents:UIControlEventTouchUpInside];
  [self.btn_cancel addTarget:self action:@selector(buttonAction_Cancel:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)updateCellViewWithInfo:(id)_dataInfo {
  [super updateCellViewWithInfo:_dataInfo];
}

- (void)buttonAction_Contact:(UIButton *)_btn {
  [self.delegate didSelectedContactWithButtonView:_btn];
}

- (void)buttonAction_Cancel:(UIButton *)_btn {
  [self.delegate didSelectedCancelWithButtonView:_btn];
}
@end

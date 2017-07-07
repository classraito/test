//
//  FGTrainerBookingHistoryFirstCellView.m
//  CSP
//
//  Created by JasonLu on 16/12/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainerBookingHistoryFirstCellView.h"

@implementation FGTrainerBookingHistoryFirstCellView

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self.btn_contact setTitle:multiLanguage(@"CONTACT") forState:UIControlStateNormal];
  [self.btn_cancel setTitle:multiLanguage(@"CANCEL") forState:UIControlStateNormal];
  [self.btn_cancel setTitleColor:color_homepage_lightGray forState:UIControlStateNormal];
  self.btn_cancel.backgroundColor = [UIColor clearColor];

  [self.btn_contact addTarget:self action:@selector(buttonAction_Contact:) forControlEvents:UIControlEventTouchUpInside];
  [self.btn_cancel addTarget:self action:@selector(buttonAction_Cancel:) forControlEvents:UIControlEventTouchUpInside];
  
  
}

- (void)updateCellViewWithInfo:(id)_dataInfo {
  BOOL _bool_hidden = [_dataInfo[@"hidden"] boolValue];
  if (_bool_hidden) {
    self.hidden = YES;
    return;
  } else {
    self.hidden = NO;
  }
  
  [super updateCellViewWithInfo:_dataInfo];
  
  self.lb_date.textColor = color_red_panel;
  self.btn_contact.hidden = NO;
  self.btn_cancel.hidden = NO;
}

- (void)buttonAction_Contact:(UIButton *)_btn {
  [self.delegate didSelectedContactWithButtonView:_btn];
}

- (void)buttonAction_Cancel:(UIButton *)_btn {
  [self.delegate didSelectedCancelWithButtonView:_btn];
}

@end

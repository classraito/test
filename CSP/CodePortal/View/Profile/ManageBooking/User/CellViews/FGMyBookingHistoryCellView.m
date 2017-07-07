//
//  FGMyBookingHistoryCellView.m
//  CSP
//
//  Created by JasonLu on 16/11/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGMyBookingHistoryCellView.h"
#import "UIView+CornerRaduis.h"
@implementation FGMyBookingHistoryCellView

@synthesize btn_rebook;
- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self.btn_contact setTitle:multiLanguage(@"REBOOK") forState:UIControlStateNormal];
  [self.btn_cancel setTitle:multiLanguage(@"FEEDBACK") forState:UIControlStateNormal];
  [self.btn_cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

  [self.btn_cancel setBackgroundColor:color_red_panel];
  [self.btn_cancel makeWithCornerRadius:5.0];
  
  if ([commond isUser] == NO) {
    self.btn_contact.hidden = YES;
    self.btn_cancel.hidden = YES;
  }
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

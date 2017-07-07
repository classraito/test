//
//  FGMyBookingPendingFirstCellView.m
//  CSP
//
//  Created by JasonLu on 16/12/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGMyBookingPendingFirstCellView.h"

@implementation FGMyBookingPendingFirstCellView

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self.btn_contact addTarget:self action:@selector(buttonAction_Contact:) forControlEvents:UIControlEventTouchUpInside];
  [self.btn_cancel addTarget:self action:@selector(buttonAction_Cancel:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonAction_Contact:(UIButton *)_btn {
  [self.delegate didSelectedContactWithButtonView:_btn];
}

- (void)buttonAction_Cancel:(UIButton *)_btn {
  [self.delegate didSelectedCancelWithButtonView:_btn];
}


- (void)updateCellViewWithInfo:(id)_dataInfo {
  [super updateCellViewWithInfo:_dataInfo];
}
@end

//
//  FGMyBookingHistoryFirstCellView.m
//  CSP
//
//  Created by JasonLu on 16/12/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGMyBookingHistoryFirstCellView.h"

@implementation FGMyBookingHistoryFirstCellView

- (void)awakeFromNib {
  [super awakeFromNib];
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

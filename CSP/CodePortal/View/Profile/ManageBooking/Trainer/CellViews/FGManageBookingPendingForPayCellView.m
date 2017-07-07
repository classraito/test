//
//  FGManageBookingPendingForPayCellView.m
//  CSP
//
//  Created by JasonLu on 16/12/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGManageBookingPendingForPayCellView.h"
@implementation FGManageBookingPendingForPayCellView

@synthesize int_index;

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [commond useDefaultRatioToScaleView:self.lb_payDesc];
  [commond useDefaultRatioToScaleView:self.lb_timeCountForPay];
  
  self.lb_payDesc.font = font(FONT_TEXT_REGULAR, 15);
  self.lb_timeCountForPay.font = font(FONT_TEXT_REGULAR, 15);

  self.lb_payDesc.textColor = color_homepage_lightGray;
  self.lb_timeCountForPay.textColor = color_red_panel;
  self.lb_timeCountForPay.textAlignment = NSTextAlignmentCenter;
  
  self.lb_payDesc.text = multiLanguage(@"Remaining time");
  
  [self regiserNSNotificationCenter];
}

- (void)dealloc {
  [self removeNSNotificationCenter];
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

- (void)updateCellViewWithInfo:(NSDictionary *)_dataInfo {
  [super updateCellViewWithInfo:_dataInfo];
  
  self.int_index = [_dataInfo[@"index"] integerValue];
  NSTimeInterval _time_leftToPay = [_dataInfo[@"timeLeft"] doubleValue];
  NSDictionary *_dic_ = @{@"time":[NSNumber numberWithDouble:_time_leftToPay],
                          @"index":[NSNumber numberWithInteger:self.int_index]};
  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CELL_TIME object:_dic_];
}

- (void)regiserNSNotificationCenter {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_updateViewWithInfo:) name:NOTIFICATION_CELL_TIME object:nil];
}

- (void)removeNSNotificationCenter {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CELL_TIME object:nil];
}

- (void)notification_updateViewWithInfo:(id)sender {
  NSDictionary *_dic_ = (NSDictionary *)[sender object];
  NSTimeInterval _time_leftToPay = [_dic_[@"time"] doubleValue];
  NSInteger _int_index = [_dic_[@"index"] integerValue];
  
  if (self.int_index == _int_index) {
    self.lb_timeCountForPay.text = [FGUtils formatDayHourMinuteWithSecondTimeInterval:_time_leftToPay];
  }
}

//- (void)updateCellViewWithInfo:(NSDictionary *)_dataInfo atIndex:(NSInteger)index {
//  self.int_index = index;
//  [self updateCellViewWithInfo:_dataInfo];
//}
@end

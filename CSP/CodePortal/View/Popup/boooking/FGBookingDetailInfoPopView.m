//
//  FGBookingDetailInfoPopView.m
//  CSP
//
//  Created by JasonLu on 16/12/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBookingDetailInfoPopView.h"

@implementation FGBookingDetailInfoPopView
@synthesize lb_title;
@synthesize btn_cancel;
@synthesize view_whiteBG;
@synthesize view_blackBG;
-(void)awakeFromNib
{
  [super awakeFromNib];
  self.backgroundColor = [UIColor clearColor];
  [commond useDefaultRatioToScaleView:self.view_blackBG];
  [commond useDefaultRatioToScaleView:view_whiteBG];
  [commond useDefaultRatioToScaleView:self.lb_title];
  [commond useDefaultRatioToScaleView:self.btn_cancel];
  
  self.lb_title.textColor = color_homepage_lightGray;
  self.lb_title.font = font(FONT_TEXT_REGULAR, 15);
  self.lb_title.textAlignment = NSTextAlignmentCenter;
  self.view_bg.backgroundColor = rgba(255, 255, 255, 1.0);
}

- (void)setupBookingDetailWithInfo:(NSDictionary *)_dic_info {
  if (_dic_info == nil || ![_dic_info isKindOfClass:[NSDictionary class]])
    return;
  NSString *_str_msg = _dic_info[@"originContent"];
  if ([_str_msg hasPrefix:@"-"]) {
    _str_msg = @"";
  }
  
  NSString *_str_orderId = _dic_info[@"orderId"];
  if ([_str_orderId hasPrefix:@"G"]) {
    NSDictionary *_dic_orders = _dic_info[@"orderInfo"];
    NSArray *_arr_orders = _dic_orders[@"SubOrders"];
    
    NSMutableString *_mstr = [NSMutableString string];
    for (NSDictionary *_dic_subOrder in _arr_orders) {
      NSString *_str_bookingTime = _dic_subOrder[@"BookTime"];
      _str_bookingTime = [FGUtils dateSpecificTimeWithTimeIntervalSecondStr:_str_bookingTime withFormat:@"yyyy-MM-dd h:mm a"];
      
      NSArray *_arr_bookingTime = [_str_bookingTime componentsSeparatedByString:@" "];
      NSString *_str_bookingTime_Detail = [NSString stringWithFormat:@"%@: %@ %@",multiLanguage(@"Time"),_arr_bookingTime[1], _arr_bookingTime[2]];
      NSString *_str_bookingTime_Date = [NSString stringWithFormat:@"%@: %@",multiLanguage(@"Date"), _arr_bookingTime[0]];
      
      [_mstr appendString:[NSString stringWithFormat:@"%@\n%@\n", _str_bookingTime_Date,_str_bookingTime_Detail]];
      
    }
    
    NSString *_str_content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",
                              _mstr,
                              _dic_info[@"location"],
                              _dic_info[@"locationDetail"],
                              _str_msg];
    self.lb_title.text = _str_content;
  }
  else {
    NSString *_str_content = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",
                              _dic_info[@"date"],
                              _dic_info[@"dateTime"],
                              _dic_info[@"location"],
                              _dic_info[@"locationDetail"],
                              _str_msg];
    self.lb_title.text = _str_content;
  }
  
  NSLog(@"_dic_info=%@", _dic_info);
}
@end

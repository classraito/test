//
//  FGWorkoutLogDetailCellView.m
//  CSP
//
//  Created by JasonLu on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGWorkoutLogDetailCellView.h"

@implementation FGWorkoutLogDetailCellView
@synthesize lb_title;
@synthesize lb_detail;
@synthesize view_separator;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  [commond useDefaultRatioToScaleView:self.lb_title];
  [commond useDefaultRatioToScaleView:self.lb_detail];
  [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, .5) toScaleView:view_separator];
  
  self.lb_title.textColor = color_homepage_black;
  self.lb_title.font = font(FONT_TEXT_REGULAR, 18);
  
  self.lb_detail.textColor = color_homepage_lightGray;
  self.lb_detail.font = font(FONT_TEXT_REGULAR, 16);
}

#pragma mark - 成员方法
- (void)updateCellViewWithInfo:(id)_dataInfo {
  if (_dataInfo == nil)
    return;
  
  NSString *_str_title = _dataInfo[@"title"];
  self.lb_title.text = _str_title;
  
  NSString *_str_time = _dataInfo[@"time"];
  
  NSString *_str_detail = [NSString stringWithFormat:@"%@   %@", [FGUtils formatDayHourMinuteWithSecondTimeInterval:[_str_time doubleValue]], _dataInfo[@"caloria"]];
  self.lb_detail.text = _str_detail;
  
  BOOL _bool_hiddenSeparator = [_dataInfo[@"hiddenSeparator"] boolValue];
  self.view_separator.hidden = _bool_hiddenSeparator;
  
}


@end

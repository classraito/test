//
//  FGWorkoutLogTitleCellView.m
//  CSP
//
//  Created by JasonLu on 16/12/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGWorkoutLogTitleCellView.h"

@implementation FGWorkoutLogTitleCellView

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  [self internalInitalWorkoutLogTitleView];
  [self updateLabelStatusWithHidden:YES];
}

- (void)internalInitalWorkoutLogTitleView {
  [commond useDefaultRatioToScaleView:self.lb_workout];
  [commond useDefaultRatioToScaleView:self.lb_hour];
  [commond useDefaultRatioToScaleView:self.lb_caloria];
  
  [self updateCellViewWithInfo:@{@"workout":@"-",@"minute":@"-",@"caloria":@"-"}];

}

- (void)updateCellViewWithInfo:(id)_dataInfo{
  if (_dataInfo == nil)
    return;
  
  [self updateLabelStatusWithHidden:NO];

  NSString *_str_workout = [NSString stringWithFormat:@"%@",_dataInfo[@"workout"]];
  NSArray *_arr_info = @[
                         [FGUtils createAttributeTextInfo:_str_workout font:font(FONT_TEXT_REGULAR, 20) color:color_workoutlog_darkGreen paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"  "],
                         [FGUtils createAttributeTextInfo:multiLanguage(@"WORKOUT") font:font(FONT_TEXT_REGULAR, 18) color:color_homepage_lightGray paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"\n"],
                         ];
  NSMutableAttributedString *mattr_str = [FGUtils createAttributedStringWithContentInfo:_arr_info];
  self.lb_workout.attributedText = mattr_str;
  
  NSString *_str_minute = [NSString stringWithFormat:@"%@",_dataInfo[@"minute"]];
  if (![_str_minute isEqualToString:@"-"]) {
    NSInteger hours;
    NSInteger minutes;
    [FGUtils calculateHourMinuteWithSecondTimeInterval:[_str_minute doubleValue] withHours:&hours withMinutes:&minutes withSeconds:nil];
    
    _str_minute = [NSString stringWithFormat:@"%ld", ((hours * 60) + minutes)];
  }
  
  
  _arr_info = @[
                [FGUtils createAttributeTextInfo:_str_minute font:font(FONT_TEXT_REGULAR, 18) color:color_workoutlog_darkGreen paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"  "],
                [FGUtils createAttributeTextInfo:multiLanguage(@"MINUTES") font:font(FONT_TEXT_REGULAR, 16) color:color_homepage_lightGray paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"\n"],
                ];
  mattr_str = [FGUtils createAttributedStringWithContentInfo:_arr_info];
  self.lb_hour.attributedText = mattr_str;
  
  NSString *_str_caloria = [NSString stringWithFormat:@"%@",_dataInfo[@"caloria"]];
  _arr_info = @[
                [FGUtils createAttributeTextInfo:_str_caloria font:font(FONT_TEXT_REGULAR, 18) color:color_workoutlog_darkGreen paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"  "],
                [FGUtils createAttributeTextInfo:multiLanguage(@"CALORIA") font:font(FONT_TEXT_REGULAR, 16) color:color_homepage_lightGray paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"\n"],
                ];
  mattr_str = [FGUtils createAttributedStringWithContentInfo:_arr_info];
  self.lb_caloria.attributedText = mattr_str;
}

- (void)updateLabelStatusWithHidden:(BOOL)isHidden {
  self.lb_workout.hidden = isHidden;
  self.lb_hour.hidden = isHidden;
  self.lb_caloria.hidden = isHidden;
}
@end

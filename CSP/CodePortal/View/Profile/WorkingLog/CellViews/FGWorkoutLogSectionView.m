//
//  FGWorkoutLogSectionView.m
//  CSP
//
//  Created by JasonLu on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGWorkoutLogSectionView.h"
#import "NSDate+Utils.h"
#import "NSDate+CL.h"
#import "DateTools.h"
@implementation FGWorkoutLogSectionView
@synthesize lb_date;
@synthesize lb_time;
@synthesize lb_caloria;
@synthesize iv_fireEmpty;
@synthesize iv_time;
#pragma mark - 生命周期
-(void)awakeFromNib
{
  [super awakeFromNib];
  
  self.backgroundColor = [UIColor whiteColor];
  
  [commond useDefaultRatioToScaleView:self.lb_date];
  [commond useDefaultRatioToScaleView:self.lb_time];
  [commond useDefaultRatioToScaleView:self.lb_caloria];
  [commond useDefaultRatioToScaleView:self.iv_time];
  [commond useDefaultRatioToScaleView:self.iv_fireEmpty];
  
  lb_date.font = font(FONT_TEXT_REGULAR, 15);
  lb_time.font = font(FONT_TEXT_REGULAR, 15);
  lb_caloria.font = font(FONT_TEXT_REGULAR, 15);
}

-(void)dealloc
{
  NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

#pragma mark - 成员方法
- (void)updateSectionViewWithInfo:(id)_dataInfo {
  
  NSLog(@"self.iv_time==%@", self.iv_time);
  
  if (_dataInfo == nil)
    return;
  NSString *_str_date = _dataInfo[@"date"];
  _str_date = [FGUtils dateSpecificTimeWithTimeIntervalSecondStr:_str_date withFormat:@"MM/dd"];
  self.lb_date.text = _str_date;
  
  NSString *_str_time = [FGUtils formatDayHourMinuteWithSecondTimeInterval:[_dataInfo[@"time"] doubleValue]];
  self.lb_time.text = _str_time;//_dataInfo[@"time"];
  self.lb_caloria.text = _dataInfo[@"caloria"];
  
//  [self.lb_caloria sizeToFit];
//  [self.lb_time sizeToFit];
  
//  self.lb_time.backgroundColor = [UIColor blueColor];
//  self.lb_caloria.backgroundColor = [UIColor blueColor];

}
@end

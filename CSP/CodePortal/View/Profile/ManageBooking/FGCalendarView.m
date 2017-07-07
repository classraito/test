//
//  FGCalendarView.m
//  CSP
//
//  Created by JasonLu on 16/11/10.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCalendarView.h"

@implementation FGCalendarView
@synthesize view_calendar;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  
  //  [commond useDefaultRatioToScaleView:self.tb_booking];
  //  [commond useDefaultRatioToScaleView:self.view_calendar];
  
  //  [self internalInitalTitleSectionView];
//  [self internalInitalView];
  //  [self bindDataToUI];
}

- (void)internalInitalView {
}

- (void)dealloc {
  self.view_calendar       = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - CLWeeklyCalendarViewDelegate
-(NSDictionary *)CLCalendarBehaviorAttributes
{
  return @{
           CLCalendarWeekStartDay : @0,                 //Start Day of the week, from 1-7 Mon-Sun -- default 1
           //             CLCalendarDayTitleTextColor : [UIColor yellowColor],
           //             CLCalendarSelectedDatePrintColor : [UIColor greenColor],
           };
}



-(void)dailyCalendarViewDidSelect:(NSDate *)date isDoubleTap:(BOOL)_isDoubleTap
{
  //You can do any logic after the view select the date
}
@end

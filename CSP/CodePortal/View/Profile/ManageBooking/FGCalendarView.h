//
//  FGCalendarView.h
//  CSP
//
//  Created by JasonLu on 16/11/10.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CLWeeklyCalendarView.h"

static CGFloat CALENDER_VIEW_HEIGHT = 100.f;

@interface FGCalendarView : UIView <CLWeeklyCalendarViewDelegate>
@property (nonatomic, strong) CLWeeklyCalendarView* view_calendar;
@end

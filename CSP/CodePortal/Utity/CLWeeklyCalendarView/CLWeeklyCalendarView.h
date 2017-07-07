//
//  CLWeeklyCalendarView.h
//  Deputy
//
//  Created by Caesar on 30/10/2014.
//  Copyright (c) 2014 Caesar Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLWeeklyCalendarViewDelegate <NSObject>

// Keys for customize the calendar behavior
extern NSString *const CLCalendarWeekStartDay;    //The Day of weekStart from 1 - 7 - Default: 1
extern NSString *const CLCalendarDayTitleTextColor; //Day Title text color,  Mon, Tue, etc label text color
extern NSString *const CLCalendarSelectedDatePrintFormat;   //Selected Date print format,  - Default: @"EEE, d MMM yyyy"
extern NSString *const CLCalendarSelectedDatePrintColor;    //Selected Date print text color -Default: [UIColor whiteColor]
extern NSString *const CLCalendarSelectedDatePrintFontSize; //Selected Date print font size - Default : 13.f
extern NSString *const CLCalendarBackgroundImageColor;      //BackgroundImage color - Default : see applyCustomDefaults.

-(NSDictionary *)CLCalendarBehaviorAttributes;       //Optional Function, Set the calendar behavior attributes by using above keys

-(void)dailyCalendarViewDidSelect: (NSDate *)date isDoubleTap:(BOOL)_isDoubleTap;
-(void)dailyCalendarViewSwipSelectWithStartDate: (NSDate *)_dt_start toEndDate:(NSDate *)_dt_end;

@end


@interface CLWeeklyCalendarView : UIView

@property (nonatomic, weak) id<CLWeeklyCalendarViewDelegate> delegate;
@property (nonatomic, assign) NSInteger int_capabilityDays;

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDate *currentServerDate;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) NSMutableArray *marr_specialDate;


- (void)redrawToDate: (NSDate *)dt;

-(void)updateWeatherIconByKey: (NSString *)key;

- (void)setupCalendarWithDate:(NSDate *)date;

-(void)markDateSelected:(NSDate *)date;

- (void)refreshWeeklyViewAfterSwipeWithStartDate:(NSDate *)_dt_start;

- (NSDate *)getStartWeekDateWithDate:(NSDate *)_dt;
@end

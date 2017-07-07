//
//  FGTrainerMyCalendarView.h
//  CSP
//
//  Created by JasonLu on 16/11/10.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGCalendarView.h"
#import "FGCalendarDetailInfoCellView.h"

@protocol FGTrainerMyCalendarViewDelegate <NSObject>

@optional
- (void)didClickForUserRebookCourseWithTrainerId:(NSString *)_str_trainerId withDate:(NSString *)_str_date andScheduleTime:(NSString *)_str_scheduleTime;

@end


@interface FGTrainerMyCalendarView : FGCalendarView <UITableViewDelegate, UITableViewDataSource, FGCalendarDetailInfoCellViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tb_timeline;
@property (nonatomic, strong) NSMutableArray *marr_data;
@property (nonatomic, strong) NSMutableArray *marr_updateSchedule;
@property (nonatomic, strong) NSMutableDictionary *mdic_localDataSourceForSchedule;
@property (nonatomic, strong) NSMutableDictionary *mdic_scheduleDataForWeek;
@property (nonatomic, strong) NSMutableDictionary *mdic_detailOrder;

@property (nonatomic, strong) NSMutableArray *marr_willUpateSchedule;

@property (nonatomic, strong) NSDate *dt_displayStartDate;
@property (nonatomic, strong) NSDate *dt_displayEndDate;

@property (nonatomic, assign) NSInteger int_orderIndex;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, copy) NSString *str_id;

@property (nonatomic, assign) id<FGTrainerMyCalendarViewDelegate>delegate;

- (void)updateCalendarView;
#pragma mark - 更新日历信息
- (void)runRequest_updateCalendar;
#pragma mark - 请求日历数据
- (void)runRequest_trainerCalendar;
- (void)runRequest_trainerCalendarWithStartDate:(NSDate *)_dt_startDate toEndDate:(NSDate *)_dt_endDate;
- (void)loadMore_trainerCalendar;
#pragma mark - 刷新数据
- (void)bindDataToUI;
- (void)loadMore_bindDataToUI;

- (void)bindDataToUIForUpdateCalendar;
- (void)bindDataToUIForSuccessCancelOrderToUpdateCalendar;
@end

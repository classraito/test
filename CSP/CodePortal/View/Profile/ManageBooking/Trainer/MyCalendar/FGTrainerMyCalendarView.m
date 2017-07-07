//
//  FGTrainerMyCalendarView.m
//  CSP
//
//  Created by JasonLu on 16/11/10.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "FGBookingHistoryViewController.h"
#import "FGTrainerMyCalendarView.h"
#import "UIScrollView+FGRereshHeader.h"
#import "NSDate+Utils.h"
#import "NSDate+CL.h"
@implementation FGTrainerMyCalendarView
@synthesize marr_data;
@synthesize marr_updateSchedule;
@synthesize marr_willUpateSchedule;
@synthesize mdic_scheduleDataForWeek;
@synthesize mdic_localDataSourceForSchedule;
@synthesize mdic_detailOrder;
@synthesize int_orderIndex;

@synthesize dt_displayStartDate;
@synthesize dt_displayEndDate;

@synthesize tb_timeline;
@synthesize isEditing;
@synthesize str_id;

@synthesize delegate;

#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  
  self.marr_data = [NSMutableArray array];
  self.marr_willUpateSchedule = [NSMutableArray array];
  self.marr_updateSchedule = [NSMutableArray array];
  self.mdic_localDataSourceForSchedule = [NSMutableDictionary  dictionary];
  self.mdic_scheduleDataForWeek = [NSMutableDictionary  dictionary];

  [self internalInitalView];
  // 添加notification
  [self internalNotification];
}

- (void)internalInitalView {
  [commond useDefaultRatioToScaleView:self.tb_timeline];

  self.tb_timeline.delegate = self;
  self.tb_timeline.dataSource = self;
  
  if(self.view_calendar == nil){
    self.view_calendar = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, CALENDER_VIEW_HEIGHT)];
    self.view_calendar.delegate = self;
    self.view_calendar.int_capabilityDays = [commond isUser] ? 30 : 90;
    
    [commond useDefaultRatioToScaleView:self.view_calendar];
    [self.view_calendar setupCalendarWithDate:[NSDate date]];
  }
  [self addSubview:self.view_calendar];
}

- (void)dealloc {
  self.marr_data = nil;
  self.marr_updateSchedule = nil;
  self.marr_willUpateSchedule = nil;
  self.mdic_scheduleDataForWeek = nil;
  self.mdic_localDataSourceForSchedule = nil;
  self.tb_timeline = nil;
  self.str_id = nil;
  
  [self clearNotification];
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

- (void)internalNotification {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_refreshAfterCancelOrder:) name:NOTIFICATION_UPDATECALENDARFROMDETAIL object:nil];
}

- (void)clearNotification {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UPDATECALENDARFROMDETAIL object:nil];
}

#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  //  NSDictionary *dic_info = [self.arr_data objectAtIndex:indexPath.row];
  //  NSMutableAttributedString *mattr_str = dic_info[@"content"];
  //  lb_tmp.attributedText = mattr_str;
  //  CGRect rect_mattrStr = [FGUtils calculatorAttributeString:mattr_str withWidth:200 * ratioW];
  //  CGFloat cellHeight = rect_mattrStr.size.height;
  
  return 45*ratioH;
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.marr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  FGCalendarDetailInfoCellView *cell = nil;
  
  cell = (FGCalendarDetailInfoCellView *)[self calendarDetailInfoViewCell:tableView];
  
  if ([cell respondsToSelector:@selector(updateCellViewWithInfo:isEditing:hiddenSepeator:)]) {
    [cell updateCellViewWithInfo:self.marr_data[indexPath.row] isEditing:self.isEditing hiddenSepeator:(indexPath.row == 0 ? YES : NO)];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
  if ([commond isUser]) {
    NSLog(@"trainer id:%@", str_id);
    NSDictionary *_dic_cellInfo = self.marr_data[indexPath.row];
    NSLog(@"cellInfo==%@", _dic_cellInfo);
  }
}

#pragma mark - 自定义cell
- (UITableViewCell *)calendarDetailInfoViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGCalendarDetailInfoCellView";
  FGCalendarDetailInfoCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGCalendarDetailInfoCellView" owner:self options:nil] lastObject];
  }
  
  cell.delegate = self;
  return cell;
}

#pragma mark - 成员方法
- (void)bindData {
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_CalendarList)];
  
  NSArray *_arr_schedule = _dic_info[@"Schedule"];
  NSString *_str_date = _dic_info[@"startDate"];
  
  NSArray *_arr_tmp = [self getSchedulesDataInDateString:_str_date];
  if (_arr_tmp)
    self.marr_data = [self getSchedulesFromList:_arr_tmp onDate:self.dt_displayStartDate];
  else
    self.marr_data = [self getSchedulesFromList:_arr_schedule onDate:self.dt_displayStartDate];
  
  //  计算当前日期的训练课程
//  self.marr_data = [self getSchedulesFromList: onDate:self.dt_displayStartDate];
  
  NSArray *_arr = [NSArray arrayWithArray:self.marr_data];
  
  [self.mdic_localDataSourceForSchedule setValue:_arr forKey:[self.dt_displayStartDate dateFormatStringYYYYMMDD]];
  [self.mdic_scheduleDataForWeek setValue:_arr_schedule forKey:[self.dt_displayStartDate dateFormatStringYYYYMMDD]];
}

- (void)bindMoreData {
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_CalendarList)];
  NSArray *_arr_schedule = _dic_info[@"Schedule"];
  NSString *_str_date = _dic_info[@"startDate"];
  
  NSArray *_arr_tmp = [self getSchedulesDataInDateString:_str_date];
  NSMutableArray *_marr_tmp;
  if (_arr_tmp)
    _marr_tmp = [self getSchedulesFromList:_arr_tmp onDate:self.dt_displayStartDate];
  else
    _marr_tmp = [self getSchedulesFromList:_arr_schedule onDate:self.dt_displayStartDate];
  
  NSArray *_arr = [NSArray arrayWithArray:_marr_tmp];
  
  [self.mdic_localDataSourceForSchedule setValue:_arr forKey:[self.dt_displayStartDate dateFormatStringYYYYMMDD]];
  [self.mdic_scheduleDataForWeek setValue:_arr_schedule forKey:[self.dt_displayStartDate dateFormatStringYYYYMMDD]];
}

- (void)bindDataToUI {
  [self bindData];
  [self refreshTableView];
  [self refreshCalendarViewForStatusWithSwip:NO];
}

- (void)loadMore_bindDataToUI {
  [self bindMoreData];
  [self refreshCalendarViewForStatusWithSwip:YES];
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView.contentOffset.y < 0) {
    scrollView.contentOffset = CGPointZero;
  }
}

#pragma mark - 请求日历数据
- (void)runRequest_trainerCalendar {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"trainerCalendarList" forKey:@"trainerCalendarList"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  
  NSDate *_dt_weekStart = [self.view_calendar.currentServerDate getWeekStartDate:0];
  NSDate *_dt_weekValidStart;
  NSDate *_dt_weekEnd;
  int i = 0;
  for(; i < 7; i++){
    NSDate *_dt = [_dt_weekStart addDays:i];
    if ([self.view_calendar.currentServerDate isSameDay:_dt]) {
      break;
    }
  }
  _dt_weekEnd   = [self.view_calendar.currentServerDate addDays:7-(i+1)];
  _dt_weekValidStart = self.view_calendar.currentServerDate;
  
  [_dic_info setObject:[_dt_weekStart dateFormatStringYYYYMMDD] forKey:@"startDate"];
  [_dic_info setObject:[_dt_weekEnd dateFormatStringYYYYMMDD] forKey:@"endDate"];
  
  //请求服务器数据
  self.dt_displayStartDate = _dt_weekStart;
  self.dt_displayEndDate   = _dt_weekEnd;
  NSLog(@"days==%ld", (long)[self.dt_displayEndDate daysLaterThan:self.dt_displayStartDate]);
  NSTimeInterval _time_start = [FGUtils formatTimeIntervalFromDate:_dt_weekValidStart];
  NSTimeInterval _time_end   = [FGUtils formatTimeIntervalFromDate:_dt_weekEnd];
  //从当天开始
  [[NetworkManager_Location sharedManager] postRequest_Locations_calendarList:_time_start endTime:_time_end trainerId:self.str_id userinfo:_dic_info];
}

#pragma mark - 请求日历数据
- (void)runRequest_trainerCalendarWithStartDate:(NSDate *)_dt_startDate toEndDate:(NSDate *)_dt_endDate {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"trainerCalendarList" forKey:@"trainerCalendarList"];
  [_dic_info setObject:@"trainerCalendarList_loadMore" forKey:@"trainerCalendarList_loadMore"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [_dic_info setObject:[_dt_startDate dateFormatStringYYYYMMDD] forKey:@"startDate"];
  [_dic_info setObject:[_dt_endDate dateFormatStringYYYYMMDD] forKey:@"endDate"];

  NSDate *_dt_weekStart;
  NSDate *_dt_weekEnd;
  _dt_weekEnd   = _dt_endDate;
  _dt_weekStart = _dt_startDate;
  
  NSTimeInterval _time_start = [FGUtils formatTimeIntervalFromDate:_dt_weekStart];
  NSTimeInterval _time_end   = [FGUtils formatTimeIntervalFromDate:_dt_weekEnd];
  //从当天开始
  [[NetworkManager_Location sharedManager] postRequest_Locations_calendarList:_time_start endTime:_time_end trainerId:self.str_id userinfo:_dic_info];
}


#pragma mark - 更新日历数据
- (void)runRequest_updateCalendar {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"trainerUpdateCalendar" forKey:@"trainerUpdateCalendar"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  
  if (self.marr_willUpateSchedule.count <= 0) {
    //提交成功需要更新列表状态
//    self.marr_data = [self getSchedulesFromList:self.marr_allScheduleData onDate:self.view_calendar.selectedDate];
    [self.tb_timeline reloadData];
//    [self refreshCalendarViewForStatus];
    return;
  }
  
  NSMutableArray *_marr = [NSMutableArray array];
  [self.marr_willUpateSchedule enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSDictionary *_dic = (NSDictionary *)obj;
    NSString *_str_scheduleTime = _dic[@"scheduleTime"];
    NSDate *_dt = [commond dateFromString:_str_scheduleTime formatter:@"yyyy-MM-dd HH:mm"];
    NSTimeInterval _time = [FGUtils formatTimeIntervalFromDate:_dt];
    NSInteger int_status = [_dic[@"status"] integerValue];
    [_marr addObject:@{@"Time":[NSNumber numberWithDouble:_time],
                       @"Type":[NSNumber numberWithInteger:int_status]}];
  }];
  
  [[NetworkManager_Location sharedManager] postRequest_Locations_setCalendar:_marr userinfo:_dic_info];
}

- (void)runRequest_updateCalendarForCancelOrder {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"trainerSuccesscancelOrderToUpdateCalendar" forKey:@"trainerSuccesscancelOrderToUpdateCalendar"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  
  NSMutableArray *_marr_tmp = [NSMutableArray arrayWithArray:self.marr_data];
  NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:self.marr_willUpateSchedule[0]];
  [_mdic setValue:[NSNumber numberWithInteger:1] forKey:@"status"];
  _marr_tmp = [self updateCalendarStatusWithInfo:_mdic inArr:_marr_tmp atIndex:self.int_orderIndex];
  self.marr_data = [NSMutableArray arrayWithArray:_marr_tmp];
  
  NSMutableArray *_marr = [NSMutableArray array];
  [self.marr_willUpateSchedule enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSDictionary *_dic = (NSDictionary *)obj;
    NSString *_str_scheduleTime = _dic[@"scheduleTime"];
    NSDate *_dt = [commond dateFromString:_str_scheduleTime formatter:@"yyyy-MM-dd HH:mm"];
    NSTimeInterval _time = [FGUtils formatTimeIntervalFromDate:_dt];
    NSInteger int_status = [_dic[@"status"] integerValue];
    [_marr addObject:@{@"Time":[NSNumber numberWithDouble:_time],
                       @"Type":[NSNumber numberWithInteger:int_status]}];
  }];
  
  [[NetworkManager_Location sharedManager] postRequest_Locations_setCalendar:_marr userinfo:_dic_info];
}

#pragma mark - 更新日历更新后的界面
- (void)bindDataToUIForUpdateCalendar {
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_SetCalendar)];
  
  NSInteger _int_ret = [_dic_info[@"Code"] integerValue];
  if (_int_ret == 0) {
//    //提交成功需要更新列表状态
//    NSDate *_dt_weekStart = [self.view_calendar getStartWeekDateWithDate:self.view_calendar.selectedDate];
//    NSArray *_arr = [self getSchedulesDataInDateString:[_dt_weekStart dateFormatStringYYYYMMDD]];
//    
//    NSMutableArray *_marr_tmp = [self getSchedulesFromList:_arr onDate:self.view_calendar.selectedDate];
//    self.marr_data = _marr_tmp;
    
    [self.tb_timeline reloadData];
    //需要刷新daily view
    [self refreshCalendarViewForStatusWithSwip:YES];
    
//    [self.marr_willUpateSchedule removeAllObjects];
    return;
  }
}

#pragma mark - 订单取消后返回日历界面
- (void)bindDataToUIForSuccessCancelOrderToUpdateCalendar {
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_SetCalendar)];
  
  NSInteger _int_ret = [_dic_info[@"Code"] integerValue];
  if (_int_ret == 0) {
    
    
//    [self.tb_timeline reloadData];
//    //需要刷新daily view
//    [self refreshCalendarViewForStatusWithSwip:YES];
//    
//    NSMutableArray *_marr_tmp = [NSMutableArray arrayWithArray:self.marr_data];
//    NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:self.marr_willUpateSchedule[0]];
//    [_mdic setValue:[NSNumber numberWithInteger:1] forKey:@"status"];
//    _marr_tmp = [self updateCalendarStatusWithInfo:_mdic inArr:_marr_tmp atIndex:self.int_orderIndex];
//    self.marr_data = [NSMutableArray arrayWithArray:_marr_tmp];
    
//    [_marr_tmp replaceObjectAtIndex:self.int_orderIndex withObject:_dic];
//    self.marr_data = [NSMutableArray arrayWithArray:_marr_tmp];
//    marr_tmp = [self updateCalendarStatusWithInfo:mdic_info inArr:marr_tmp atIndex:indexPath.row];
    
    NSIndexPath *_indexPath = [NSIndexPath indexPathForRow:self.int_orderIndex inSection:0];
    [self.tb_timeline reloadRowsAtIndexPaths:[NSArray arrayWithObjects:_indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
//    [self.tb_timeline reloadData];
    //需要刷新daily view
    [self refreshCalendarViewForStatusWithSwip:YES];
    
//    [self.marr_willUpateSchedule removeAllObjects];
    return;
  }
}




#pragma mark - 计算选择日期的行程表
- (NSMutableArray *)getSchedulesFromList:(NSArray *)_arr_schedules onDate:(NSDate *)_dt {

  NSString *_str_date = [_dt dateFormatStringYYYYMMDD];
  NSDate *_dt_now = [NSDate date];
  //当前时间往后推一个小时
  NSDate *_dt_new = [_dt_now dateByAddingHours:1];
  
//  [_dt_new isLaterThan:[NSDate dateWithString:[NSString stringWithFormat:@"%@ 06:00",_str_date] formatString:@"yyyy-MM-dd HH:mm"]]
  NSArray *_arr_default = @[
    @{@"scheduleTime":[NSString stringWithFormat:@"%@ 06:00",_str_date],
      @"time":@"06:00-07:00",
      @"status":@0,
      @"session":@"",
      @"detail":@{},
      @"isPastTime":[NSNumber numberWithBool:[_dt_new isLaterThan:[NSDate dateWithString:[NSString stringWithFormat:@"%@ 06:00",_str_date] formatString:@"yyyy-MM-dd HH:mm"]]]},
    @{@"scheduleTime":[NSString stringWithFormat:@"%@ 07:30",_str_date],
      @"time":@"07:30-08:30",
      @"status":@0,
      @"session":@"",
      @"detail":@{},
      @"isPastTime":[NSNumber numberWithBool:[_dt_new isLaterThan:[NSDate dateWithString:[NSString stringWithFormat:@"%@ 07:30",_str_date] formatString:@"yyyy-MM-dd HH:mm"]]]},
    @{@"scheduleTime":[NSString stringWithFormat:@"%@ 09:00",_str_date],
      @"time":@"09:00-10:00",
      @"status":@0,
      @"session":@"",
      @"detail":@{},
      @"isPastTime":[NSNumber numberWithBool:[_dt_new isLaterThan:[NSDate dateWithString:[NSString stringWithFormat:@"%@ 09:00",_str_date] formatString:@"yyyy-MM-dd HH:mm"]]]},
    @{@"scheduleTime":[NSString stringWithFormat:@"%@ 10:30",_str_date],
      @"time":@"10:30-11:30",
      @"status":@0,
      @"session":@"",
      @"detail":@{},
      @"isPastTime":[NSNumber numberWithBool:[_dt_new isLaterThan:[NSDate dateWithString:[NSString stringWithFormat:@"%@ 10:30",_str_date] formatString:@"yyyy-MM-dd HH:mm"]]]},
    @{@"scheduleTime":[NSString stringWithFormat:@"%@ 12:00",_str_date],
      @"time":@"12:00-13:00",
      @"status":@0,
      @"session":@"",
      @"detail":@{},
      @"isPastTime":[NSNumber numberWithBool:[_dt_new isLaterThan:[NSDate dateWithString:[NSString stringWithFormat:@"%@ 12:00",_str_date] formatString:@"yyyy-MM-dd HH:mm"]]]},
    @{@"scheduleTime":[NSString stringWithFormat:@"%@ 13:30",_str_date],
      @"time":@"13:30-14:30",
      @"status":@0,
      @"session":@"",
      @"detail":@{},
      @"isPastTime":[NSNumber numberWithBool:[_dt_new isLaterThan:[NSDate dateWithString:[NSString stringWithFormat:@"%@ 13:30",_str_date] formatString:@"yyyy-MM-dd HH:mm"]]]},
    @{@"scheduleTime":[NSString stringWithFormat:@"%@ 15:00",_str_date],
      @"time":@"15:00-16:00",
      @"status":@0,
      @"session":@"",
      @"detail":@{},
      @"isPastTime":[NSNumber numberWithBool:[_dt_new isLaterThan:[NSDate dateWithString:[NSString stringWithFormat:@"%@ 15:00",_str_date] formatString:@"yyyy-MM-dd HH:mm"]]]},
    @{@"scheduleTime":[NSString stringWithFormat:@"%@ 16:30",_str_date],
      @"time":@"16:30-17:30",
      @"status":@0,
      @"session":@"",
      @"detail":@{},
      @"isPastTime":[NSNumber numberWithBool:[_dt_new isLaterThan:[NSDate dateWithString:[NSString stringWithFormat:@"%@ 16:30",_str_date] formatString:@"yyyy-MM-dd HH:mm"]]]},
    @{@"scheduleTime":[NSString stringWithFormat:@"%@ 18:00",_str_date],
      @"time":@"18:00-19:00",
      @"status":@0,
      @"session":@"",
      @"detail":@{},
      @"isPastTime":[NSNumber numberWithBool:[_dt_new isLaterThan:[NSDate dateWithString:[NSString stringWithFormat:@"%@ 18:00",_str_date] formatString:@"yyyy-MM-dd HH:mm"]]]},
    @{@"scheduleTime":[NSString stringWithFormat:@"%@ 19:30",_str_date],
      @"time":@"19:30-20:30",
      @"status":@0,
      @"session":@"",
      @"detail":@{},
      @"isPastTime":[NSNumber numberWithBool:[_dt_new isLaterThan:[NSDate dateWithString:[NSString stringWithFormat:@"%@ 19:30",_str_date] formatString:@"yyyy-MM-dd HH:mm"]]]},
    @{@"scheduleTime":[NSString stringWithFormat:@"%@ 21:00",_str_date],
      @"time":@"21:00-22:00",
      @"status":@0,
      @"session":@"",
      @"detail":@{},
      @"isPastTime":[NSNumber numberWithBool:[_dt_new isLaterThan:[NSDate dateWithString:[NSString stringWithFormat:@"%@ 21:00",_str_date] formatString:@"yyyy-MM-dd HH:mm"]]]}
    ];
  
  
  
  NSMutableArray *_marr_ret = [NSMutableArray arrayWithArray:_arr_default];
  [_arr_schedules enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSDictionary *_dic_scheduleDetail = (NSDictionary *)obj;
    NSString *_str_scheduleTime = [FGUtils dateSpecificTimeWithTimeInterval:[_dic_scheduleDetail[@"Time"] doubleValue] withFormat:@"yyyy-MM-dd HH:mm"];
    
    if ([_str_scheduleTime hasPrefix:_str_date]) {
      NSString *_str_sessionTime = [FGUtils formatScheduleSpecificTimeDurationWithStartTime:_str_scheduleTime];
      ;
      [_marr_ret enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *_dic_tmp = (NSDictionary *)obj;
        
        if ([_str_sessionTime isEqualToString:_dic_tmp[@"time"]]) {
          NSInteger _int_type = [_dic_scheduleDetail[@"Type"] integerValue];
          NSString *_str_orderId = [NSString stringWithFormat:@"%@", _dic_scheduleDetail[@"OrderId"]];
          
          NSDictionary *_dic_ret = @{
                                     @"scheduleTime":_dic_tmp[@"scheduleTime"],
                                     @"time":_str_sessionTime,
                                     @"status":[NSNumber numberWithInteger:_int_type],
                                     @"session":_int_type == 2? multiLanguage(@"TRAINING SESSION"):@"",
                                     @"detail":@{@"id":ISNULLObj(_str_orderId)?@"":_str_orderId},
                                     @"isPastTime": @NO};
          [_marr_ret replaceObjectAtIndex:idx withObject:_dic_ret];
          *stop = YES;
        }
      }];
    }
  }];
  
  //计算schedule时间是否已经过期了
//  [[NSDate date] formattedDateWithFormat:<#(NSString *)#>]
  NSString *_str_selectDate_YYYYMMdd = [self.view_calendar.currentServerDate dateFormatStringYYYYMMDD];
  [_marr_ret enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSDictionary *_dic_tmp = (NSDictionary *)obj;
//    NSArray *_arr_tmp = [_dic_tmp[@"time"] componentsSeparatedByString:@"-"];
//    NSString *_str_date = [NSString stringWithFormat:@"%@ %@",_str_selectDate_YYYYMMdd, _arr_tmp[0]];
//    NSDate *_dt_schedule = [NSDate dateWithString:_str_date formatString:@"yyyy-MM-dd HH:mm"];
//    BOOL isPastTime = YES;
//    if ([_dt_schedule isLaterThan:_dt_new]) {
//      isPastTime = NO;
//    }
    NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:_dic_tmp];
//    [_mdic setValue:[NSNumber numberWithBool:isPastTime] forKey:@"isPastTime"];
    
    //判断是否关闭
//    if (self.isEditing) {
      [self.marr_updateSchedule enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *_dic = (NSDictionary *)obj;
        if ([_dic[@"scheduleTime"] isEqualToString:_mdic[@"scheduleTime"]]) {
          [_mdic setValue:_dic[@"status"] forKey:@"status"];
          *stop = YES;
        }
      }];
//    }
    [_marr_ret replaceObjectAtIndex:idx withObject:_mdic];
  }];
  
  return _marr_ret;
}

- (void)loadMore_trainerCalendar {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"trainerCalendarList" forKey:@"trainerCalendarList"];
  [_dic_info setObject:@"trainerCalendarList_loadMore" forKey:@"trainerCalendarList_loadMore"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  
  [[NetworkManager_Location sharedManager] postRequest_Locations_trainOrderListWithTrainerId:self.str_id orderFilter:1 isFirstPage:NO count:10 userinfo:_dic_info];
}

#pragma mark - Notification事件
- (void)notification_refreshAfterCancelOrder:(id)sender {
  NSLog(@"mdic==%@", self.mdic_detailOrder);
  NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:self.mdic_detailOrder];
  [_mdic setValue:[NSNumber numberWithInteger:0] forKey:@"status"];
  NSLog(@"new dic=%@", _mdic);
//  [self.marr_willUpateSchedule addObject:_mdic];
  
  
  NSMutableArray *_marr_tmp = [NSMutableArray arrayWithArray:self.marr_data];
//  NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:self.marr_willUpateSchedule[0]];
  [_mdic setValue:[NSNumber numberWithInteger:1] forKey:@"status"];
  [_mdic setValue:@"" forKey:@"session"];
  _marr_tmp = [self updateCalendarStatusWithInfo:_mdic inArr:_marr_tmp atIndex:self.int_orderIndex];
  self.marr_data = [NSMutableArray arrayWithArray:_marr_tmp];
//  
  //更新需要更新的计划表数组
  NSDictionary *_dic_newInfo = _marr_tmp[self.int_orderIndex];
  [self updateWillScheduleWithInfo:_dic_newInfo];
  
  [self runRequest_updateCalendarForCancelOrder];
//  [self runRequest_updateCalendar];
}

#pragma mark - FGCalendarDetailInfoCellView delegate
- (void)didClickButton:(UIButton *)sender {
  FGCalendarDetailInfoCellView *cell = (FGCalendarDetailInfoCellView *)sender.superview.superview;
  NSIndexPath *indexPath = [self.tb_timeline indexPathForCell:cell];
  //设置cell的状态
  NSMutableArray *marr_tmp = [NSMutableArray arrayWithArray:self.marr_data];
  NSMutableDictionary * mdic_info = [NSMutableDictionary dictionaryWithDictionary:marr_tmp[indexPath.row]];
  
  if (isEditing) {
    marr_tmp = [self updateCalendarStatusWithInfo:mdic_info inArr:marr_tmp atIndex:indexPath.row];
    self.marr_data = [NSMutableArray arrayWithArray:marr_tmp];
    [self.tb_timeline reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    //更新需要更新的计划表数组
    NSDictionary *_dic_newInfo = marr_tmp[indexPath.row];
    [self updateWillScheduleWithInfo:_dic_newInfo];
  }
  else {
    //已经有个课程了，不能修改
    if ([self hasSessionWithInfo:mdic_info]) {
      NSLog(@"go to booking detail....==%@", mdic_info);
      self.mdic_detailOrder = mdic_info;
      self.int_orderIndex = indexPath.row;
      FGControllerManager *manager = [FGControllerManager sharedManager];
      FGBookingHistoryViewController *_vc_history = [[FGBookingHistoryViewController alloc] initWithNibName:@"FGBookingHistoryViewController" bundle:nil withOrderDetailInfo:mdic_info];
      [manager pushController:_vc_history navigationController:nav_current];
      return;
    }
  }
}

- (void)didClickCell:(UIButton *)sender {
  FGCalendarDetailInfoCellView *cell = (FGCalendarDetailInfoCellView *)sender.superview.superview;
  NSIndexPath *indexPath = [self.tb_timeline indexPathForCell:cell];
  NSDictionary * _dic_info = self.marr_data[indexPath.row];
  NSString *_str_date = [_dic_info[@"scheduleTime"] componentsSeparatedByString:@" "][0];
  NSString *_str_scheduleTime = _dic_info[@"time"];
  
  if (self.delegate) {
    [self.delegate didClickForUserRebookCourseWithTrainerId:self.str_id withDate:_str_date andScheduleTime:_str_scheduleTime];
  }
}

#pragma mark -
- (void)updateCalendarView {
  if (self.isEditing == NO) {
    
    NSLog(@"arr_updateSchedule===%@", marr_updateSchedule);
    
    [self runRequest_updateCalendar];

    
//    [self.tb_timeline setupLoadingMaskLayerHidden:NO withAlpha:0.9];
//    [self.tb_timeline triggerPullToRefresh];
//    
//    //请求网络数据
//    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC);
//    dispatch_after(time, dispatch_get_main_queue(), ^{
//      [self bindDataToUI];
//    });
  }
  else {
    self.tb_timeline.contentOffset = CGPointZero;
    [self.tb_timeline stopRefresh];
    [self.tb_timeline reloadData];
  }
}

- (BOOL)hasSessionWithInfo:(NSDictionary *)info{
  if (info == nil)
    return NO;
  
  NSInteger _int_status = [info[@"status"] integerValue];
  if (_int_status == 2) {
    return YES;
  }
  
  return NO;
}

#pragma mark - CLWeeklyCalendarViewDelegate
-(void)dailyCalendarViewDidSelect:(NSDate *)date isDoubleTap:(BOOL)_isDoubleTap
{
  
  //You can do any logic after the view select the date
  NSLog(@"date==%@,==%@",date,self.view_calendar.currentServerDate);
  NSLog(@"_isDoubleTap=%d", _isDoubleTap);
  if (_isDoubleTap) {
    //设置cell的状态
    if (isEditing) {
      
      __block NSMutableArray *marr_tmp = [NSMutableArray arrayWithArray:self.marr_data];
      //    NSMutableDictionary * mdic_info = [NSMutableDictionary dictionaryWithDictionary:marr_tmp[indexPath.row]];
      //已经有个课程了，不能修改
      __block BOOL _bool_hasSession = NO;
      [marr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary * mdic_info = [NSMutableDictionary dictionaryWithDictionary:obj];
        
        if ([self hasSessionWithInfo:mdic_info]) {
          _bool_hasSession = YES;
          *stop = YES;
        }
      }];
      
      if (_bool_hasSession) {
        [commond alert:multiLanguage(@"Alert") message:multiLanguage(@"There are scheduled courses! \n can't close the day!") callback:nil];
        return;
      }
      
      
      [marr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          [self updateCalendarStatusWithInfo:obj inArr:marr_tmp atIndex:idx];
        
        //更新需要更新的计划表数组
        NSDictionary *_dic_newInfo = marr_tmp[idx];
        [self updateWillScheduleWithInfo:_dic_newInfo];
      }];
      
      self.marr_data = [NSMutableArray arrayWithArray:marr_tmp];
      [self.tb_timeline reloadData];
      
      return;
    }
  }
  NSDate *_dt_weekStart = [self.view_calendar getStartWeekDateWithDate:self.view_calendar.selectedDate];
  NSArray *_arr = [self getSchedulesDataInDateString:[_dt_weekStart dateFormatStringYYYYMMDD]];
  NSMutableArray *_marr_tmp = [self getSchedulesFromList:_arr onDate:self.view_calendar.selectedDate];
  self.marr_data = _marr_tmp;
  
  [self refreshTableView];
}

-(void)dailyCalendarViewSwipSelectWithStartDate: (NSDate *)_dt_start toEndDate:(NSDate *)_dt_end {
  NSLog(@"startDate=%@,endDate=%@",_dt_start, _dt_end);
  //请求服务器数据
//  [self runRequest_trainerCalendarWithStartDate:_dt_start toEndDate:_dt_end];
  self.dt_displayStartDate = _dt_start;
  self.dt_displayEndDate   = _dt_end;

  BOOL _bool_isDownload = [self isAlreadyDownloadSchedulesInDate:_dt_start];
  if (_bool_isDownload == NO) {
//    [self.tb_timeline setupLoadingMaskLayerHidden:NO withAlpha:1.0f];
    [self runRequest_trainerCalendarWithStartDate:_dt_start toEndDate:_dt_end];
    return;
  }
  
//  NSString *_str_startDate = [self.dt_displayStartDate dateFormatStringYYYYMMDD];
  //有数据的话获取本地数据
//  self.marr_data = [NSMutableArray arrayWithArray:self.mdic_localDataSourceForSchedule[_str_startDate]];
//  [self refreshTableView];
  [self refreshCalendarViewForStatusWithSwip:YES];
}

#pragma mark - 其它方法
- (void)refreshTableView {
  self.tb_timeline.contentOffset = CGPointZero;
  [self.tb_timeline setupLoadingMaskLayerHidden:YES];
  [self.tb_timeline stopRefresh];
  [self.tb_timeline reloadData];
  
//  //获取所有数据后，还需要判断这一天是否关闭
////  if (_bool_isNeed)
//    [self refreshCalendarViewForStatusWithSwip];
  
}

- (void)refreshCalendarViewForStatusWithSwip:(BOOL)_bool_isSwipe {
  /*
   1:不可用
   0:可用(默认)
   2:有课
   */
  __block int _int_closeHoursInDay = 0;
  __block int _int_dateType = 0;
  [self.marr_updateSchedule removeAllObjects];
  
  NSLog(@"start date=%@,end date=%@, selected date=%@", self.dt_displayStartDate, self.dt_displayEndDate, self.view_calendar.selectedDate);
  NSMutableArray *_marr_everyDateStatus = [NSMutableArray array];
  __block NSString *_str_hasCloseDate = [self.dt_displayStartDate dateFormatStringYYYYMMDD];
  __block NSString *_str_hasCourseDate;
  ;
  NSArray *_arr = [self getSchedulesDataInDateString:[self.dt_displayStartDate dateFormatStringYYYYMMDD]];
  [_arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSDictionary *_dic_scheduleDetail = (NSDictionary *)obj;
    NSString *_str_scheduleTime = [FGUtils dateSpecificTimeWithTimeInterval:[_dic_scheduleDetail[@"Time"] doubleValue] withFormat:@"yyyy-MM-dd HH:mm"];
    NSString *_str_date = [_str_scheduleTime componentsSeparatedByString:@" "][0];
    NSLog(@"_str_scheduleTime==%@,_str_date=%@",_str_scheduleTime, _str_date);
    
    int _int_type = [_dic_scheduleDetail[@"Type"] intValue];
    if (_int_type == 1) {
      if ([_str_hasCloseDate isEqualToString:_str_date]) {
        _int_closeHoursInDay++;
      }
      else {
        _int_closeHoursInDay = 1;
        _str_hasCloseDate = _str_date;
      }
      
      if (_int_closeHoursInDay == 11) {
        // 说明全部关闭
        [_marr_everyDateStatus addObject:
         @{@"date":_str_date,
           @"type": [NSNumber numberWithInt:1]
           }];
        _int_closeHoursInDay = 0;
      }
      
      //添加到marr_updateSchedule
      //不可用一定没有课程
      NSDictionary *_dic = @{
        @"scheduleTime":_str_scheduleTime,
        @"time":[FGUtils formatScheduleSpecificTimeDurationWithStartTime:[_str_scheduleTime componentsSeparatedByString:@" "][1]],
        @"status":@1,
        @"session":@"",
        @"detail":@{},
        @"isPastTime":@NO};
      [self.marr_updateSchedule addObject:_dic];
      ;
    }
    
    if (_str_hasCourseDate &&
        [_str_hasCourseDate isEqualToString:_str_date]) {
    } else {
      _str_hasCourseDate = nil;
      if (_int_type == 2) {
        //说明有课程，直接跳出
        _int_dateType = 2;
        _str_hasCourseDate = _str_date;
        
        [_marr_everyDateStatus addObject:
         @{@"date":_str_date,
           @"type": [NSNumber numberWithInt:_int_dateType]
           }];
      }
    }
  }];
  
  NSLog(@"_marr_everyDateStatus==%@", _marr_everyDateStatus);
  ;
  
  [self.view_calendar setMarr_specialDate:_marr_everyDateStatus];
  if (_bool_isSwipe)
    [self.view_calendar refreshWeeklyViewAfterSwipeWithStartDate:self.dt_displayStartDate];
  else
    [self.view_calendar setNeedsDisplay];
}

- (NSMutableArray *)updateCalendarStatusWithInfo:(NSMutableDictionary *)_mdic_info inArr:(NSMutableArray *)_marr_tmp atIndex:(NSInteger)idx {
      NSInteger _int_status = [_mdic_info[@"status"] integerValue];
      NSInteger _int_newStatus;
      if (_int_status == 1) //不可用
      {
        _int_newStatus = 0;//可用
      } else if (_int_status == 0) {
        _int_newStatus = 1;//不可用
      }
  
      [_mdic_info setValue:[NSNumber numberWithInteger:_int_newStatus] forKey:@"status"];
      [_marr_tmp replaceObjectAtIndex:idx withObject:_mdic_info];
      //
      NSString *_str_schedule = _mdic_info[@"scheduleTime"];
      //      //如果是非空闲
      if (_int_newStatus == 1) {
        //        检查是否已经在更新序列中，这个时候需要移除
        [self.marr_updateSchedule addObject:_mdic_info];
  
        //还需要刷新原始的总的数据源
         NSArray *_arr = [self getSchedulesDataInDateString:[self.dt_displayStartDate dateFormatStringYYYYMMDD]];
        NSMutableArray *_marr_scheduleData = [NSMutableArray arrayWithArray:_arr];
        NSMutableArray *_marr_tmp = [NSMutableArray arrayWithArray:_arr];
        __block NSUInteger _int_idx = 0;
        NSDate *_dt_schedule = [commond dateFromString:_str_schedule formatter:@"yyyy-MM-dd HH:mm"];
        [_marr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          NSDictionary *_dic_scheduleDetail = (NSDictionary *)obj;
          NSString *_str_scheduleTime = [FGUtils dateSpecificTimeWithTimeInterval:[_dic_scheduleDetail[@"Time"] doubleValue] withFormat:@"yyyy-MM-dd HH:mm"];
          NSDate *_dt_scheduleDetail = [commond dateFromString:_str_scheduleTime formatter:@"yyyy-MM-dd HH:mm"];
  
          if ([_dt_scheduleDetail isLaterThan:_dt_schedule]) {
            _int_idx = idx;
            *stop = YES;
          }
        }];
  
  
        NSDictionary *_dic_new = @{@"OrderId":@"",
                                   @"Time":[NSNumber numberWithDouble:[FGUtils formatTimeIntervalFromDate:_dt_schedule]],
                                   @"Type":@1};
        [_marr_scheduleData insertObject:_dic_new atIndex:_int_idx==0?0:_int_idx-1];
  
        [self.mdic_scheduleDataForWeek setValue:_marr_scheduleData forKey:[self.dt_displayStartDate dateFormatStringYYYYMMDD]];
      } else {
        //空闲
        [self.marr_updateSchedule enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          NSDictionary *_dic = (NSDictionary *)obj;
          if ([_dic[@"scheduleTime"] isEqualToString:_str_schedule]) {
            [self.marr_updateSchedule removeObjectAtIndex:idx];
            *stop = YES;
          }
        }];
        
        NSArray *_arr = [self getSchedulesDataInDateString:[self.dt_displayStartDate dateFormatStringYYYYMMDD]];
        NSMutableArray *_marr_scheduleData = [NSMutableArray arrayWithArray:_arr];
        //还需要刷新原始的总的数据源
        [_arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          NSDictionary *_dic_scheduleDetail = (NSDictionary *)obj;
          NSString *_str_scheduleTime = [FGUtils dateSpecificTimeWithTimeInterval:[_dic_scheduleDetail[@"Time"] doubleValue] withFormat:@"yyyy-MM-dd HH:mm"];
  
          if ([_str_schedule isEqualToString:_str_scheduleTime]) {
            [_marr_scheduleData removeObjectAtIndex:idx];
            *stop = YES;
          }
        }];
        
        [self.mdic_scheduleDataForWeek setValue:_marr_scheduleData forKey:[self.dt_displayStartDate dateFormatStringYYYYMMDD]];
      }
  
  return _marr_tmp;
}


- (void)updateWillScheduleWithInfo:(NSDictionary *)_dic {
  __block NSUInteger _int_idx = 0;
  __block BOOL _bool_has = NO;

  [self.marr_willUpateSchedule enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSDictionary *_dic_tmp = (NSDictionary *)obj;
    NSString *_str_schedule = _dic_tmp[@"scheduleTime"];
    NSString *_str_updateSchedule = _dic[@"scheduleTime"];
    
    if ([_str_schedule isEqualToString:_str_updateSchedule]) {
      _int_idx = idx;
      _bool_has = YES;
      *stop = YES;
    }
  }];
  
  if (_bool_has)
    [self.marr_willUpateSchedule replaceObjectAtIndex:_int_idx withObject:_dic];
  else
    [self.marr_willUpateSchedule addObject:_dic];
  NSLog(@"marr_willUpateSchedule==%@", self.marr_willUpateSchedule);
}

- (BOOL)isAlreadyDownloadSchedulesInDate:(NSDate *)_dt {
  NSArray *_arr = self.mdic_localDataSourceForSchedule[[_dt dateFormatStringYYYYMMDD]];
  if (ISNULLObj(_arr)) {
    NSLog(@"没有数据，需要请求");
    return NO;
  }
  
  return YES;
}

- (NSArray *)getSchedulesDataInDateString:(NSString *)_str_dt {
  NSArray *_arr = self.mdic_scheduleDataForWeek[_str_dt];
  if (ISNULLObj(_arr)) {
    NSLog(@"没有数据，需要请求");
    return nil;
  }
  
  return _arr;
}
@end

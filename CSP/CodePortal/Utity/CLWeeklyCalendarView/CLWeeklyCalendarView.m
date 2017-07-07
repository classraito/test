//
//  CLWeeklyCalendarView.m
//  Deputy
//
//  Created by Caesar on 30/10/2014.
//  Copyright (c) 2014 Caesar Li. All rights reserved.
//

#import "CLWeeklyCalendarView.h"
#import "DailyCalendarView.h"
#import "DayTitleLabel.h"

#import "NSDate+Utils.h"
#import "NSDate+CL.h"
#import "UIColor+CL.h"
#import "NSDictionary+CL.h"
#import "UIImage+CL.h"

#define WEEKLY_VIEW_COUNT 7
#define DAY_TITLE_VIEW_HEIGHT 40.f
#define DAY_TITLE_FONT_SIZE 11.f
#define DATE_TITLE_MARGIN_TOP 0.0f

#define DATE_VIEW_MARGIN_TOP 0.0f

#define DATE_VIEW_MARGIN 0.f
#define DATE_VIEW_HEIGHT 60.f


#define DATE_LABEL_MARGIN_LEFT 9.f
#define DATE_LABEL_INFO_WIDTH 160.f
#define DATE_LABEL_INFO_HEIGHT 40.f

#define WEATHER_ICON_WIDTH 20
#define WEATHER_ICON_HEIGHT 20
#define WEATHER_ICON_LEFT 90
#define WEATHER_ICON_MARGIN_TOP 9

//Attribute Keys
NSString *const CLCalendarWeekStartDay = @"CLCalendarWeekStartDay";
NSString *const CLCalendarDayTitleTextColor = @"CLCalendarDayTitleTextColor";
NSString *const CLCalendarSelectedDatePrintFormat = @"CLCalendarSelectedDatePrintFormat";
NSString *const CLCalendarSelectedDatePrintColor = @"CLCalendarSelectedDatePrintColor";
NSString *const CLCalendarSelectedDatePrintFontSize = @"CLCalendarSelectedDatePrintFontSize";
NSString *const CLCalendarBackgroundImageColor = @"CLCalendarBackgroundImageColor";

//Default Values
static NSInteger const CLCalendarWeekStartDayDefault = 1;
static NSInteger const CLCalendarDayTitleTextColorDefault = 0x000000;//0xC2E8FF;
static NSString* const CLCalendarSelectedDatePrintFormatDefault = @"EEE, d MMM yyyy";
static float const CLCalendarSelectedDatePrintFontSizeDefault = 13.f;


@interface CLWeeklyCalendarView()<DailyCalendarViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGSize size_newBound;
@property (nonatomic, strong) NSDate *swipStartDate;

@property (nonatomic, strong) UIView *dailySubViewContainer;
@property (nonatomic, strong) UIView *dayTitleSubViewContainer;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *dailyInfoSubViewContainer;
@property (nonatomic, strong) UIImageView *weatherIcon;
@property (nonatomic, strong) UILabel *dateInfoLabel;
@property (nonatomic, strong) NSDictionary *arrDailyWeather;
@property (nonatomic, strong) NSDictionary *dic_swipParam;


@property (nonatomic, strong) NSNumber *weekStartConfig;
@property (nonatomic, strong) UIColor *dayTitleTextColor;
@property (nonatomic, strong) NSString *selectedDatePrintFormat;
@property (nonatomic, strong) UIColor *selectedDatePrintColor;
@property (nonatomic) float selectedDatePrintFontSize;
@property (nonatomic, strong) UIColor *backgroundImageColor;


@end

@implementation CLWeeklyCalendarView
@synthesize currentServerDate;
@synthesize int_capabilityDays; //能够滚动的日期大小
@synthesize startDate;
@synthesize endDate;
@synthesize marr_specialDate;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
    self.size_newBound = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    // Initialization code
    [self addSubview:self.backgroundImageView];
    [commond useDefaultRatioToScaleView:self.backgroundImageView];
    self.arrDailyWeather = @{};
    self.marr_specialDate = [NSMutableArray array];
  }
  return self;
}


-(void)setDelegate:(id<CLWeeklyCalendarViewDelegate>)delegate
{
  _delegate = delegate;
  //    [self applyCustomDefaults];
}

- (void)setupCalendarWithDate:(NSDate *)date {
  self.currentServerDate = date;
  self.selectedDate = date;
  [self applyCustomDefaults];
}

-(void)applyCustomDefaults
{
  NSDictionary *attributes;
  
  if ([self.delegate respondsToSelector:@selector(CLCalendarBehaviorAttributes)]) {
    attributes = [self.delegate CLCalendarBehaviorAttributes];
  }
  self.weekStartConfig = attributes[CLCalendarWeekStartDay] ? attributes[CLCalendarWeekStartDay] : [NSNumber numberWithInt:CLCalendarWeekStartDayDefault];
  
  self.dayTitleTextColor = attributes[CLCalendarDayTitleTextColor]? attributes[CLCalendarDayTitleTextColor]:[UIColor colorWithHex:CLCalendarDayTitleTextColorDefault];
  
  self.selectedDatePrintFormat = attributes[CLCalendarSelectedDatePrintFormat]? attributes[CLCalendarSelectedDatePrintFormat] : CLCalendarSelectedDatePrintFormatDefault;
  
  self.selectedDatePrintColor = attributes[CLCalendarSelectedDatePrintColor]? attributes[CLCalendarSelectedDatePrintColor] : [UIColor whiteColor];
  
  self.selectedDatePrintFontSize = attributes[CLCalendarSelectedDatePrintFontSize]? [attributes[CLCalendarSelectedDatePrintFontSize] floatValue] : CLCalendarSelectedDatePrintFontSizeDefault;
  
  NSLog(@"%@  %f", attributes[CLCalendarBackgroundImageColor],  self.selectedDatePrintFontSize);
  self.backgroundImageColor = attributes[CLCalendarBackgroundImageColor];
  
  [self setNeedsDisplay];
}
-(UIView *)dailyInfoSubViewContainer
{
  if(!_dailyInfoSubViewContainer){
    _dailyInfoSubViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, DATE_TITLE_MARGIN_TOP+DAY_TITLE_VIEW_HEIGHT + DATE_VIEW_HEIGHT + DATE_VIEW_MARGIN * 2, self.bounds.size.width, DATE_LABEL_INFO_HEIGHT)];
    _dailyInfoSubViewContainer.userInteractionEnabled = YES;
    [_dailyInfoSubViewContainer addSubview:self.weatherIcon];
    [_dailyInfoSubViewContainer addSubview:self.dateInfoLabel];
    
    [commond useDefaultRatioToScaleView:self.dateInfoLabel];
    [commond useDefaultRatioToScaleView:self.weatherIcon];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dailyInfoViewDidClick:)];
    [_dailyInfoSubViewContainer addGestureRecognizer:singleFingerTap];
  }
  return _dailyInfoSubViewContainer;
}
-(UIImageView *)weatherIcon
{
  if(!_weatherIcon){
    _weatherIcon = [[UIImageView alloc] initWithFrame:CGRectMake(WEATHER_ICON_LEFT, WEATHER_ICON_MARGIN_TOP, WEATHER_ICON_WIDTH, WEATHER_ICON_HEIGHT)];
  }
  return _weatherIcon;
}
-(UILabel *)dateInfoLabel
{
  if(!_dateInfoLabel){
    _dateInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(WEATHER_ICON_LEFT+WEATHER_ICON_WIDTH+DATE_LABEL_MARGIN_LEFT, 0, DATE_LABEL_INFO_WIDTH, DATE_LABEL_INFO_HEIGHT)];
    _dateInfoLabel.textAlignment = NSTextAlignmentCenter;
    _dateInfoLabel.userInteractionEnabled = YES;
  }
  _dateInfoLabel.font = [UIFont systemFontOfSize: self.selectedDatePrintFontSize];
  _dateInfoLabel.textColor = self.selectedDatePrintColor;
  return _dateInfoLabel;
}
-(UIView *)dayTitleSubViewContainer
{
  if(!_dayTitleSubViewContainer){
    _dayTitleSubViewContainer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, DAY_TITLE_VIEW_HEIGHT)];
    _dayTitleSubViewContainer.backgroundColor = [UIColor whiteColor];
    _dayTitleSubViewContainer.userInteractionEnabled = YES;
    
  }
  return _dayTitleSubViewContainer;
  
}
-(UIView *)dailySubViewContainer
{
  if(!_dailySubViewContainer){
    _dailySubViewContainer = [[UIImageView alloc] initWithFrame:CGRectMake(0, DATE_TITLE_MARGIN_TOP+DAY_TITLE_VIEW_HEIGHT+DATE_VIEW_MARGIN + DATE_VIEW_MARGIN_TOP, self.bounds.size.width, DATE_VIEW_HEIGHT)];
    _dailySubViewContainer.backgroundColor = [UIColor whiteColor];
    _dailySubViewContainer.userInteractionEnabled = YES;
    
  }
  return _dailySubViewContainer;
}
-(UIImageView *)backgroundImageView
{
//  CGSize size_newBound = CGSizeMake(self.size_newBound.width, self.size_newBound.height);
  if(!_backgroundImageView){
    _backgroundImageView = [[UIImageView alloc] initWithFrame:
                            CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.height)];
    
    _backgroundImageView.userInteractionEnabled = YES;
    [_backgroundImageView addSubview:self.dayTitleSubViewContainer];
    [_backgroundImageView addSubview:self.dailySubViewContainer];
//    [_backgroundImageView addSubview:self.dailyInfoSubViewContainer];
    
    [commond useDefaultRatioToScaleView:self.dayTitleSubViewContainer];
    [commond useDefaultRatioToScaleView:self.dailySubViewContainer];
    
    
    //Apply swipe gesture
    UISwipeGestureRecognizer *recognizerRight;
    recognizerRight.delegate=self;
    
    recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [_backgroundImageView addGestureRecognizer:recognizerRight];
    
    
    UISwipeGestureRecognizer *recognizerLeft;
    recognizerLeft.delegate=self;
    recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [recognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_backgroundImageView addGestureRecognizer:recognizerLeft];
    
//    //添加双击手势
//    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
//    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
//    [_backgroundImageView addGestureRecognizer:doubleTapGestureRecognizer];
  }
  _backgroundImageView.backgroundColor = [UIColor whiteColor];//self.backgroundImageColor? self.backgroundImageColor : [UIColor colorWithPatternImage:[UIImage calendarBackgroundImage:self.size_newBound.height]];;
  
  return _backgroundImageView;
}

- (BOOL)shouldHiddenSepeatorWithDate:(NSDate *)_dt withType:(int *)_type {
  __block int _int_type = 0;
  NSString *_str_dailyDate = [_dt dateFormatStringYYYYMMDD];
  [self.marr_specialDate enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSDictionary *_dic = (NSDictionary *)obj;
    NSString *_str_date = _dic[@"date"];
    if ([_str_dailyDate isEqualToString:_str_date]) {
      _int_type = [_dic[@"type"] intValue];
      *stop = YES;
    }
  }];
  
  if (_type != nil)
    *_type = _int_type;
  
  if (_int_type == 1) {
    return YES;
  }
  return NO;
}

-(void)initDailyViewsWithDate:(NSDate *)date
{
  CGFloat dailyWidth = 46;//(self.size_newBound.width-(6*2))/WEEKLY_VIEW_COUNT;
  NSDate *today = date;//[NSDate new];
  NSDate *dtWeekStart = [today getWeekStartDate:self.weekStartConfig.integerValue];
  self.startDate = dtWeekStart;
  for (UIView *v in [self.dailySubViewContainer subviews]){
    [v removeFromSuperview];
  }
  for (UIView *v in [self.dayTitleSubViewContainer subviews]){
    [v removeFromSuperview];
  }

  BOOL _bool_hiddenSepeator = NO;
  int _type;
  for(int i = 0; i < WEEKLY_VIEW_COUNT; i++){
    NSDate *dt = [dtWeekStart addDays:i];
    _type = 0;
    _bool_hiddenSepeator = NO;
    if (i >= 0 && i < WEEKLY_VIEW_COUNT) {
      _bool_hiddenSepeator = NO;
    }
    else {
      _bool_hiddenSepeator = YES;
    }
    
    if ([self shouldHiddenSepeatorWithDate:[dt addDays:1] withType:nil] ) {
      _bool_hiddenSepeator = YES;
    }
    [self shouldHiddenSepeatorWithDate:dt withType:&_type];
    if (_type == 1)
      _bool_hiddenSepeator = YES;
    
    [self dayTitleViewForDate: dt inFrame: CGRectMake(dailyWidth*i, 0, dailyWidth, DAY_TITLE_VIEW_HEIGHT)];
    
    [self dailyViewForDate:dt inFrame: CGRectMake(dailyWidth*i, 0, dailyWidth, DATE_VIEW_HEIGHT) hiddenSpeator:_bool_hiddenSepeator withType:_type];

    self.endDate = dt;
  }
  
  //画分隔线
  UIView *view_separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
  view_separator.backgroundColor = color_homepage_lightGray;
  [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 0.5) toScaleView:view_separator];
  [self.dailySubViewContainer addSubview:view_separator];
  
  [self dailyCalendarViewDidSelect:self.currentServerDate isDoubleTap:NO];
}

-(UILabel *)dayTitleViewForDate: (NSDate *)date inFrame: (CGRect)frame
{
  DayTitleLabel *dayTitleLabel = [[DayTitleLabel alloc] initWithFrame:frame];
  dayTitleLabel.backgroundColor = [UIColor clearColor];
  dayTitleLabel.textColor = self.dayTitleTextColor;
  dayTitleLabel.textAlignment = NSTextAlignmentCenter;
  dayTitleLabel.font = [UIFont systemFontOfSize:DAY_TITLE_FONT_SIZE];
  
  dayTitleLabel.text = [[date getDayOfWeekShortString] uppercaseString];
  dayTitleLabel.date = date;
  dayTitleLabel.userInteractionEnabled = YES;
  
  UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dayTitleViewDidClick:)];
  [dayTitleLabel addGestureRecognizer:singleFingerTap];
  
  [commond useDefaultRatioToScaleView:dayTitleLabel];
  [self.dayTitleSubViewContainer addSubview:dayTitleLabel];
  return dayTitleLabel;
}

-(DailyCalendarView *)dailyViewForDate: (NSDate *)date inFrame: (CGRect)frame hiddenSpeator:(BOOL)bool_hideSpeator withType:(int)_type
{
//  __block int _int_type = 0;
//  NSString *_str_dailyDate = [date dateFormatStringYYYYMMDD];
//  [self.marr_specialDate enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//    NSDictionary *_dic = (NSDictionary *)obj;
//    NSString *_str_date = _dic[@"date"];
//    if ([_str_dailyDate isEqualToString:_str_date]) {
//      _int_type = [_dic[@"type"] intValue];
//      *stop = YES;
//    }
//  }];
  
  DailyCalendarView *view = [[DailyCalendarView alloc] initWithFrame:frame hideSpeator:bool_hideSpeator withType:_type];
  //[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
  view.date = date;
  view.delegate = self;
  [commond useDefaultRatioToScaleView:view];
  [self.dailySubViewContainer addSubview:view];
  return view;
}

- (void)dailySpeatorViewForDateInFrame:(CGRect)_rect{
  UIView *view_separator = [[UIView alloc] initWithFrame:_rect];
  view_separator.backgroundColor = color_homepage_lightGray;
  CGRect ratio_separator = CGRectMake(ratioW, ratioH, ratioW, 0.5);
  [commond useRatio:ratio_separator toScaleView:view_separator] ;
  
//  [commond useDefaultRatioToScaleView:view_separator];
//  [commond useRatio:CGRectMake(_rect.origin.x, _rect.origin.y, 2, 40) toScaleView:view_separator];
  [self.dailySubViewContainer addSubview:view_separator];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  // Drawing code
  [self initDailyViewsWithDate:self.selectedDate];
  
}

-(void)markDateSelected:(NSDate *)date
{
  for (DailyCalendarView *v in [self.dailySubViewContainer subviews]){
    if ([v isKindOfClass:[DailyCalendarView class]]) {
      [v markSelected:([v.date isSameDateWith:date])];
    }
  }
  self.selectedDate = date;
  NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
  [dayFormatter setDateFormat:self.selectedDatePrintFormat];
  NSString *strDate = [dayFormatter stringFromDate:date];
  if([date isDateToday]){
    strDate = [NSString stringWithFormat:@"Today, %@", strDate ];
  }
  
  
  [self adjustDailyInfoLabelAndWeatherIcon : NO];
  
  
  self.dateInfoLabel.text = strDate;
}
-(void)dailyInfoViewDidClick: (UIGestureRecognizer *)tap
{
  //Click to jump back to today
  [self redrawToDate:[NSDate new] ];
}
-(void)dayTitleViewDidClick: (UIGestureRecognizer *)tap
{
  [self redrawToDate:((DayTitleLabel *)tap.view).date];
}
-(void)redrawToDate:(NSDate *)dt
{
  if(![dt isWithinDate:self.startDate toDate:self.endDate]){
    BOOL swipeRight = ([dt compare:self.startDate] == NSOrderedAscending);
    [self delegateSwipeAnimation:swipeRight blnToday:[dt isDateToday] selectedDate:dt];
  }
  
  [self dailyCalendarViewDidSelect:dt isDoubleTap:NO];
}
-(void)redrawCalenderData
{
  [self redrawToDate:self.selectedDate];
}

-(void)adjustDailyInfoLabelAndWeatherIcon: (BOOL)blnShowWeatherIcon
{
  self.dateInfoLabel.textAlignment = (blnShowWeatherIcon)?NSTextAlignmentLeft:NSTextAlignmentCenter;
  if(blnShowWeatherIcon){
    if([self.selectedDate isDateToday]){
      self.weatherIcon.frame = CGRectMake(WEATHER_ICON_LEFT-20, WEATHER_ICON_MARGIN_TOP, WEATHER_ICON_WIDTH, WEATHER_ICON_HEIGHT);
      self.dateInfoLabel.frame = CGRectMake(WEATHER_ICON_LEFT+WEATHER_ICON_WIDTH+DATE_LABEL_MARGIN_LEFT-20, 0, DATE_LABEL_INFO_WIDTH, DATE_LABEL_INFO_HEIGHT);
    }else{
      self.weatherIcon.frame = CGRectMake(WEATHER_ICON_LEFT, WEATHER_ICON_MARGIN_TOP, WEATHER_ICON_WIDTH, WEATHER_ICON_HEIGHT);
      self.dateInfoLabel.frame = CGRectMake(WEATHER_ICON_LEFT+WEATHER_ICON_WIDTH+DATE_LABEL_MARGIN_LEFT, 0, DATE_LABEL_INFO_WIDTH, DATE_LABEL_INFO_HEIGHT);
    }
  }else{
    self.dateInfoLabel.frame = CGRectMake( (self.size_newBound.width - DATE_LABEL_INFO_WIDTH)/2, 0, DATE_LABEL_INFO_WIDTH, DATE_LABEL_INFO_HEIGHT);
  }
  
  self.weatherIcon.hidden = !blnShowWeatherIcon;
}

#pragma swipe
- (BOOL)canSwipeDateWithAdd:(BOOL)isAdd {
  int step = isAdd ? 1 : -1;
  NSDate *dtStart = self.startDate;
  NSDate * dtNewStart = [dtStart addDays:7 * step];
  
  //  判断如果这个日期小于服务器时间就不能滑动了
//  NSLog(@"dtStart=%@,dtEnd=%@", dtNewStart, [dtNewStart addDays:6]);
  
  NSComparisonResult result_start = [dtNewStart compare:self.currentServerDate];
  if (result_start == NSOrderedAscending) {
    if (isAdd == NO) {
      NSComparisonResult result_end = [[dtNewStart addDays:6] compare:self.currentServerDate];
      if (result_end == NSOrderedAscending) {
        return NO;
      }
    }
  }
  else {
    NSComparisonResult result_end = [[self.currentServerDate addDays:self.int_capabilityDays] compare:[dtNewStart addDays:6]];
    if (result_end == NSOrderedAscending) {
      return NO;
    }
  }
  
  return YES;
}
-(void)swipeLeft: (UISwipeGestureRecognizer *)swipe
{
  if ([self canSwipeDateWithAdd:YES])
    [self delegateSwipeAnimation: NO blnToday:NO selectedDate:nil];
}
-(void)swipeRight: (UISwipeGestureRecognizer *)swipe
{
  //需要判断是否能够滑动
  if ([self canSwipeDateWithAdd:NO])
    [self delegateSwipeAnimation: YES blnToday:NO selectedDate:nil];
}

-(void)delegateSwipeAnimation: (BOOL)blnSwipeRight blnToday: (BOOL)blnToday selectedDate:(NSDate *)selectedDate
{
  CATransition *animation = [CATransition animation];
  [animation setDelegate:self];
  [animation setType:kCATransitionPush];
  [animation setSubtype:(blnSwipeRight)?kCATransitionFromLeft:kCATransitionFromRight];
  [animation setDuration:0.50];
  [animation setTimingFunction:
   [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  [self.dailySubViewContainer.layer addAnimation:animation forKey:kCATransition];
  
  NSMutableDictionary *data = @{@"blnSwipeRight": [NSNumber numberWithBool:blnSwipeRight], @"blnToday":[NSNumber numberWithBool:blnToday]}.mutableCopy;
  
  if(selectedDate){
    [data setObject:selectedDate forKey:@"selectedDate"];
  }
  
  [self performSelector:@selector(renderSwipeDates:) withObject:data afterDelay:0.05f];
}

-(void)renderSwipeDates: (NSDictionary*)param
{
  self.dic_swipParam = param;
  int step = ([[param objectForKey:@"blnSwipeRight"] boolValue])? -1 : 1;
  BOOL blnToday = [[param objectForKey:@"blnToday"] boolValue];
  NSDate *selectedDate = [param objectForKeyWithNil:@"selectedDate"];
  
  NSDate *dtStart;
  if(blnToday){
    dtStart = [self.currentServerDate getWeekStartDate:self.weekStartConfig.integerValue];
  }else{
    dtStart = (selectedDate)? [selectedDate getWeekStartDate:self.weekStartConfig.integerValue]:[self.startDate addDays:step*7];
  }
  
  self.startDate = dtStart;
  self.swipStartDate = dtStart;
  self.endDate = [dtStart addDays:WEEKLY_VIEW_COUNT];
  
  //需要请求新数据
  [self.delegate dailyCalendarViewSwipSelectWithStartDate:self.swipStartDate toEndDate:self.endDate];
}

- (void)refreshWeeklyViewAfterSwipeWithStartDate:(NSDate *)_dt_start {
  
  NSDictionary *_param = self.dic_swipParam;
  int step = ([[_param objectForKey:@"blnSwipeRight"] boolValue])? -1 : 1;
  BOOL blnToday = [[_param objectForKey:@"blnToday"] boolValue];
  NSDate *selectedDate = [_param objectForKeyWithNil:@"selectedDate"];
  CGFloat dailyWidth = (self.size_newBound.width/WEEKLY_VIEW_COUNT);
  

  NSDate *dtStart = _dt_start;
//  if(blnToday){
//    dtStart = [_dt_start getWeekStartDate:self.weekStartConfig.integerValue];
//  }else{
//    dtStart = (selectedDate)? [selectedDate getWeekStartDate:self.weekStartConfig.integerValue]:[self.startDate addDays:step*7];
//  }
  
  self.startDate = dtStart;
  self.swipStartDate = dtStart;
  
//  CGFloat dailyWidth = 46;//(self.size_newBound.width-(6*2))/WEEKLY_VIEW_COUNT;
//  NSDate *today = selectedDate;//[NSDate new];
  NSDate *dtWeekStart = dtStart;//[today getWeekStartDate:self.weekStartConfig.integerValue];
//  self.startDate = dtWeekStart;
  for (UIView *v in [self.dailySubViewContainer subviews]){
    [v removeFromSuperview];
  }
  for (UIView *v in [self.dayTitleSubViewContainer subviews]){
    [v removeFromSuperview];
  }
  
  BOOL _bool_hiddenSepeator = NO;
  int _type;
  for(int i = 0; i < WEEKLY_VIEW_COUNT; i++){
    NSDate *dt = [dtWeekStart addDays:i];
    _type = 0;
    _bool_hiddenSepeator = NO;
    if (i >= 0 && i < WEEKLY_VIEW_COUNT) {
      _bool_hiddenSepeator = NO;
    }
    else {
      _bool_hiddenSepeator = YES;
    }
    
    if ([self shouldHiddenSepeatorWithDate:[dt addDays:1] withType:nil] ) {
      _bool_hiddenSepeator = YES;
    }
    [self shouldHiddenSepeatorWithDate:dt withType:&_type];
    if (_type == 1)
      _bool_hiddenSepeator = YES;
    
    DayTitleLabel *titleLabel = (DayTitleLabel *)[self dayTitleViewForDate: dt inFrame: CGRectMake(dailyWidth*i, 0, dailyWidth, DAY_TITLE_VIEW_HEIGHT)];
    
    DailyCalendarView* view = [self dailyViewForDate:dt inFrame: CGRectMake(dailyWidth*i, 0, dailyWidth, DATE_VIEW_HEIGHT) hiddenSpeator:_bool_hiddenSepeator withType:_type];
    
//    DayTitleLabel *titleLabel = [[self.dayTitleSubViewContainer subviews] objectAtIndex:i];
    titleLabel.date = dt;
    [view markSelected:([view.date isSameDateWith:self.selectedDate])];
    self.endDate = dt;
  }
  
//  for (UIView *v in [self.dailySubViewContainer subviews]){
//    [v removeFromSuperview];
//  }
//  
//  BOOL _bool_hiddenSepeator = NO;
//  int _type;
//  for(int i = 0; i < WEEKLY_VIEW_COUNT; i++){
//    NSDate *dt = [dtStart addDays:i];
//    
//    _type = 0;
//    _bool_hiddenSepeator = NO;
//    if (i >= 0 && i < WEEKLY_VIEW_COUNT) {
//      _bool_hiddenSepeator = NO;
//    }
//    else {
//      _bool_hiddenSepeator = YES;
//    }
//    
//    if ([self shouldHiddenSepeatorWithDate:[dt addDays:1] withType:nil] ) {
//      _bool_hiddenSepeator = YES;
//    }
//    [self shouldHiddenSepeatorWithDate:dt withType:&_type];
//    if (_type == 1)
//      _bool_hiddenSepeator = YES;
//    
//    DailyCalendarView* view = [self dailyViewForDate:dt inFrame: CGRectMake(dailyWidth*i, 0, dailyWidth, DATE_VIEW_HEIGHT) hiddenSpeator:_bool_hiddenSepeator withType:_type];
//    
//    DayTitleLabel *titleLabel = [[self.dayTitleSubViewContainer subviews] objectAtIndex:i];
//    titleLabel.date = dt;
//    [view markSelected:([view.date isSameDateWith:self.selectedDate])];
//    self.endDate = dt;
//  }
  
  //画分隔线
  UIView *view_separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
  view_separator.backgroundColor = color_homepage_lightGray;
  [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 0.5) toScaleView:view_separator];
  [self.dailySubViewContainer addSubview:view_separator];
}

-(void)updateWeatherIconByKey:(NSString *)key
{
  if(!key){
    [self adjustDailyInfoLabelAndWeatherIcon:NO];
    return;
  }
  
  self.weatherIcon.image = [UIImage imageNamed:key];
  [self adjustDailyInfoLabelAndWeatherIcon:YES];
}

#pragma DeputyDailyCalendarViewDelegate
-(void)dailyCalendarViewDidSelect: (NSDate *)date isDoubleTap:(BOOL)_isDoubleTap {
  [self markDateSelected:date];
  
  [self.delegate dailyCalendarViewDidSelect:date isDoubleTap:_isDoubleTap];
}
#pragma mark -获取一周的起始
- (NSDate *)getStartWeekDateWithDate:(NSDate *)_dt {
  NSDate *today = _dt;
  NSDate *dtWeekStart = [today getWeekStartDate:self.weekStartConfig.integerValue];
  return dtWeekStart;
}

@end

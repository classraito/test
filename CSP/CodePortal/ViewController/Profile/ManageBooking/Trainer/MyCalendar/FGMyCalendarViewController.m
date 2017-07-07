//
//  FGMyCalendarViewController.m
//  CSP
//
//  Created by JasonLu on 16/11/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGMyCalendarViewController.h"
#import "FGTrainerMyCalendarView.h"
#import "FGLocationFindATrainerViewController.h"

@interface FGMyCalendarViewController () <FGTrainerMyCalendarViewDelegate>
@property (nonatomic, strong) FGTrainerMyCalendarView * view_calendar;
@end

@implementation FGMyCalendarViewController
@synthesize view_calendar;
@synthesize str_id;
#pragma mark - 生命周期
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(id)_str_id {
  if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
    if (_str_id != nil && !ISNULLObj(_str_id)) {
      self.str_id = _str_id;
    }
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  if ([commond isUser]) {
    self.view_topPanel.str_title = multiLanguage(@"TRAINER CALENDAR");
    self.view_topPanel.iv_right.image = [UIImage imageNamed:@"warmupbtn.png"];
    SAFE_RemoveSupreView(self.view_topPanel.iv_right);
    SAFE_RemoveSupreView(self.view_topPanel.btn_right);
    
  } else {
    self.view_topPanel.str_title = multiLanguage(@"MY CALENDAR");
    self.view_topPanel.iv_right.image = [UIImage imageNamed:@"warmupbtn.png"];
    SAFE_RemoveSupreView(self.view_topPanel.iv_right);
    
    [self.view_topPanel.btn_right setTitle:multiLanguage(@"Edit") forState:UIControlStateNormal];
    [self.view_topPanel.btn_right setTitleColor:color_red_panel forState:UIControlStateNormal];
    [self.view_topPanel.btn_right addTarget:self action:@selector(buttonAction_edit:) forControlEvents:UIControlEventTouchUpInside];
  }
  
  [self hideBottomPanelWithAnimtaion:NO];
  [self internalInitalCalendarView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  self.view_calendar   = nil;
  self.str_id = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self setWhiteBGStyle];
}

- (void)manullyFixSize {
  [super manullyFixSize];
}

#pragma mark - 初始化
- (void)internalInitalCalendarView {
  view_calendar = (FGTrainerMyCalendarView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainerMyCalendarView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:view_calendar];
  view_calendar.str_id = self.str_id;
  if ([commond isUser]) {
    view_calendar.delegate = self;
  }

  CGRect frame             = self.view_topPanel.frame;
  view_calendar.frame = CGRectMake(0, frame.size.height, view_calendar.frame.size.width, view_calendar.frame.size.height);
  view_calendar.isEditing = NO;
  [self.view addSubview:view_calendar];
  
  [self.view_calendar runRequest_trainerCalendar];
}

#pragma mark - FGTrainerMyCalendarViewDelegate
- (void)didClickForUserRebookCourseWithTrainerId:(NSString *)_str_trainerId withDate:(NSString *)_str_date andScheduleTime:(NSString *)_str_scheduleTime {
  NSLog(@"trainerId==%@",_str_trainerId);
  NSLog(@"date==%@",_str_date);
  NSLog(@"scheduleTime==%@", _str_scheduleTime);
  NSLog(@"go to location trainer...");
//  NSString *_str_id = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
  
  _str_scheduleTime = [_str_scheduleTime stringByReplacingOccurrencesOfString:@"-" withString:@" - "];
  NSString *_str_dateFormatter;
  if([commond isChinese])
  {
    _str_dateFormatter = @"YYYY年MM月dd日";
  }
  else
  {
    _str_dateFormatter = @"YYYY / MM / dd";
  }
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  NSDate *newDate = [dateFormatter dateFromString:_str_date];
  NSString *dateFormat = [newDate formattedDateWithFormat:_str_dateFormatter ];
  //NSDate *_date_newFormater = [NSDate dateWithString:_str_date formatString:_str_dateFormatter];
  _str_date = dateFormat;//[_date_newFormater formattedDateWithFormat:_str_dateFormatter];
    
    
  FGControllerManager *manager = [FGControllerManager sharedManager];
    FGLocationFindATrainerViewController *_vc_findTrainer = [[FGLocationFindATrainerViewController alloc] initWithNibName:@"FGLocationFindATrainerViewController" bundle:nil trainingID:_str_trainerId dateStr:_str_date timeStr:_str_scheduleTime];
    [manager pushController:_vc_findTrainer navigationController:nav_current];//跳转到 预订单个课程
    
}

#pragma mark - 按钮事件
- (void)buttonAction_edit:(id)sender {
  self.view_calendar.isEditing = !self.view_calendar.isEditing;
  NSString *str_btn = self.view_calendar.isEditing ? multiLanguage(@"Done"):multiLanguage(@"Edit");
  [self.view_topPanel.btn_right setTitle:str_btn forState:UIControlStateNormal];
  [self.view_calendar updateCalendarView];
}

#pragma mark - 从父类继承的
- (void)buttonAction_right:(id)_sender {
  NSLog(@"my calendar buttonAction_right");
//  FGControllerManager *manager = [FGControllerManager sharedManager];
//  [manager pushControllerByName:@"FGMyCalendarViewController" inNavigation:nav_current];
}

- (void)receivedDataFromNetwork:(NSNotification *)_notification {
  [super receivedDataFromNetwork:_notification];
  NSMutableDictionary *_dic_requestInfo = _notification.object;
  NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
  [commond removeLoading];
  
  if ([HOST(URL_LOCATION_CalendarList) isEqualToString:_str_url]) {
    if([[_dic_requestInfo allKeys] containsObject:@"trainerCalendarList"])
    {
      if(self.view_calendar)
      {
        if([[_dic_requestInfo allKeys] containsObject:@"trainerCalendarList_loadMore"])
        {
          [self.view_calendar loadMore_bindDataToUI];
        }//加载更多
        else
        {
          [self.view_calendar bindDataToUI];
        }//加载最新的
      }
    }
  }
  else if ([HOST(URL_LOCATION_SetCalendar) isEqualToString:_str_url]) {
    if([[_dic_requestInfo allKeys] containsObject:@"trainerUpdateCalendar"])
    {
      if(self.view_calendar)
      {
          [self.view_calendar bindDataToUIForUpdateCalendar];
      }
    }
    else if([[_dic_requestInfo allKeys] containsObject:@"trainerSuccesscancelOrderToUpdateCalendar"]) {
      if(self.view_calendar)
      {
        [self.view_calendar bindDataToUIForSuccessCancelOrderToUpdateCalendar];
      }
    }
  }
}

- (void)requestFailedFromNetwork:(NSNotification *)_notification {
  
}
@end

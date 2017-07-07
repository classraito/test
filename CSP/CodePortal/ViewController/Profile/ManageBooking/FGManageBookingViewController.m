//
//  FGManageBookingViewController.m
//  CSP
//
//  Created by JasonLu on 16/11/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "FGFeedBackForTrainerViewController.h"
#import "FGManageBookingViewController.h"
#import "FGManagingBookTitleView.h"
@interface FGManageBookingViewController () <FGManageBookingViewForUserDelegate, FGManageBookingViewForTrainerDelegate> {
  BOOL _bool_isFromPush;
}
@end

@implementation FGManageBookingViewController
@synthesize view_manageBookingForUser;
@synthesize view_manageBookingForTrainer;
@synthesize str_id;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(id)_str_id withInfo:(NSDictionary *)_info
{
  
  if (self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil withId:_str_id]) {
    _dic_info = _info;
    _bool_isFromPush = YES;
  }
  return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(id)_str_id
{
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
  
  [self hideBottomPanelWithAnimtaion:NO];
  [self internalInitalManageBookingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self setWhiteBGStyle];
}

- (void)manullyFixSize {
  [super manullyFixSize];
}

- (void)dealloc {
  self.view_manageBookingForUser   = nil;
  self.view_manageBookingForTrainer= nil;
  self.str_id = nil;
  _dic_info = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}


- (void)internalInitalManageBookingView {
  [commond saveBookingCntWithCnt:0];
  if ([commond isUser]) {
    SAFE_RemoveSupreView(self.view_topPanel.iv_right);
    SAFE_RemoveSupreView(self.view_topPanel.btn_right);
    
    self.view_topPanel.str_title = multiLanguage(@"MY BOOKING");
    view_manageBookingForUser = (FGManageBookingViewForUser *)[[[NSBundle mainBundle] loadNibNamed:@"FGManageBookingViewForUser" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_manageBookingForUser];
    CGRect frame             = self.view_topPanel.frame;
    view_manageBookingForUser.frame = CGRectMake(0, frame.size.height, view_manageBookingForUser.frame.size.width, view_manageBookingForUser.frame.size.height);
    [self.view addSubview:view_manageBookingForUser];
    view_manageBookingForUser.delegate = self;
    enum_section _status = _bool_isFromPush ? [_dic_info[@"type"] integerValue] : SECTION_PENDING;
    [self.view_manageBookingForUser setupManageBookingStatus:_status];
    _bool_isFromPush = NO;

  } else {
    
    self.view_topPanel.str_title = multiLanguage(@"MANAGE BOOKING");
    self.view_topPanel.iv_right.image = [UIImage imageNamed:@"calendar.png"];
    
    view_manageBookingForTrainer = (FGManageBookingViewForTrainer *)[[[NSBundle mainBundle] loadNibNamed:@"FGManageBookingViewForTrainer" owner:nil options:nil] objectAtIndex:0];
    view_manageBookingForTrainer.delegate = self;
    view_manageBookingForTrainer.str_id = self.str_id;
    [commond useDefaultRatioToScaleView:view_manageBookingForTrainer];
    CGRect frame             = self.view_topPanel.frame;
    view_manageBookingForTrainer.frame = CGRectMake(0, frame.size.height, view_manageBookingForTrainer.frame.size.width, view_manageBookingForTrainer.frame.size.height);
    [self.view addSubview:view_manageBookingForTrainer];
    
    enum_section _status = _bool_isFromPush ? [_dic_info[@"type"] integerValue] : SECTION_PENDING;
    [self.view_manageBookingForTrainer setupManageBookingStatus:_status];
    _bool_isFromPush = NO;
  }
}

- (void)refreshBookingWithInfo:(NSDictionary *)_dic_pushInfo {
  if ([commond isUser]) {
    [self.view_manageBookingForUser beginRefreshFromPushWithInfo:_dic_pushInfo];
  } else {
    [self.view_manageBookingForTrainer beginRefreshFromPushWithInfo:_dic_pushInfo];
  }
}

#pragma mark - FGManageBookingViewForUserDelegate
- (void)didRebookCourseWithTrainerId:(NSString *)_str_trainerId {
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGMyCalendarViewController *vc_booking = [[FGMyCalendarViewController alloc] initWithNibName:@"FGMyCalendarViewController" bundle:nil withId:_str_trainerId];
  [manager pushController:vc_booking navigationController:nav_current];
}

- (void)didFeedbackWithTrainerInfo:(NSDictionary *)_dic_trainerInfo{
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGFeedBackForTrainerViewController *vc_feedbackForTrianer = [[FGFeedBackForTrainerViewController alloc] initWithNibName:@"FGFeedBackForTrainerViewController" bundle:nil withTrainerInfo:_dic_trainerInfo];
  [manager pushController:vc_feedbackForTrianer navigationController:nav_current];
}

- (void)didGoToFindTrainerMapView {
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGLocationFindATrainerViewController *vc_feedbackForTrianer = [[FGLocationFindATrainerViewController alloc] initWithNibName:@"FGLocationFindATrainerViewController" bundle:nil];
  [manager pushController:vc_feedbackForTrianer navigationController:nav_current];
}

#pragma mark - FGManageBookingViewForTrainerDelegate
- (void)didGotoUserInfoWithUserId:(NSString *)_str_userId {
  NSLog(@"_str_userId==%@",_str_userId);
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGFriendProfileViewController *vc_profile = [[FGFriendProfileViewController alloc] initWithNibName:@"FGFriendProfileViewController" bundle:nil withFriendId:_str_userId];
  [manager pushController:vc_profile navigationController:nav_current];
}


- (void)didGotoTrainerInfoWithTrainerId:(NSString *)_str_trainerId {
  //go to trainer info
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGTrainerProfileViewController *vc_trainerProfile = [[FGTrainerProfileViewController alloc] initWithNibName:@"FGTrainerProfileViewController" bundle:nil withTrainerId:_str_trainerId];
  [manager pushController:vc_trainerProfile navigationController:nav_current];
  
}

#pragma mark - 从父类继承的
- (void)buttonAction_right:(id)_sender {
  NSString *_str_id = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGMyCalendarViewController *vc_booking = [[FGMyCalendarViewController alloc] initWithNibName:@"FGMyCalendarViewController" bundle:nil withId:_str_id];
  [manager pushController:vc_booking navigationController:nav_current];
}

- (void)receivedDataFromNetwork:(NSNotification *)_notification {
  [super receivedDataFromNetwork:_notification];
  NSMutableDictionary *_dic_requestInfo = _notification.object;
  NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
  [commond removeLoading];

  if ([commond isUser]) {
    if ([HOST(URL_LOCATION_OrderCancel) isEqualToString:_str_url]) {
      if([[_dic_requestInfo allKeys] containsObject:@"cancelOrder"])
      {
        if(self.view_manageBookingForUser) {
          [self.view_manageBookingForUser loadUIFromCancelOrder];
        }
      }
      return;
    }
    
    
    if ([HOST(URL_LOCATION_BundleList) isEqualToString:_str_url]) {
      if(self.view_manageBookingForUser) {
        [self.view_manageBookingForUser bindDataToUIForBundleWithIndex:0];
      }
      return;
    }
    if ([HOST(URL_LOCATION_CouponList) isEqualToString:_str_url]) {
      if(self.view_manageBookingForUser) {
        [self.view_manageBookingForUser bindDataToUIForBundleWithIndex:1];
      }
      return;
    }
    
    
    if ([HOST(URL_LOCATION_OrderList) isEqualToString:_str_url]) {
      if([[_dic_requestInfo allKeys] containsObject:@"userBookingForPending"])
      {
        if(self.view_manageBookingForUser)
        {
          if([[_dic_requestInfo allKeys] containsObject:@"userBookingForPending_loadMore"])
          {
            [self.view_manageBookingForUser loadMoreBookingForPending];
          }//加载更多
          else
          {
            [self.view_manageBookingForUser bindDataToUIForPending];
          }//加载最新的
        }
      }
      else if([[_dic_requestInfo allKeys] containsObject:@"userBookingForHistory"])
      {
        if(self.view_manageBookingForUser)
        {
          if([[_dic_requestInfo allKeys] containsObject:@"userBookingForHistory_loadMore"])
          {
            [self.view_manageBookingForUser loadMoreBookingForHistory];
          }//加载更多
          else
          {
            [self.view_manageBookingForUser bindDataToUIForHistory];
          }//加载最新的
        }
      }
    }
    return;
  }
  
  
  if ([HOST(URL_LOCATION_Update_OrderAccept) isEqualToString:_str_url]) {
    if([[_dic_requestInfo allKeys] containsObject:@"trainerAcceptOrderBetweenTwoCourses"])
    {
      if(self.view_manageBookingForTrainer) {
        NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_Update_OrderAccept)];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ACCEPTCOURSESUCCESS object:_dic_info];
        return;
      }
    }
  }
  
  //教练请求
  if ([HOST(URL_LOCATION_Update_OrderAccept) isEqualToString:_str_url]) {
    if([[_dic_requestInfo allKeys] containsObject:@"trainerAcceptOrder"])
    {
      if(self.view_manageBookingForTrainer) {
          [self.view_manageBookingForTrainer loadUIFromPendingToPay];
      }
    }
    return;
  }
  
  if ([HOST(URL_LOCATION_OrderCancel) isEqualToString:_str_url]) {
    if([[_dic_requestInfo allKeys] containsObject:@"cancelOrder"])
    {
      if(self.view_manageBookingForTrainer) {
        [self.view_manageBookingForTrainer loadUIFromCancelOrder];
      }
    }
    return;
  }

  
  if ([HOST(URL_LOCATION_TrainOrderList) isEqualToString:_str_url]) {
    if([[_dic_requestInfo allKeys] containsObject:@"trainerBookingForPending"])
    {
      if(self.view_manageBookingForTrainer)
      {
        if([[_dic_requestInfo allKeys] containsObject:@"trainerBookingForPending_loadMore"])
        {
          [self.view_manageBookingForTrainer loadMoreBookingForPending];
        }//加载更多
        else
        {
          [self.view_manageBookingForTrainer bindDataToUIForPending];
        }//加载最新的
      }
    }
    else if([[_dic_requestInfo allKeys] containsObject:@"trainerBookingForAccepted"])
    {
      if(self.view_manageBookingForTrainer)
      {
        if([[_dic_requestInfo allKeys] containsObject:@"trainerBookingForAccepted_loadMore"])
        {
          [self.view_manageBookingForTrainer loadMoreBookingForAccepted];
        }//加载更多
        else
        {
          [self.view_manageBookingForTrainer bindDataToUIForAccepted];
        }//加载最新的
      }
    }
    else if([[_dic_requestInfo allKeys] containsObject:@"trainerBookingForHistory"])
    {
      if(self.view_manageBookingForTrainer)
      {
        if([[_dic_requestInfo allKeys] containsObject:@"trainerBookingForHistory_loadMore"])
        {
          [self.view_manageBookingForTrainer loadMoreBookingForHistory];
        }//加载更多
        else
        {
          [self.view_manageBookingForTrainer bindDataToUIForHistory];
        }//加载最新的
      }
    }
  }
}

- (void)requestFailedFromNetwork:(NSNotification *)_notification {
  
}
@end

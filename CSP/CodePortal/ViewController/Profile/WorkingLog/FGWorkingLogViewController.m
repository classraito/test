//
//  FGWorkingLogViewController.m
//  CSP
//
//  Created by JasonLu on 16/12/6.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGWorkingLogViewController.h"

@interface FGWorkingLogViewController ()

@end

@implementation FGWorkingLogViewController
@synthesize view_workinglog;
@synthesize str_id;
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
  self.view_topPanel.str_title = multiLanguage(@"WORKOUT LOG");

  [self hideBottomPanelWithAnimtaion:NO];
  [self internalInitalViewController];
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
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

- (void)internalInitalViewController {
  if (self.view_workinglog == nil) {
    view_workinglog = (FGWorkingLogView *)[[[NSBundle mainBundle] loadNibNamed:@"FGWorkingLogView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_workinglog];
    CGRect frame           = self.view_topPanel.frame;
    view_workinglog.frame = CGRectMake(0, frame.size.height, view_workinglog.frame.size.width, view_workinglog.frame.size.height);
    [self.view addSubview:view_workinglog];
  }
  
  [self.view_workinglog beginToRefresh];
}

#pragma mark - 从父类继承的
- (void)buttonAction_right:(id)_sender {
}

- (void)receivedDataFromNetwork:(NSNotification *)_notification {
  [super receivedDataFromNetwork:_notification];
  NSMutableDictionary *_dic_requestInfo = _notification.object;
  NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
  [commond removeLoading];
//  // 验证码请求
  if ([HOST(URL_PROFILE_WorkoutReport) isEqualToString:_str_url]){
    NSString *_str_type = _dic_requestInfo[@"reportType"];
    if ([_str_type isEqualToString:@"week"]) {
      if([[_dic_requestInfo allKeys] containsObject:@"loadMore"])
      {
        [self.view_workinglog loadMoreWorkoutLogsForWeek];
      }
      else
      {
        [self.view_workinglog bindDataToUIForWeekAtIndex:0];
      }
    } else if ([_str_type isEqualToString:@"month"]) {
      if([[_dic_requestInfo allKeys] containsObject:@"loadMore"])
      {
        [self.view_workinglog loadMoreWorkoutLogsForMonth];
      }
      else
      {
        [self.view_workinglog bindDataToUIForMonthAtIndex:0];
      }
    }
    return;
  }
  
  if ([HOST(URL_PROFILE_WorkoutDailyReport) isEqualToString:_str_url]){
    if([[_dic_requestInfo allKeys] containsObject:@"loadMore"])
    {
      [self.view_workinglog loadMoreWorkoutLogsForTotal];
    }
    else
    {
      [self.view_workinglog bindDataToUIForTotal];
    }
  }
}

- (void)requestFailedFromNetwork:(NSNotification *)_notification {
}
@end

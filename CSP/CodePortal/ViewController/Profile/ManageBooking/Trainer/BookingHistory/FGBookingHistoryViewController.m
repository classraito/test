//
//  FGBookingHistoryViewController.m
//  CSP
//
//  Created by JasonLu on 16/11/15.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBookingHistoryViewController.h"
#import "FGBookingHistroyView.h"

@interface FGBookingHistoryViewController () {
  BOOL bool_cancelSuccess;
}
#pragma mark - 属性
@property (nonatomic, strong) FGBookingHistroyView *view_bookingHistroy;
@end

@implementation FGBookingHistoryViewController
@synthesize view_bookingHistroy;
@synthesize str_orderId;
@synthesize dic_orderInfo;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withOrderDetailInfo:(id)_dic_orderInfo
{
  if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
    if (_dic_orderInfo != nil && !ISNULLObj(_dic_orderInfo)) {
      self.dic_orderInfo = _dic_orderInfo;
      self.str_orderId = [NSString stringWithFormat:@"%@",_dic_orderInfo[@"detail"][@"id"]];
    }
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  SAFE_RemoveSupreView(self.view_topPanel.btn_right);
  SAFE_RemoveSupreView(self.view_topPanel.iv_right);
  
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

- (void)internalInitalViewController {
  
  BOOL _bool_isPastTime = [self.dic_orderInfo[@"isPastTime"] boolValue];
  self.view_topPanel.str_title = _bool_isPastTime?multiLanguage(@"BOOKING HISTORY"):multiLanguage(@"BOOKING DETAIL");
  
  view_bookingHistroy = (FGBookingHistroyView *)[[[NSBundle mainBundle] loadNibNamed:@"FGBookingHistroyView" owner:nil options:nil] objectAtIndex:0];
  view_bookingHistroy.str_orderId = self.str_orderId;
  [commond useDefaultRatioToScaleView:view_bookingHistroy];
  CGRect frame             = self.view_topPanel.frame;
  view_bookingHistroy.frame = CGRectMake(0, frame.size.height, view_bookingHistroy.frame.size.width, view_bookingHistroy.frame.size.height);
  [self.view addSubview:view_bookingHistroy];
  
  [self.view_bookingHistroy loadData];
}

#pragma mark - 从父类继承的
- (void)buttonAction_left:(id)_sender {
  [super buttonAction_left:_sender];
  if (bool_cancelSuccess)
  {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATECALENDARFROMDETAIL object:nil];
  }
}

- (void)receivedDataFromNetwork:(NSNotification *)_notification {
  [super receivedDataFromNetwork:_notification];
  NSMutableDictionary *_dic_requestInfo = _notification.object;
  NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
  [commond removeLoading];
  
  if ([HOST(URL_LOCATION_OrderDetail) isEqualToString:_str_url]) {
    if([[_dic_requestInfo allKeys] containsObject:@"orderDetail"])
    {
      if(self.view_bookingHistroy) {
        [self.view_bookingHistroy bindDataToUI];
      }
    }
    return;
  }
  
  if ([HOST(URL_LOCATION_OrderCancel) isEqualToString:_str_url]) {
    if([[_dic_requestInfo allKeys] containsObject:@"cancelOrder"])
    {
      if(self.view_bookingHistroy) {
        [self.view_bookingHistroy bindDataToUIForCancelOrder];
        
        NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_OrderCancel)];
        NSInteger _int_code = [_dic_info[@"Code"] integerValue];
        if (_int_code == 0) {
          bool_cancelSuccess = YES;
        }
      }
    }
    return;
  }
}

- (void)requestFailedFromNetwork:(NSNotification *)_notification {
  
}

@end

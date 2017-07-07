//
//  FGFeedBackForTrainerViewController.m
//  CSP
//
//  Created by JasonLu on 16/12/26.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGFeedBackForTrainerViewController.h"

@interface FGFeedBackForTrainerViewController () {
  UIView *view_bg;
}

@end

@implementation FGFeedBackForTrainerViewController


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTrainerInfo:(id)_dic_info
{
  if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
    if (_dic_info != nil && !ISNULLObj(_dic_info)) {
      _dic_trainerInfo = _dic_info;
      _str_id = _dic_info[@"user"][@"UserId"];
    }
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self hideBottomPanelWithAnimtaion:NO];
  [self internalInitalView];
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
  _str_id = nil;
  _dic_trainerInfo = nil;
  _view_feedbackForTrainer = nil;
  _view_buyBundlePop = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}


- (void)internalInitalView{
  self.view_topPanel.str_title = multiLanguage(@"WRITE FEEDBACK");
  
  _view_feedbackForTrainer = (FGFeedBackForTrainerView *)[[[NSBundle mainBundle] loadNibNamed:@"FGFeedBackForTrainerView" owner:nil options:nil] objectAtIndex:0];
  
  self.view_topPanel.btn_right.hidden = NO;
  self.view_topPanel.btn_right.titleLabel.font = font(FONT_TEXT_REGULAR, 14);
  [self.view_topPanel.btn_right setTitleColor:color_homepage_black forState:UIControlStateNormal];
  [self.view_topPanel.btn_right setTitle:multiLanguage(@"Submit") forState:UIControlStateNormal];
//  [self.view_topPanel.btn_right addTarget:self action:@selector(runRequest_sendFeedback) forControlEvents:UIControlEventTouchUpInside];
  
  
  [commond useDefaultRatioToScaleView:_view_feedbackForTrainer];
  CGRect frame             = self.view_topPanel.frame;
  _view_feedbackForTrainer.frame = CGRectMake(0, frame.size.height, _view_feedbackForTrainer.frame.size.width, _view_feedbackForTrainer.frame.size.height);
  [self.view addSubview:_view_feedbackForTrainer];
  [_view_feedbackForTrainer setupByOriginalContentSize:_view_feedbackForTrainer.bounds.size];
  [self.view_feedbackForTrainer setupViewWithTrainerInfo:_dic_trainerInfo];
  
//  [self.view_feedbackForTrainer.btn_sendFeedback addTarget:self action:@selector(runRequest_sendFeedback) forControlEvents:UIControlEventTouchUpInside];
}


- (void)internalInitalBuyBundlePopViewWithBundleInfo:(NSDictionary *)_dic_bundleInfo {
  //如果没有优惠券了，弹出购买界面
  _view_buyBundlePop = (FGBuyBundlePopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGBuyBundlePopView" owner:nil options:nil] objectAtIndex:0];
  [_view_buyBundlePop setupViewWithInfo:_dic_bundleInfo];
  [commond useDefaultRatioToScaleView:_view_buyBundlePop];
  view_bg = [FGUtils getBlackBgViewWithSize:getScreenSize() withAlpha:0.8f];
  [appDelegate.window addSubview:view_bg];
  [appDelegate.window addSubview:_view_buyBundlePop];
  
  [_view_buyBundlePop.btn_done addTarget:self action:@selector(buttonAction_buyBundle:) forControlEvents:UIControlEventTouchUpInside];
  [_view_buyBundlePop.btn_cancel addTarget:self action:@selector(buttonAction_cancelBuyBundle:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 发送feedback请求
- (void)runRequest_sendFeedback {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"feedbackForTrainer" forKey:@"feedbackForTrainer"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
  NSString *_str_orderId = _dic_trainerInfo[@"orderId"];
  NSString *_str_trainerId = _str_id;
  NSString *_str_review = [self.view_feedbackForTrainer reviewContent];
  NSInteger int_rating = [self.view_feedbackForTrainer ratingCount];
  [[NetworkManager_Location sharedManager] postRequest_Locations_submitFeedback:_str_orderId trainerId:_str_trainerId rating:int_rating review:_str_review userinfo:_dic_info];
}

- (void)runReqeust_checkBundleList {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  //请求bundle数据
  [_dic_info setObject:@"bundleAfterFeedback" forKey:@"bundleAfterFeedback"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_Location sharedManager] postRequest_Locations_bundleList:_dic_info];
}

#pragma mark - 从父类继承的
- (void)buttonAction_right:(id)_sender {
  [self runRequest_sendFeedback];
//  NSString *_str_userId = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
//  FGControllerManager *manager = [FGControllerManager sharedManager];
//  FGMyCalendarViewController *vc_booking = [[FGMyCalendarViewController alloc] initWithNibName:@"FGMyCalendarViewController" bundle:nil withId:_str_userId];
//  [manager pushController:vc_booking navigationController:nav_current];
}

- (void)receivedDataFromNetwork:(NSNotification *)_notification {
  [super receivedDataFromNetwork:_notification];
  NSMutableDictionary *_dic_requestInfo = _notification.object;
  NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
  [commond removeLoading];
  
  //反馈成功还需要调用一个请求
  if ([HOST(URL_LOCATION_SubmitFeedback) isEqualToString:_str_url]) {
    if([[_dic_requestInfo allKeys] containsObject:@"feedbackForTrainer"])
    {
      if(self.view_feedbackForTrainer) {
        NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_SubmitFeedback)];
        NSInteger code = [_dic_info[@"Code"] integerValue];
        if (code == 0)
        {
            [self buttonAction_left:nil];
             //[self runReqeust_checkBundleList];//
        }
         
        
      }
    }
    return;
  }
  
  if ([HOST(URL_LOCATION_BundleList) isEqualToString:_str_url]) {
    if([[_dic_requestInfo allKeys] containsObject:@"bundleAfterFeedback"])
    {
      if(self.view_feedbackForTrainer) {
        NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_BundleList)];
       /* NSArray *_arr_bundles = _dic_info[@"Bundles"];
        if (_arr_bundles.count > 0) {
          [self buttonAction_left:nil];
          return;
        }
          [self internalInitalBuyBundlePopViewWithBundleInfo:_dic_info];*/
          [self buttonAction_left:nil];
      }
    }
  }
  
}

- (void)requestFailedFromNetwork:(NSNotification *)_notification {
  
}

#pragma mark - 按钮事件
- (void)buttonAction_buyBundle:(id)sender {
  //FIXME: GONG
  //购买优惠券
}

- (void)buttonAction_cancelBuyBundle:(id)sender {
  SAFE_RemoveSupreView(_view_buyBundlePop);
  SAFE_RemoveSupreView(view_bg);
  view_bg = nil;
  _view_buyBundlePop = nil;
  
  [self buttonAction_left:nil];
}

@end

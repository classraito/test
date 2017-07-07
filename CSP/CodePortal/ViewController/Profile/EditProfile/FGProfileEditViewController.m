//
//  FGProfileEditViewController.m
//  CSP
//
//  Created by JasonLu on 16/10/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "Global.h"
#import "FGProfileEditViewController.h"
#import "UITableView+InputPageView.h"
@interface FGProfileEditViewController () <FGProfileDetailViewDelegate>
@end
@implementation FGProfileEditViewController
@synthesize view_profileDetail;
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
  self.view_topPanel.str_title = multiLanguage(@"EDIT PROFILE");
  
  
  [self hideBottomPanelWithAnimtaion:NO];
  [self internalInitalProfileHomeView];

}

- (void)manullyFixSize {
  [super manullyFixSize];
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
  self.str_id = nil;
  self.view_profileDetail.delegate = nil;
  self.view_profileDetail = nil;
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

- (void)internalInitalProfileHomeView {
  view_profileDetail = (FGProfileDetailView *)[[[NSBundle mainBundle] loadNibNamed:@"FGProfileDetailView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:view_profileDetail];
  CGRect frame             = self.view_topPanel.frame;
  view_profileDetail.frame = CGRectMake(0, frame.size.height, view_profileDetail.frame.size.width, view_profileDetail.frame.size.height);
  [self.view addSubview:view_profileDetail];
  self.view_profileDetail.delegate = self;
  self.view_profileDetail.str_id = self.str_id;
  
  [self runRequest_getUserProfile];
}

- (void)runRequest_getUserProfile {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_User sharedManager] postRequest_GetUserProfileWithQueryId:self.str_id userinfo:_dic_info];
}

#pragma mark - 从父类继承的
- (void)buttonAction_left:(id)_sender {
  [self buttonAction_submit:nil];
}

- (void)buttonAction_right:(id)_sender {
}

- (void)receivedDataFromNetwork:(NSNotification *)_notification {
  //保存成功后返回
  [super receivedDataFromNetwork:_notification];
  NSMutableDictionary *_dic_requestInfo = _notification.object;
  NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
  [commond removeLoading];
  // 验证码请求
  if ([HOST(URL_USER_SetUserProfile) isEqualToString:_str_url]) {
    [self action_gobackWithNotification:YES];
      
      [NetworkEventTrack track:KEY_TRACK_EVENTID_PROFILE attrs:nil];//追踪 修改个人资料
    return;
  }
  
  if ([HOST(URL_USER_GetUserProfile) isEqualToString:_str_url]) {
    [self.view_profileDetail bindDataToUI];
  }
  
}

- (void)requestFailedFromNetwork:(NSNotification *)_notification {
}

#pragma mark - 按钮事件
- (void)buttonAction_submit:(id)sender {
  if ([self.view_profileDetail hasUpdatePersonInfo]) {
    if ([self.view_profileDetail isValiadteUserName]) {
      NSMutableArray *_marr_profileInfo = [self.view_profileDetail profileDetailInfo];
      //保存用户信息
      NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
      [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
      [[NetworkManager_User sharedManager] postRequest_SetUserProfile:_marr_profileInfo userinfo:_dic_info];
    } else {
      [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"WRONG USERNAME") callback:nil];
    }
  } else {
    [self action_gobackWithNotification:NO];
  }
}

- (void)action_gobackWithNotification:(BOOL)shouldNotification {
  if (shouldNotification) {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REFRESHPROFILE object:nil];
  }
  FGControllerManager *manager = [FGControllerManager sharedManager];
  [manager popViewControllerInNavigation:&nav_current animated:YES];
}

//#pragma mark - FGProfileDetailViewDelegate
//- (void)action_uploadUserIconWithImage:(UIImage *)_img {
//  [commond showLoading];
//  UIImage *imgNeedUpload = _img;
//  ASINetworkQueue *asiQueue = [[NetworkManager_UploadFile sharedManager] startUploadImages:(NSMutableArray *)@[imgNeedUpload]];
//  asiQueue.delegate = self;
//  asiQueue.requestDidFinishSelector = @selector(didFinishUploadFilesInQueue:);
//  asiQueue.requestDidFailSelector = @selector(didFailedUploadFilesInQueue:);
//}

@end

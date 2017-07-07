//
//  FGProfileViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/9/13.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "FGCircluarForUserIconButton.h"
#import "FGCircluarWithRightTitleButton.h"
#import "FGProfileHomeView.h"
#import "FGProfileInfoCellView.h"
#import "FGProfileSettingCellView.h"
#import "FGProfileViewController.h"
#import "FGWorkingLogViewController.h"
#import "Global.h"
@interface FGProfileViewController ()
#pragma mark - 属性
@property (nonatomic, strong) FGProfileHomeView *view_profileHome;
@end

@implementation FGProfileViewController
@synthesize view_profileHome;
#pragma mark - 生命周期
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  self.view_topPanel.str_title = multiLanguage(@"PROFILE");
  SAFE_RemoveSupreView(self.view_topPanel.iv_left);
  SAFE_RemoveSupreView(self.view_topPanel.btn_left);
  self.view_topPanel.iv_right.image = [UIImage imageNamed:@"addfriends.png"];
  [self.view_topPanel.btn_right addTarget:self action:@selector(buttonAction_gotoAddFriend:) forControlEvents:UIControlEventTouchUpInside];
  
  [self internalInitalProfileHomeView];
  [self setupProfileHomeViewAction];
   
}

- (void)manullyFixSize {
  [super manullyFixSize];
    
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
   [self.view_profileHome beginReresh];
  
}

- (void)dealloc {
  self.view_profileHome = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

- (void)internalInitalProfileHomeView {
  if (self.view_profileHome == nil) {
    view_profileHome = (FGProfileHomeView *)[[[NSBundle mainBundle] loadNibNamed:@"FGProfileHomeView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_profileHome];
    CGRect frame           = self.view_topPanel.frame;
    view_profileHome.frame = CGRectMake(0, frame.size.height, view_profileHome.frame.size.width, view_profileHome.frame.size.height);
    [self.view addSubview:view_profileHome];
  }
  
//  [self.view_profileHome runRequest_getUserProfile];
}

- (void)setupProfileHomeViewAction {
  FGProfileSettingCellView *settingView = [self.view_profileHome getProfileSettingViewCell];
  [settingView.btn_mybooking.btn addTarget:self action:@selector(buttonActoin_gotoMyBooking:) forControlEvents:UIControlEventTouchUpInside];
  [settingView.btn_workinglog.btn addTarget:self action:@selector(buttonActoin_gotoWorkinglog:) forControlEvents:UIControlEventTouchUpInside];
  [settingView.btn_savedworkouts.btn addTarget:self action:@selector(buttonActoin_gotoSavedworkouts:) forControlEvents:UIControlEventTouchUpInside];
  [settingView.btn_favorite.btn addTarget:self action:@selector(buttonActoin_gotoFavorite:) forControlEvents:UIControlEventTouchUpInside];
  [settingView.btn_fitnessleveltest.btn addTarget:self action:@selector(buttonActoin_gotoFitnessleveltest:) forControlEvents:UIControlEventTouchUpInside];
  [settingView.btn_setting.btn addTarget:self action:@selector(buttonActoin_gotoSetting:) forControlEvents:UIControlEventTouchUpInside];
  
  NSLog(@"profile home==%@", self.view_profileHome);
  
  FGProfileInfoCellView *cellView = [self.view_profileHome getProfileInfoViewCell];
  NSLog(@"profileInfoView==%@", cellView);
  NSLog(@"cellView.view_useIconAndname==%@", cellView.view_useIconAndname);
  NSLog(@"cellView.view_useIconAndname.btn==%@", cellView.view_useIconAndname.btn);

  [cellView.view_useIconAndname.btn addTarget:self action:@selector(buttonAction_gotoProfileDetail:) forControlEvents:UIControlEventTouchUpInside];
  
  [cellView.btn_post addTarget:self action:@selector(buttonAction_gotoPostList:) forControlEvents:UIControlEventTouchUpInside];
  [cellView.btn_follow addTarget:self action:@selector(buttonAction_gotoFollowList:) forControlEvents:UIControlEventTouchUpInside];
  [cellView.btn_follower addTarget:self action:@selector(buttonAction_gotoFollowerList:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)refreshBookingBadgeNumber {
  [self.view_profileHome refreshBookingBadgeNumber];
  [self setupProfileHomeViewAction];
}

#pragma mark - 界面跳转
- (void)buttonActoin_gotoMyBooking:(id)_sender {
  // TODO: 需要跳转
  NSLog(@"go to my booking...");
  //清除booking通知
  [commond saveBookingCntWithCnt:0];
  NSString *_str_id = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGManageBookingViewController *vc_booking = [[FGManageBookingViewController alloc] initWithNibName:@"FGManageBookingViewController" bundle:nil withId:_str_id];
  [manager pushController:vc_booking navigationController:nav_current];
}

- (void)buttonActoin_gotoWorkinglog:(id)_sender {
  // TODO: 需要跳转
  NSLog(@"go to working log...");
  NSString *_str_id = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGWorkingLogViewController *vc_workinglog = [[FGWorkingLogViewController alloc] initWithNibName:@"FGWorkingLogViewController" bundle:nil withId:_str_id];
  [manager pushController:vc_workinglog navigationController:nav_current];
}

- (void)buttonActoin_gotoSavedworkouts:(id)_sender {
  // TODO: 需要跳转
  NSLog(@"go to saved workouts...");
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGProfileSavedWorkoutViewController *vc_profile_workout = [[FGProfileSavedWorkoutViewController alloc] initWithNibName:@"FGProfileSavedWorkoutViewController" bundle:nil title:multiLanguage(@"SAVED WORKOUT")];
    [manager pushController:vc_profile_workout navigationController:nav_profile];
}

- (void)buttonActoin_gotoFavorite:(id)_sender {
  // TODO: 需要跳转
  NSLog(@"go to favorite...");
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGLocationMyGroupViewController *vc_profile_group = [[FGLocationMyGroupViewController alloc] initWithNibName:@"FGLocationMyGroupViewController" bundle:nil];
    [manager pushController:vc_profile_group navigationController:nav_current];
}//跳转到my group

- (void)buttonActoin_gotoFitnessleveltest:(id)_sender {
  // TODO: 需要跳转
  NSLog(@"go to fitness level test...");
  FGControllerManager *manager = [FGControllerManager sharedManager];
  [manager pushControllerByName:@"FGProfileFitnessLevelTestHomeViewController" inNavigation:nav_current];
}

- (void)buttonActoin_gotoSetting:(id)_sender {
  // TODO: 需要跳转
  NSLog(@"go to settting...");
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager pushControllerByName:@"FGProfileSettingsViewController" inNavigation:nav_current];
}

- (void)buttonAction_gotoProfileDetail:(id)_sender {
  // TODO: 需要跳转
  NSLog(@"go to profile detail...");
  NSString *_str_id = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGProfileEditViewController *vc_follow = [[FGProfileEditViewController alloc] initWithNibName:@"FGProfileEditViewController" bundle:nil withId:_str_id];
  [manager pushController:vc_follow navigationController:nav_current];
}

- (void)buttonAction_gotoAddFriend:(id)_sender {
  // TODO: 需要跳转
  NSLog(@"go to profile detail...");
  FGControllerManager *manager = [FGControllerManager sharedManager];
  [manager pushControllerByName:@"FGAddFriendViewController" inNavigation:nav_current];
}

- (void)buttonAction_gotoFollowList:(id)_sender {
  if ([self.view_profileHome hasNoFollowList])
    return;
  
  // TODO: 需要跳转
  NSLog(@"go to follow...");
  NSString *_str_id = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGMyFriendsViewController *vc_follow = [[FGMyFriendsViewController alloc] initWithNibName:@"FGMyFriendsViewController" bundle:nil withId:_str_id];
  [manager pushController:vc_follow navigationController:nav_current];
}

- (void)buttonAction_gotoFollowerList:(id)_sender {
  if ([self.view_profileHome hasNoFollowerList])
    return;
  // TODO: 需要跳转
  NSLog(@"go to follower...");
  NSString *_str_id = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGMyFollowerViewController *vc_follow = [[FGMyFollowerViewController alloc] initWithNibName:@"FGMyFollowerViewController" bundle:nil withId:_str_id];
  [manager pushController:vc_follow navigationController:nav_current];
  
}

- (void)buttonAction_gotoPostList:(id)_sender {
  if ([self.view_profileHome hasNoPostList])
    return;
  // TODO: 需要跳转
  NSLog(@"go to post...");
  [self.view_profileHome gotoProfilePost];
}


#pragma mark - 从父类继承的
- (void)buttonAction_left:(id)_sender {
    
}

- (void)buttonAction_right:(id)_sender {
    
}

- (void)receivedDataFromNetwork:(NSNotification *)_notification {
  [super receivedDataFromNetwork:_notification];
  NSMutableDictionary *_dic_requestInfo = _notification.object;
  NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
  [commond removeLoading];
  // 验证码请求
  if ([HOST(URL_PROFILE_ProfilePage) isEqualToString:_str_url] &&
      !ISNULLObj(_dic_requestInfo[@"userId"])) {
    [view_profileHome bindDataToUI];
    [self setupProfileHomeViewAction];
  }
  
  if ([HOST(URL_POST_GetPostList) isEqualToString:_str_url]) {
    if([[_dic_requestInfo allKeys] containsObject:@"Filter"])
    {
      NSString *_str_filter  = [_dic_requestInfo objectForKey:@"Filter"];
      if([@"@" isEqualToString:_str_filter])
      {
        if(self.view_profileHome)
        {
          if([[_dic_requestInfo allKeys] containsObject:@"GetPost_loadMore"])
          {
            [self.view_profileHome loadMorePosts];
          }
          else
          {
            [self.view_profileHome bindDataToUI];
          }
            
        }
      }
    }//我和我跟随的Post
  }
    
    if ([HOST(URL_POST_SetPostLike) isEqualToString:_str_url])
    {
        NSString *_str_postId = [_dic_requestInfo objectForKey:@"SetLike_PostId"];
        BOOL isLike = [[_dic_requestInfo objectForKey:@"IsLike"] boolValue];
        int likes = [[_dic_requestInfo objectForKey:@"Like"] intValue];
        [self.view_profileHome updateLikeStatusByPostId:_str_postId isLike:isLike likes:likes];
    }
    
    if([HOST(URL_POST_DeletePost) isEqualToString:_str_url])
    {
        if(view_profileHome)
        {
           // [view_profileHome afterDeletePost];
        }
    }
}

- (void)requestFailedFromNetwork:(NSNotification *)_notification {
    
}
@end

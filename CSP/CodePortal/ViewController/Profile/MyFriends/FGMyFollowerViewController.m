//
//  FGMyFollowerViewController.m
//  CSP
//
//  Created by JasonLu on 16/11/15.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGMyFollowerViewController.h"
@interface FGMyFollowerViewController () <FGMyFriendsListViewDelegate>
@property (nonatomic, copy) NSString *str_id;
@end

@implementation FGMyFollowerViewController
@synthesize str_id;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(id)_str_id{
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
  self.view_topPanel.str_title = multiLanguage(@"MY FOLLOWER");
  SAFE_RemoveSupreView(self.view_topPanel.iv_right);
  SAFE_RemoveSupreView(self.view_topPanel.btn_right);
  
  [self hideBottomPanelWithAnimtaion:NO];
  [self internalInitalMyFriendsView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setWhiteBGStyle];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)manullyFixSize {
  [super manullyFixSize];
}

- (void)dealloc {
  self.view_myFriendsList = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

- (void)internalInitalMyFriendsView {
  self.view_myFriendsList          = (FGMyFriendsListView *)[[[NSBundle mainBundle] loadNibNamed:@"FGMyFriendsListView" owner:nil options:nil] objectAtIndex:0];
  self.view_myFriendsList.delegate = self;
  [commond useDefaultRatioToScaleView:self.view_myFriendsList];
  CGRect frame             = self.view_topPanel.frame;
  self.view_myFriendsList.frame = CGRectMake(0, frame.size.height, self.view_myFriendsList.frame.size.width, self.view_myFriendsList.frame.size.height);
  [self.view addSubview:self.view_myFriendsList];
  self.view_myFriendsList.followType = Friends_Follower;
  
  [self runRequest_GetFollowerList];
}

- (void)runRequest_GetFollowerList {
  [self.view_myFriendsList postRequest_getUserList_followerWithId:self.str_id];
}

- (void)receivedDataFromNetwork:(NSNotification *)_notification {
  NSMutableDictionary *_dic_requestInfo = _notification.object;
  NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
  [commond removeLoading];
  // 验证码请求
  if ([HOST(URL_USER_GetUserList) isEqualToString:_str_url]) {
    if([[_dic_requestInfo allKeys] containsObject:@"loadMore"])
    {
      [self.view_myFriendsList loadMoreUsers];
    }//加载更多
    else
    {
      [self.view_myFriendsList bindDataToUI];
    }//加载最新的
  }
}

#pragma mark - FGMyFriendsListViewDelegate
- (void)buttonAction_selectWithFriend:(id)friend {
  NSLog(@"friend obj==%@", friend);
  
//  FGControllerManager *manager = [FGControllerManager sharedManager];
//  [manager pushControllerByName:@"FGFriendProfileViewController" inNavigation:nav_current];
  
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGFriendProfileViewController *vc_FriendProfile = [[FGFriendProfileViewController alloc] initWithNibName:@"FGFriendProfileViewController" bundle:nil withFriendId:friend[@"id"]];
  [manager pushController:vc_FriendProfile navigationController:nav_current];
  
}
@end

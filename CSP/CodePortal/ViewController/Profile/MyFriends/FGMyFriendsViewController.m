//
//  FGMyFriendsViewController.m
//  CSP
//
//  Created by JasonLu on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGMyFriendsListView.h"
#import "FGMyFriendsViewController.h"
@interface FGMyFriendsViewController () <FGMyFriendsListViewDelegate>
@property (nonatomic, copy) NSString * str_id;
@end

@implementation FGMyFriendsViewController
@synthesize str_id;
@synthesize view_myFriendsList;
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
  self.view_topPanel.str_title = multiLanguage(@"MY FOLLOW");
  SAFE_RemoveSupreView(self.view_topPanel.iv_right);
  SAFE_RemoveSupreView(self.view_topPanel.btn_right);

  [self hideBottomPanelWithAnimtaion:NO];
  [self internalInitalMyFriendsView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setWhiteBGStyle];
  
  [self runRequest_GetFollowList];
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
  view_myFriendsList          = (FGMyFriendsListView *)[[[NSBundle mainBundle] loadNibNamed:@"FGMyFriendsListView" owner:nil options:nil] objectAtIndex:0];
  view_myFriendsList.delegate = self;
  [commond useDefaultRatioToScaleView:view_myFriendsList];
  CGRect frame             = self.view_topPanel.frame;
  view_myFriendsList.frame = CGRectMake(0, frame.size.height, view_myFriendsList.frame.size.width, view_myFriendsList.frame.size.height);
  [self.view addSubview:view_myFriendsList];
  view_myFriendsList.followType = Friends_Follow;
}

//获取follow列表
- (void)runRequest_GetFollowList {
  self.view_myFriendsList.cursor = 0;
  [view_myFriendsList postRequest_getUserList_followWithId:self.str_id];
}

#pragma mark - 从父类继承的
//- (void)buttonAction_left:(id)_sender {
//}
//
//- (void)buttonAction_right:(id)_sender {
//}

- (void)receivedDataFromNetwork:(NSNotification *)_notification {
  [super receivedDataFromNetwork:_notification];
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
  
  if ([HOST(URL_POST_SetFollow) isEqualToString:_str_url]) {
    if([[_dic_requestInfo allKeys] containsObject:@"friendList"])
    {
      //成功取消关注就需要刷新列表
      [self.view_myFriendsList refreshMyFollowList];
      
      NSMutableDictionary *_dic_attrs = [NSMutableDictionary dictionaryWithCapacity:1];
      [_dic_attrs setObject:_dic_requestInfo[@"userid"] forKey:KEY_TRACK_ATTRID_ADDFRIEND_FRIENDID];
      [NetworkEventTrack track:KEY_TRACK_EVENTID_ADDFRIEND attrs:_dic_attrs];
    }
  }
  
  
  /*
  if ([HOST(URL_POST_GetFollowList) isEqualToString:_str_url]) {
    if(![[_dic_requestInfo allKeys] containsObject:@"Filter"])
    {
      if(self.view_profileHome)
      {
        if([[_dic_requestInfo allKeys] containsObject:@"AllPost_loadMore"])
        {
          [self.view_profileHome loadMorePosts];
        }//加载更多
        else
        {
          [self.view_profileHome bindDataToUI];
        }//加载最新的
      }
    }//不筛选Post
    else
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
  */
}

- (void)requestFailedFromNetwork:(NSNotification *)_notification {
}

#pragma mark - FGMyFriendsListViewDelegate
- (void)buttonAction_selectWithFriend:(id)friend {
  NSLog(@"friend obj==%@", friend);
  
  FGControllerManager *manager = [FGControllerManager sharedManager];
  
  FGFriendProfileViewController *vc_FriendProfile = [[FGFriendProfileViewController alloc] initWithNibName:@"FGFriendProfileViewController" bundle:nil withFriendId:friend[@"id"]];
  [manager pushController:vc_FriendProfile navigationController:nav_current];
}
@end

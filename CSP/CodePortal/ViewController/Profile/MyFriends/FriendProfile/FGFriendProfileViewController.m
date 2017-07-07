//
//  FGFriendProfileViewController.m
//  CSP
//
//  Created by JasonLu on 16/10/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCircluarWithRightButton.h"
#import "FGFriendProfileView.h"
#import "FGFriendProfileViewController.h"
#import "FGUserProfileInfoCellView.h"
@interface FGFriendProfileViewController ()
@property (nonatomic, strong) FGFriendProfileView *view_friendProfile;
@property (nonatomic, copy) NSString *str_friendId;
@end

@implementation FGFriendProfileViewController
@synthesize view_friendProfile;
@synthesize str_friendId;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withFriendId:(id)_str_friendId
{
  if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
    if (_str_friendId != nil && !ISNULLObj(_str_friendId)) {
      self.str_friendId = _str_friendId;
    }
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  SAFE_RemoveSupreView(self.view_topPanel.iv_right);
  SAFE_RemoveSupreView(self.view_topPanel.btn_right);
  self.view_topPanel.str_title = multiLanguage(@"USER PROFILE");

  [self internalInitalViewCtrl];
  [self hideBottomPanelWithAnimtaion:NO];
  [self setupFriendProfileAction];
    
   
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
        
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setWhiteBGStyle];
   [self.view_friendProfile beginRefresh];
  
}

- (void)dealloc {
  [self.view_friendProfile.tb_friendProfile setRefreshFooter:nil];
  self.view_friendProfile     = nil;
  self.str_friendId       = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

- (void)internalInitalViewCtrl {
  view_friendProfile = (FGFriendProfileView *)[[[NSBundle mainBundle] loadNibNamed:@"FGFriendProfileView" owner:nil options:nil] objectAtIndex:0];
  view_friendProfile.str_friendId = str_friendId;
  [commond useDefaultRatioToScaleView:view_friendProfile];
  CGRect frame             = self.view_topPanel.frame;
  view_friendProfile.frame = CGRectMake(0, frame.size.height, view_friendProfile.frame.size.width, view_friendProfile.frame.size.height);
  [self.view addSubview:view_friendProfile];
}

- (void)setupFriendProfileAction {
  FGUserProfileInfoCellView *cellView = [view_friendProfile getUserProfileViewCell];
  [cellView.btn_addFriend addTarget:self action:@selector(buttonAction_addUserToFriend) forControlEvents:UIControlEventTouchUpInside];
  
  [cellView.btn_post addTarget:self action:@selector(buttonAction_gotoPostList:) forControlEvents:UIControlEventTouchUpInside];
  [cellView.btn_follow addTarget:self action:@selector(buttonAction_gotoFollowList:) forControlEvents:UIControlEventTouchUpInside];
  [cellView.btn_follower addTarget:self action:@selector(buttonAction_gotoFollowerList:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonAction_gotoPostList:(id)_sender {
  if ([self.view_friendProfile hasNoPostList])
    return;
  // TODO: 需要跳转
  NSLog(@"go to post...");
  [self.view_friendProfile gotoProfilePost];
}

- (void)buttonAction_gotoFollowList:(id)_sender {
  if ([self.view_friendProfile hasNoFollowList])
    return;
  // TODO: 需要跳转
  NSLog(@"go to follow...");
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGMyFriendsViewController *vc_follow = [[FGMyFriendsViewController alloc] initWithNibName:@"FGMyFriendsViewController" bundle:nil withId:str_friendId];
  [manager pushController:vc_follow navigationController:nav_current];
}

- (void)buttonAction_gotoFollowerList:(id)_sender {
  if ([self.view_friendProfile hasNoFollowerList])
    return;
  // TODO: 需要跳转
  NSLog(@"go to follower...");
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGMyFollowerViewController *vc_follow = [[FGMyFollowerViewController alloc] initWithNibName:@"FGMyFollowerViewController" bundle:nil withId:str_friendId];
  [manager pushController:vc_follow navigationController:nav_current];
}

- (void)buttonAction_addUserToFriend {
  NSLog(@"add friend...with fired id: %@", str_friendId);
  NSLog(@"follow==%d", self.view_friendProfile.bool_isFollow);
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
  [_dic_info setObject:str_friendId forKey:@"userid"];
    [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];//指定了只能由当前viewController接收当前请求的数据
  //添加关注或许取消关注
  [[NetworkManager_Post sharedManager] postRequest_setFollow:str_friendId isFollow:!self.view_friendProfile.bool_isFollow userinfo:_dic_info];
}

#pragma mark - 从父类继承的
- (void)buttonAction_left:(id)_sender {
  [super buttonAction_left:_sender];
}

- (void)buttonAction_right:(id)_sender {
}

- (void)receivedDataFromNetwork:(NSNotification *)_notification {
  [super receivedDataFromNetwork:_notification];
  NSMutableDictionary *_dic_requestInfo = _notification.object;
  NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
  
  if ([HOST(URL_PROFILE_ProfilePage) isEqualToString:_str_url] &&
      !ISNULLObj(_dic_requestInfo[@"friendId"])) {
    [self.view_friendProfile bindDataToUI];
    return;
  }
  
  if ([HOST(URL_POST_SetFollow) isEqualToString:_str_url]) {
    [self.view_friendProfile refreshFollowStatus];
    [self setupFriendProfileAction];
    
    
    NSMutableDictionary *_dic_attrs = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_attrs setObject:_dic_requestInfo[@"userid"] forKey:KEY_TRACK_ATTRID_ADDFRIEND_FRIENDID];
    [NetworkEventTrack track:KEY_TRACK_EVENTID_ADDFRIEND attrs:_dic_attrs];
  }
  
  if ([HOST(URL_POST_GetPostList) isEqualToString:_str_url]) {
    if([[_dic_requestInfo allKeys] containsObject:@"Filter"])
    {
      NSString *_str_filter  = [_dic_requestInfo objectForKey:@"Filter"];
      NSString * _str_friendId = str_friendId;
      if([_str_friendId isEqualToString:_str_filter])
      {
        if(self.view_friendProfile)
        {
          if([[_dic_requestInfo allKeys] containsObject:@"GetPost_loadMore"])
          {
            [self.view_friendProfile loadMorePosts];
          }
          else if([[_dic_requestInfo allKeys] containsObject:@"GetPost_reload"])
          {
              [self.view_friendProfile reloadPosts];
          }
          else
          {
            [self.view_friendProfile bindDataToUI];
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
        [self.view_friendProfile updateLikeStatusByPostId:_str_postId isLike:isLike likes:likes];
    }
    
    if([HOST(URL_POST_DeletePost) isEqualToString:_str_url])
    {
        if(view_friendProfile)
        {
            [view_friendProfile afterDeletePost];
        }
    }
}

- (void)requestFailedFromNetwork:(NSNotification *)_notification {
}

@end

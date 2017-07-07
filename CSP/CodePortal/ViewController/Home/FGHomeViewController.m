//
//  FGHomeViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/9/12.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
//#import "FGSNSManager.h"

#import "FGSeeMoreForSearchResultViewController.h"
#import "FGCustomSearchView+SearchModel.h"
#import "FGHomeViewController.h"
#import "FGHomepageSearchResultView.h"
#import "FGHomepageView.h"
#import "FGSearchResultView.h"
#import "UIScrollView+FGRereshFooter.h"
#import "FGTrainingDetailViewController.h"
#import "FGNewsInfoViewController.h"
#import "FGTrainerProfileViewController.h"

@interface FGHomeViewController () <FGCustomSearchViewDelegate, FGHomepageSearchResultViewDelegate , FGSearchResultViewDelegate , FGHomepageViewDelegate> {
}
#pragma mark - 属性
@property (nonatomic, strong) FGHomepageView *view_homepage;
@property (nonatomic, strong) FGSearchResultView *view_search;
@property (nonatomic, strong) FGHomepageSearchResultView *view_searchResult;

@end

@implementation FGHomeViewController
@synthesize view_homepage;
@synthesize view_search;
@synthesize view_searchResult;
#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (view_searchResult != nil) {
    [self.view bringSubviewToFront:self.view_searchResult];
  }
  
  if (view_homepage) {
    [view_homepage.tb_homepage triggerRecoveryAnimationIfNeeded];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
    FGControllerManager *manager = [FGControllerManager sharedManager];
    manager.currentNavigationStatus = NavigationStatus_Home;
  // Do any additional setup after loading the view from its nib.
  self.view_topPanel.iv_left.image  = [UIImage imageNamed:@"WE-BOX-FIT.png"];
  self.view_topPanel.iv_left.contentMode = UIViewContentModeScaleAspectFill;
  self.view_topPanel.iv_right.image = [UIImage imageNamed:@"addfriends.png"];
  [self.view_topPanel.btn_right addTarget:self action:@selector(buttonAction_gotoAddFrideds) forControlEvents:UIControlEventTouchUpInside];
  self.view_topPanel.cs_search.hidden = NO;
  [self.view_topPanel.cs_search
   setupByBGColor:[UIColor clearColor]
   borderColor:rgba(255, 255, 255, .5)
   roundRadius:self.view_topPanel.cs_search.view_bg.frame.size.height / 2
   borderWidth:1
   placeHolderColor:rgba(255, 255, 255, .5)
   placeHolderFont:font(FONT_TEXT_REGULAR, 17)];
  self.view_topPanel.cs_search.delegate           = self;
  self.view_topPanel.cs_search.tf_search.font     = font(FONT_TEXT_REGULAR, 17);
  self.view_topPanel.cs_search.tf_search.delegate = self;
  
  [self internalInitalHomepageView];
}

- (void)manullyFixSize {
  [super manullyFixSize];
}

- (void)dealloc {
  [self.view_homepage.tb_homepage setRefreshFooter:nil];
  self.view_homepage     = nil;
  self.view_search       = nil;
  self.view_searchResult = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - home view相关
- (void)internalInitalHomepageView {
  if (view_homepage == nil) {
    view_homepage = (FGHomepageView *)[[[NSBundle mainBundle] loadNibNamed:@"FGHomepageView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_homepage];
    CGRect frame        = self.view_topPanel.frame;
    view_homepage.frame = CGRectMake(0, frame.size.height, view_homepage.frame.size.width, view_homepage.frame.size.height);
    [self.view addSubview:view_homepage];
    view_homepage.delegate = self;
  }
  
 [self runRequest_getHomePageInfo];
}

- (void)updateTopRightButtonWithHidden:(BOOL)_bool_hidden {
  self.view_topPanel.iv_right.hidden = _bool_hidden;
  self.view_topPanel.btn_right.hidden = _bool_hidden;
}

#pragma mark - search view相关
- (void)internalInitalHomeSearchView {
  [self clearSearchView];
  view_search = (FGSearchResultView *)[[[NSBundle mainBundle] loadNibNamed:@"FGSearchResultView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:view_search];
  view_search.delegate = self;
  CGRect searchFrame = self.view_topPanel.cs_search.frame;
  [self.view_topPanel.cs_search setupSearchModelWithFrame:CGRectMake(0, searchFrame.origin.y, 320 * ratioW, searchFrame.size.height) padding:UIEdgeInsetsMake(0, 12, 0, 60) searchCancleButtonTitle:multiLanguage(@"Cancel") withAnimated:YES];
  self.view_search.frame                             = CGRectMake(0, self.view_homepage.frame.origin.y, self.view_search.frame.size.width, H - self.view_homepage.frame.origin.y - 44);
  self.view_topPanel.cs_search.tf_search.placeholder = multiLanguage(@"Search workout/trainer/news");
  [self.view addSubview:self.view_search];
  [self.view_search bindDataToUI];
  
  [self updateTopRightButtonWithHidden:YES];
}

- (void)runRequest_getHomePageInfo {
  [[NetworkManager_Home sharedManager] postRequest_Home_getHomePage:nil];
}

- (void)removeSearchView {
  self.view_topPanel.cs_search.tf_search.placeholder = multiLanguage(@"Search");
  self.view_topPanel.cs_search.tf_search.text        = @"";
  [self.view_search removeFromSuperview];
  [self.view_searchResult removeFromSuperview];
  
  [self updateTopRightButtonWithHidden:NO];
}

- (void)didSelectedWithResult:(NSString *)_str_key {
  [self action_clickSearchWithKey:_str_key];
  self.view_topPanel.cs_search.tf_search.text        = _str_key;
}

- (void)clearSearchView {
  [self.view_search removeFromSuperview];
  self.view_search = nil;
}
#pragma mark - search result view相关
- (void)internalInitalHomeSearchResultView {
  [self clearSearchResultView];
  
  view_searchResult = (FGHomepageSearchResultView *)[[[NSBundle mainBundle] loadNibNamed:@"FGHomepageSearchResultView" owner:nil options:nil] objectAtIndex:0];
  self.view_searchResult.frame = CGRectMake(0, 62, self.view_searchResult.frame.size.width, self.view_searchResult.frame.size.height);
  [commond useDefaultRatioToScaleView:view_searchResult];
  
  [view_search.tb_serachResult resetNoResultView];
  view_searchResult.delegate = self;
  [self.view addSubview:self.view_searchResult];
}

- (void)clearSearchResultView {
  [self.view_searchResult removeFromSuperview];
  self.view_searchResult = nil;
}

#pragma mark - 从父类继承的
- (void)buttonAction_left:(id)_sender {
//  [[FGSNSManager shareInstance] actionToShareInviateCodeOnView:self.view title:share_inviationCode_title text:[NSString stringWithFormat:@"%@;%@;%@%@",share_inviationCode_content1,share_inviationCode_content2,multiLanguage(@"Invitation code:"), @"L40F288444"] url:share_inviationCode_link inviateCode:nil];
}

- (void)buttonAction_right:(id)_sender {
}

- (void)receivedDataFromNetwork:(NSNotification *)_notification {
  [super receivedDataFromNetwork:_notification];
  NSMutableDictionary *_dic_requestInfo = _notification.object;
  NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
  
  
  if ([HOST(URL_GetCityList) isEqualToString:_str_url]) {
    [self.view_homepage bindDataToUI];
  }
  else if ([HOST(URL_HOME_HomePage) isEqualToString:_str_url]){
    [self.view_homepage bindDataToUI];
  }
  else if ([HOST(URL_HOME_HomeSearch) isEqualToString:_str_url]) {
    [self.view_searchResult bindDataToUI];
  }
  else if ([HOST(URL_HOME_NewsFeeds) isEqualToString:_str_url]) {
    [self.view_homepage loadMoreNews];
  }
}

- (void)requestFailedFromNetwork:(NSNotification *)_notification {
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  [self internalInitalHomeSearchView];
  return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  //  [textField resignFirstResponder];
  
  //保存搜索关键字
  NSLog(@"===search keys===");
  NSLog(@"keys: %@",[FGUtils searchKeys]);
  [FGUtils saveSeachKeyWithString:textField.text];
  NSLog(@"======");
  
  [self action_clickSearchWithKey:textField.text];
  
  return YES;
}

- (void)action_clickSearchWithKey:(NSString *)_str_key {
  
  [commond dismissKeyboard:self.view];
  
  [self.view_topPanel.cs_search searchDidSearch];
  [self internalInitalHomeSearchResultView];
  
  //请求网络数据
  [[NetworkManager_Home sharedManager] postRequest_Home_homeSearch:_str_key count:10 userinfo:nil];
  
}
#pragma mark - 其他事件
- (void)buttonAction_gotoAddFrideds {
  FGControllerManager *manager = [FGControllerManager sharedManager];
  [manager pushControllerByName:@"FGAddFriendViewController" inNavigation:nav_current];
}

#pragma mark - FGCustomSearchViewDelegate
- (void)searchDidCancle {
  [self removeSearchView];
}

#pragma mark - FGHomepageSearchResultViewDelegate
- (void)selectSearchResultWithInfo:(NSDictionary *)_info {
  NSLog(@"go to detail info===%@", _info);
  NSString * _str_title = _info[@"title"];
  if ([_str_title isEqualToString:@"workouts"]) {
    NSString *_workoutId = _info[@"trainingId"];
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGTrainingDetailViewController *vc_trainingDetail = [[FGTrainingDetailViewController alloc] initWithNibName:@"FGTrainingDetailViewController" bundle:nil workoutID:_workoutId];
    [manager pushController:vc_trainingDetail navigationController:nav_current];
  }
  else if ([_str_title isEqualToString:@"newsfeed"]) {
    //go to web
    NSString *_link = _info[@"link"];
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGNewsInfoViewController *vc_newsInfo = [[FGNewsInfoViewController alloc] initWithNibName:@"FGNewsInfoViewController" bundle:nil withInfo:_link];
    [manager pushController:vc_newsInfo navigationController:nav_current];
    
  } else if ([_str_title isEqualToString:@"trainer"]) {
    //go to detail
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGTrainerProfileViewController *vc_trainerProfile = [[FGTrainerProfileViewController alloc] initWithNibName:@"FGTrainerProfileViewController" bundle:nil withInfo:_info];
    [manager pushController:vc_trainerProfile navigationController:nav_current];
    
  } else if ([_str_title isEqualToString:@"user"]) {
      NSLog(@"_info = %@",_info);
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGFriendProfileViewController *vc_friendProfile = [[FGFriendProfileViewController alloc] initWithNibName:@"FGFriendProfileViewController" bundle:nil withFriendId:_info[@"id"]];
    [manager pushController:vc_friendProfile navigationController:nav_current];
  
  } else if ([_str_title isEqualToString:@"topic"]) {
      NSString *_str_topicId = [NSString stringWithFormat:@"%@",[_info objectForKey:@"id"]];
      NSString *_str_title = [_info objectForKey:@"title"];
      FGTopicViewController *vc_topic = [[FGTopicViewController alloc] initWithNibName:@"FGTopicViewController" bundle:nil topicId:_str_topicId topicName:_str_title];
      FGControllerManager *manager = [FGControllerManager sharedManager];
      [manager pushController:vc_topic navigationController:nav_current];
  }
  
}

#pragma mark - FGHomepageViewDelegate
-(void)didClickWithViewControllerName:(NSString *)name withInfo:(id)obj{
  if ([name isEqualToString:@"FGHomepageFeaturedUserListViewController"]) {
      
      if(![appDelegate isLoggedIn])
      {
          [commond showAskForLogin];
          return;
      }

    FGControllerManager *manager = [FGControllerManager sharedManager];
    manager.currentNavigationStatus = NavigationStatus_Post;
    [manager initNavigation:&nav_post rootControllerName:@"FGPostViewController"];
  } else if ([name isEqualToString:@"FGHomeWorkoutsListViewController"]) {
    FGControllerManager *manager = [FGControllerManager sharedManager];
    manager.currentNavigationStatus = NavigationStatus_Training;
    [manager initNavigation:&nav_training rootControllerName:@"FGTrainingViewController"];
  } else if ([name isEqualToString:@"FGFriendProfileViewController"]){
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGFriendProfileViewController *vc_FriendProfile = [[FGFriendProfileViewController alloc] initWithNibName:@"FGFriendProfileViewController" bundle:nil withFriendId:obj[@"id"]];
    [manager pushController:vc_FriendProfile navigationController:nav_current];
  } else if ([name isEqualToString:@"FGTrainingDetailViewController"]) {
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGTrainingDetailViewController *vc_trainingDetail = [[FGTrainingDetailViewController alloc] initWithNibName:@"FGTrainingDetailViewController" bundle:nil workoutID:(NSString *)obj];
    [manager pushController:vc_trainingDetail navigationController:nav_current];
  }
  else if ([name isEqualToString:@"FGNewsInfoViewController"]) {
    NSDictionary *_dic_ = (NSDictionary *)obj;
    NSString *_link = _dic_[@"link"];
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGNewsInfoViewController *vc_newsInfo = [[FGNewsInfoViewController alloc] initWithNibName:@"FGNewsInfoViewController" bundle:nil withInfo:_link];
    [manager pushController:vc_newsInfo navigationController:nav_current];
  }
}

- (void)action_gotoSeeMoreInfoWithSection:(NSString *)_str_section {
  NSLog(@"see more info: %@", _str_section);
  
  //go to see more view controller
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGSeeMoreForSearchResultViewController *_vc = [[FGSeeMoreForSearchResultViewController alloc] initWithNibName:@"FGSeeMoreForSearchResultViewController" bundle:nil withInfo:@{@"title":_str_section}];
  [manager pushController:_vc navigationController:nav_current];
  
  
}
@end

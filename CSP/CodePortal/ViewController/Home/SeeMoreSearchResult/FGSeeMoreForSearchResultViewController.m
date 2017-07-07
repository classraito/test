//
//  FGSeeMoreForSearchResultViewController.m
//  CSP
//
//  Created by JasonLu on 17/1/24.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGSeeMoreForSearchResultViewController.h"
#import "FGMoreResultsView.h"

@interface FGSeeMoreForSearchResultViewController () <FGMoreResultsViewDelegate> {
}
@property (nonatomic, strong) FGMoreResultsView *view_moreSearchReuslt;
@property (nonatomic, strong) NSDictionary *dic_info;

@end

@implementation FGSeeMoreForSearchResultViewController
@synthesize view_moreSearchReuslt;
@synthesize dic_info;
#pragma mark - 生命周期
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withInfo:(id)_obj
{
  if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
    if (_obj != nil && [_obj isKindOfClass:[NSDictionary class]]) {
      self.dic_info = (NSDictionary *)_obj;
    }
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self hideBottomPanelWithAnimtaion:NO];

  // Do any additional setup after loading the view from its nib.
//  self.view_topPanel.str_title = multiLanguage(@"PROFILE");
  SAFE_RemoveSupreView(self.view_topPanel.iv_right);
  SAFE_RemoveSupreView(self.view_topPanel.btn_right);
  
//  self.view_topPanel.iv_right.image = [UIImage imageNamed:@"addfriends.png"];
//  [self.view_topPanel.btn_right addTarget:self action:@selector(buttonAction_gotoAddFriend:) forControlEvents:UIControlEventTouchUpInside];
  
  [self internalInitalView];
}

- (void)manullyFixSize {
  [super manullyFixSize];
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setWhiteBGStyle];

  NSString *_str_title = self.dic_info[@"title"];
  self.view_topPanel.str_title = _str_title;
  
  [self.view_moreSearchReuslt beginRefresh];
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

- (void)internalInitalView {
  view_moreSearchReuslt = (FGMoreResultsView *)[[[NSBundle mainBundle] loadNibNamed:@"FGMoreResultsView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:view_moreSearchReuslt];
  CGRect frame             = self.view_topPanel.frame;
  view_moreSearchReuslt.frame = CGRectMake(0, frame.size.height, view_moreSearchReuslt.frame.size.width, view_moreSearchReuslt.frame.size.height);
  [self.view addSubview:view_moreSearchReuslt];
  self.view_moreSearchReuslt.delegate = self;
  [self.view_moreSearchReuslt setupWithInfo:self.dic_info];
}

#pragma mark - 从父类继承的

- (void)receivedDataFromNetwork:(NSNotification *)_notification {
  [super receivedDataFromNetwork:_notification];
  NSMutableDictionary *_dic_requestInfo = _notification.object;
  NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
  [commond removeLoading];
  
  if ([HOST(URL_HOME_SearcSeeMore) isEqualToString:_str_url]) {
    if(self.view_moreSearchReuslt)
    {
      if([[_dic_requestInfo allKeys] containsObject:@"searchResultMore"])
      {
        [self.view_moreSearchReuslt bindMoreResultsDataToUI];
      }
      else
      {
        [self.view_moreSearchReuslt bindDataToUI];
      }
    }
  }
}

- (void)requestFailedFromNetwork:(NSNotification *)_notification {
  
}

#pragma mark - FGMoreResultsViewDelegate
- (void)selectSearchResultWithInfo:(NSDictionary *)_info {
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

@end

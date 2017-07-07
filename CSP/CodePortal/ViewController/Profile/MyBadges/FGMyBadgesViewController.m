//
//  FGMyBadgesViewController.m
//  CSP
//
//  Created by JasonLu on 16/10/10.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGMyBadgesView.h"
#import "FGMyBadgesViewController.h"
@interface FGMyBadgesViewController ()

@end

@implementation FGMyBadgesViewController
@synthesize view_mybadges;
@synthesize str_id;
@synthesize str_name;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(id)_str_id name:(NSString *)_str_name
{
  if(self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil withId:_str_id]){
    if (!ISNULLObj(_str_name)) {
      self.str_name = _str_name;
    }
  }
  return self;
}


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withId:(id)_str_id
{
  if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
    if (!ISNULLObj(_str_id)) {
      self.str_id = _str_id;
    }
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  if ([commond isCurrentUserWithId:self.str_id]) {
    self.view_topPanel.str_title = multiLanguage(@"My BADGES");
  }
  else {
    self.view_topPanel.str_title = [NSString stringWithFormat:@"%@%@",self.str_name, multiLanguage(@"'s BADGES")];
  }
  
  
  SAFE_RemoveSupreView(self.view_topPanel.iv_right);
  [self internalInitalMyBadgesDetailView];
  [self hideBottomPanelWithAnimtaion:NO];
}

- (void)manullyFixSize {
  [super manullyFixSize];
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - 初始化FGTrainingDetailView
- (void)internalInitalMyBadgesDetailView {
  view_mybadges = (FGMyBadgesView *)[[[NSBundle mainBundle] loadNibNamed:@"FGMyBadgesView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:view_mybadges];
  CGRect frame        = self.view_topPanel.frame;
  view_mybadges.frame = CGRectMake(0, frame.size.height, view_mybadges.frame.size.width, view_mybadges.frame.size.height);
  [self.view addSubview:view_mybadges];
  
  view_mybadges.str_id = self.str_id;
  [self.view_mybadges runRequest_GetUserBadges];
}

#pragma mark - 从父类继承的

- (void)buttonAction_right:(id)_sender {
}

- (void)receivedDataFromNetwork:(NSNotification *)_notification {
  NSMutableDictionary *_dic_requestInfo = _notification.object;
  NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
  [commond removeLoading];
  // 验证码请求
  if ([HOST(URL_PROFILE_GetUserBadges) isEqualToString:_str_url]) {
    [self.view_mybadges bindDataToUI];
  }
}

- (void)requestFailedFromNetwork:(NSNotification *)_notification {
}

@end

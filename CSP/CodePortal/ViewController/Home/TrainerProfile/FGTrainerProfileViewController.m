//
//  FGTrainerProfileViewController.m
//  CSP
//
//  Created by JasonLu on 16/10/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainerProfileView.h"
#import "FGTrainerProfileViewController.h"
@interface FGTrainerProfileViewController ()
@property (nonatomic, strong) FGTrainerProfileView *view_trainerProfile;
@property (nonatomic, strong) NSDictionary *dic_trainerInfo;

@end

@implementation FGTrainerProfileViewController
@synthesize view_trainerProfile;
@synthesize dic_trainerInfo;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTrainerId:(id)_obj
{
  if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
    if (_obj != nil) {
      self.dic_trainerInfo = @{@"id":(NSString *)_obj};
    }
  }
  return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withInfo:(id)_obj
{
  if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
    if (_obj != nil && [_obj isKindOfClass:[NSDictionary class]]) {
      self.dic_trainerInfo = (NSDictionary *)_obj;
    }
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  self.view_topPanel.str_title = multiLanguage(@"TRAINER PROFILE");

  [self internalInitalViewCtrl];
  [self hideBottomPanelWithAnimtaion:NO];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setWhiteBGStyle];
  [self.view_trainerProfile beginRefresh];
}

- (void)manullyFixSize {
  [super manullyFixSize];
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

- (void)internalInitalViewCtrl {
  view_trainerProfile = (FGTrainerProfileView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainerProfileView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:view_trainerProfile];
  CGRect frame              = self.view_topPanel.frame;
  view_trainerProfile.frame = CGRectMake(0, frame.size.height, view_trainerProfile.frame.size.width, view_trainerProfile.frame.size.height);
  [self.view addSubview:view_trainerProfile];
  self.view_trainerProfile.str_trainerId = dic_trainerInfo[@"id"];
  //界面加载
//  [self.view_trainerProfile.tb_trainerProfile setupLoadingMaskLayerHidden:NO withAlpha:1.0 withSpinnerHidden:NO];
  
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
  
  if ([HOST(URL_PROFILE_TrainerDetailPage) isEqualToString:_str_url]) {
    [self.view_trainerProfile bindDataToUI];
  }
  
  if ([HOST(URL_PROFILE_TrainerComments) isEqualToString:_str_url]) {
    [self.view_trainerProfile loadMoreComments];
  }
  
  
}

- (void)requestFailedFromNetwork:(NSNotification *)_notification {
}


@end

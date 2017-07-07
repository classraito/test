//
//  FGChooseBoxingLevelViewController.m
//  CSP
//
//  Created by JasonLu on 16/10/12.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGChooseBoxingLevelViewController.h"
#import "UIImage+BlurEffect.h"
#import "UIView+CornerRaduis.h"

#define SELECTEDCOLOR rgb(80, 227, 194)
#define UNSELECTEDCOLOR [UIColor whiteColor]

@interface FGChooseBoxingLevelViewController ()
@property (nonatomic, assign) EMBoxingLevel userBoxingLevel;
@end

@implementation FGChooseBoxingLevelViewController
@synthesize userBoxingLevel;
#pragma mark - 生命周期
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  [[UIApplication sharedApplication] setStatusBarHidden:YES];
  [self internalInitalViewContrller];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)manullyFixSize {
  [super manullyFixSize];
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}
#pragma mark - 自定义方法
- (void)internalInitalViewContrller {
  [commond useDefaultRatioToScaleView:self.vi_bg];
  [commond useDefaultRatioToScaleView:self.btn_done];
  [commond useDefaultRatioToScaleView:self.lb_title];
  [commond useDefaultRatioToScaleView:self.btn_beginner];
  [commond useDefaultRatioToScaleView:self.btn_intermediate];
  [commond useDefaultRatioToScaleView:self.btn_advanced];

  [self hideBottomPanelWithAnimtaion:NO];
  [self topPanelStatus:Hidden withAnimtaion:NO];

  self.btn_beginner.titleLabel.font     = font(FONT_TEXT_REGULAR, 19);
  self.btn_intermediate.titleLabel.font = font(FONT_TEXT_REGULAR, 19);
  self.btn_advanced.titleLabel.font     = font(FONT_TEXT_REGULAR, 19);

  self.lb_title.font      = font(FONT_TEXT_REGULAR, 25);
    self.lb_title.text      = multiLanguage(@"Please select the option that best describes your level of boxing ability");
  NSString *str_beginner = multiLanguage(@"Beginner");
  NSString *str_Intermediate = multiLanguage(@"Intermediate");
  NSString *str_Advanced = multiLanguage(@"Advanced");
    
    [self.btn_beginner setTitle:str_beginner forState:UIControlStateNormal];
    [self.btn_beginner setTitle:str_beginner forState:UIControlStateHighlighted];
    
    [self.btn_intermediate setTitle:str_Intermediate forState:UIControlStateNormal];
    [self.btn_intermediate setTitle:str_Intermediate forState:UIControlStateHighlighted];
    
    [self.btn_advanced setTitle:str_Advanced forState:UIControlStateNormal];
    [self.btn_advanced setTitle:str_Advanced forState:UIControlStateHighlighted];
    
    
    
  self.lb_title.textColor = [UIColor whiteColor];

  [self.btn_done setTitle:multiLanguage(@"DONE") forState:UIControlStateNormal];
  self.btn_done.titleLabel.font = font(FONT_TEXT_REGULAR, 19);
  [self.btn_done makeWithCornerRadius:self.btn_done.bounds.size.height / 2];

  self.vi_bg.image = IMGWITHNAME(@"00.jpg");

  self.userBoxingLevel = Beginner;
  [self setupButtonStatus];
}

- (void)setupButtonStatus {
  [self.btn_beginner setTitleColor:UNSELECTEDCOLOR forState:UIControlStateNormal];
  [self.btn_intermediate setTitleColor:UNSELECTEDCOLOR forState:UIControlStateNormal];
  [self.btn_advanced setTitleColor:UNSELECTEDCOLOR forState:UIControlStateNormal];

  if (self.userBoxingLevel == Beginner) {
    [self.btn_beginner setTitleColor:SELECTEDCOLOR forState:UIControlStateNormal];
  } else if (self.userBoxingLevel == Intermediate) {
    [self.btn_intermediate setTitleColor:SELECTEDCOLOR forState:UIControlStateNormal];
  } else if (self.userBoxingLevel == Advanced) {
    [self.btn_advanced setTitleColor:SELECTEDCOLOR forState:UIControlStateNormal];
  }
}

- (IBAction)buttonAction_beginner:(id)sender {
  self.userBoxingLevel = Beginner;
  [self setupButtonStatus];
}
- (IBAction)buttonAction_Intermediate:(id)sender {
  self.userBoxingLevel = Intermediate;
  [self setupButtonStatus];
}
- (IBAction)buttonAction_Advanced:(id)sender {
  self.userBoxingLevel = Advanced;
  [self setupButtonStatus];
}

- (IBAction)buttonAction_done:(id)sender {
  //保存用户boxing等级
  [commond setUserDefaults:[NSNumber numberWithInteger:self.userBoxingLevel] forKey:KEY_USER_BOXING_LEVEL];
  //跳转到first reccomended workout
  FGControllerManager *manager = [FGControllerManager sharedManager];
  [manager pushControllerByName:@"FGFirstReccommendWorkoutViewController" inNavigation:nav_current withAnimtae:YES];
}
@end

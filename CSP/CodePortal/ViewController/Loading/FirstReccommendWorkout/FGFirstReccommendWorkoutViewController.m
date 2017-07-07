//
//  FGFirstReccommendWorkoutViewController.m
//  CSP
//
//  Created by JasonLu on 16/10/12.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGAlignmentLabel.h"
#import "FGFirstReccommendWorkoutViewController.h"
#import "UIView+CornerRaduis.h"
@interface FGFirstReccommendWorkoutViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iv_bg;
@property (weak, nonatomic) IBOutlet UIButton *btn_started;
@property (weak, nonatomic) IBOutlet UIButton *btn_notnow;
@property (weak, nonatomic) IBOutlet UILabel *lb_bigTitle;
@property (weak, nonatomic) IBOutlet UILabel *lb_subTItle;
@property (weak, nonatomic) IBOutlet FGAlignmentLabel *lb_time;
@property (weak, nonatomic) IBOutlet FGAlignmentLabel *lb_timeunit;

@end

@implementation FGFirstReccommendWorkoutViewController
@synthesize iv_bg;
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
  [commond useDefaultRatioToScaleView:self.iv_bg];
  [commond useDefaultRatioToScaleView:self.btn_started];
  [commond useDefaultRatioToScaleView:self.btn_notnow];
  [commond useDefaultRatioToScaleView:self.lb_bigTitle];
  [commond useDefaultRatioToScaleView:self.lb_subTItle];
  [commond useDefaultRatioToScaleView:self.lb_time];
  [commond useDefaultRatioToScaleView:self.lb_timeunit];

  [self hideBottomPanelWithAnimtaion:NO];
  [self topPanelStatus:Hidden withAnimtaion:NO];

  self.lb_bigTitle.font      = font(FONT_TEXT_BOLD, 35);
  self.lb_bigTitle.text      = multiLanguage(@"Time to start your first WeBox Workout!");
  self.lb_bigTitle.textColor = [UIColor whiteColor];

  self.lb_subTItle.font      = font(FONT_TEXT_REGULAR, 20);
  self.lb_subTItle.text      = multiLanguage(@"FEARLESS FOCUS");
  self.lb_subTItle.textColor = [UIColor whiteColor];

  self.lb_time.font = font(FONT_TEXT_REGULAR, 50);
  // FIXME: 根据之前用户选择boxing level设置时间
  NSNumber *number = (NSNumber *)[commond getUserDefaults:KEY_USER_BOXING_LEVEL];
  NSInteger level  = [number integerValue];
  if (level == Beginner)
    self.lb_time.text = multiLanguage(@"15");
  else if (level == Intermediate)
    self.lb_time.text = multiLanguage(@"25");
  else if (level == Advanced)
    self.lb_time.text    = multiLanguage(@"45");
  self.lb_time.transform = CGAffineTransformMakeScale(1.0, 1.2);

  self.lb_time.textColor = [UIColor whiteColor];
  [self.lb_time setVerticalAlignment:VerticalAlignmentBottom];

  self.lb_timeunit.font      = font(FONT_TEXT_BOLD, 16);
  self.lb_timeunit.text      = multiLanguage(@"MINS");
  self.lb_timeunit.textColor = [UIColor whiteColor];
  [self.lb_timeunit setVerticalAlignment:VerticalAlignmentTop];

    [self.btn_started setTitle:multiLanguage(@"Get Started") forState:UIControlStateNormal];
  self.btn_started.titleLabel.font = font(FONT_TEXT_REGULAR, 19);
  [self.btn_started makeWithCornerRadius:self.btn_started.bounds.size.height / 2];

  [self.btn_notnow setTitle:multiLanguage(@"Skip") forState:UIControlStateNormal];
  self.btn_notnow.titleLabel.font = font(FONT_TEXT_REGULAR, 19);

  self.iv_bg.image = IMGWITHNAME(@"00.jpg");
}

- (IBAction)buttonAction_started:(id)sender {
  // TODO: 跳转到first reccomended workout
}

- (IBAction)buttonAction_notnow:(id)sender {
  FGControllerManager *manager = [FGControllerManager sharedManager];
  [manager pushControllerByName:@"FGHomeViewController" inNavigation:nav_current withAnimtae:YES];
}

@end

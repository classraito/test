//
//  FGProfileSettingsViewController.m
//  CSP
//
//  Created by Ryan Gong on 17/1/9.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGProfileSettingsView.h"
#import "FGProfileSettingsViewController.h"
#import "Global.h"
@interface FGProfileSettingsViewController ()
{
  FGProfileSettingsView *view_settings;
}
@end

@implementation FGProfileSettingsViewController
@synthesize btn_logout;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"Setting");
    SAFE_RemoveSupreView(self.view_topPanel.btn_right);
    SAFE_RemoveSupreView(self.view_topPanel.iv_right);
  
  [self hideBottomPanelWithAnimtaion:NO];
  [self internalInitalView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
  
  [view_settings reload];
}

-(void)dealloc
{
  view_settings = nil;
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

#pragma mark - view相关
- (void)internalInitalView {
  if (view_settings == nil) {
    view_settings = (FGProfileSettingsView *)[[[NSBundle mainBundle] loadNibNamed:@"FGProfileSettingsView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_settings];
    CGRect frame        = self.view_topPanel.frame;
    view_settings.frame = CGRectMake(0, frame.size.height, view_settings.frame.size.width, view_settings.frame.size.height);
    [self.view addSubview:view_settings];
  }
}
#pragma mark - 按钮事件
-(IBAction)buttonAction_logout:(id)_sender;
{
    [appDelegate logout];
}
@end

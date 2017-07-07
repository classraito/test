//
//  FGHomepageFeaturedUserListViewController.m
//  CSP
//
//  Created by JasonLu on 16/11/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGHomepageFeaturedUserListViewController.h"

@interface FGHomepageFeaturedUserListViewController ()

@end

@implementation FGHomepageFeaturedUserListViewController
@synthesize view_featuredUserList;
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  self.view_topPanel.str_title = multiLanguage(@"FEATURED USERS");
  SAFE_RemoveSupreView(self.view_topPanel.iv_right);
  SAFE_RemoveSupreView(self.view_topPanel.btn_right);
  
  [self internalInitalView];
  [self hideBottomPanelWithAnimtaion:NO];
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
#pragma mark - home view相关
- (void)internalInitalView {
  view_featuredUserList = (FGFeaturedUserListView *)[[[NSBundle mainBundle] loadNibNamed:@"FGFeaturedUserListView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:view_featuredUserList];
  CGRect frame        = self.view_topPanel.frame;
  view_featuredUserList.frame = CGRectMake(0, frame.size.height, view_featuredUserList.frame.size.width, view_featuredUserList.frame.size.height);
  [self.view addSubview:view_featuredUserList];
}
@end

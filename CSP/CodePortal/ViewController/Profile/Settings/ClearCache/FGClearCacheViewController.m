//
//  FGClearCacheViewController.m
//  CSP
//
//  Created by JasonLu on 17/1/20.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGClearCacheViewController.h"
#import "FGClearCacheView.h"
@interface FGClearCacheViewController () {
    FGClearCacheView *view_clearCache;
}
@end

@implementation FGClearCacheViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  self.view_topPanel.str_title = multiLanguage(@"Clear Cache");
  SAFE_RemoveSupreView(self.view_topPanel.btn_right);
  SAFE_RemoveSupreView(self.view_topPanel.iv_right);
  
  [self hideBottomPanelWithAnimtaion:NO];
  [self internalInitalView];
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self setWhiteBGStyle];
}

-(void)dealloc
{
  view_clearCache = nil;
  NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

#pragma mark - view相关
- (void)internalInitalView {
  if (view_clearCache == nil) {
    view_clearCache = (FGClearCacheView *)[[[NSBundle mainBundle] loadNibNamed:@"FGClearCacheView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_clearCache];
    CGRect frame        = self.view_topPanel.frame;
    view_clearCache.frame = CGRectMake(0, frame.size.height, view_clearCache.frame.size.width, view_clearCache.frame.size.height);
    [self.view addSubview:view_clearCache];
  }
}
@end

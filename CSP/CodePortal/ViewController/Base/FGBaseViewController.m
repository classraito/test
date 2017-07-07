
//  FGBaseViewController.m
//  DunkinDonuts
//
//  Created by Ryan Gong on 15/11/10.
//  Copyright © 2015年 Ryan Gong. All rights reserved.
//
#import "FGSNSManager.h"
#import "FGBaseViewController.h"
#import "Global.h"

STPopupController *vc_popup;
@interface FGBaseViewController () {
    
}
@end

@implementation FGBaseViewController
@synthesize view_topPanel;
@synthesize iv_bg;
@synthesize view_bottomPanel;

#pragma mark - 生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {

    //注册网络请求通知事件
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(receivedDataFromNetworkOnBase:)
               name:Notification_UpdateData
             object:nil];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(requestFailedFromNetworkOnBase:)
               name:Notification_UpdateFailed
             object:nil];
     
      
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  NSLog(@":::::>(%f,%f)", W, H);
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
  /*
   如果viewcontroller的第一个子视图是一个
   scrollview（包括状态栏）。当程序运行，显示界面的时候，scrollview
   会向下偏移20个像素。
   这是由于iOS7的UIViewController有个新特性
   @property(nonatomic,assign) BOOL automaticallyAdjustsScrollViewInsets
   NS_AVAILABLE_IOS(7_0); // Defaults to YES
   scrollview会自动偏移,要手动关掉
   */
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  /*初始化标题栏*/
  view_topPanel = (FGTopPanelView *)[[[NSBundle mainBundle]
      loadNibNamed:@"FGTopPanelView"
             owner:nil
           options:nil] objectAtIndex:0];
  [self.view addSubview:view_topPanel];

  iv_bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, W, H)];
  [self.view addSubview:iv_bg];
  [self.view sendSubviewToBack:iv_bg];

  //注册标题栏按钮事件
  [view_topPanel.btn_left addTarget:self
                             action:@selector(buttonAction_left:)
                   forControlEvents:UIControlEventTouchUpInside];
  [view_topPanel.btn_right addTarget:self
                              action:@selector(buttonAction_right:)
                    forControlEvents:UIControlEventTouchUpInside];
  [view_topPanel.btn_right_inside1
             addTarget:self
                action:@selector(buttonAction_right_inside1:)
      forControlEvents:UIControlEventTouchUpInside];

  view_bottomPanel = (FGBottomPanelView *)[[[NSBundle mainBundle]
      loadNibNamed:@"FGBottomPanelView"
             owner:nil
           options:nil] objectAtIndex:0];
  [self.view addSubview:view_bottomPanel];
  //注册底部导航栏按钮事件
  [view_bottomPanel.btn_home addTarget:self
                                action:@selector(buttonAction_home:)
                      forControlEvents:UIControlEventTouchUpInside];
  [view_bottomPanel.btn_traning addTarget:self
                                   action:@selector(buttonAction_traning:)
                         forControlEvents:UIControlEventTouchUpInside];
  [view_bottomPanel.btn_post addTarget:self
                                action:@selector(buttonAction_post:)
                      forControlEvents:UIControlEventTouchUpInside];
  [view_bottomPanel.btn_location addTarget:self
                                    action:@selector(buttonAction_location:)
                          forControlEvents:UIControlEventTouchUpInside];
  [view_bottomPanel.btn_profile addTarget:self
                                   action:@selector(buttonAction_profile:)
                         forControlEvents:UIControlEventTouchUpInside];

    
    
  [self manullyFixSize];
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:Notification_UpdateData
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:Notification_UpdateFailed
                                                object:nil];
  vc_popup = nil;
  view_topPanel = nil;
  iv_bg = nil;
  [[SDImageCache sharedImageCache] clearMemory];
}

-(void)setWhiteBGStyle
{
    view_topPanel.backgroundColor = [UIColor whiteColor];
    view_topPanel.lb_title.textColor = [UIColor blackColor];
    view_topPanel.iv_left.highlighted = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    CGRect _frame = view_topPanel.view_separator.frame;
    _frame.origin.y = view_topPanel.frame.size.height - view_topPanel.view_separator.frame.size.height;
    view_topPanel.view_separator.frame = _frame;
    view_topPanel.view_separator.backgroundColor = [UIColor lightGrayColor];
    view_topPanel.view_separator.hidden = NO;
}

-(void)setRedBgStyle
{
    view_topPanel.backgroundColor = color_red_panel;
    view_topPanel.lb_title.textColor = [UIColor whiteColor];
    view_topPanel.iv_left.highlighted = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setRedBgStyle];
  self.automaticallyAdjustsScrollViewInsets = NO;
  FGControllerManager *manager = [FGControllerManager sharedManager];
  [view_bottomPanel
      setButtonHighlightedByStatus:manager.currentNavigationStatus];

  [self.view bringSubviewToFront:view_topPanel];
  [self.view bringSubviewToFront:view_bottomPanel];
}

/*
 使用这个生命周期的前提是你打开了autolayout
 autolayout
 会在viewWillAppear和viewDidAppear之间的那段时间为你分析约束、设置frame,所以不能在这两个方法中操作frame,因为你会在这viewDidAppear中得到不同结果，而且我发现他们会被调用多次
 而需要在viewDidLayoutSubviews中操作，因为这个方法是在autolayout布局完成之后执行
 在iOS5.0以后就有这个生命周期函数ViewDidLayoutSubViews这个方法基本可以代替ViewDidload使用，只不过差别在于前者是约束(autolayout)后，后者是约束前*/
- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

#pragma mark - 隐藏底部导航栏
- (void)hideBottomPanelWithAnimtaion:(BOOL)_animation {

  if (!view_bottomPanel)
    return;
  if (view_bottomPanel.frame.origin.y > H)
    return;

  if (_animation) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
  }
  CGRect _frame = view_bottomPanel.frame;
  _frame.origin.y = H + view_bottomPanel.frame.size.height;
  view_bottomPanel.frame = _frame;
  if (_animation) {
    [UIView commitAnimations];
  }
}

#pragma mark - 显示底部导航栏
- (void)showBottomPanelWithAnimation:(BOOL)_animation {
  if (!view_bottomPanel)
    return;
  if (view_bottomPanel.frame.origin.y < H)
    return;

  if (_animation) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
  }
  CGRect _frame = view_bottomPanel.frame;
  _frame.origin.y = H - view_bottomPanel.frame.size.height;
  view_bottomPanel.frame = _frame;
  if (_animation) {
    [UIView commitAnimations];
  }
}

#pragma mark - 顶部导航栏显示状态
- (void)topPanelStatus:(EMStatus)status withAnimtaion:(BOOL)_animation {

  status == Show ? [self showTopPanelWithAnimation:_animation]
                 : [self hiddenTopPanelWithAnimation:_animation];
}

- (void)showTopPanelWithAnimation:(BOOL)_animation {
  if (!view_topPanel)
    return;
  if (view_topPanel.frame.origin.y > 0)
    return;

  CGRect _frame = view_bottomPanel.frame;
  _frame.origin.y = 0;
  if (!_animation) {
    view_bottomPanel.frame = _frame;
    return;
  }

  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:1];
  view_bottomPanel.frame = _frame;
  [UIView commitAnimations];
}

- (void)hiddenTopPanelWithAnimation:(BOOL)_animation {
  if (!view_topPanel)
    return;
  if (view_topPanel.frame.origin.y < -1 * view_topPanel.frame.size.height)
    return;

  CGRect _frame = view_topPanel.frame;
  _frame.origin.y = -1 * view_topPanel.frame.size.height;
  if (!_animation) {
    view_topPanel.frame = _frame;
    return;
  }

  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:1];
  view_topPanel.frame = _frame;
  [UIView commitAnimations];
}

#pragma mark - 底部导航栏按钮
- (void)buttonAction_home:(id)_sender;
{
  if (!view_bottomPanel)
    return;

  FGControllerManager *manager = [FGControllerManager sharedManager];
  manager.currentNavigationStatus = NavigationStatus_Home;
  [manager initNavigation:&nav_home rootControllerName:@"FGHomeViewController"];
}

- (void)buttonAction_traning:(id)_sender;
{
  if (!view_bottomPanel)
    return;
    
  
    
  FGControllerManager *manager = [FGControllerManager sharedManager];
  manager.currentNavigationStatus = NavigationStatus_Training;
  [manager initNavigation:&nav_training
       rootControllerName:@"FGTrainingViewController"];
}

- (void)buttonAction_post:(id)_sender;
{
  if (!view_bottomPanel)
    return;

    if(![appDelegate isLoggedIn])
    {
        [commond showAskForLogin];
        return;
    }

    
  FGControllerManager *manager = [FGControllerManager sharedManager];
  manager.currentNavigationStatus = NavigationStatus_Post;
  [manager initNavigation:&nav_post rootControllerName:@"FGPostViewController"];
}

- (void)buttonAction_location:(id)_sender;
{
  if (!view_bottomPanel)
    return;
    
  
  [[FGLocationManagerWrapper sharedManager] startUpdatingLocation:^(CLLocationDegrees _lat, CLLocationDegrees _lng) {
  }];
    FGControllerManager *manager = [FGControllerManager sharedManager];
    manager.currentNavigationStatus = NavigationStatus_Location;
    [manager initNavigation:&nav_location
         rootControllerName:@"FGLocationViewController"];
  
}

- (void)buttonAction_profile:(id)_sender;
{
  if (!view_bottomPanel)
    return;

    if(![appDelegate isLoggedIn])
    {
        [commond showAskForLogin];
        return;
    }
    
  FGControllerManager *manager = [FGControllerManager sharedManager];
  manager.currentNavigationStatus = NavigationStatus_Profile;
  [manager initNavigation:&nav_profile
       rootControllerName:@"FGProfileViewController"];
}

#pragma mark - 子类需要实现以下方法
//最右边的按钮
- (void)buttonAction_right:(id)_sender;
{

}

//左边的按钮 默认功能是退回到当前navigation 的上一级界面 如果子类覆盖这个方法
//那么子类可以改写这个默认功能
- (void)buttonAction_left:(id)_sender;
{
  FGControllerManager *manager = [FGControllerManager sharedManager];
  switch (manager.currentNavigationStatus) {
  case NavigationStatus_Home:
    [manager popViewControllerInNavigation:&nav_current animated:YES];
    break;

  case NavigationStatus_Training:
    [manager popViewControllerInNavigation:&nav_current animated:YES];
    break;

  case NavigationStatus_Post:
    [manager popViewControllerInNavigation:&nav_current animated:YES];
    break;

  case NavigationStatus_Location:
    
    [manager popViewControllerInNavigation:&nav_current animated:YES];
    break;

  case NavigationStatus_Profile:
    [manager popViewControllerInNavigation:&nav_current animated:YES];
    break;
  }
}

//右边靠内的第一个按钮
- (void)buttonAction_right_inside1:(id)_sender {
}

/*所有屏幕适配代码在子类的这个手工适配方法中实现*/
- (void)manullyFixSize {
  NSLog(@":::::>%s %d", __FUNCTION__, __LINE__);
  [commond useDefaultRatioToScaleView:iv_bg];
  [commond useDefaultRatioToScaleView:view_topPanel];
  [commond useDefaultRatioToScaleView:view_bottomPanel];
  CGRect _frame = view_bottomPanel.frame;
  _frame.origin.y = H - view_bottomPanel.frame.size.height;
  view_bottomPanel.frame = _frame;
}



-(void)buttonAction_shareNow:(id)_sender
{
    [vc_popup dismissWithCompletion:^{}];
    vc_popup = nil;
  // FIXME: share
  [[FGSNSManager shareInstance] actionToShareWithTitle:@"" text:@"" url:@"" images:@[]];
}



/*获得任何网络数据时会通知此方法 以便基类将数据分发给子类*/
- (void)receivedDataFromNetworkOnBase:(NSNotification *)_notification {
   
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSNumber *_notifyVCHash = nil;
    if([[_dic_requestInfo allKeys] containsObject:KEY_NOTIFY_IDENTIFIER])
    {
        _notifyVCHash = [_dic_requestInfo objectForKey:KEY_NOTIFY_IDENTIFIER];
    }
    
    /*如果有独占hash码 并且 hash码与本实例hash码不匹配 那么不通知子类处理请求数据*/
    if(_notifyVCHash && [_notifyVCHash isKindOfClass:[NSNumber class]] && self.hash != [_notifyVCHash longValue])
    {
        NSLog(@"hash码不匹配此实例，子类不处理请求数据");
        NSLog(@"%@ : %ld = %@",[self class],self.hash,_notifyVCHash);
        return;
    }
    else
    {
        if(_notifyVCHash)
        {
            NSLog(@"匹配到hash码:%@ 子类允许处理该请求数据",_notifyVCHash);
        }
    }
    
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    if ([HOST(URL_PROFILE_UploadUserTrace) isEqualToString:_str_url]) {
        [NetworkEventTrack clearTrackDatas];
        NSMutableDictionary *_dic_traceInfo = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_PROFILE_UploadUserTrace)];
        if([[_dic_traceInfo allKeys ] containsObject:@"Badges"])
        {
            int index = 0;
            for(NSMutableDictionary *_dic_info in [_dic_traceInfo objectForKey:@"Badges"])
            {
                if([self isEqual:nav_current.topViewController])
                {
                    [commond showGlobalPopupWithData:_dic_info];
                    NSLog(@"::::::>popuped badges[%d]: %@",index,_dic_info);
                    index ++;
                }
               
            }
        }
    }
    
    [self receivedDataFromNetwork:_notification];
}

/*请求网络失败后的通知*/
- (void)requestFailedFromNetworkOnBase:(NSNotification *)_notification {
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSNumber *_notifyVCHash = nil;
    if([[_dic_requestInfo allKeys] containsObject:KEY_NOTIFY_IDENTIFIER])
    {
        _notifyVCHash = [_dic_requestInfo objectForKey:KEY_NOTIFY_IDENTIFIER];
    }
    
    /*如果有独占hash码 并且 hash码与本实例hash码不匹配 那么不通知子类处理请求数据*/
    if(_notifyVCHash && [_notifyVCHash isKindOfClass:[NSNumber class]] && self.hash != [_notifyVCHash longValue])
        return;
    
    [self requestFailedFromNetwork:_notification];
}



/* 子类实现此方法来自定义收到网络数据后的行为*/
- (void)receivedDataFromNetwork:(NSNotification *)_notification {
  NSLog(@":::::>%s %d obj = %@", __FUNCTION__, __LINE__, _notification.object);
     [commond removeLoading];
}

/* 子类实现此方法来自定义收到网络数据后的行为*/
- (void)requestFailedFromNetwork:(NSNotification *)_notification {
  NSLog(@"::::::>%s  %d requestFailedFromNetwork obj = %@", __FUNCTION__,
        __LINE__, _notification.object);
    [commond removeLoading];
}


@end

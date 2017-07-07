//
//  AppDelegate+PushHandler.m
//  RuntimeTestProject
//
//  Created by JasonLu on 16/9/2.
//  Copyright © 2016年 JasonLu. All rights reserved.
//

#import "EBForeNotification.h"
#import "AppDelegate+PushHandler.h"
#import "CUtils.h"
#import "AppDelegate.h"
#import "JPUSHService.h"
#pragma mark - JPush 功能

// 引JPush功能所需头 件
#import "JPUSHService.h"
// iOS10注册APNs所需头 件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@implementation AppDelegate (PushHandler)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        swizzleMethod(class, @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:), @selector(AOP_PH_application:didRegisterForRemoteNotificationsWithDeviceToken:));
        swizzleMethod(class, @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:), @selector(AOP_PH_application:didRegisterForRemoteNotificationsWithDeviceToken:));
        swizzleMethod(class, @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:), @selector(AOP_PH_application:didReceiveRemoteNotification:fetchCompletionHandler:));
        swizzleMethod(class, @selector(application:didReceiveRemoteNotification:), @selector(AOP_PH_application:didReceiveRemoteNotification:));
    });
}


-(void)AOP_PH_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)_deviceToken
{
    // TODO: your code...
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    self.deviceToken = [[[[_deviceToken description]
                     stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                    stringByReplacingOccurrencesOfString:@" "
                    withString:@""] copy];
    NSLog(@"1.deviceToken=%@",self.deviceToken);
//  [commond saveToKeyChain:KEYCHAIN_KEY_PUSH_DEVICETOKEN passwd:self.deviceToken];
  [commond setUserDefaults:self.deviceToken forKey:KEYCHAIN_KEY_PUSH_DEVICETOKEN];
  [JPUSHService registerDeviceToken:_deviceToken];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dddd:) name:EBBannerViewDidClick object:nil];
    // TODO: 如果需要调用原来AppDelegate对应方法请打开注释
//    [self AOP_PH_application:application didRegisterForRemoteNotificationsWithDeviceToken:_deviceToken];
}

-(void)AOP_PH_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // TODO: your code...
  NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);

    // TODO: 如果需要调用原来AppDelegate对应方法请打开注释
//    [self AOP_PH_application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)AOP_PH_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    // TODO: your code...
  [JPUSHService handleRemoteNotification:userInfo];
  NSLog(@"iOS7及以上系统，收到通知:%@", [FGUtils logDic:userInfo]);
  
  if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
//    [rootViewController addNotificationCount];
  }
  
  completionHandler(UIBackgroundFetchResultNewData);
  
  
  //解析推送信息
  [self action_parsePushWithInfo:userInfo];
  
    // TODO: 如果需要调用原来AppDelegate对应方法请打开注释
//  [self AOP_PH_application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

-(void)AOP_PH_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // TODO: your code...
  [JPUSHService handleRemoteNotification:userInfo];
  NSLog(@"iOS6及以下系统，收到通知:%@", [FGUtils logDic:userInfo]);
//  [rootViewController addNotificationCount];
//     TODO: 如果需要调用原来AppDelegate对应方法请打开注释
//    [self AOP_PH_application:application didReceiveRemoteNotification:userInfo];
}

#pragma mark - 推送解析
- (void)action_parsePushWithInfo:(NSDictionary *)_dic_pushInfo {
  BOOL _bool_isNeedNotification = [(NSNumber *)[commond getUserDefaults:STATUS_NOTIFICATION] boolValue];
  if (_bool_isNeedNotification == NO)
    return;
  
  NSString *_str_type = _dic_pushInfo[@"type"];
  NSString *_str_message = _dic_pushInfo[@"aps"][@"alert"];

  if (![_str_type isEqualToString:@"booking"])
    return;
  
  BOOL _bool_appActived = [(NSNumber *)[commond getUserDefaults:APPACTIVE_NOTIFICATION] boolValue];
  
  if (_bool_appActived == NO) {
    NSInteger _int_type = [_dic_pushInfo[@"action"] integerValue];
    if (_int_type == 1) {
      
      if ([nav_current.topViewController isKindOfClass:[FGManageBookingViewController class]]) {
        //如果已经在booking界面需要自动刷新
        NSLog(@"如果已经在booking界面需要自动刷新");
        FGManageBookingViewController *vc_booking = (FGManageBookingViewController*)nav_current.topViewController;
        [vc_booking refreshBookingWithInfo:_dic_pushInfo];
        return;
      }
      
      //进入booking界面的pending列表
      NSString *_str_id = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
      FGControllerManager *manager = [FGControllerManager sharedManager];
      FGManageBookingViewController *vc_booking = [[FGManageBookingViewController alloc] initWithNibName:@"FGManageBookingViewController" bundle:nil withId:_str_id withInfo:@{@"type":@0}];
      [manager pushController:vc_booking navigationController:nav_current];
    } else if (_int_type == 2) {
      if ([nav_current.topViewController isKindOfClass:[FGManageBookingViewController class]]) {
        //如果已经在booking界面需要自动刷新
        NSLog(@"如果已经在booking界面需要自动刷新");
        FGManageBookingViewController *vc_booking = (FGManageBookingViewController*)nav_current.topViewController;
        [vc_booking refreshBookingWithInfo:_dic_pushInfo];
        return;
      }
      
      //进入booking界面的history列表
      NSString *_str_id = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
      FGControllerManager *manager = [FGControllerManager sharedManager];
      FGManageBookingViewController *vc_booking = [[FGManageBookingViewController alloc] initWithNibName:@"FGManageBookingViewController" bundle:nil withId:_str_id  withInfo:@{@"type":@1}];
      [manager pushController:vc_booking navigationController:nav_current];
    }
    return;
  }
  
  
  NSInteger _int_type = [_dic_pushInfo[@"action"] integerValue];
  if (_int_type == -1) {
    NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:_dic_pushInfo];
    [_mdic setObject:_str_message forKey:@"alert"];
    [EBForeNotification handleRemoteNotification:@{@"aps":_mdic} soundID:1312 isIos10:YES];
    return;
  }
  
  if (_int_type == 1) {
    NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:_dic_pushInfo];
    [_mdic setObject:_str_message forKey:@"alert"];
    [EBForeNotification handleRemoteNotification:@{@"aps":_mdic} soundID:1312 isIos10:YES];
    // FIXME: lu 订单数量
    //需要最新的订单数量
    [commond saveBookingCntWithCnt:1];
    //如果是profile界面需要刷新界面
    if ([nav_current.topViewController isKindOfClass:[FGProfileViewController class]]) {
      NSLog(@"在profile界面...");
      FGProfileViewController *_vc = (FGProfileViewController *)nav_current.topViewController;
      [_vc refreshBookingBadgeNumber];
      return;
    }
    
    if ([nav_current.topViewController isKindOfClass:[FGManageBookingViewController class]]) {
      //如果已经在booking界面需要自动刷新
      NSLog(@"如果已经在booking界面需要自动刷新");
      FGManageBookingViewController *vc_booking = (FGManageBookingViewController*)nav_current.topViewController;
      [vc_booking refreshBookingWithInfo:_dic_pushInfo];
      return;
    }
    
    
  } else if (_int_type == 2) {
    
    NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:_dic_pushInfo];
    [_mdic setObject:_str_message forKey:@"alert"];
    [EBForeNotification handleRemoteNotification:@{@"aps":_mdic} soundID:1312 isIos10:YES];
    [commond saveBookingCntWithCnt:1];
    //如果是profile界面需要刷新界面
    if ([nav_current.topViewController isKindOfClass:[FGProfileViewController class]]) {
      NSLog(@"在profile界面...");
      FGProfileViewController *_vc = (FGProfileViewController *)nav_current.topViewController;
      [_vc refreshBookingBadgeNumber];
      return;
    }
    
    if ([nav_current.topViewController isKindOfClass:[FGManageBookingViewController class]]) {
      //如果已经在booking界面需要自动刷新
      NSLog(@"如果已经在booking界面需要自动刷新");
      FGManageBookingViewController *vc_booking = (FGManageBookingViewController*)nav_current.topViewController;
      [vc_booking refreshBookingWithInfo:_dic_pushInfo];
      return;
    }
    
    
    
  }
}

-(void)dddd:(NSNotification*)noti{
  NSLog(@"ddd,%@",noti);
  BOOL _bool_appActived = [(NSNumber *)[commond getUserDefaults:APPACTIVE_NOTIFICATION] boolValue];
  if (_bool_appActived) {
    if ([nav_current.topViewController isKindOfClass:[FGManageBookingViewController class]]) {
      return;
    }
  }
  
  NSDictionary *_dic_pushInfo = ((NSDictionary *)[noti object])[@"aps"];
  NSInteger _int_type = [_dic_pushInfo[@"action"] integerValue];
  if (_int_type == 1) {
        //进入booking界面的pending列表
        NSString *_str_id = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
        FGControllerManager *manager = [FGControllerManager sharedManager];
        FGManageBookingViewController *vc_booking = [[FGManageBookingViewController alloc] initWithNibName:@"FGManageBookingViewController" bundle:nil withId:_str_id withInfo:@{@"type":@0}];
        [manager pushController:vc_booking navigationController:nav_current];
  } else if (_int_type == 2) {
    //进入booking界面的history列表
    NSString *_str_id = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGManageBookingViewController *vc_booking = [[FGManageBookingViewController alloc] initWithNibName:@"FGManageBookingViewController" bundle:nil withId:_str_id  withInfo:@{@"type":@1}];
    [manager pushController:vc_booking navigationController:nav_current];
  }
}

@end

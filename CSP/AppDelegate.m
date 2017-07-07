//
//  AppDelegate.m
//  CSP
//
//  Created by Ryan Gong on 16/8/22.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "AppDelegate.h"
#import "FGUtils.h"
#import "Global.h"
#import "UIImage+BlurEffect.h"
#import <AlipaySDK/AlipaySDK.h>
#import "FGPostLikesCommentsSyncModel.h"
#import "AppDelegate+PushHandler.h"

#pragma mark - JPush 功能

// 引JPush功能所需头 件
#import "JPUSHService.h"
// iOS10注册APNs所需头 件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

// 如果需要使 idfa功能所需要引 的头 件(可选)
#import <AdSupport/AdSupport.h>
#import "FGMaoPao.h"

@interface AppDelegate () <JPUSHRegisterDelegate>

@end

@implementation AppDelegate
@synthesize deviceToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    FGMaoPao *maopao = [[FGMaoPao alloc] init];
    [maopao doMaoPao];
    
    
  //设置启动页停留时间
  [NSThread sleepForTimeInterval:1.0];
  
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    [NetworkEventTrack sharedEventTrack];
    
    
    [AMapServices sharedServices].apiKey = AUTONAVI_KEY;//设置高德地图apiKey
    [[FGLocationManagerWrapper sharedManager] startUpdatingLocation:^(CLLocationDegrees _lat, CLLocationDegrees _lng) {}];
  // Override point for customization after application launch.
  /*加载字体*/
  [FGFont loadMyFonts];
  [FGFont showSupportedFont];
  
  //初始化
  [self internalInitalOnlyOnce];


  /*初始化window*/
  self.window                 = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];

  [self.window makeKeyAndVisible];
  [self go2FirstPage];
    
  //开始监听,会启动一个run loop

  /*注册push*/

  //[self registePushWithOptions:launchOptions];
  

  [self registePushWithOptions:launchOptions];
    
    /*添加一个网络状态监听*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myReachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability *hostReach = [Reachability reachabilityForInternetConnection]; //可以以多种形式初始化
    [hostReach startNotifier];
  return YES;
}

- (void)registePushWithOptions:(NSDictionary *)_dic_options {
//  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
//                                                                            settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert)
//                                                                                  categories:nil]];
//      
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//  } else {
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//                                           (UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
//  }
  
  
  
  
  ////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////以下是注册push代码//////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  
  
  // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
  JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
  entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    //可以添加自定义categories
    //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
    //      NSSet<UNNotificationCategory *> *categories;
    //      entity.categories = categories;
    //    }
    //    else {
    //      NSSet<UIUserNotificationCategory *> *categories;
    //      entity.categories = categories;
    //    }
  }
  [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
  //如不需要使用IDFA，advertisingIdentifier 可为nil
  [JPUSHService setupWithOption:_dic_options
                         appKey:JPush_AppKey
                        channel:JPush_Channel
               apsForProduction:isProduction
          advertisingIdentifier:nil];
  
  //2.1.9版本新增获取registration id block接口。
  [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
    if(resCode == 0){
      NSLog(@"registrationID获取成功：%@",registrationID);
    }
    else{
      NSLog(@"registrationID获取失败，code：%d",resCode);
    }
  }];
}

- (void)go2FirstPage {
  FGControllerManager *manager = [FGControllerManager sharedManager];
  
    if([self isLoggedIn])
    {
        FGLocationViewController *vc_location = [[FGLocationViewController alloc] initWithNibName:@"FGLocationViewController" bundle:nil];
        [manager initNavigation:&nav_location rootController:vc_location];
    }
    else
    {
        [manager initNavigation:&nav_location rootControllerName:@"FGLoadingViewController"];
    }
}

-(BOOL)isLoggedIn
{
    id obj = [commond getUserDefaults:KEY_API_USER_ACCESSTOKEN];
    
    if(!obj || [obj isEqual:@""])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)logout
{
  //注销JPush别名
  [FGUtils jpush_resignAlias];
    [self setAsGuest];
  
  [nav_home popToRootViewControllerAnimated:NO];
  [nav_training popToRootViewControllerAnimated:NO];
  [nav_post popToRootViewControllerAnimated:NO];
  [nav_location popToRootViewControllerAnimated:NO];
  [nav_profile popToRootViewControllerAnimated:NO];
  
  nav_home = nil;
  nav_training = nil;
  nav_post = nil;
  nav_location = nil;
  nav_profile = nil;
  
  FGControllerManager *manager = [FGControllerManager sharedManager];
  [manager initNavigation:&nav_location rootControllerName:@"FGLoginViewController"];
}

-(void)setAsGuest
{
    [commond setUserDefaults:@"" forKey:KEY_API_USER_ACCESSTOKEN];
    [commond setUserDefaults:@"0" forKey:KEY_API_USER_USERID];
    [commond setUserDefaults:@"" forKey:KEY_DEFAULT_ADDRESS1];
    [commond setUserDefaults:@"" forKey:KEY_DEFAULT_ADDRESS2];
    [commond setUserDefaults:@"" forKey:KEY_DEFAULT_ADDRESS1_LAT];
    [commond setUserDefaults:@"" forKey:KEY_DEFAULT_ADDRESS1_LNG];
    [commond setUserDefaults:@"" forKey:KEY_DEFAULT_ADDRESS2_LAT];
    [commond setUserDefaults:@"" forKey:KEY_DEFAULT_ADDRESS2_LNG];
}


#pragma mark - url scheme 回调
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        [self dealWithAlipayCallback:url];
    }
    
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    NSString *sourceApplication = options[@"UIApplicationOpenURLOptionsSourceApplicationKey"];
    if ([url.host isEqualToString:@"safepay"]) {
        [self dealWithAlipayCallback:url];
    }
    
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

#pragma mark - 处理支付宝同步回调
-(void)dealWithAlipayCallback:(NSURL *)url
{
    
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [self afterAlipayCallback:resultDic];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    

}

-(void)afterAlipayCallback:(NSDictionary *) resultDic
{
    NSDictionary *_dic_result = [resultDic copy];
    NSLog(@"1._dic_result = %@",_dic_result);
    int resultStatus = [[_dic_result objectForKey:@"resultStatus"] intValue];
    
    NSString *str_result = [_dic_result objectForKey:@"result"];
    NSMutableDictionary *_dic_tmp = [str_result objectFromJSONString];
    
    NSString *str_msg = [[_dic_tmp objectForKey:@"alipay_trade_app_pay_response"] objectForKey:@"msg"];
    if(resultStatus == 9000)
    {
        [self confirmOrderAfterPayment];
    }
    else
    {
        [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"payment failed!") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
            
        }];
    }
    /* 9000	订单支付成功
     8000	正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
     4000	订单支付失败
     5000	重复请求
     6001	用户中途取消
     6002	网络连接出错
     6004	支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态*/
}

-(void)confirmOrderAfterPayment
{
    FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];
    if(paymentModel.paymentCheckType == PaymentCheckType_Buy1Session)
    {
        NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"From3rdPayment" notifyOnVC:nil];
        [[NetworkManager_Location sharedManager] postRequest_Locations_orderDetailWithOrderId:paymentModel.str_currentRequestedOrderId userinfo:_dic_info];
    }
    else if(paymentModel.paymentCheckType == PaymentCheckType_BuyBundle)
    {
        NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"From3rdPayment" notifyOnVC:nil];
        [[NetworkManager_Location sharedManager] postRequest_Locations_GetBundleInfo:_dic_info];
    }
}

#pragma mark - 处理微信同步回调
-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                [self confirmOrderAfterPayment];
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
}

#pragma mark - 初始化头像信息
- (void)internalInitalOnlyOnce {
  NSNumber *_number = (NSNumber *)[commond getUserDefaults:@"isInit"];
  
  [FGUtils internalInitalUserAvatar];
  
  _number = (NSNumber *)[commond getUserDefaults:STATUS_NOTIFICATION];
  if (ISNULLObj(_number))
  {
    [commond setUserDefaults:[NSNumber numberWithBool:YES] forKey:STATUS_NOTIFICATION];
  }
  
  _number = (NSNumber *)[commond getUserDefaults:BOOKINGCNT];
  if (ISNULLObj(_number))
  {
    [commond setUserDefaults:[NSNumber numberWithInteger:0] forKey:BOOKINGCNT];
  }
}

- (void)updateUserAvatarWithImage:(UIImage *)_img {
  
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
  NSDictionary * userInfo = notification.request.content.userInfo;
  
  UNNotificationRequest *request = notification.request; // 收到推送的请求
  UNNotificationContent *content = request.content; // 收到推送的消息内容
  
  NSNumber *badge = content.badge;  // 推送消息的角标
  NSString *body = content.body;    // 推送消息体
  UNNotificationSound *sound = content.sound;  // 推送消息的声音
  NSString *subtitle = content.subtitle;  // 推送消息的副标题
  NSString *title = content.title;  // 推送消息的标题
  
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS10 前台收到远程通知:%@", [FGUtils logDic:userInfo]);
    
//    [rootViewController addNotificationCount];
    //解析推送信息
    [self action_parsePushWithInfo:userInfo];
  }
  else {
    // 判断为本地通知
    NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
  }
  completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
  
  NSDictionary * userInfo = response.notification.request.content.userInfo;
  UNNotificationRequest *request = response.notification.request; // 收到推送的请求
  UNNotificationContent *content = request.content; // 收到推送的消息内容
  
  NSNumber *badge = content.badge;  // 推送消息的角标
  NSString *body = content.body;    // 推送消息体
  UNNotificationSound *sound = content.sound;  // 推送消息的声音
  NSString *subtitle = content.subtitle;  // 推送消息的副标题
  NSString *title = content.title;  // 推送消息的标题
   
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS10 收到远程通知:%@", [FGUtils logDic:userInfo]);
//    [rootViewController addNotificationCount];
    //解析推送信息
    [self action_parsePushWithInfo:userInfo];
  }
  else {
    // 判断为本地通知
    NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
  }
  
  completionHandler();  // 系统要求执行这个方法
}
#endif

#pragma mark － 网络状态监测回调
- (void)myReachabilityChanged:(NSNotification *)notification {
    Reachability *reach = [notification object];
    //判断网络状态
    if (![reach isReachable]) {
        NSLog(@"网络连接不可用");
    } else {
        [commond removeLoading];
        [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please check your network connection!") callback:nil];
        if ([reach currentReachabilityStatus] == ReachableViaWiFi) {
            NSLog(@"正在使用WiFi");
        } else if ([reach currentReachabilityStatus] == ReachableViaWWAN) {
            NSLog(@"正在使用移动数据");
        }
    }
}

@end

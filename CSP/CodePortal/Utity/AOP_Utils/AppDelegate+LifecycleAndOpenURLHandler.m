//
//  AppDelegate+LifecycleAndOpenURLHandler.m
//  CSP
//
//  Created by JasonLu on 16/9/21.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "AppDelegate+LifecycleAndOpenURLHandler.h"
#import "AppDelegate.h"
#import "CUtils.h"
#import "NSString+Utility.h"

#pragma mark - 分享功能
#import "WBApiWrapper.h"
#import "WXApiWrapper.h"
#import "sdkCall.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

//Facebook Messenger SDK
#import <FBSDKMessengerShareKit/FBSDKMessengerSharer.h>

#define kConst_QQApplication @"com.tencent.mqq"
#define kConst_FBApplication @"com.fbook.cd"
#define kConst_SafariApplication @"com.apple.SafariViewService"
#define kCompareTwoStringIsSame(x, y) [x isEqualToString:y]

@implementation AppDelegate (LifecycleAndOpenURLHandler)
+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class class = [self class];
    
    swizzleMethod(class, @selector(application:didFinishLaunchingWithOptions:), @selector(AOP_LH_application:didFinishLaunchingWithOptions:));
    swizzleMethod(class, @selector(applicationWillResignActive:), @selector(AOP_LH_applicationWillResignActive:));
    swizzleMethod(class, @selector(applicationDidEnterBackground:), @selector(AOP_LH_applicationDidEnterBackground:));
    swizzleMethod(class, @selector(applicationWillEnterForeground:), @selector(AOP_LH_applicationWillEnterForeground:));
    swizzleMethod(class, @selector(applicationDidBecomeActive:), @selector(AOP_LH_applicationDidBecomeActive:));
    swizzleMethod(class, @selector(applicationWillTerminate:), @selector(AOP_LH_applicationWillTerminate:));

    swizzleMethod(class, @selector(application:openURL:sourceApplication:annotation:), @selector(AOP_application:openURL:sourceApplication:annotation:));
    swizzleMethod(class, @selector(application:openURL:options:), @selector(AOP_application:openURL:options:));
    //    swizzleMethod(class, @selector(application:handleOpenURL:), @selector(AOP_application:handleOpenURL:));

  });
}

#pragma mark - Lifecycle handler
- (BOOL)AOP_LH_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //设置share功能
  [ShareSDK registerApp:@"1ad9ad9f877e4"
        activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                          @(SSDKPlatformTypeMail),
                          @(SSDKPlatformTypeFacebook),
                          @(SSDKPlatformTypeTwitter),
                          @(SSDKPlatformTypeWechat),
                          @(SSDKPlatformTypeQQ),
                          @(SSDKPlatformTypeSMS),
                          @(SSDKPlatformTypeCopy)
//                          @(SSDKPlatformTypeInstagram)
                          ]
               onImport:^(SSDKPlatformType platformType) {
                 
                 switch (platformType)
                 {
                   case SSDKPlatformTypeWechat:
                     [ShareSDKConnector connectWeChat:[WXApi class]];
                     break;
                   case SSDKPlatformTypeQQ:
                     [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                     break;
                   case SSDKPlatformTypeSinaWeibo:
                     [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                     break;
                   case SSDKPlatformTypeFacebookMessenger:
                     [ShareSDKConnector connectFacebookMessenger:[FBSDKMessengerSharer class]];
                     break;
                   default:
                     break;
                 }
                 
               }
        onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
          
          switch (platformType)
          {
            case SSDKPlatformTypeSinaWeibo:
              //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
              [appInfo SSDKSetupSinaWeiboByAppKey:WEIBO_APPKEY
                                        appSecret:WEIBO_APPSECRET
                                      redirectUri:WEIBO_kRedirectURI
                                         authType:SSDKAuthTypeBoth];
              break;
            case SSDKPlatformTypeFacebook:
              //设置Facebook应用信息，其中authType设置为只用Web形式授权
              [appInfo SSDKSetupFacebookByApiKey:FB_APPID
                                       appSecret:FB_APPSECRET
                                        authType:SSDKAuthTypeBoth];
              break;
            case SSDKPlatformTypeTwitter:
              //设置Twitter应用信息
              [appInfo SSDKSetupTwitterByConsumerKey:TW_APPID
                                      consumerSecret:TW_APPSECRET
                                         redirectUri:TW_kRedirectURI];
              break;
            case SSDKPlatformTypeWechat:
              //设置微信应用信息
              [appInfo SSDKSetupWeChatByAppId:WECHAT_APPID
                                    appSecret:WECHAT_APPSECRET];
              break;
            case SSDKPlatformTypeQQ:
              //设置QQ应用信息，其中authType设置为只用SSO形式授权
              [appInfo SSDKSetupQQByAppId:QQ_APPID
                                   appKey:QQ_APPKEY
                                 authType:SSDKAuthTypeSSO];
              break;
            case SSDKPlatformTypeInstagram:
              [appInfo SSDKSetupInstagramByClientID:IG_APPID
                                       clientSecret:@""
                                        redirectUri:@""];
              break;
            case SSDKPlatformTypeSMS:
              //[appInfo SSDKSetupSMSParamsByText:<#(NSString *)#> title:<#(NSString *)#> images:<#(id)#> attachments:<#(id)#> recipients:<#(NSArray *)#> type:<#(SSDKContentType)#>]
              break;
            case SSDKPlatformTypeCopy:
              //[appInfo SSDKSetupCopyParamsByText:<#(NSString *)#> images:<#(id)#> url:<#(NSURL *)#> type:<#(SSDKContentType)#>]
              break;
            default:
              break;
          }
        }];
  
  //向微信注册
  [WXApi registerApp:WECHAT_APPID withDescription:@"demo 2.0"];
  //向微博注册
  [WeiboSDK registerApp:WEIBO_APPKEY];
  
 

  
  return [self AOP_LH_application:application didFinishLaunchingWithOptions:launchOptions];
  
}

- (void)AOP_LH_applicationWillResignActive:(UIApplication *)application {
  NSLog(@"AOP_LH_applicationWillResignActive");
  // TODO: 如果需要调用原来AppDelegate对应方法请打开注释
  //    [self AOP_LH_applicationWillResignActive:application];
  [commond setUserDefaults:@(NO) forKey:APPACTIVE_NOTIFICATION];
}

- (void)AOP_LH_applicationDidEnterBackground:(UIApplication *)application {
  NSLog(@"AOP_LH_applicationDidEnterBackground");
  // TODO: 如果需要调用原来AppDelegate对应方法请打开注释
  //    [self AOP_LH_applicationDidEnterBackground:application];
}

- (void)AOP_LH_applicationWillEnterForeground:(UIApplication *)application {
  NSLog(@"AOP_LH_applicationWillEnterForeground");
  // TODO: 如果需要调用原来AppDelegate对应方法请打开注释
  //    [self AOP_LH_applicationWillEnterForeground:application];
}

- (void)AOP_LH_applicationDidBecomeActive:(UIApplication *)application {
  NSLog(@"AOP_LH_applicationDidBecomeActive");
//  [FBSDKSettings setAppID:@"251866938571947"];
//  [FBSDKAppEvents activateApp];
//  // TODO: 如果需要调用原来AppDelegate对应方法请打开注释
//  //    [self AOP_LH_applicationDidBecomeActive:application];
//
  
//  再次注册别名，放置登录时候没有注册推送别名
  NSLog(@"userid ==%@", [commond getUserDefaults:JPush_UserId]);
  if (!ISNULLObj([commond getUserDefaults:JPush_UserId])) {
    NSString *_str_userid = [NSString stringWithFormat:@"%@",[commond getUserDefaults:JPush_UserId]];
    NSLog(@"userid ==%@", _str_userid);
    //  [FGUtils jpush_registerAlias:_str_userid];
  }

//  处于激活状态
  [commond setUserDefaults:@(YES) forKey:APPACTIVE_NOTIFICATION];
  [commond saveBookingCntWithCnt:0];
  application.applicationIconBadgeNumber = 0;
}

- (void)AOP_LH_applicationWillTerminate:(UIApplication *)application {
  NSLog(@"AOP_LH_applicationWillTerminate");
}

#pragma mark - open url handler
- (BOOL)AOP_application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  NSLog(@"sourceApplication==%@,url==%@", sourceApplication, url);

  // qq客户端打开
  if (kCompareTwoStringIsSame(sourceApplication, kConst_QQApplication))
    return [TencentOAuth HandleOpenURL:url];

//  // fb客户端打开
//  if (kCompareTwoStringIsSame(sourceApplication, kConst_FBApplication)) {
//    return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                          openURL:url
//                                                sourceApplication:sourceApplication
//                                                       annotation:annotation];
//  }

  if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
    return [WXApi handleOpenURL:url delegate:[WXApiWrapper sharedManager]];
  } else if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
    return [WeiboSDK handleOpenURL:url delegate:[WBApiWrapper sharedManager]];
  }

  // 浏览器打开
  if (kCompareTwoStringIsSame(sourceApplication, kConst_SafariApplication)) {
    if ([url.absoluteString contains:@"fb251866938571947" withIgnoreCase:NO]) {
//      return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                            openURL:url
//                                                  sourceApplication:sourceApplication
//                                                         annotation:annotation];
    } else if ([url.absoluteString contains:@"tencent" withIgnoreCase:NO]) {
      return [TencentOAuth HandleOpenURL:url];
    } else if ([url.absoluteString contains:@"weibo" withIgnoreCase:NO]) {
      return [WeiboSDK handleOpenURL:url delegate:[WBApiWrapper sharedManager]];
    }
  }

  return NO;
}

// NOTE: 9.0以后使用新API接口
//- (BOOL)AOP_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
- (BOOL)AOP_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
  [self AOP_application:app openURL:url options:options];
  
  
  NSLog(@"sourceApplication==%@,url==%@", app, url);
  NSLog(@"options==%@",options);
  NSString *sourceApplication = options[@"UIApplicationOpenURLOptionsSourceApplicationKey"];
  
  // qq客户端打开
  if (kCompareTwoStringIsSame(sourceApplication, kConst_QQApplication))
    return [TencentOAuth HandleOpenURL:url];
  
  // fb客户端打开
//  if (kCompareTwoStringIsSame(sourceApplication, kConst_FBApplication)) {
//    return [[FBSDKApplicationDelegate sharedInstance] application:app
//                                                          openURL:url
//                                                sourceApplication:sourceApplication
//                                                       annotation:nil];
//  }
  
  if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
    return [WXApi handleOpenURL:url delegate:[WXApiWrapper sharedManager]];
      
  } else if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
    return [WeiboSDK handleOpenURL:url delegate:[WBApiWrapper sharedManager]];
  }
  
  // 浏览器打开
  if (kCompareTwoStringIsSame(sourceApplication, kConst_SafariApplication)) {
    if ([url.absoluteString contains:@"fb251866938571947" withIgnoreCase:NO]) {
//      return [[FBSDKApplicationDelegate sharedInstance] application:app
//                                                            openURL:url
//                                                  sourceApplication:sourceApplication
//                                                         annotation:nil];
    } else if ([url.absoluteString contains:@"tencent" withIgnoreCase:NO]) {
      return [TencentOAuth HandleOpenURL:url];
    } else if ([url.absoluteString contains:@"weibo" withIgnoreCase:NO]) {
      return [WeiboSDK handleOpenURL:url delegate:[WBApiWrapper sharedManager]];
    }
  }
  
  
  return YES;
  
}

- (BOOL)AOP_application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  // 浏览器打开
  if ([url.absoluteString contains:@"tencent" withIgnoreCase:NO]) {
    return [TencentOAuth HandleOpenURL:url];
  } else if ([url.absoluteString contains:@"weibo" withIgnoreCase:NO]) {
    return [WeiboSDK handleOpenURL:url delegate:[WBApiWrapper sharedManager]];
  }
  return NO;
}

@end

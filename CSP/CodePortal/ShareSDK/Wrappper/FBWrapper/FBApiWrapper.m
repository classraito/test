//
//  FBApiWrapper.m
//  CSP
//
//  Created by JasonLu on 16/9/12.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FBApiWrapper.h"
#import "NSString+Utility.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKCoreKit/FBSDKProfile.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Social/Social.h>

static id _instance = nil;
@interface FBApiWrapper () <FBSDKSharingDelegate> {
}
@property (nonatomic, assign) BOOL isLogined;
@property (nonatomic, copy) CompletetionHandler completetionHandler;
@property (nonatomic, copy) NSString *fbUsername;
@property (nonatomic, strong) FBSDKLoginManagerLoginResult *fbLoginResult;
@property (nonatomic, strong) FBSDKLoginManager *login;

@end

@implementation FBApiWrapper
@synthesize completetionHandler;
#pragma mark - 单例方法
+ (FBApiWrapper *)shareInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [[self alloc] init];
  });
  return _instance;
}

#pragma mark - 工具方法
- (void)fbLoginAction {
  FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
  [login
      logInWithReadPermissions:@[ @"public_profile" ]
            fromViewController:nil
                       handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                         if (error) {
                           NSLog(@"Process error");
                         } else if (result.isCancelled) {
                           NSLog(@"Cancelled");
                         } else {
                           NSLog(@"Logged in");
                           self.fbLoginResult = result;

                           //登录成功
                           //保存token
                           if (![[self fbToken] isEmptyStr] &&
                               [[self fbToken] length] > 0) {
//                             [commond saveToKeyChain:KEYCHAIN_KEY_ACCESSTOKEN_FB passwd:[self fbToken]];
                             [commond setUserDefaults:[self fbToken] forKey:KEYCHAIN_KEY_ACCESSTOKEN_FB];
                           }

                           //保存用户的唯一标识
                           if (![[self fbUserID] isEmptyStr] &&
                               [[self fbUserID] length] > 0) {
//                             [commond saveToKeyChain:KEYCHAIN_KEY_USERID_FB passwd:[self fbUserID]];
                              [commond setUserDefaults:[self fbUserID] forKey:KEYCHAIN_KEY_USERID_FB];
                           }

                           //获取用户姓名
                           [self fbGetGraphWithRepHandler:^(id result, NSError *error){
                           }];
                         }
                       }];
}

/*!
 *  @brief 登录facebook
 *
 *  @param VCtrl          请求登录时当前视图控制器(ViewController)
 *  @param handler        请求结束后的回调函数
 *
 */
- (void)fbLoginInVCtrl:(UIViewController *)VCtrl withCompletetionHandler:(CompletetionHandler)handler {
  self.completetionHandler = handler;
  FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
  [login
      logInWithReadPermissions:@[ @"public_profile" ]
            fromViewController:VCtrl
                       handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                         if (error) {
                           NSLog(@"Process error");
                         } else if (result.isCancelled) {
                           NSLog(@"Cancelled");
                         } else {
                           NSLog(@"Logged in");
                           self.fbLoginResult = result;

                           //登录成功
                           //保存token
                           if (![[self fbToken] isEmptyStr] &&
                               [[self fbToken] length] > 0) {
//                             [commond saveToKeyChain:KEYCHAIN_KEY_ACCESSTOKEN_FB passwd:[self fbToken]];
                             [commond setUserDefaults:[self fbToken] forKey:KEYCHAIN_KEY_ACCESSTOKEN_FB];

                           }

                           //保存用户的唯一标识
                           if (![[self fbUserID] isEmptyStr] &&
                               [[self fbUserID] length] > 0) {
//                             [commond saveToKeyChain:KEYCHAIN_KEY_USERID_FB passwd:[self fbUserID]];
//                             [commond saveToKeyChain:KEYCHAIN_KEY_OPENID_FB passwd:[self fbUserID]];
                             
                             [commond setUserDefaults:[self fbUserID] forKey:KEYCHAIN_KEY_USERID_FB];
                             [commond setUserDefaults:[self fbUserID] forKey:KEYCHAIN_KEY_OPENID_FB];

                           }

                           //获取用户姓名
                           [self fbGetGrapRequestAction];
                         }
                       }];
}
/*!
 *  @brief 获取登录后facebook的用户信息
 *
 *  @param handler        请求结束后的回调函数
 *
 */
- (void)fbGetProfileWithRepHandler:(CompletetionHandler)handler {
  //获取用户基本信息
  [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *profile, NSError *error) {
    NSLog(@"firstName==%@", profile.firstName);
    NSLog(@"lastName==%@", profile.lastName);
    handler(profile, error);
  }];
}
/*!
 *  @brief 获取登录后facebook的用户图表信息
 *
 */
- (void)fbGetGrapRepHandler:(CompletetionHandler)handler {
  if ([self fbNoLoginInfo]) {
    NSLog(@"没有登录信息...需要登录fb才能获取用户信息");
    return;
  }

  //获取用户图表
  NSDictionary *params       = [NSDictionary new];
  FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
      initWithGraphPath:[self fbUserID]
             parameters:params
             HTTPMethod:@"GET"];

  [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                        id result,
                                        NSError *error) {
    NSString *name   = [result objectForKey:@"name"];
    NSString *userid = [result objectForKey:@"id"];
    NSLog(@"name=%@ userID=%@ ", name, userid); //这里就是登录后拿到的用户信息提交到自己服务器吧！
    self.fbUsername = name;
    //通知调用者请求结束了，进行回调
    handler(result, error);
  }];
}

- (void)fbGetGrapRequestAction {
  if ([self fbNoLoginInfo]) {
    NSLog(@"没有登录信息...需要登录fb才能获取用户信息");
    return;
  }

  NSLog(@"USER ID=%@", [self fbUserID]);
  //获取用户图表
  NSDictionary *params       = [NSDictionary new];
  FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
      initWithGraphPath:[self fbUserID]
             parameters:params
             HTTPMethod:@"GET"];

  [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                        id result,
                                        NSError *error) {
    NSError *err       = nil;
    NSDictionary *info = nil;

    if (error != nil) {
      //处理异常
      err = [NSError errorWithDomain:@"获取用户信息失败!" code:-1 userInfo:nil];
    } else {
      NSString *name   = [result objectForKey:@"name"];
      NSString *userid = [result objectForKey:@"id"];
      NSLog(@"name=%@ userID=%@ ", name, userid); //这里就是登录后拿到的用户信息提交到自己服务器吧！
      self.fbUsername = name;
      //通知调用者请求结束了，进行回调
      //保存用户基本信息
      NSDictionary *userinfo = @{ @"Name" : name,
                                  @"id" : userid };
      NSString *_str_json = [userinfo JSONString];
      
//      [commond saveToKeyChain:KEYCHAIN_KEY_FB_USERINFO passwd:_str_json];
      
      [commond setUserDefaults:_str_json forKey:KEYCHAIN_KEY_FB_USERINFO];

      info = @{ @"openid" : [commond getUserDefaults:KEYCHAIN_KEY_OPENID_FB],
                @"accesstoken" : [commond getUserDefaults:KEYCHAIN_KEY_ACCESSTOKEN_FB] };
    }

    if (self.completetionHandler) {
      completetionHandler(info, err);
      self.completetionHandler = nil;
    }
  }];
}

#pragma mark - 分享方法
- (void)fbShareWithImages:(NSArray *)_arr_img inVCtrl:(UIViewController *)vCtrl{
  NSMutableArray *_marr_photos = [NSMutableArray array];
  for (int i = 0; i < _arr_img.count; i++) {
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = _arr_img[i];
    photo.userGenerated = YES;
    [_marr_photos addObject:photo];
  }
  
  
  FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
  content.photos = _marr_photos;
  
  [FBSDKShareDialog showFromViewController:vCtrl
                               withContent:content
                                  delegate:self];
  
}
- (void)fbShareWithTitle:(NSString *)title shareURL:(NSString *)url sharePreviewURL:(NSString *)previewurl inVCtrl:(UIViewController *)vCtrl {
  //  if (![FBSDKAccessToken currentAccessToken]) {
  NSString *fbToken = [commond getUserDefaults:KEYCHAIN_KEY_ACCESSTOKEN_FB];
  if (ISNULLObj(fbToken) ||
      [fbToken isEmptyStr]) {
    self.login = nil;
    self.login = [[FBSDKLoginManager alloc] init];

    [self.login logInWithPublishPermissions:@[ @"publish_actions" ] fromViewController:vCtrl handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
      if (error) {
        // Process error
        NSLog(@"Process error");
      } else if (result.isCancelled) {
        // Handle cancellations
      } else {
        //        [self useFacebookAppToShareWithTitle:title desctiption:@"" shareURL:url sharePreviewURL:previewurl];
        if ([result.grantedPermissions containsObject:@"publish_actions"]) {
          [self useFacebookAppToShareWithTitle:title desctiption:@"" shareURL:url sharePreviewURL:previewurl inVCtrl:vCtrl];
        } else {
          [self useFacebookAppToShareWithTitle:title desctiption:@"" shareURL:url sharePreviewURL:previewurl inVCtrl:vCtrl];
        }
      }
    }];
    return;
  } else if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
    [self useFacebookAppToShareWithTitle:title desctiption:@"" shareURL:url sharePreviewURL:previewurl inVCtrl:vCtrl];
  } else {
    // TODO: - func ok
    [self useFacebookAppToShareWithTitle:title desctiption:@"" shareURL:url sharePreviewURL:previewurl inVCtrl:vCtrl];
  }
  return;
}

- (id<FBSDKSharingContent>)shareStaticContent {
  FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
  content.contentURL             = [NSURL URLWithString:@"http://www.baidu.com"];
  content.imageURL               = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Facebook_Headquarters_Menlo_Park.jpg/2880px-Facebook_Headquarters_Menlo_Park.jpg"];
  content.contentTitle           = @"Share Test";
  content.contentDescription     = @"Allow your users to share stories on Facebook from your app using the iOS SDK.";
  return content;
}

- (void)useFacebookAppToShareWithTitle:(NSString *)title desctiption:(NSString *)description shareURL:(NSString *)url sharePreviewURL:(NSString *)previewurl inVCtrl:(UIViewController *)vCtrl {
  FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
  content.contentURL             = [NSURL URLWithString:url];        //[NSURL URLWithString:@"http://www.baidu.com"];
  content.imageURL               = [NSURL URLWithString:previewurl]; //[NSURL URLWithString:@"http://i.imgur.com/g3Qc1HN.png"];
  content.contentTitle           = title;
  content.contentDescription     = description;
  
  [FBSDKShareDialog showFromViewController:vCtrl
                               withContent:content
                                  delegate:self];
}

- (BOOL)isLogined {
  NSString *accesstoken = [commond getUserDefaults:KEYCHAIN_KEY_ACCESSTOKEN_FB];
  if (ISNULLObj(accesstoken) || [accesstoken isEmptyStr])
    _isLogined = NO;
  else
    _isLogined = YES;
  
  return _isLogined;
}

#pragma mark - 用户信息
- (BOOL)fbLogined {
  if (self.fbLoginResult == nil)
    return NO;
  return YES;
}
- (BOOL)fbNoLoginInfo {
  return ![self fbLogined];
}
/*!
 *  @brief 获取登录后facebook的token值
 *
 *  @return facebook的token
 */
- (NSString *)fbToken {
  if ([self fbNoLoginInfo])
    return @"";
  return [self.fbLoginResult token].tokenString;
}
/*!
 *  @brief 获取登录后facebook的用户的id
 *
 *  @return 用户的id
 */
- (NSString *)fbUserID {
  if ([self fbNoLoginInfo])
    return @"";
  return [self.fbLoginResult token].userID;
}
/*!
 *  @brief 获取登录后facebook的用户头像地址
 *
 *  @return 用户头像url地址
 */
- (NSString *)fbUserAvatarURL {
  if ([self fbNoLoginInfo])
    return @"";
  //获取用户头像
  NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [self fbUserID]];
  return userImageURL;
}
/*!
 *  @brief 获取登录后facebook的用户名字
 *
 *  @return 用户名字
 */
- (NSString *)fbUsername {
  if ([self fbNoLoginInfo])
    return @"";
  if (ISNULLObj(self.fbUsername))
    return @"";
  return self.fbUsername;
}

#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
  if (results.count > 0 && [results objectForKey:@"postId"] != nil) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:multiLanguage(@"ALERT") message:multiLanguage(@"Share Sucess") delegate:nil cancelButtonTitle:multiLanguage(@"Back") otherButtonTitles:nil];
    [alertView show];
  }
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"didFailWithError" message:@"error" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
  [alertView show];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"sharerDidCancel" message:@"cancel" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
  [alertView show];
}
@end

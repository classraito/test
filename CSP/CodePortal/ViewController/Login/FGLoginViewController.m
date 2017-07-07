//
//  FGLoginViewController.m
//  CSP
//
//  Created by JasonLu on 16/9/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "FGLoginView.h"
#import "FGLoginViewController.h"
#import "NetworkManager_User.h"
#import "QQApiWrapper.h"
#import "WBApiWrapper.h"
#import "WXApiWrapper.h"
#import "FGLoginInputNicknameViewController.h"
#import "FGLoginBindPhoneNumberViewController.h"
@interface FGLoginViewController ()
@property (nonatomic, strong) FGLoginView *view_login;
@end

@implementation FGLoginViewController
@synthesize str_myInvitationCode;
#pragma mark - 生命周期
- (void)viewDidLoad {
  [super viewDidLoad];
  [[UIApplication sharedApplication] setStatusBarHidden:YES];
  // Do any additional setup after loading the view from its nib.
  [self internalInitalViewController];
    [NetworkEventTrack trackDownloadAppIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (self.view_login) {
    [self.view_login refreshData];
  }
}

- (void)manullyFixSize {
  [super manullyFixSize];
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
    str_myInvitationCode = nil;
}

- (void)internalInitalViewController {
  [self hideBottomPanelWithAnimtaion:NO];
  [self topPanelStatus:Hidden withAnimtaion:NO];

  self.view_login = (FGLoginView *)[[[NSBundle mainBundle] loadNibNamed:@"FGLoginView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:self.view_login];
  [self.view_login setupByOriginalContentSize:self.view_login.bounds.size];
  [self.view addSubview:self.view_login];

  //绑定登录方法
  [self.view_login.btn_login_qq addTarget:self action:@selector(buttonAction_loginUseQQ:) forControlEvents:UIControlEventTouchUpInside];
  [self.view_login.btn_login_sina addTarget:self action:@selector(buttonAction_loginUseWeibo:) forControlEvents:UIControlEventTouchUpInside];
  [self.view_login.btn_login_wechat addTarget:self action:@selector(buttonAction_loginUseWechat:) forControlEvents:UIControlEventTouchUpInside];
  [self.view_login.btn_login_fb addTarget:self action:@selector(buttonAction_loginUseFB:) forControlEvents:UIControlEventTouchUpInside];

  [self.view_login.view_needhelp.btn addTarget:self action:@selector(buttonAction_skipGotoHomePage:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)go2HomeViewController {
    
  FGControllerManager *manager = [FGControllerManager sharedManager];
  [manager pushControllerByName:@"FGLocationViewController" inNavigation:nav_current withAnimtae:YES];
    
}

- (void)go2LoginInputNickname {
  FGLoginInputNicknameViewController *vc_inputInvitation = [[FGLoginInputNicknameViewController alloc] initWithNibName:@"FGLoginInputNicknameViewController" bundle:nil];
  FGControllerManager *manager = [FGControllerManager sharedManager];
  [manager pushController:vc_inputInvitation navigationController:nav_current];
}

- (void)go2LoginInputPhoneNumber {
  FGLoginBindPhoneNumberViewController *vc_inputInvitation = [[FGLoginBindPhoneNumberViewController alloc] initWithNibName:@"FGLoginBindPhoneNumberViewController" bundle:nil];
  FGControllerManager *manager = [FGControllerManager sharedManager];
  [manager pushController:vc_inputInvitation navigationController:nav_current];
}

-(void)go2LoginInputInvitationCode
{
    FGLoginInputInvitationCodeViewController *vc_inputInvitation = [[FGLoginInputInvitationCodeViewController alloc] initWithNibName:@"FGLoginInputInvitationCodeViewController" bundle:nil];
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager pushController:vc_inputInvitation navigationController:nav_current];
//    [self presentViewController:vc_inputInvitation animated:YES completion:^{ }];
}

#pragma mark - 从父类继承的
- (void)receivedDataFromNetwork:(NSNotification *)_notification {
  [super receivedDataFromNetwork:_notification];
  NSMutableDictionary *_dic_requestInfo = _notification.object;
  NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
  [commond removeLoading];
  // 验证码请求
  if ([HOST(URL_USER_SendVCodeMobileLogin) isEqualToString:_str_url]) {
      
  }

  // 登录请求
  if ([HOST(URL_USER_VerifyCodeMobileLogin) isEqualToString:_str_url]) {
      NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_USER_VerifyCodeMobileLogin)];
    
    //保存手机号码
    NSString *_str_mobile = _dic_requestInfo[MOBILEFORLOGIN];
    [commond setUserDefaults:_str_mobile forKey:MOBILEFORLOGIN];
    
    // 设置推送别名
    NSString *_str_userid = _dic_result[@"UserId"];
    [commond setUserDefaults:_str_userid forKey:JPush_UserId];
    [FGUtils jpush_registerAlias:_str_userid];
    [NetworkEventTrack track:KEY_TRACK_EVENTID_REGISTERAPP attrs:nil];//追踪:登录
    
    
      BOOL isNewUser = [[_dic_result objectForKey:@"NewUser"] boolValue];
//    isNewUser = YES;
      if(isNewUser)
      {
          str_myInvitationCode = [_dic_result objectForKey:@"InvitationCode"];
          //[self go2LoginInputInvitationCode];
        [commond setUserDefaults:str_myInvitationCode forKey:USERINVITATIONCODE];
        [self go2LoginInputNickname];
      }
      else
      {
         [self go2HomeViewController];
      }
    
    
    
  }

  //第三方登录
  if ([HOST(URL_USER_OauthLogin) isEqualToString:_str_url]) {
    
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_USER_OauthLogin)];
    BOOL isNewUser = [[_dic_result objectForKey:@"NewUser"] boolValue];
    
    NSString *_str_userid = _dic_result[@"UserId"];
    [commond setUserDefaults:_str_userid forKey:JPush_UserId];
    [FGUtils jpush_registerAlias:_str_userid];
    [NetworkEventTrack track:KEY_TRACK_EVENTID_REGISTERAPP attrs:nil];//追踪:登录
    if(isNewUser)
    {
      str_myInvitationCode = [_dic_result objectForKey:@"InvitationCode"];
//      [self go2LoginInputInvitationCode];
      [commond setUserDefaults:str_myInvitationCode forKey:USERINVITATIONCODE];

#ifdef NOINPUTPHONENUMBER_FEATURE
      [self go2LoginInputNickname];
#else
      [self go2LoginInputPhoneNumber];
#endif
      
    }
    else
    {
      [self go2HomeViewController];
    }
  }
}

- (void)requestFailedFromNetwork:(NSNotification *)_notification {
}

#pragma mark - 登录方式
- (void)buttonAction_loginUseQQ:(id)sender {
  [[QQApiWrapper shareInstance] qqloginActionWithCompletionHandler:^(id result, NSError *err) {
    if (err != nil) {
      //授权失败请重新登录
      [self showLoginOuthaFailMessage:[err domain]];
      return;
    }
    //登录成功后,调用OauthLogin接口
    NSDictionary *info = (NSDictionary *)result;
    NSString *_str_qq = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEYCHAIN_KEY_QQ_USERINFO]];
    NSDictionary *_dic_qqInfo = [_str_qq objectFromJSONString];
    
//    //保存本地QQ用户头像
//    [FGUtils saveUserAvatarWithUrlString:_dic_qqInfo[@"figureurl_qq_2"]];
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
    [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
    [[NetworkManager_User sharedManager] postRequest_OauthLogin:@"qq" gatewayID:info[@"openid"] gatewayToken:info[@"accesstoken"] userName:_dic_qqInfo[@"nickname"] userinfo:_dic_info];
  }];
}

- (void)buttonAction_loginUseWeibo:(id)sender {
  WBApiWrapper *wbapiWrapper = [WBApiWrapper sharedManager];
  [wbapiWrapper loginWithCompletetionHandler:^(id result, NSError *err) {
    if (err != nil) {
      //授权失败请重新登录
      [self showLoginOuthaFailMessage:[err domain]];
      return;
    }
    //登录成功后,调用OauthLogin接口
    NSDictionary *info = (NSDictionary *)result;
    NSString *_str_weibo = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEYCHAIN_KEY_WEIBOUSERINFO]];
    NSDictionary *_dic_weiboInfo = [_str_weibo objectFromJSONString];
    NSLog(@"name==%@",_dic_weiboInfo[@"Name"]);
    
//    [FGUtils saveUserAvatarWithUrlString:_dic_weiboInfo[@"avatarLargeUrl"]];
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
    [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
    [[NetworkManager_User sharedManager] postRequest_OauthLogin:@"weibo" gatewayID:info[@"openid"] gatewayToken:info[@"accesstoken"] userName:_dic_weiboInfo[@"screenName"] userinfo:_dic_info];
  }];
}

- (void)buttonAction_loginUseWechat:(id)sender {
  [[WXApiWrapper sharedManager] loginInViewController:self withCompletetionHandler:^(id result, NSError *err) {
    if (err != nil) {
      //授权失败请重新登录
      [self showLoginOuthaFailMessage:[err domain]];
      return;
    }
    //登录成功后,调用OauthLogin接口
    NSDictionary *info = (NSDictionary *)result;
    
    NSString *_str_wechat = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEYCHAIN_KEY_WECHAT_USERINFO]];
    NSDictionary *_dic_wechatInfo = [_str_wechat objectFromJSONString];
    NSLog(@"_dic_wechatInfo==%@", _dic_wechatInfo);
    
//    [FGUtils saveUserAvatarWithUrlString:_dic_wechatInfo[@"headimgurl"]];
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
    [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
    [[NetworkManager_User sharedManager] postRequest_OauthLogin:@"wechat" gatewayID:info[@"openid"] gatewayToken:info[@"accesstoken"] userName:_dic_wechatInfo[@"nickname"] userinfo:_dic_info];
  }];
}

- (void)buttonAction_loginUseFB:(id)sender {
//  [[FBApiWrapper shareInstance] fbLoginInVCtrl:sel0f withCompletetionHandler:^(id result, NSError *err) {
//    if (err != nil) {
//      //授权失败请重新登录
//      [self showLoginOuthaFailMessage:[err domain]];
//      return;
//    }
//    //登录成功后,调用OauthLogin接口
//    NSDictionary *info = (NSDictionary *)result;
//    NSString *_str_fb = [commond getFromKeyChain:KEYCHAIN_KEY_FB_USERINFO];
//    NSDictionary *_dic_fbInfo = [_str_fb objectFromJSONString];
//    NSLog(@"name==%@",_dic_fbInfo[@"Name"]);
//    
//    [[NetworkManager_User sharedManager] postRequest_OauthLogin:@"facebook" gatewayID:info[@"openid"] gatewayToken:info[@"accesstoken"] userName:_dic_fbInfo[@"Name"] userinfo:nil];
//    ;
//  }];
}

- (void)buttonAction_skipGotoHomePage:(id)sender {

    [appDelegate setAsGuest];
  
    //记录第一次登录的，下一次就不需要
    [self go2HomeViewController];
}

- (void)showLoginOuthaFailMessage:(NSString *)message {
  FGCustomAlertView *alert = (FGCustomAlertView *)[[[NSBundle mainBundle]
      loadNibNamed:@"FGCustomAlertView"
             owner:nil
           options:nil] objectAtIndex:0];
  [alert setupWithTitle:multiLanguage(@"ALERT")
                message:message
                buttons:@[ multiLanguage(@"BACK") ]
            andCallBack:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
              NSLog(@"buttonIndex = %lu", buttonIndex);
            }];
  [alert show];
}
@end

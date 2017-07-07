//
//  QQApiWrapper.m
//  CSP
//
//  Created by LuYang on 16/8/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "sdkCall.h"
#import "QQApiWrapper.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import <TencentOpenAPI/TencentOAuth.h>

static id _instance = nil;
@interface QQApiWrapper () <TencentSessionDelegate, TencentLoginDelegate>{
  NSError *err;
  NSDictionary *info;
  NSArray *permissions;
}

@property (nonatomic, copy) NSString *qqtoken;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, strong) NSMutableDictionary *snsInfoDic;
@property (nonatomic, assign) BOOL isLogined;
@property (nonatomic, copy) CompletetionHandler completetionHandler;
@end

@implementation QQApiWrapper
@synthesize completetionHandler;

#pragma mark - 单例方法
+ (QQApiWrapper *)shareInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _instance = [[self alloc] init];
  });
  return _instance;
}

#pragma mark - 初始化方法
- (id)init {
  if (ISEXISTObj(_instance))
    return _instance;

  if (self = [super init]) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(qqUserInfoResponse:) name:kGetUserInfoResponse object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessed) name:kLoginSuccessed object:[sdkCall getinstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:kLoginFailed object:[sdkCall getinstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCancelled) name:kLoginCancelled object:[sdkCall getinstance]];

    [self initQQInfoWith:nil];
  }
  return self;
}

- (void)initQQInfoWith:(NSDictionary *)dic {
  
  permissions = [NSArray arrayWithObjects:
                          kOPEN_PERMISSION_GET_USER_INFO,
                          kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                          kOPEN_PERMISSION_ADD_ALBUM,
                          kOPEN_PERMISSION_ADD_ONE_BLOG,
                          kOPEN_PERMISSION_ADD_SHARE,
                          kOPEN_PERMISSION_ADD_TOPIC,
                          kOPEN_PERMISSION_CHECK_PAGE_FANS,
                          kOPEN_PERMISSION_GET_INFO,
                          kOPEN_PERMISSION_GET_OTHER_INFO,
                          kOPEN_PERMISSION_LIST_ALBUM,
                          kOPEN_PERMISSION_UPLOAD_PIC,
                          kOPEN_PERMISSION_GET_VIP_INFO,
                          kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                          nil];

  
  self.snsInfoDic = nil;
  if (dic == nil)
    self.snsInfoDic = [NSMutableDictionary dictionary];
  else
    self.snsInfoDic = [NSMutableDictionary dictionaryWithDictionary:dic];
}

#pragma mark - 生命周期
- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kGetUserInfoResponse object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginSuccessed object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginFailed object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginCancelled object:nil];
}

#pragma mark - 工具方法
- (void)qqloginAction {
  [[[sdkCall getinstance] oauth] authorize:permissions inSafari:NO];
}

- (void)qqreloginAction {
  [[[sdkCall getinstance] oauth] reauthorizeWithPermissions:permissions];
}

- (void)qqlogoutActionWithCompletionHandler:(CompletetionHandler)handler {
}

- (void)qqloginActionWithCompletionHandler:(CompletetionHandler)handler {
  NSString *openid      = [[sdkCall getinstance] oauth].openId;
  NSString *accesstoken = [[sdkCall getinstance] oauth].accessToken;
  NSLog(@"opendid==%@", openid);
  NSLog(@"accesstoken==%@", accesstoken);
  
  self.completetionHandler = handler;
  [self qqloginAction];
}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin {
  
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
  
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork {
  
}


- (void)qqUserInfoRequestAction {
  BOOL getUserInfoSuccess = [[[sdkCall getinstance] oauth] getUserInfo];
  if (getUserInfoSuccess) {
    NSLog(@"获取用户信息成功!");

    NSString *openid      = [[sdkCall getinstance] oauth].openId;
    NSString *accesstoken = [[sdkCall getinstance] oauth].accessToken;

    NSLog(@"opendid==%@", openid);
    NSLog(@"accesstoken==%@", accesstoken);

    info = @{ @"openid" : openid,
              @"accesstoken" : accesstoken };

//    [commond saveToKeyChain:KEYCHAIN_KEY_OPENID_QQ passwd:openid];
//    [commond saveToKeyChain:KEYCHAIN_KEY_ACCESSTOKEN_QQ passwd:accesstoken];
    [commond setUserDefaults:openid forKey:KEYCHAIN_KEY_OPENID_QQ];
    [commond setUserDefaults:accesstoken forKey:KEYCHAIN_KEY_ACCESSTOKEN_QQ];
  } else {
    err = [NSError errorWithDomain:@"获取用户信息失败!" code:-1 userInfo:nil];
  }

//  if (self.completetionHandler) {
//    completetionHandler(info, err);
//    self.completetionHandler = nil;
//  }
}

- (void)qqUserInfoResponse:(NSNotification *)obj {
  NSDictionary *infoDic = (NSDictionary *)[obj userInfo];
  APIResponse *response = (APIResponse *)[infoDic objectForKey:kResponse];
  [self initQQInfoWith:[response jsonResponse]];

  //保存qq用户信息
  NSDictionary *_dic_userinfo_qq = [response jsonResponse];
  NSString *_str_json            = [_dic_userinfo_qq JSONString];
//  [commond saveToKeyChain:KEYCHAIN_KEY_QQ_USERINFO passwd:_str_json];
  [commond setUserDefaults:_str_json forKey:KEYCHAIN_KEY_QQ_USERINFO];

  //最后返回
  if (self.completetionHandler) {
    completetionHandler(info, err);
    self.completetionHandler = nil;
    info                     = nil;
    err                      = nil;
  }
}

- (NSString *)qqUserNickName {
  if (ISNULLObj(self.snsInfoDic))
    return @"";

  return [self.snsInfoDic objectForKey:@"nickname"];
}

- (NSString *)qqUserAvatarURL {
  if (ISNULLObj(self.snsInfoDic))
    return @"";

  return [self.snsInfoDic objectForKey:@"figureurl_qq_2"];
}

- (NSString *)qqUserID {
  if (ISNULLObj(self.qqUserID))
    return @"";
  return self.qqUserID;
}

- (NSString *)qqToken {
  if (ISNULLObj(self.qqtoken))
    return @"";
  return self.qqtoken;
}

#pragma mark - QQ登陆相关
- (BOOL) isLogined {
  NSString *accesstoken = [commond getUserDefaults:KEYCHAIN_KEY_ACCESSTOKEN_QQ];
  if (ISNULLObj(accesstoken) || [accesstoken isEmptyStr])
    _isLogined = NO;
  else
    _isLogined = YES;
  
  return _isLogined;
}

- (void)loginSuccessed {
  
  if (NO == _isLogined) {
    _isLogined = YES;
  }

  //保存token
  if ([[sdkCall getinstance] oauth].accessToken &&
      [[[[sdkCall getinstance] oauth] accessToken] length] > 0) {
    self.qqtoken = [[[sdkCall getinstance] oauth] accessToken];
//    [commond saveToKeyChain:KEYCHAIN_KEY_ACCESSTOKEN_QQ passwd:self.qqtoken];
    [commond setUserDefaults:self.qqtoken forKey:KEYCHAIN_KEY_ACCESSTOKEN_QQ];

  }

  //保存用户的唯一标识
  if ([[sdkCall getinstance] oauth].openId &&
      [[[[sdkCall getinstance] oauth] openId] length] > 0) {
    self.userID = [[[sdkCall getinstance] oauth] openId];
//    [commond saveToKeyChain:KEYCHAIN_KEY_USERID_QQ passwd:self.userID];
    [commond setUserDefaults:self.userID forKey:KEYCHAIN_KEY_USERID_QQ];

  }

  [[QQApiWrapper shareInstance] qqUserInfoRequestAction];
}

- (void)loginFailed {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"结果" message:@"登录失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
  [alertView show];
}

- (void)loginCancelled {
  //do nothing
}

- (void)showInvalidTokenOrOpenIDMessage {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"api调用失败" message:@"可能未授权登录或者授权已过期，请先重新登陆再获取" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  [alert show];
}

#pragma mark - qq logout
/**
 * 退出登录的回调
 */
- (void)tencentDidLogout {
  NSLog(@"tencent logout");
  ;
}

/**
 * 因用户未授予相应权限而需要执行增量授权。在用户调用某个api接口时，如果服务器返回操作未被授权，则触发该回调协议接口，由第三方决定是否跳转到增量授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \param permissions 需增量授权的权限列表。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启增量授权流程。若需要增量授权请调用\ref TencentOAuth#incrAuthWithPermissions: \n注意：增量授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions {
  return YES;
}

/**
 * [该逻辑未实现]因token失效而需要执行重新登录授权。在用户调用某个api接口时，如果服务器返回token失效，则触发该回调协议接口，由第三方决定是否跳转到登录授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启重新登录授权流程。若需要重新登录授权请调用\ref TencentOAuth#reauthorizeWithPermissions: \n注意：重新登录授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth {
  NSLog(@"tencentOAuth==%@", tencentOAuth);
  return YES;
}

#pragma mark - QQ分享
/*!
 *  @brief qq分享
 *
 *  @param title          分享标题
 *  @param description    分享描述
 *  @param url            分享跳转URL
 *  @param previewurl     分享图预览URL地址
 *
 */
- (void)qqShareSendNewsMessageWithLocalImage:(NSString *)_str_img withTitle:(NSString *)title desctiption:(NSString *)description shareURL:(NSString *)url sharePreviewURL:(NSString *)previewurl toShareType:(QQ_shareType)shareType {
  
//  NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_str_img];
//  NSData* data = [NSData dataWithContentsOfFile:path];
  
  NSData* data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_str_img ofType:@"png"]];
  //分享跳转URL
  NSString *shareURL = url;
  QQApiNewsObject* img = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareURL] title:title description:description previewImageData:data];
  SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
  QQApiSendResultCode sent;
  if (shareType == QQ_PERSON) {
    //将内容分享到qq
    sent = [QQApiInterface sendReq:req];
  } else {
    //将内容分享到qzone
    sent = [QQApiInterface SendReqToQZone:req];
  }
  [self handleSendResult:sent];
}

- (void)qqShareSendNewsMessageWithNetworkImage:(NSString *)_str_img withTitle:(NSString *)title desctiption:(NSString *)description shareURL:(NSString *)url sharePreviewURL:(NSString *)previewurl toShareType:(QQ_shareType)shareType {
  
  //分享跳转URL
  NSString *shareURL = url;
  QQApiNewsObject* img = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareURL] title:title description:description previewImageURL:[NSURL URLWithString:previewurl]];
  SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
  QQApiSendResultCode sent;
  if (shareType == QQ_PERSON) {
    //将内容分享到qq
    sent = [QQApiInterface sendReq:req];
  } else {
    //将内容分享到qzone
    sent = [QQApiInterface SendReqToQZone:req];
  }
  [self handleSendResult:sent];
}



- (void)qqSharesendTextMessageWithText:(NSString *)_str_text toShareType:(QQ_shareType)shareType {
  
  QQApiTextObject* txtObj = [QQApiTextObject objectWithText:_str_text];
  SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:txtObj];
  
  QQApiSendResultCode sent;
  if (shareType == QQ_PERSON) {
    //将内容分享到qq
    sent = [QQApiInterface sendReq:req];
  } else {
    //将内容分享到qzone
    sent = [QQApiInterface SendReqToQZone:req];
  }
  [self handleSendResult:sent];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult {
  switch (sendResult) {
    case EQQAPIAPPNOTREGISTED: {
      UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
      [msgbox show];

      break;
    }
    case EQQAPIMESSAGECONTENTINVALID:
    case EQQAPIMESSAGECONTENTNULL:
    case EQQAPIMESSAGETYPEINVALID: {
      UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
      [msgbox show];

      break;
    }
    case EQQAPIQQNOTINSTALLED: {
      UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
      [msgbox show];

      break;
    }
    case EQQAPIQQNOTSUPPORTAPI: {
      UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
      [msgbox show];

      break;
    }
    case EQQAPISENDFAILD: {
      UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
      [msgbox show];

      break;
    }
    case EQQAPIVERSIONNEEDUPDATE: {
      UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
      [msgbox show];
      break;
    }
    default: {
      break;
    }
  }
}

#pragma mark - 

@end

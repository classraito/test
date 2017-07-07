//
//  NetworkManager+User.m
//  CSP
//
//  Created by Ryan Gong on 16/8/29.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NetworkManager_User.h"
#import "Global.h"
@implementation NetworkManager_User

#pragma mark - 用户注册和登录接口, 会向用户手机发送验证码，没有注册的情况下，该用户将进入注册流程
-(void)postRequest_SendVCodeMobileLogin:(NSString *)_str_mobile  userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
//#if TARGET_IPHONE_SIMULATOR//模拟器
  [dic_params setObjectSafty:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"DeviceToken"];
//#elif TARGET_OS_IPHONE//真机
//  [dic_params setObjectSafty:[commond getUserDefaults:KEYCHAIN_KEY_PUSH_DEVICETOKEN] forKey:@"DeviceToken"];
//#endif
    [dic_params setObjectSafty:_str_mobile forKey:@"Mobile"];
    [self requestUrl:HOST(URL_USER_SendVCodeMobileLogin) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 用户收到登录短信认证码，提交服务器验证，成功后用户进入登录状态
-(void)postRequest_VerifyCodeMobileLogin:(NSString *)_str_mobile vCode:(NSString *)_str_verifyCode  userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:_str_mobile forKey:@"Mobile"];
    [dic_params setObjectSafty:_str_verifyCode forKey:@"VCode"];
    [self requestUrl:HOST(URL_USER_VerifyCodeMobileLogin) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 用户第三方登录接口
/*
 _str_gatewaty : qq, wechat, weibo, facebook etc...
 _str_gatewayID : 第三方用户id
 _str_gatewayToken : 第三方接口返回的accessToken
 */
-(void)postRequest_OauthLogin:(NSString *)_str_gatewaty gatewayID:(NSString *)_str_gatewayID gatewayToken:(NSString *)_str_gatewayToken userName:(NSString *)_str_username  userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    dispatch_async(dispatch_get_main_queue(), ^{
      [commond showLoading];
    });
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:_str_gatewaty forKey:@"Gateway"];
//#if TARGET_IPHONE_SIMULATOR//模拟器
  [dic_params setObjectSafty:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"DeviceToken"];
//#elif TARGET_OS_IPHONE//真机
//  [dic_params setObjectSafty:[commond getUserDefaults:KEYCHAIN_KEY_PUSH_DEVICETOKEN] forKey:@"DeviceToken"];
//#endif
    [dic_params setObjectSafty:_str_gatewayID forKey:@"GatewayId"];
    [dic_params setObjectSafty:_str_gatewayToken forKey:@"GatewayToken"];
  [dic_params setObjectSafty:_str_username forKey:@"UserName"];
    [self requestUrl:HOST(URL_USER_OauthLogin) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 登录状态中，需要绑定或更改手机号码，向新手机号发送手机验证码
-(void)postRequest_SendVCodeBindingMobile:(NSString *)_str_mobile userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_mobile forKey:@"Mobile"];
    
    [self requestUrl:HOST(URL_USER_SendVCodeBindingMobile) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 登录状态下，提交验证码，手机号和用户绑定
/*_str_vCode: 手机验证码*/
-(void)postRequest_VerifyCodeBindingMobile:(NSString *)_str_vCode userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_vCode forKey:@"VCode"];
    
    [self requestUrl:HOST(URL_USER_VerifyCodeBindingMobile) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 登录状态下第三方用户账号和用户绑定
/*
 _str_gatewaty : qq, wechat, weibo, facebook etc...
 _str_gatewayID : 第三方用户id
 _str_gatewayToken : 第三方接口返回的accessToken
 */
-(void)postRequest_BindingOauth:(NSString *)_str_gatewaty gatewayID:(NSString *)_str_gatewayID gatewayToken:(NSString *)_str_gatewayToken  userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_gatewaty forKey:@"Gateway"];
    [dic_params setObjectSafty:_str_gatewayID forKey:@"GatewayId"];
    [dic_params setObjectSafty:_str_gatewayToken forKey:@"GatewayToken"];
    
    [self requestUrl:HOST(URL_USER_BindingOauth) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取用户信息的接口
-(void)postRequest_GetUserProfileWithQueryId:(NSString *)_str_queryId userinfo:(NSMutableDictionary *)_dic_userinfo
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_queryId forKey:@"QueryUserId"];
    
    [self requestUrl:HOST(URL_USER_GetUserProfile) params:dic_params headers:dic_headers userinfo:_dic_userinfo];

}

#pragma mark - 设置用户信息接口
-(void)postRequest_SetUserProfile:(NSMutableArray *)_arr_needToUpdate userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_arr_needToUpdate forKey:@"Action"];
    
    [[Mixpanel sharedInstance] identify:(NSString *)[commond getUserDefaults:KEY_API_USER_USERID]]; //mixpanel identify username
    /*以下代码用于提交mixpanel数据*/
    for(NSMutableDictionary *_dic_singleInfo in _arr_needToUpdate)//搜索提交数组里是否有UserName的更新如果有更新 提交给mixpanel用户名
    {
        NSString *_str_action = [_dic_singleInfo objectForKey:@"ActionType"];
        /*
         “UserName”
         “Location”
         “Name”
         “Age”
         “Gender”
         “Nationality”
         “Weight”
         “Height”
         “Goal”
         “Boxing_Level”
         “Gym”
         */
        
        if([_str_action isEqualToString:@"UserName"])
        {
            NSString *_str_value = [_dic_singleInfo objectForKey:@"Value"];
            [[Mixpanel sharedInstance].people set:@"UserName" to:_str_value];
        }
        
        if([_str_action isEqualToString:@"Location"])
        {
            NSString *_str_value = [_dic_singleInfo objectForKey:@"Value"];//
            [[Mixpanel sharedInstance].people set:@"Location" to:_str_value];
        }
        
        if([_str_action isEqualToString:@"Name"])
        {
            NSString *_str_value = [_dic_singleInfo objectForKey:@"Value"];//
            [[Mixpanel sharedInstance].people set:@"Name" to:_str_value];
        }
        
        if([_str_action isEqualToString:@"Age"])
        {
            NSString *_str_value = [_dic_singleInfo objectForKey:@"Value"];//
            [[Mixpanel sharedInstance].people set:@"Age" to:_str_value];
        }
        
        if([_str_action isEqualToString:@"Gender"])
        {
            NSString *_str_value = [_dic_singleInfo objectForKey:@"Value"];//
            [[Mixpanel sharedInstance].people set:@"Gender" to:_str_value];
        }
        
        if([_str_action isEqualToString:@"Nationality"])
        {
            NSString *_str_value = [_dic_singleInfo objectForKey:@"Value"];//
            [[Mixpanel sharedInstance].people set:@"Nationality" to:_str_value];
        }

        
        if([_str_action isEqualToString:@"Weight"])
        {
            NSString *_str_value = [_dic_singleInfo objectForKey:@"Value"];//
            [[Mixpanel sharedInstance].people set:@"Weight" to:_str_value];
        }
        
        if([_str_action isEqualToString:@"Height"])
        {
            NSString *_str_value = [_dic_singleInfo objectForKey:@"Value"];//
            [[Mixpanel sharedInstance].people set:@"Height" to:_str_value];
        }
        
        if([_str_action isEqualToString:@"Goal"])
        {
            NSString *_str_value = [_dic_singleInfo objectForKey:@"Value"];//
            [[Mixpanel sharedInstance].people set:@"Goal" to:_str_value];
        }
        
        if([_str_action isEqualToString:@"Boxing_Level"])
        {
            NSString *_str_value = [_dic_singleInfo objectForKey:@"Value"];//
            [[Mixpanel sharedInstance].people set:@"Boxing_Level" to:_str_value];
        }
        
        if([_str_action isEqualToString:@"Gym"])
        {
            NSString *_str_value = [_dic_singleInfo objectForKey:@"Value"];//
            [[Mixpanel sharedInstance].people set:@"Gym" to:_str_value];
        }

        
        
    }
    
    
    [self requestUrl:HOST(URL_USER_SetUserProfile) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

-(void)postRequest_GetUserList:(NSString *)_str_filter keywords:(NSString *)_str_keywords cursor:(NSInteger)_cursor count:(NSInteger)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_filter forKey:@"Filter"];
    [dic_params setObjectSafty:_str_keywords forKey:@"Keywords"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_cursor] forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    [self requestUrl:HOST(URL_USER_GetUserList) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 变更手机号码前，需验证用户原手机号码，向用户原手机号发送验证码
-(void)postRequest_USER_SendVCodeOldMobile:(NSMutableDictionary *)_dic_info;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [self requestUrl:HOST(URL_USER_SendVCodeOldMobile) params:dic_params headers:dic_headers userinfo:_dic_info];
}

#pragma mark - 用户验证原手机号码，通过后，可进入新手机号码验证程流(SendVCodeBindingMobile)
-(void)postRequest_USER_VerifyCodeOldMobile:(NSString *)_str_vCode userinfo:(NSMutableDictionary *)_dic_info;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_vCode forKey:@"VCode"];
    [self requestUrl:HOST(URL_USER_VerifyCodeOldMobile) params:dic_params headers:dic_headers userinfo:_dic_info];
}

#pragma mark - 登录状态中，需要绑定或更改手机号码，向新手机号发送手机验证码
-(void)postRequest_USER_SendVCodeBindingMobile:(NSString *)_str_mobile userinfo:(NSMutableDictionary *)_dic_info;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_mobile forKey:@"Mobile"];
    [self requestUrl:HOST(URL_USER_SendVCodeBindingMobile) params:dic_params headers:dic_headers userinfo:_dic_info];
}

#pragma mark - 登录状态下，提交验证码，手机号和用户绑定
-(void)postRequest_USER_VerifyCodeBindingMobile:(NSString *)_str_vCode mobile:(NSString *)_str_mobile userinfo:(NSMutableDictionary *)_dic_info;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_vCode forKey:@"VCode"];
    [dic_params setObjectSafty:_str_mobile forKey:@"Mobile"];
    [self requestUrl:HOST(URL_USER_VerifyCodeBindingMobile) params:dic_params headers:dic_headers userinfo:_dic_info];
}

#pragma mark - 继承自父类的方法: 用于持久化某些重要信息到本地
-(void)saveImportInfo:(NSMutableDictionary *)_dic_result url:(NSString *)_str_url userinfo:(NSMutableDictionary *)_dic_userinfo
{
    if(!_dic_result)
        return;
    if([_dic_result count]<=0)
        return;
    if(!_str_url)
        return;
    
    if([HOST(URL_USER_VerifyCodeMobileLogin) isEqualToString:_str_url] ||
       [HOST(URL_USER_OauthLogin) isEqualToString:_str_url])
    {
        NSString *_str_accessToken = [_dic_result objectForKey:@"AccessToken"];
        NSString *_str_userID = [_dic_result objectForKey:@"UserId"];
        int role = [[_dic_result objectForKey:@"Role"] intValue];
        BOOL isNewUser = [[_dic_result objectForKey:@"NewUser"] boolValue];
        [commond setUserDefaults:_str_accessToken forKey:KEY_API_USER_ACCESSTOKEN];
        [commond setUserDefaults:[NSString stringWithFormat:@"%@",_str_userID] forKey:KEY_API_USER_USERID];
        [commond setUserDefaults:[NSNumber numberWithInt:role] forKey:KEY_API_USER_ROLE];
        [commond setUserDefaults:[NSNumber numberWithBool:isNewUser] forKey:KEY_API_USER_ISNEWUSER];
    }
    
}
@end

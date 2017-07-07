//
//  NetworkManager+User.h
//  CSP
//
//  Created by Ryan Gong on 16/8/29.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NetworkManager.h"
/*用户注册和登录接口, 会向用户手机发送验证码，没有注册的情况下，该用户将进入注册流程*/
#define URL_USER_SendVCodeMobileLogin @"/Account/SendVCodeMobile.ashx"
/*用户收到登录短信认证码，提交服务器验证，成功后用户进入登录状态*/
#define URL_USER_VerifyCodeMobileLogin @"/Account/VerifyCodeMobileLogin.ashx"
/*用户第三方登录接口*/
#define URL_USER_OauthLogin @"/Account/Login.ashx"


/*变更手机号码前，需验证用户原手机号码，向用户原手机号发送验证码*/
#define URL_USER_SendVCodeOldMobile @"/Account/SendVCodeOldMobile.ashx"
/*用户验证原手机号码，通过后，可进入新手机号码验证程流(SendVCodeBindingMobile)*/
#define URL_USER_VerifyCodeOldMobile @"/Account/VerifyCodeOldMobile.ashx"

/*登录状态中，需要绑定或更改手机号码，向新手机号发送手机验证码*/
#define URL_USER_SendVCodeBindingMobile @"/Account/SendVCodeBindingMobile.ashx"
/*登录状态下，提交验证码，手机号和用户绑定*/
#define URL_USER_VerifyCodeBindingMobile @"/Account/VerifyCodeBindingMobile.ashx"

/*登录状态下第三方用户账号和用户绑定*/
#define URL_USER_BindingOauth @"/Account/xxxx.ashx"
/*获取用户信息的接口*/
#define URL_USER_GetUserProfile @"/Account/GetUserProfile.ashx"
/*设置用户信息接口*/
#define URL_USER_SetUserProfile @"/Account/SetUserProfile.ashx"


/*获取用户列表，一般用于@，添加好友时查找用户*/
#define URL_USER_GetUserList  @"/Social/GetUserList.ashx"

#define KEY_API_USER_ACCESSTOKEN @"KEY_API_ACCESSTOKEN" //用于保存用户AccessToken的key
#define KEY_API_USER_USERID @"KEY_API_USERID"           //用于保存用户USERID的key
#define KEY_API_USER_MOBILE @"KEY_API_MOBILE"           //用于保存用户手机号码的key
#define KEY_API_USER_ISNEWUSER @"KEY_API_ISNEWUSER"     //用于保存用户是否为新用户的key
#define KEY_API_USER_ROLE @"KEY_API_ROLE"               //用于保存用户角色的key

@interface NetworkManager_User : NetworkManager
{
    
}

#pragma mark - 用户注册和登录接口, 会向用户手机发送验证码，没有注册的情况下，该用户将进入注册流程
-(void)postRequest_SendVCodeMobileLogin:(NSString *)_str_mobile  userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 用户收到登录短信认证码，提交服务器验证，成功后用户进入登录状态
-(void)postRequest_VerifyCodeMobileLogin:(NSString *)_str_mobile vCode:(NSString *)_str_verifyCode  userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 用户第三方登录接口
/*
 _str_gatewaty : qq, wechat, weibo, facebook etc...
 _str_gatewayID : 第三方用户id
 _str_gatewayToken : 第三方接口返回的accessToken
 */
//-(void)postRequest_OauthLogin:(NSString *)_str_gatewaty gatewayID:(NSString *)_str_gatewayID gatewayToken:(NSString *)_str_gatewayToken  userinfo:(NSMutableDictionary *)_dic_userinfo;
-(void)postRequest_OauthLogin:(NSString *)_str_gatewaty gatewayID:(NSString *)_str_gatewayID gatewayToken:(NSString *)_str_gatewayToken userName:(NSString *)_str_username  userinfo:(NSMutableDictionary *)_dic_userinfo;


#pragma mark - 登录状态中，需要绑定或更改手机号码，向新手机号发送手机验证码
-(void)postRequest_SendVCodeBindingMobile:(NSString *)_str_mobile userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 登录状态下，提交验证码，手机号和用户绑定
/*_str_vCode: 手机验证码*/
-(void)postRequest_VerifyCodeBindingMobile:(NSString *)_str_vCode userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 登录状态下第三方用户账号和用户绑定
/*
 _str_gatewaty : qq, wechat, weibo, facebook etc...
 _str_gatewayID : 第三方用户id
 _str_gatewayToken : 第三方接口返回的accessToken
 */
-(void)postRequest_BindingOauth:(NSString *)_str_gatewaty gatewayID:(NSString *)_str_gatewayID gatewayToken:(NSString *)_str_gatewayToken  userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取用户信息的接口
-(void)postRequest_GetUserProfileWithQueryId:(NSString *)_str_queryId userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 设置用户信息接口
-(void)postRequest_SetUserProfile:(NSMutableArray *)_arr_needToUpdate userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取用户列表，一般用于@，添加好友时查找用户
-(void)postRequest_GetUserList:(NSString *)_str_filter keywords:(NSString *)_str_keywords cursor:(NSInteger)_cursor count:(NSInteger)_count  userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 变更手机号码前，需验证用户原手机号码，向用户原手机号发送验证码
-(void)postRequest_USER_SendVCodeOldMobile:(NSMutableDictionary *)_dic_info;

#pragma mark - 用户验证原手机号码，通过后，可进入新手机号码验证程流(SendVCodeBindingMobile)
-(void)postRequest_USER_VerifyCodeOldMobile:(NSString *)_str_vCode userinfo:(NSMutableDictionary *)_dic_info;

#pragma mark - 登录状态中，需要绑定或更改手机号码，向新手机号发送手机验证码
-(void)postRequest_USER_SendVCodeBindingMobile:(NSString *)_str_mobile userinfo:(NSMutableDictionary *)_dic_info;

#pragma mark - 登录状态下，提交验证码，手机号和用户绑定
-(void)postRequest_USER_VerifyCodeBindingMobile:(NSString *)_str_vCode mobile:(NSString *)_str_mobile userinfo:(NSMutableDictionary *)_dic_info;
@end

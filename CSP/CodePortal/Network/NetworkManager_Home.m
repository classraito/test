//
//  NetworkManager_Home.m
//  CSP
//
//  Created by Ryan Gong on 16/11/23.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NetworkManager_Home.h"
#import "Global.h"
#import "MemoryCache.h"
@implementation NetworkManager_Home
#pragma mark - 获取首页顶部列表
-(void)postRequest_Home_getTitleImages:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    
    [self requestUrl:HOST(URL_HOME_TitleImages) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}
//FIXME: lu see more
-(void)postRequest_Home_searchSeeMore:(NSString *)_str_keywords isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
  NSString *_str_cursor = [self getCursorByURL:HOST(URL_HOME_SearcSeeMore) isFirstPage:_isFirstPage];
  if(!_str_cursor)
    return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
  
  NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
  [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
  [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
  
  NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
  [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
  [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];
  [dic_params setObjectSafty:_str_keywords forKey:@"Keywords"];
  [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
  
  [self requestUrl:HOST(URL_HOME_SearcSeeMore) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取某类训练项目列表
-(void)postRequest_Home_searchWorkouts:(NSString *)_str_keywords isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSString *_str_cursor = [self getCursorByURL:HOST(URL_HOME_SearchWorkouts) isFirstPage:_isFirstPage];
    if(!_str_cursor)
        return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];
    [dic_params setObjectSafty:_str_keywords forKey:@"Keywords"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    
    [self requestUrl:HOST(URL_HOME_SearchWorkouts) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取教练列表
-(void)postRequest_Home_searchTrainer:(NSString *)_str_keywords isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSString *_str_cursor = [self getCursorByURL:HOST(URL_HOME_SearchTrainer) isFirstPage:_isFirstPage];
    if(!_str_cursor)
        return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];
    [dic_params setObjectSafty:_str_keywords forKey:@"Keywords"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    
    [self requestUrl:HOST(URL_HOME_SearchTrainer) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取新闻列表
-(void)postRequest_Home_newsFeed:(NSString *)_str_keywords isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSString *_str_cursor = [self getCursorByURL:HOST(URL_HOME_NewsFeeds) isFirstPage:_isFirstPage];
    if(!_str_cursor)
        return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];
    [dic_params setObjectSafty:_str_keywords forKey:@"Keywords"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    
    [self requestUrl:HOST(URL_HOME_NewsFeeds) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取首页显示内容
-(void)postRequest_Home_getHomePage:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    [dic_headers setObjectSafty:@"1080" forKey:@"ScreenResolution"];
    
    NSMutableArray *arr_paramsWrapper = [NSMutableArray arrayWithCapacity:1];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [self appendParams:dic_params toArray:arr_paramsWrapper requestId:@"1" requestName:@"TitleImages"];
    
    NSMutableDictionary *dic_params1 = [NSMutableDictionary dictionary];
    [dic_params1 setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params1 setObjectSafty:[NSNumber numberWithInteger:10] forKey:@"Count"];
    [self appendParams:dic_params1 toArray:arr_paramsWrapper requestId:@"2" requestName:@"GetUserList"];
    
    NSMutableDictionary *dic_params2 = [NSMutableDictionary dictionary];
    [dic_params2 setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params2 setObjectSafty:[NSNumber numberWithInteger:10] forKey:@"Count"];
    [self appendParams:dic_params2 toArray:arr_paramsWrapper requestId:@"3" requestName:@"GetFeaturedList"];
    
    NSMutableDictionary *dic_params3 = [NSMutableDictionary dictionary];
    [dic_params3 setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params3 setObjectSafty:[NSNumber numberWithInteger:10] forKey:@"Count"];
    [self appendParams:dic_params3 toArray:arr_paramsWrapper requestId:@"4" requestName:@"NewsFeeds"];
    
    [self requestUrl:HOST(URL_HOME_HomePage) params:arr_paramsWrapper headers:dic_headers userinfo:_dic_userinfo];

}

#pragma mark - 获取首页搜索显示内容
-(void)postRequest_Home_homeSearch:(NSString *)_str_keywords count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    [dic_headers setObjectSafty:@"1080" forKey:@"ScreenResolution"];
    
    NSMutableArray *arr_paramsWrapper = [NSMutableArray arrayWithCapacity:1];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_keywords forKey:@"Keywords"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    [self appendParams:dic_params toArray:arr_paramsWrapper requestId:@"1" requestName:@"SearchWorkouts"];
    
    NSMutableDictionary *dic_params1 = [NSMutableDictionary dictionary];
    [dic_params1 setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params1 setObjectSafty:_str_keywords forKey:@"Keywords"];
    [dic_params1 setObjectSafty:[NSNumber numberWithInteger:10] forKey:@"Count"];
    [self appendParams:dic_params1 toArray:arr_paramsWrapper requestId:@"2" requestName:@"GetUserList"];
    
    NSMutableDictionary *dic_params2 = [NSMutableDictionary dictionary];
    [dic_params2 setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params2 setObjectSafty:_str_keywords forKey:@"Keywords"];
    [dic_params2 setObjectSafty:[NSNumber numberWithInteger:10] forKey:@"Count"];
    [self appendParams:dic_params2 toArray:arr_paramsWrapper requestId:@"3" requestName:@"SearchTrainer"];
    
    NSMutableDictionary *dic_params3 = [NSMutableDictionary dictionary];
    [dic_params3 setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params3 setObjectSafty:_str_keywords forKey:@"Keywords"];
    [dic_params3 setObjectSafty:[NSNumber numberWithInteger:10] forKey:@"Count"];
    [self appendParams:dic_params3 toArray:arr_paramsWrapper requestId:@"4" requestName:@"NewsFeeds"];
    
    NSMutableDictionary *dic_params4 = [NSMutableDictionary dictionary];
    [dic_params4 setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params4 setObjectSafty:_str_keywords forKey:@"Keywords"];
    [dic_params4 setObjectSafty:[NSNumber numberWithInteger:10] forKey:@"Count"];
    [self appendParams:dic_params4 toArray:arr_paramsWrapper requestId:@"5" requestName:@"GetTopicList"];
    
    [self requestUrl:HOST(URL_HOME_HomeSearch) params:arr_paramsWrapper headers:dic_headers userinfo:_dic_userinfo];

}
@end

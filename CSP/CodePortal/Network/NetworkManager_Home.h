//
//  NetworkManager_Home.h
//  CSP
//
//  Created by Ryan Gong on 16/11/23.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
// FIXME: lu see more
#define TESTSEEMORE 1

#import "NetworkManager.h"
/*获取首页顶部列表*/
#define URL_HOME_TitleImages @"/Home/TitleImages.ashx"

#ifdef TESTSEEMORE
/*获取某类训练项目列表*/
#define URL_HOME_SearcSeeMore @"/Home/SearchWorkouts.ashx"
#else
#define URL_HOME_SearchSeeMore @"/Home/SearchWorkouts.ashx"
#endif

/*获取某类训练项目列表*/
#define URL_HOME_SearchWorkouts @"/Home/SearchWorkouts.ashx"

/*获取教练列表*/
#define URL_HOME_SearchTrainer @"/Home/SearchTrainer.ashx"

/*获取新闻列表*/
#define URL_HOME_NewsFeeds @"/Home/NewsFeeds.ashx"

/*获取首页显示内容*/
#define URL_HOME_HomePage @"/Home/HomePage.ashx"

/*获取首页搜索显示内容*/
#define URL_HOME_HomeSearch @"/Home/HomeSearch.ashx"

@interface NetworkManager_Home : NetworkManager

#pragma mark - 获取首页顶部列表
-(void)postRequest_Home_getTitleImages:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取更多信息
-(void)postRequest_Home_searchSeeMore:(NSString *)_str_keywords isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取某类训练项目列表
-(void)postRequest_Home_searchWorkouts:(NSString *)_str_keywords isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取教练列表
-(void)postRequest_Home_searchTrainer:(NSString *)_str_keywords isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取新闻列表
-(void)postRequest_Home_newsFeed:(NSString *)_str_keywords isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取首页显示内容
-(void)postRequest_Home_getHomePage:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取首页搜索显示内容
-(void)postRequest_Home_homeSearch:(NSString *)_str_keywords count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
@end

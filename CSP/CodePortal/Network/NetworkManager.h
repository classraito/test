//
//  NetworkManager.h
//  MyStock
//
//  Created by Ryan Gong on 15/9/10.
//  Copyright (c) 2015年 Ryan Gong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "NetworkRequestInfo.h"
//API URL
#define URL_GetCityList @"/api/city.json"

#define HOST(_str_url) [NSString stringWithFormat:@"%@%@",HOSTNAME,_str_url]
#define projectversion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]





@interface NetworkManager : NSObject<ASIHTTPRequestDelegate>
{

}
@property int refreshCode;;
+(instancetype)sharedManager;//manager 单例初始化

/*通用请求方法(block返回)*/
- (ASIFormDataRequest *)requestUrl:(NSString *)_str_url
                            params:(id)_dic_params
                           headers:(NSMutableDictionary *)_dic_headers
                            sucess:(ASIBasicBlock)_sucessBlock
                            failed:(ASIBasicBlock)_failedBlock
                            userinfo:(NSMutableDictionary *)_dic_userinfo;

-(ASIFormDataRequest *)requestUrl:(NSString *)_str_url
                           method:(NSString *)_str_method
                           params:(id)_dic_params
                          headers:(NSMutableDictionary *)_dic_headers
                         userinfo:(NSMutableDictionary *)_dic_userinfo;

-(ASIFormDataRequest *)requestUrl:(NSString *)_str_url
                           params:(id)_dic_params
                          headers:(NSMutableDictionary *)_dic_headers;


-(ASIFormDataRequest *)requestUrl:(NSString *)_str_url
                           params:(id)_dic_params
                          headers:(NSMutableDictionary *)_dic_headers
                         userinfo:(NSMutableDictionary *)_dic_userinfo;
-(NSString *)getAppLang;

-(void)saveImportInfo:(NSMutableDictionary *)_dic_result url:(NSString *)_str_url userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 根据URL 返回 MemoryCache中最新的Cursor
-(NSString *)giveMeLatestCursorByURL:(NSString *)_str_url;
#pragma mark - 根据url 和 是否第一页 判断 返回该URL接口的 Cursor
/*
 _isFirstPage : 是否第一页
 _str_url:接口URL
 return: 如果为 @"" 则说明是第一页， 如果是nil 说明是最后一页
 */
-(NSString *)getCursorByURL:(NSString *)_str_url isFirstPage:(BOOL)_isFirstPage;

#pragma mark - 一些组合接口的参数需要此方法拼装
-(void)appendParams:(NSMutableDictionary *)_dic_params toArray:(NSMutableArray *)_arr_wrapper requestId:(NSString *)_str_requestId requestName:(NSString *)_str_requestName;

+(NSNumber *)giveHashCodeByObj:(NSObject *)_obj;
@end










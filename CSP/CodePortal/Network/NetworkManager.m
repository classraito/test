//
//  NetworkManager.m
//  MyStock
//
//  Created by Ryan Gong on 15/9/10.
//  Copyright (c) 2015年 Ryan Gong. All rights reserved.
//

#import "AppDelegate.h"
#import "Global.h"
#import "NetworkManager.h"
#import <objc/runtime.h>
#import "ASIDownloadCache.h"
@interface NetworkManager () {
    ASINetworkQueue *queue;
}
@end

@implementation NetworkManager
@synthesize refreshCode;
+ (instancetype)sharedManager {
  id instance = objc_getAssociatedObject(self, @"instance");

  if (!instance) {
    instance = [[super allocWithZone:NULL] init];
         NSLog(@"单例创建=====%@=====", instance);
    objc_setAssociatedObject(self, @"instance", instance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
  return [self sharedManager];
}

- (id)copyWithZone:(struct _NSZone *)zone {
  Class selfClass = [self class];
  return [selfClass sharedManager];
}

- (NSString *)getAppLang {
  if ([commond isChinese])
    return @"zh";
  else
    return @"en";
}

/* 子方法 */
- (void)clearAllRequeast {
}

#pragma mark -
/*ASIHttpRequestDelegate 处理回调*/
- (void)requestFinished:(ASIFormDataRequest *)request {
  NSString *str_response = request.responseString;

  NSLog(@"str_response = %@", str_response);
  int responseCode = request.responseStatusCode;

  if (responseCode != 200) {
    [commond removeLoading];
    [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please check your network connection!") callback:nil];
    return; //第一级检查返回码,(http 返回码)
  }

  NSString *_str_requestUrl      = request.url.absoluteString;
    
  NSMutableDictionary *_dic_json = [str_response mutableObjectFromJSONString]; //转json对象

  if (!_dic_json || [_dic_json count]<=0) //第二次检查
    return;
    
  /*没有通过返回码检查*/
  if (![self isReturnCodePass:_dic_json url:_str_requestUrl]) {
      if([[_dic_json allKeys] containsObject:@"Msg"])
      {
          NSString *_str_errorMsg = [_dic_json objectForKey:@"Msg"];
          [commond removeLoading];
          [commond alert:multiLanguage(@"ALERT") message:_str_errorMsg callback:nil];
      }
    NSDictionary *_dic_failedInfo = @{ @"result" : _dic_json,
                                       @"url" : _str_requestUrl };
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_UpdateFailed object:_dic_failedInfo];
    return;
  } //第三次检查json 带回的返回码
  
  //=================以下正常处理请求====================

  NSMutableDictionary *dic_info = nil;
  if (request.userInfo) {
    dic_info = [NSMutableDictionary dictionaryWithDictionary:request.userInfo]; //如果接口带userinfo 把它传进来
  } else {
    dic_info = [NSMutableDictionary dictionary];
  }
  [dic_info setObjectSafty:_str_requestUrl forKey:@"url"];
    
  NSLog(@"json Sucess [%@][%@]: _dic_json = %@",_str_requestUrl,dic_info,_dic_json);
    /*if([_str_requestUrl isEqualToString:HOST(URL_POST_GetPostList)])
    {
        NSLog(@"json Sucess [%@][%@][%ld]: _dic_json = %@",_str_requestUrl,dic_info,[[_dic_json objectForKey:@"Posts"] count],_dic_json);
    }*/
    [self saveImportInfo:_dic_json url:_str_requestUrl userinfo:dic_info];
    
  [[MemoryCache sharedMemoryCache] saveData:_dic_json info:dic_info];
  //保存到内存缓存中

  
    
    [request clearDelegatesAndCancel];
}

/*处理连接错误*/
- (void)requestFailed:(ASIFormDataRequest *)request {
  NSLog(@"XXXXXXXXXXXXXX> response error:%@ url:%@", request.error, request.url);
  [commond removeLoading];
  [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please check your network connection!") callback:nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:Notification_UpdateFailed object:nil];
}

/*通用请求方法(block返回)*/
- (ASIFormDataRequest *)requestUrl:(NSString *)_str_url
                            params:(id)_dic_params
                           headers:(NSMutableDictionary *)_dic_headers
                            sucess:(ASIBasicBlock)_sucessBlock
                            failed:(ASIBasicBlock)_failedBlock
                            userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    ASIFormDataRequest *request = [self requestUrl:_str_url method:@"POST" params:_dic_params headers:_dic_headers userinfo:_dic_userinfo];
    [request setCompletionBlock:_sucessBlock];
    [request setFailedBlock:_failedBlock];
    //[request startAsynchronous];
    [queue go];
    return request;
}



/*通用请求方法*/
- (ASIFormDataRequest *)requestUrl:(NSString *)_str_url
                            params:(id)_dic_params
                           headers:(NSMutableDictionary *)_dic_headers
                          userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    ASIFormDataRequest *request = [self requestUrl:_str_url method:@"POST" params:_dic_params headers:_dic_headers userinfo:_dic_userinfo];
    request.delegate = self;
    //[request startAsynchronous];
    [queue go];
    return request;
}



/*通用请求方法*/
- (ASIFormDataRequest *)requestUrl:(NSString *)_str_url
                            method:(NSString *)_str_method
                            params:(id)_dic_params
                           headers:(NSMutableDictionary *)_dic_headers
                          userinfo:(NSMutableDictionary *)_dic_userinfo;
{
  @try {
//    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
//      [commond removeLoading];
//      [commond alert:multiLanguage(@"警告") message:multiLanguage(@"请检查您的网络!") callback:nil];
//      return nil;
//    }
    
    if(!queue)
    {
        queue = [ASINetworkQueue queue];
    }
    
        if([[_dic_userinfo allKeys] containsObject:KEY_NOTIFY_REPEL])
        {
            NSString *str_repel = [_dic_userinfo objectForKey:KEY_NOTIFY_REPEL];
            for(NSOperation *operation in queue.operations)
            {
                if([operation isKindOfClass:[ASIFormDataRequest class]])
                {
                    ASIFormDataRequest *_request = (ASIFormDataRequest *)operation;
                    if([[_request.userInfo allKeys] containsObject:KEY_NOTIFY_REPEL])
                    {
                        NSString *_str_repelInQueue = [_request.userInfo objectForKey:KEY_NOTIFY_REPEL];
                        if([_str_repelInQueue isEqualToString:str_repel])
                        {
                            [_request clearDelegatesAndCancel];
                            
                            NSLog(@"canceled request on repel name:%@",_str_repelInQueue);
                        }
                        
                    }
                }
            }
        }//如果队列中已经存在互斥名相同的request,那么取消队列中的请求，执行当前的请求
    
      
    if (_dic_params && ![self isParameterValid:_dic_params])
      return nil;

    NSURL *url                  = [NSURL URLWithString:[_str_url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setTimeOutSeconds:60]; //TODO: 超时改到1分钟
    [request setRequestMethod:_str_method];
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=utf-8"];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    NSLog(@"cache path: %@",[[ASIDownloadCache sharedCache] storagePath]);
    [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
      
    NSLog(@"request.didUseCachedResponse = %d",request.didUseCachedResponse);
    if (_dic_userinfo)
      request.userInfo = _dic_userinfo;
    [request setValidatesSecureCertificate:NO];
    if (_dic_headers && [_dic_headers count] > 0) {
      for (int i = 0; i < [_dic_headers count]; i++) {
        id key = [[_dic_headers allKeys] objectAtIndex:i];
        [request addRequestHeader:key value:[_dic_headers objectForKey:key]];
      }
    }
    if (_dic_params)
    {
        [request appendPostData:[_dic_params JSONData]];
    }
     
    NSLog(@"::::>request json:%@", [_dic_params JSONString]);
    NSLog(@"::::::::::::::::::>request:[%@] %@ %@", _str_url, _dic_params, request.requestHeaders);
      [queue addOperation:request];
    return request;
  }
  @catch (NSException *exception) {
    NSLog(@"exception = %@", exception);
    [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please check your network connection!") callback:nil];
    return nil;
  }
}

- (ASIFormDataRequest *)requestUrl:(NSString *)_str_url
                            params:(id)_dic_params
                           headers:(NSMutableDictionary *)_dic_headers;
{
  return [self requestUrl:_str_url params:_dic_params headers:_dic_headers userinfo:nil];
}

/*保存一些重要信息到本地持久*/
- (void)saveImportInfo:(NSMutableDictionary *)_dic_result url:(NSString *)_str_url userinfo:(NSMutableDictionary *)_dic_userinfo {
}

/*判断返回码*/
- (BOOL)isReturnCodePass:(NSMutableDictionary *)_dic_result url:(NSString *)_str_requestUrl {
  NSNumber *_num_returncode = [_dic_result objectForKey:@"Code"];
  NSInteger _returncode     = [_num_returncode integerValue];
  if (_returncode == 0) {
    return YES;
  } //通常情况下返回值不是0说明有错误

  if([_str_requestUrl isEqualToString:HOST(URL_LOCATION_CheckOrder)])
  {
     if(_returncode == 1)
     {
         return YES;
     }
  }//订单锁查询 接口 返回码为1时 调用成功但没有任何锁住的订单
    
  if(_returncode == -200 || _returncode == -201 || _returncode == -105 || _returncode == -106)
  {
      [commond showAskForLogin];
    return NO;
  }
    
  return NO;
}

/*判断参数字典中是否有空值*/
- (BOOL)isParameterValid:(id)_dic_params {
    if([_dic_params isKindOfClass:[NSMutableDictionary class]] ||
      [_dic_params isKindOfClass:[NSDictionary class]] )
    {
        for (NSString *str_key in [_dic_params allKeys]) {
            NSString *str_value = [_dic_params objectForKey:str_key];
            if (!str_value)
                return NO;
        }
        return YES;
    }
    return YES;
}

#pragma mark - 根据URL 返回 MemoryCache中最新的Cursor
- (NSString *)giveMeLatestCursorByURL:(NSString *)_str_url {
  NSMutableDictionary *_dic_data = [[MemoryCache sharedMemoryCache] getDataByUrl:_str_url];
    
   // NSLog(@"::>_dic_data = %@",_dic_data);
  NSString *_str_latestCursor    = [_dic_data objectForKey:@"Cursor"];
  return _str_latestCursor;
}

#pragma mark - 根据url 和 是否第一页 判断 返回该URL接口的 Cursor
/*
 _isFirstPage : 是否第一页
 _str_url:接口URL
 return: 如果为 @"" 则说明是第一页， 如果是nil 说明是最后一页
 */
- (NSString *)getCursorByURL:(NSString *)_str_url isFirstPage:(BOOL)_isFirstPage {
  NSString *_str_cursor = @"";
  if (!_isFirstPage) //如果是第一页 cursor传空
  {
    _str_cursor = [self giveMeLatestCursorByURL:_str_url]; //如果不是第一页，cursor去memorycache中最近的一条数据
     
    /*按照API文档定义 如果取出的cursor是空 那么说明到了页尾 不再执行请求*/
    if (!_str_cursor)
      _str_cursor = @"0";
    else {
        if([@"" isEqualToString:_str_cursor])
        {
            return nil;
        }
        if([@"0" isEqualToString:_str_cursor])
        {
            return nil;
        }
    }
  }

  return _str_cursor;
}

#pragma mark - 一些组合接口的参数需要此方法拼装
-(void)appendParams:(NSMutableDictionary *)_dic_params toArray:(NSMutableArray *)_arr_wrapper requestId:(NSString *)_str_requestId requestName:(NSString *)_str_requestName
{
    NSMutableDictionary *_dic_singleAPI = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_singleAPI setObject:_str_requestId forKey:@"RequestId"];
    [_dic_singleAPI setObject:_str_requestName forKey:@"RequestName"];
    [_dic_singleAPI setObject:_dic_params forKey:@"Param"];
    [_arr_wrapper addObject:_dic_singleAPI];
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

+(NSNumber *)giveHashCodeByObj:(NSObject *)_obj;
{
    return [NSNumber numberWithLong:_obj.hash];
}
@end

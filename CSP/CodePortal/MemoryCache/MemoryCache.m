//
//  DataManager.m
//  MyStock
//
//  Created by Ryan Gong on 15/9/11.
//  Copyright (c) 2015年 Ryan Gong. All rights reserved.
//

#import "MemoryCache.h"
#import "Global.h"
static MemoryCache *cache;
@implementation MemoryCache
@synthesize dic_data;
+(id)alloc
{
    @synchronized(self)     {
        NSAssert(cache == nil, @"企圖創建一個singleton模式下的MemoryCache");
        return [super alloc];
    }
    return nil;
}


+(MemoryCache *)sharedMemoryCache//用这个方法来初始化MemoryCache
{
    @synchronized(self)     {
        if(!cache)
        {
            cache=[[MemoryCache alloc]init];
            cache.dic_data = [[NSMutableDictionary alloc] init];
            return cache;
        }
    }
    return cache;
}

-(void)clearAllData
{
    [dic_data removeAllObjects];
}

-(void)clearDataForKey:(NSString *)_str_url
{
    NSString *_str_key = [NSString md5:_str_url];
    if(![[dic_data allKeys] containsObject:_str_key])
        return;
    [dic_data removeObjectForKey:_str_key];
}

-(void)saveData:(NSMutableDictionary *)_dic_json info:(NSMutableDictionary *)_dic_info
{
    NSString *_str_url = [_dic_info objectForKey:@"url"];
    NSString *_str_key = nil;
    if([[_dic_info allKeys] containsObject:KEY_NOTIFY_ALIAS])
    {
        NSString *_str_alias = [_dic_info objectForKey:KEY_NOTIFY_ALIAS];
        _str_key = [_str_url stringByAppendingString:_str_alias];
        _str_key = [NSString md5:_str_key];
        [dic_data setObject:_dic_json forKey:_str_key];
    }//如果信息中带有别名，则按照MD5(URL+别名) 作为该条数据的KEY值
    else
    {
        _str_key = [NSString md5:_str_url];
        [dic_data setObject:_dic_json forKey:_str_key];
    }//如果信息中没有别名，则按照MD5(URL) 作为该条数据的KEY值
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_UpdateData object:_dic_info];//通知每个viewcontroller 已经收到新数据
}

-(NSMutableDictionary *)getDataByUrl:(NSString *)_str_url
{
    return [self getDataByUrl:_str_url alias:@""];
}

-(NSMutableDictionary *)getDataByUrl:(NSString *)_str_url alias:(NSString *)_str_alias
{
    if(!_str_url)
        return nil;
    
    NSString *_str_key = nil;
    if(_str_alias && ![_str_alias isEmptyStr])
    {
        _str_key = [_str_url stringByAppendingString:_str_alias];
        _str_key = [NSString md5:_str_key];
    }//如果信息中带有别名，则按照MD5(URL+别名) 作为该条数据的KEY值
    else
    {
        _str_key = [NSString md5:_str_url];
    }//如果信息中没有别名，则按照MD5(URL) 作为该条数据的KEY值
    
    if(![[dic_data allKeys] containsObject:_str_key])
        return nil;
    
    NSMutableDictionary *_dic_json = [dic_data objectForKey:_str_key];
    if(_dic_json && [_dic_json isKindOfClass:[NSMutableDictionary class]])
    {
        return _dic_json;
    }
    return nil;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    dic_data = nil;
}
@end

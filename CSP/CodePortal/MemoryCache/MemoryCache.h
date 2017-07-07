//
//  MemoryCache.h
//  CSP
//
//  Created by Ryan Gong on 15/9/11.
//  Copyright (c) 2015年 Ryan Gong. All rights reserved.
//

#import <Foundation/Foundation.h>
/*一个简易的内存缓存，读取数据的类
 
 它存储从NetworkManager请求来的JSON dictionary 
 
 */
#define KEY_ALIAS @"KEY_DUNKIN_ALIAS"
#define KEY_USERID @"KEY_DUNKIN_USERID"

#define Notification_UpdateData @"Notification_UpdateData"
#define Notification_UpdateFailed @"Notification_UpdateFailed"
@interface MemoryCache : NSObject
{
    
}
@property(nonatomic,strong)NSMutableDictionary *dic_data;
+(MemoryCache *)sharedMemoryCache;//用这个方法来初始化MemoryCache
-(void)clearAllData;
-(void)clearDataForKey:(NSString *)_str_url;

/*保存网络数据到数据中心里
 @_dic_json 包含json信息的dictionary
 @_dic_info 发送请求时 带的NetworkRequestInfo信息
 */
-(void)saveData:(NSMutableDictionary *)_dic_json info:(NSMutableDictionary *)_dic_info;

/*获得数据中心里的网络数据
 @_str_url  请求时的URL
 */
-(NSMutableDictionary *)getDataByUrl:(NSString *)_str_url;

/*获得数据中心里的网络数据
 @_str_url   请求时的URL
 @_str_alias 请求时的别名
 */
-(NSMutableDictionary *)getDataByUrl:(NSString *)_str_url alias:(NSString *)_str_alias;
@end

//
//  NetworkRequestInfo.h
//  CSP
//
//  Created by Ryan Gong on 16/12/22.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>
 //这个键用于保存希望收到通知的ViewController的哈希码，用于标示该ViewController唯一接收该条通知信息
#define KEY_NOTIFY_IDENTIFIER @"KEY_NOTIFY_IDENTIFIER"

//这个键用于保存 URL 别名 Alias ,应用于 当 URL请求相同时 可以根据Alias存取数据中心(MemoryCache)中的数据
#define KEY_NOTIFY_ALIAS @"KEY_NOTIFY_ALIAS"

//这个键用于 标记 某两个 或两个以上的request请求 是相互排斥的 ， 它们不能同时发起请求，当同时存在一个以上请求时，会取消前一个请求
#define KEY_NOTIFY_REPEL @"KEY_NOTIFY_REPEL"
@interface NetworkRequestInfo : NSMutableDictionary
{
    
}


/*
 @_str_urlAlias    别名 Alias ,应用于 当 URL请求相同时 可以根据Alias存取数据中心(MemoryCache)中的数据
 @_viewController  独占该通知的viewController的实例
 */
+(NetworkRequestInfo *)infoWithURLAlias:(NSString *)_str_urlAlias
                               notifyOnVC:(UIViewController *)_viewController;


/*
 @_str_urlAlias    别名
 @_viewController  独占该通知的viewController的实例
 @_str_repelKey 用于 标记 某两个 或两个以上的request请求 是相互排斥的 ， 它们不能同时发起请求，当同时存在一个以上请求时，会取消前一个请求
 */
+(NetworkRequestInfo *)infoWithURLAlias:(NSString *)_str_urlAlias
                             notifyOnVC:(UIViewController *)_viewController repelKEY:(NSString *)_str_repelKey;
@end

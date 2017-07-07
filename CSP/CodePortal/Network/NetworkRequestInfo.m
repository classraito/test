//
//  NetworkRequestInfo.m
//  CSP
//
//  Created by Ryan Gong on 16/12/22.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NetworkRequestInfo.h"

@implementation NetworkRequestInfo
+(NetworkRequestInfo *)infoWithURLAlias:(NSString *)_str_urlAlias
                        notifyOnVC:(UIViewController *)_viewController
{
    return [NetworkRequestInfo infoWithURLAlias:_str_urlAlias notifyOnVC:_viewController repelKEY:nil];
}

+(NetworkRequestInfo *)infoWithURLAlias:(NSString *)_str_urlAlias
                             notifyOnVC:(UIViewController *)_viewController repelKEY:(NSString *)_str_repelKey
{
    NetworkRequestInfo *_retVal = (NetworkRequestInfo *)[NSMutableDictionary dictionaryWithCapacity:1];
    if( _viewController && [_viewController isKindOfClass:[UIViewController class]] )
    {
        [_retVal setObject:[NetworkManager giveHashCodeByObj:_viewController] forKey:KEY_NOTIFY_IDENTIFIER];
    }
    if(_str_urlAlias && ![_str_urlAlias isEmptyStr])
    {
        [_retVal setObject:_str_urlAlias forKey:KEY_NOTIFY_ALIAS];
    }
    if(_str_repelKey && ![_str_repelKey isEmptyStr])
    {
        [_retVal setObject:_str_repelKey forKey:KEY_NOTIFY_REPEL];
    }
    return _retVal;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

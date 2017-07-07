//
//  NetworkEventTrack.m
//  CSP
//
//  Created by Ryan Gong on 16/12/29.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NetworkEventTrack.h"
#import "Global.h"
static NetworkEventTrack *eventTrack;
@implementation NetworkEventTrack
+(id)alloc
{
    @synchronized(self)     {
        NSAssert(eventTrack == nil, @"企圖創建一個singleton模式下的NetworkEventTrack");
        
        return [super alloc];
    }
    return nil;
}


+(NetworkEventTrack *)sharedEventTrack//用这个方法来初始化NetworkEventTrack
{
    @synchronized(self)     {
        if(!eventTrack)
        {
            eventTrack=[[NetworkEventTrack alloc]init];
            
            [[NSNotificationCenter defaultCenter] addObserver:eventTrack selector:@selector(applicationWillTerminate:)
                                                         name:UIApplicationWillTerminateNotification object:nil];//监听是否触发home键挂起程序.
            
            [[NSNotificationCenter defaultCenter] addObserver:eventTrack selector:@selector(applicationDidBecomeActive:)
                                                         name:UIApplicationDidBecomeActiveNotification object:nil];//监听是否重新进入程序程序.
            return eventTrack;
        }
    }
    return eventTrack;
}


+(void)track:(NSString *)_str_eventID attrs:(NSMutableDictionary *)_dic_attrs isUploadImmediate:(BOOL)_isUploadImmediate
{
    
    NSMutableArray *_arr_events = [NSMutableArray arrayWithCapacity:1];
    id obj = [commond getUserDefaults:KEY_TRACKDATA];
    if(!obj)
    {
        [commond setUserDefaults:_arr_events forKey:KEY_TRACKDATA];
    }
    else
    {
        _arr_events = [[commond getUserDefaults:KEY_TRACKDATA] mutableCopy];
    }
    
    NSString *str_deviceToken = [[UIDevice currentDevice] uniqueDeviceIdentifier];
    NSNumber *occTimeFromNow = [NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]];
    NSString *str_OS = [NSString stringWithFormat:@"%@ %@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];
    FGLocationManagerWrapper *locationWrapper = [FGLocationManagerWrapper sharedManager];
    long lat = locationWrapper.currentLatitude;
    long lng = locationWrapper.currentLontitude;
    
    NSMutableDictionary *_dic_singleTrack = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_singleTrack setObject:_str_eventID forKey:@"Id"];
    [_dic_singleTrack setObject:occTimeFromNow forKey:@"OccTimeFromNow"];
    [_dic_singleTrack setObject:str_deviceToken forKey:@"device"];
    [_dic_singleTrack setObject:str_OS forKey:@"OS"];
    [_dic_singleTrack setObject:[NSNumber numberWithLong:lat] forKey:@"Lat"];
    [_dic_singleTrack setObject:[NSNumber numberWithLong:lng] forKey:@"Lng"];
    if(_dic_attrs && [_dic_attrs count] > 0)
        [_dic_singleTrack setObject:_dic_attrs forKey:@"Attr"];
    else
    {
        NSMutableDictionary *_dic_attrs = [NSMutableDictionary dictionaryWithCapacity:1];
        [_dic_singleTrack setObject:_dic_attrs forKey:@"Attr"];
    }
    
    
    [_arr_events addObject:_dic_singleTrack];
    [commond setUserDefaults:_arr_events forKey:KEY_TRACKDATA];
    
    if(_isUploadImmediate)
    {
        [NetworkEventTrack uploadTrackDatasIfNeeded];
    }
}

/*默认立即上传追踪*/
+(void)track:(NSString *)_str_eventID attrs:(NSMutableDictionary *)_dic_attrs
{
    [NetworkEventTrack track:_str_eventID attrs:_dic_attrs isUploadImmediate:YES];
}

+(void)trackDownloadAppIfNeeded
{
    id obj = [commond getUserDefaults:KEY_TRACK_EVENTID_DOWNLOADAPP];
    if(!obj)
    {
        [NetworkEventTrack track:KEY_TRACK_EVENTID_DOWNLOADAPP attrs:nil isUploadImmediate:NO];
        [commond setUserDefaults:[NSNumber numberWithBool:YES] forKey:KEY_TRACK_EVENTID_DOWNLOADAPP];
    }
    return;
}

/*把保存的追踪数据上传到mixpanel*/
+(void)uploadMixPanelDatas
{
    NSMutableArray *_arr_events = (NSMutableArray *)[commond getUserDefaults:KEY_TRACKDATA];
    for(NSMutableDictionary *_dic_singleTrack in _arr_events)
    {
        NSString *_str_mixpanelEvent = [_dic_singleTrack objectForKey:@"Id"];
        NSMutableDictionary *_dic_mixpanelProperts = [_dic_singleTrack objectForKey:@"Attr"];
        if(_dic_mixpanelProperts && [_dic_mixpanelProperts count]>0)
        {
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            [mixpanel track:_str_mixpanelEvent properties:_dic_mixpanelProperts];
        }
        else
        {
            Mixpanel *mixpanel = [Mixpanel sharedInstance];
            [mixpanel track:_str_mixpanelEvent];
        }
    }
}

+(void)uploadTrackDatasIfNeeded
{
    NSMutableArray *_arr_events = (NSMutableArray *)[commond getUserDefaults:KEY_TRACKDATA];
    if(_arr_events && [_arr_events count] > 0)
    {
        [[NetworkManager_Profile sharedManager] postRequest_Profile_UploadUserTrace:_arr_events userinfo:nil];
    }/*把保存的追踪数据上传到fugu server*/
    
    [NetworkEventTrack uploadMixPanelDatas];/*把保存的追踪数据上传到mixpanel*/
}

+(void)clearTrackDatas
{
    NSMutableArray *_arr_events = [NSMutableArray arrayWithCapacity:1];
    [commond setUserDefaults:_arr_events forKey:KEY_TRACKDATA];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - 处理程序生命周期
- (void)applicationWillTerminate:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    eventTrack = nil;
    [NetworkEventTrack uploadTrackDatasIfNeeded];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [NetworkEventTrack uploadTrackDatasIfNeeded];
    
    
}
@end

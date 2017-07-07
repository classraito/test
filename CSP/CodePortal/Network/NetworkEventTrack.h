//
//  NetworkEventTrack.h
//  CSP
//
//  Created by Ryan Gong on 16/12/29.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_TRACKDATA @"KEY_TRACKDATA"                          //保存所有
#define KEY_TRACKDATA_MIXPANEL @"KEY_TRACKDATA_MIXPANEL"        //只保存mixpanel 数据

//============================这里是FUGU后台 和 MixPanel 共同追踪的数据===========================

#define KEY_TRACK_EVENTID_DOWNLOADAPP @"downloadAPP"  //只执行一次      //弹badges

#define KEY_TRACK_EVENTID_REGISTERAPP @"resgisterAPP" //第一次注册,和登录时    //弹badges     tested

#define KEY_TRACK_EVENTID_FITNESSTEST @"fitnessTest"   //完成一次fitnesstest      //弹badges   tested

#define KEY_TRACK_EVENTID_WORKOUT @"workout"            //每看完一整个workout          //Attr :    "WorkoutID":"40","duration":1800  //tested
#define KEY_TRACK_ATTRID_WORKOUT_ID @"WorkoutID"
#define KEY_TRACK_ATTRID_WORKOUT_DURATION @"duration"//弹badges


#define KEY_TRACK_EVENTID_SHAREAPP @"shareAPP"          //除了post外 每次分享时  //弹badges       //Attr :    "shareContent":"post","shareTo":Wechat
#define KEY_TRACK_ATTRID_POST_SHARECONTENT @"shareContent"
#define KEY_TRACK_ATTRID_POST_SHARETO @"shareTo"                //TODO:

#define KEY_TRACK_EVENTID_GETPOST @"getPost"            //每次点了Post->ALL USER   或  POST->FOLLOWING

#define KEY_TRACK_EVENTID_PTSESSION @"ptSession"        //学员点击 MYBOODING 刷新列表时  完成1次booking 并且时间完成

#define KEY_TRACK_EVENTID_ADDFRIEND @"addFriend"        //FOWLLOW 或 UNFOLLOW        //Attr :  "friendID":"123"  tested
#define KEY_TRACK_ATTRID_ADDFRIEND_FRIENDID @"friendID"        

#define KEY_TRACK_EVENTID_JOINGROUP @"joinGroup"        //每次加入一个组   //Attr :    "GroupId":"40"    tested
#define KEY_TRACK_ATTRID_JOINGROUP_GROUPID @"GroupId"

#define KEY_TRACK_EVENTID_SUBMITPOST @"submitPost"      //每次发布POST                  //tested

#define KEY_TRACK_EVENTID_SUBMITCOMMENT @"submitComment"    //每次被评论的时候              //tested

#define KEY_TRACK_EVENTID_PROFILE @"profile"                //每次修改个人资料并上传时


//===========================这里是MIXPanel 追踪的数据========================
#define KEY_MIXPANEL_EVENTID_BOOKATRAINER @"Book a trainer"                                        //用户实际预订成功了一个教练
#define KEY_MIXPANEL_EVENTID_BOOKNOW @"Book Now"                                                   //用户点击预订时
#define KEY_MIXPANEL_EVENTID_PAYSESSION @"User Pay Session"                                        //用户付款时
#define KEY_MIXPANEL_EVENTID_REBOOK @"Rebook"                                                      //用户再次预订时
#define KEY_MIXPANEL_EVENTID_CANCEL_SESSION @"Cancel Session"                                      //取消订单





#define KEY_TRACK_EVENTID_WORKOUTPLAN @"workoutPlan"   //暂无//Attr : "TimeStamp":12345678901,"Level":1,"Equipment":2,"Goal":1,"Weeks":4,"WorkoutPerWeek":3
#define KEY_TRACK_ATTRID_WORKOUTPLAN_TIMESTAMP @"TimeStamp"
#define KEY_TRACK_ATTRID_WORKOUTPLAN_LEVEL @"Level"
#define KEY_TRACK_ATTRID_WORKOUTPLAN_EQUIPMENT @"Equipment"
#define KEY_TRACK_ATTRID_WORKOUTPLAN_GOAL @"Goal"
#define KEY_TRACK_ATTRID_WORKOUTPLAN_WEEKS @"Weeks"
#define KEY_TRACK_ATTRID_WORKOUTPLAN_WORKOUTPERWEEK @"WorkoutPerWeek"

#define KEY_TRACK_EVENT_ATTR @"KEY_TRACK_EVENT_ATTR"

@interface NetworkEventTrack : NSObject
{
    
}
+(NetworkEventTrack *)sharedEventTrack;//用这个方法来初始化NetworkEventTrack
+(void)trackDownloadAppIfNeeded;
/*可设置是否立即上传 如果不立即上传 则保存在本地 开启和关闭APP时会上传*/
+(void)track:(NSString *)_str_eventID attrs:(NSMutableDictionary *)_dic_attrs isUploadImmediate:(BOOL)_isUploadImmediate;
/*默认立即上传追踪*/
+(void)track:(NSString *)_str_eventID attrs:(NSMutableDictionary *)_dic_attrs;
+(void)uploadTrackDatasIfNeeded;
+(void)clearTrackDatas;
@end

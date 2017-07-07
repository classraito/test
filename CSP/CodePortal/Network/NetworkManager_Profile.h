//
//  NetworkManager_Profile.h
//  CSP
//
//  Created by Ryan Gong on 16/11/23.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NetworkManager.h"
/*获取用户信息的接口*/
#define URL_PROFILE_GetUserProfile @"/Account/GetUserProfile.ashx"

/*获取教练详细信息的接口*/
#define URL_PROFILE_TrainerDetailPage @"/Account/TrainerDetailPage.ashx"//TODO

/*获取Workout记录列表*/
#define URL_PROFILE_WorkoutReport @"/Account/WorkoutReport.ashx"

/*获取Workout日记录列表*/
#define URL_PROFILE_WorkoutDailyReport @"/Account/WorkoutDailyReport.ashx"

/*获取教练信息的接口*/
#define URL_PROFILE_GetTrainerProfile @"/Account/GetTrainerProfile.ashx"

/*获取身体素质测试列表*/
#define URL_PROFILE_FitnessTestList @"/Account/FitnessTestList.ashx"

/*测试身体素质*/
#define URL_PROFILE_FitnessTest @"/Account/FitnessTest.ashx"

/*获取用户勋章接口*/
#define URL_PROFILE_GetUserBadges @"/Account/GetUserBadges.ashx"//TODO

/*获取教练评论列表*/
#define URL_PROFILE_TrainerComments @"/Account/TrainerComments.ashx"

/*记录用户的行为，用于统计用户的勋章*/
#define URL_PROFILE_UploadUserTrace @"/Track/UploadUserTrace.ashx"

/*设置用户信息接口*/
#define URL_PROFILE_SetUserProfile @"/Account/SetUserProfile.ashx"

/*获取profile 首页信息接口*/
#define URL_PROFILE_ProfilePage @"/Account/ProfilePage.ashx"
@interface NetworkManager_Profile : NetworkManager
#pragma mark - 获取用户信息的接口
-(void)postRequest_Profile_getUserProfile:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取教练详细信息的接口 //TODO
-(void)postRequest_Profile_TrainerDetailPage:(NSString *)_str_trainerId userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取Workout记录列表
-(BOOL)postRequest_Profile_WorkoutReport:(int)_queryType isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取Workout日记录列表
-(void)postRequest_Profile_WorkoutDailyReport:(int)_queryType isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取教练信息的接口
-(void)postRequest_Profile_GetTrainerProfile:(NSString *)_str_trainerId userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取身体素质测试列表
-(void)postRequest_Profile_FitnessTestList:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 测试身体素质
-(void)postRequest_Profile_SubmitFitnessTestByPushUp:(int)_pushUp situps:(int)_situps squats:(int)_squats burpees:(int)_burpees plank:(long)_plank url:(NSString *)_str_url fitnessID:(NSString *)_str_fitnessID userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取用户勋章接口 //TODO
-(void)postRequest_Profile_GetUserBadges:(NSMutableDictionary *)_dic_userinfo;
-(void)postRequest_Profile_GetUserBadgesWithUserId:(NSString *)str_id userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取教练评论列表
-(void)postRequest_Profile_TrainerComments:(NSString *)_str_trainerId isFirstPage:(BOOL)_isFirstPage count:(int)_count cursor:(NSInteger)_cursor userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 设置用户信息接口
-(void)postRequest_Profile_SetUserProfile:(NSMutableArray *)_arr_actionInfo userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取profile 首页信息接口 //TODO
-(void)postRequest_Profile_ProfilePage:(NSString *)_str_postFilter userinfo:(NSMutableDictionary *)_dic_userinfo;
-(void)postRequest_Profile_ProfilePageWithUserId:(NSString *)_str_userId postFilter:(NSString *)_str_postFilter userinfo:(NSMutableDictionary *)_dic_userinfo;
-(void)postRequest_Profile_ProfilePageWithUserId:(NSString *)_str_userId queryUserId:(NSString *)_str_queryUserId postFilter:(NSString *)_str_postFilter userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 记录用户的行为，用于统计用户的勋章
-(void)postRequest_Profile_UploadUserTrace:(NSMutableArray *)_arr_events userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 记录用户的行为，用于统计用户的勋章 使用block 返回结果
-(void)postRequest_Profile_UploadUserTrace:(NSMutableArray *)_arr_events sucess:(ASIBasicBlock)_sucessBlock failed:(ASIBasicBlock)_failedBlock;
@end

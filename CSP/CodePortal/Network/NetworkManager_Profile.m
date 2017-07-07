//
//  NetworkManager_Profile.m
//  CSP
//
//  Created by Ryan Gong on 16/11/23.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NetworkManager_Profile.h"
#import "Global.h"
@implementation NetworkManager_Profile
#pragma mark - 获取用户信息的接口
-(void)postRequest_Profile_getUserProfile:(NSMutableDictionary *)_dic_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"QueryUserId"];
    [self requestUrl:HOST(URL_PROFILE_GetUserProfile) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取教练详细信息的接口
-(void)postRequest_Profile_TrainerDetailPage:(NSString *)_str_trainerId userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    [dic_headers setObjectSafty:@"1080" forKey:@"ScreenResolution"];
    
    NSMutableArray *arr_paramsWrapper = [NSMutableArray arrayWithCapacity:1];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_trainerId forKey:@"TrainerId"];
    [self appendParams:dic_params toArray:arr_paramsWrapper requestId:@"1" requestName:@"GetTrainerProfile"];
    
    NSMutableDictionary *dic_params1 = [NSMutableDictionary dictionary];
    [dic_params1 setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params1 setObjectSafty:_str_trainerId forKey:@"TrainerId"];
    [dic_params1 setObjectSafty:@"" forKey:@"Cursor"];
    [dic_params1 setObjectSafty:[NSNumber numberWithInteger:5] forKey:@"Count"];
    [self appendParams:dic_params1 toArray:arr_paramsWrapper requestId:@"2" requestName:@"GetTrainerComments"];
    
    [self requestUrl:HOST(URL_PROFILE_TrainerDetailPage) params:arr_paramsWrapper headers:dic_headers userinfo:_dic_userinfo];

}

#pragma mark - 获取Workout记录列表
-(BOOL)postRequest_Profile_WorkoutReport:(int)_queryType isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo
{
//  [commond showLoading];
    NSString *_str_cursor = [self getCursorByURL:HOST(URL_PROFILE_WorkoutReport) isFirstPage:_isFirstPage];
  if(!_str_cursor || [_str_cursor isEqualToString:@"-1"]){
    return YES;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
  }
  
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_queryType] forKey:@"QueryType"];
    [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    
    [self requestUrl:HOST(URL_PROFILE_WorkoutReport) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
  
  return NO;
}

#pragma mark - 获取Workout日记录列表
-(void)postRequest_Profile_WorkoutDailyReport:(int)_queryType isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSString *_str_cursor = [self getCursorByURL:HOST(URL_PROFILE_WorkoutDailyReport) isFirstPage:_isFirstPage];
    if(!_str_cursor)
        return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    
    [self requestUrl:HOST(URL_PROFILE_WorkoutDailyReport) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取教练信息的接口
-(void)postRequest_Profile_GetTrainerProfile:(NSString *)_str_trainerId userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_trainerId forKey:@"TrainerId"];
    
    [self requestUrl:HOST(URL_PROFILE_GetTrainerProfile) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取身体素质测试列表
-(void)postRequest_Profile_FitnessTestList:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSString *_str_cursor = [self getCursorByURL:HOST(URL_PROFILE_FitnessTestList) isFirstPage:_isFirstPage];
    if(!_str_cursor)
        return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    
    [self requestUrl:HOST(URL_PROFILE_FitnessTestList) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 测试身体素质
-(void)postRequest_Profile_SubmitFitnessTestByPushUp:(int)_pushUp situps:(int)_situps squats:(int)_squats burpees:(int)_burpees plank:(long)_plank url:(NSString *)_str_url fitnessID:(NSString *)_str_fitnessID userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_pushUp] forKey:@"PushUp"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_situps] forKey:@"Situps"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_squats] forKey:@"Squats"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_burpees] forKey:@"Burpees"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_plank] forKey:@"Plank"];
    [dic_params setObjectSafty:_str_fitnessID forKey:@"FitnessTestId"];
    
    [dic_params setObjectSafty:_str_url forKey:@"URL"];
    [self requestUrl:HOST(URL_PROFILE_FitnessTest) params:dic_params headers:dic_headers userinfo:_dic_userinfo];

}

#pragma mark - 获取用户勋章接口
-(void)postRequest_Profile_GetUserBadgesWithUserId:(NSString *)str_id userinfo:(NSMutableDictionary *)_dic_userinfo
{
  NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
  [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
  [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
  
  NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];

  [dic_params setObjectSafty:str_id forKey:@"QueryUserId"];
  [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];

  [self requestUrl:HOST(URL_PROFILE_GetUserBadges) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

-(void)postRequest_Profile_GetUserBadges:(NSMutableDictionary *)_dic_userinfo;
{
  NSString *_str_id = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
  [self postRequest_Profile_GetUserBadgesWithUserId:_str_id userinfo:_dic_userinfo];
}

#pragma mark - 获取教练评论列表
-(void)postRequest_Profile_TrainerComments:(NSString *)_str_trainerId isFirstPage:(BOOL)_isFirstPage count:(int)_count cursor:(NSInteger)_cursor userinfo:(NSMutableDictionary *)_dic_userinfo;
{
  NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
  [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
  [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
  
  NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
  [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
  [dic_params setObjectSafty:_str_trainerId forKey:@"TrainerId"];
  [dic_params setObjectSafty:[NSNumber numberWithInteger:_cursor] forKey:@"Cursor"];
  [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
  
  [self requestUrl:HOST(URL_PROFILE_TrainerComments) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}


#pragma mark - 记录用户的行为，用于统计用户的勋章
-(void)postRequest_Profile_UploadUserTrace:(NSMutableArray *)_arr_events userinfo:(NSMutableDictionary *)_dic_userinfo{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"DeviceToken"];
    [dic_params setObjectSafty:_arr_events forKey:@"Events"];
    
    [self requestUrl:HOST(URL_PROFILE_UploadUserTrace) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}


#pragma mark - 记录用户的行为，用于统计用户的勋章 使用block 返回结果
-(void)postRequest_Profile_UploadUserTrace:(NSMutableArray *)_arr_events sucess:(ASIBasicBlock)_sucessBlock failed:(ASIBasicBlock)_failedBlock{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:@"DeviceToken"];
    [dic_params setObjectSafty:_arr_events forKey:@"Events"];
    
    [self requestUrl:HOST(URL_PROFILE_UploadUserTrace) params:dic_params headers:dic_headers sucess:_sucessBlock failed:_failedBlock userinfo:nil];
}

#pragma mark - 设置用户信息接口
-(void)postRequest_Profile_SetUserProfile:(NSMutableArray *)_arr_actionInfo userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_arr_actionInfo forKey:@"Action"];
    
    
    [self requestUrl:HOST(URL_PROFILE_SetUserProfile) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取profile 首页信息接口
-(void)postRequest_Profile_ProfilePageWithUserId:(NSString *)_str_userId postFilter:(NSString *)_str_postFilter userinfo:(NSMutableDictionary *)_dic_userinfo
{
  [self postRequest_Profile_ProfilePageWithUserId:_str_userId queryUserId:[NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]] postFilter:_str_postFilter userinfo:_dic_userinfo];
}

//获取自己profile信息,徽章，post
-(void)postRequest_Profile_ProfilePage:(NSString *)_str_postFilter userinfo:(NSMutableDictionary *)_dic_userinfo;
{
  [self postRequest_Profile_ProfilePageWithUserId:[NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]] postFilter:_str_postFilter userinfo:_dic_userinfo];
}

-(void)postRequest_Profile_ProfilePageWithUserId:(NSString *)_str_userId queryUserId:(NSString *)_str_queryUserId postFilter:(NSString *)_str_postFilter userinfo:(NSMutableDictionary *)_dic_userinfo {
  NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
  [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
  [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
  [dic_headers setObjectSafty:@"1080" forKey:@"ScreenResolution"];
  
  NSMutableArray *arr_paramsWrapper = [NSMutableArray arrayWithCapacity:1];
  
  NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
  [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
  [dic_params setObjectSafty:_str_userId forKey:@"QueryUserId"];
  
  [self appendParams:dic_params toArray:arr_paramsWrapper requestId:@"1" requestName:@"GetUserProfile"];
  
  NSMutableDictionary *dic_params1 = [NSMutableDictionary dictionary];

  [dic_params1 setObjectSafty:_str_userId forKey:@"QueryUserId"];
  [dic_params1 setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];

  [self appendParams:dic_params1 toArray:arr_paramsWrapper requestId:@"2" requestName:@"GetUserBadges"];
  
  NSMutableDictionary *dic_params2 = [NSMutableDictionary dictionary];
  [dic_params2 setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
  [dic_params2 setObjectSafty:_str_postFilter forKey:@"Filter"];
  [dic_params2 setObjectSafty:[NSNumber numberWithInteger:10] forKey:@"Count"];
  [self appendParams:dic_params2 toArray:arr_paramsWrapper requestId:@"3" requestName:@"GetPostList"];
  
  [self requestUrl:HOST(URL_PROFILE_ProfilePage) params:arr_paramsWrapper headers:dic_headers userinfo:_dic_userinfo];
}
@end

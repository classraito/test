//
//  NetworkManager_Training.m
//  CSP
//
//  Created by Ryan Gong on 16/9/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NetworkManager_Training.h"
#import "Global.h"
#import "MemoryCache.h"
@implementation NetworkManager_Training
#pragma mark - 获取个人定制训练项目列表
/*
    _isFirstPage : 是否第一页
    _count : 请求返回Post的数量
 */
-(void)postRequest_GetFeaturedVideoList:(BOOL )_isFirstPage count:(NSInteger)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    
    NSString *_str_cursor = [self getCursorByURL:HOST(URL_TRAINING_GetFeaturedVideoList) isFirstPage:_isFirstPage];
    if(!_str_cursor)
        return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    
    [self requestUrl:HOST(URL_TRAINING_GetFeaturedVideoList) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取付费定制训练项目列表
/*
 _isFirstPage : 是否第一页
 _count : 请求返回Post的数量
 */
-(void)postReqeust_GetVIPVideoList:(BOOL )_isFirstPage count:(NSInteger)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    
    NSString *_str_cursor = [self getCursorByURL:HOST(URL_TRAINING_GetVIPVideoList) isFirstPage:_isFirstPage];
    if(!_str_cursor)
        return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
    
//    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    
    [self requestUrl:HOST(URL_TRAINING_GetVIPVideoList) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取某类训练项目列表
/*
 _isFirstPage : 是否第一页
 _count : 请求返回Post的数量
 _workoutType:训练项目类型
 */
-(void)postReqeust_GetWorkoutVideoList:(BOOL )_isFirstPage count:(NSInteger)_count workoutType:(WorkoutType)_workoutType userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    
    NSString *_str_cursor = [self getCursorByURL:HOST(URL_TRAINING_GetWorkoutVideoList) isFirstPage:_isFirstPage];
    if(!_str_cursor)
        return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
    
//    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:[NSNumber numberWithInt:_workoutType] forKey:@"WorkoutType"];
    [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    
    [self requestUrl:HOST(URL_TRAINING_GetWorkoutVideoList) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取所有动作视频列表
/*
 _isFirstPage : 是否第一页
 _count : 请求返回Post的数量
 */
-(void)postReqeust_GetAllStep:(BOOL )_isFirstPage count:(NSInteger)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    
    NSString *_str_cursor = [self getCursorByURL:HOST(URL_TRAINING_GetAllStep) isFirstPage:_isFirstPage];
    if(!_str_cursor)
        return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
    
 
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    [dic_headers setObjectSafty:@"1080" forKey:@"ScreenResolution"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    
    [self requestUrl:HOST(URL_TRAINING_GetAllStep) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取某训练项目动作视频列表，注意这里没有分页，某训练项目中的动作视频全部下载
-(void)postRequest_GetTrainingStep:(NSString *)_str_trainingID userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_trainingID forKey:@"TrainingId"];
    
    [self requestUrl:HOST(URL_TRAINING_GetTrainingStep) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取某训练项目的评论列表
-(void)postRequest_GetTrainCommentList:(int )cursor trainingID:(NSString *)_str_trainingID count:(NSInteger)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    if(cursor == -1)
        return;
    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_trainingID forKey:@"TrainingId"];
    [dic_params setObjectSafty:[NSString stringWithFormat:@"%d",cursor] forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    
    [self requestUrl:HOST(URL_TRAINING_GetTrainCommentList) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 对某训练项目的评论
-(void)postRequest_SubmitTrainComment:(NSString *)_str_trainingID content:(NSString *)_str_content userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    [commond showLoading];
    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_trainingID forKey:@"TrainingId"];
    [dic_params setObjectSafty:_str_content forKey:@"Content"];
    
    [self requestUrl:HOST(URL_TRAINING_SubmitTrainComment) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 对某训练项目点攒或取消
-(void)postRequest_SetTrainLike:(NSString *)_str_trainingID isLike:(BOOL)_isLike userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    [commond showLoading];
    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_trainingID forKey:@"TrainingId"];
    [dic_params setObjectSafty:[NSNumber numberWithBool:_isLike] forKey:@"Like"];
    
    [self requestUrl:HOST(URL_TRAINING_SetTrainLike) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 对某训练项目点攒或取消
-(void)postRequest_SetTrainFavorite:(NSString *)_str_trainingID isFavorite:(BOOL)_isFavorite userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    [commond showLoading];
    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_trainingID forKey:@"TrainingId"];
    [dic_params setObjectSafty:[NSNumber numberWithBool:_isFavorite] forKey:@"Favorite"];
    
    [self requestUrl:HOST(URL_TRAINING_SetTrainFavorite) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取训练项目的详情
-(void)postRequest_GetTrainDetail:(NSString *)_str_trainingID  userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *_dic_singleParams = [NSMutableDictionary dictionary];
    [_dic_singleParams setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [_dic_singleParams setObjectSafty:_str_trainingID forKey:@"TrainingId"];
    [self requestUrl:HOST(URL_TRAINING_GetTrainDetail) params:_dic_singleParams headers:dic_headers userinfo:_dic_userinfo];
    
}

#pragma mark - 获取训练项目点攒列表
-(void)postRequest_GetTrainLikeList:(BOOL )_isFirstPage count:(NSInteger)_count trainingID:(NSString *)_str_trainingID userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSString *_str_cursor = [self getCursorByURL:HOST(URL_TRAINING_GetTrainLikeList) isFirstPage:_isFirstPage];
    if(!_str_cursor)
        return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_trainingID forKey:@"TrainingId"];
    [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    
    [self requestUrl:HOST(URL_TRAINING_GetTrainLikeList) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

-(void)postRequest_GetTrainDetailPageBytrainingID:(NSString *)_str_trainingID userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableArray *arr_paramsWrapper = [NSMutableArray arrayWithCapacity:1];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_trainingID forKey:@"TrainingId"];
    [self appendParams:dic_params toArray:arr_paramsWrapper requestId:@"1" requestName:@"GetTrainDetail"];
    
    NSMutableDictionary *dic_params1 = [NSMutableDictionary dictionary];
    [dic_params1 setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params1 setObjectSafty:_str_trainingID forKey:@"TrainingId"];
    [dic_params1 setObjectSafty:@"" forKey:@"Cursor"];
    [dic_params1 setObjectSafty:[NSNumber numberWithInteger:10] forKey:@"Count"];
    [self appendParams:dic_params1 toArray:arr_paramsWrapper requestId:@"2" requestName:@"GetTrainLikeList"];
    
    NSMutableDictionary *dic_params2 = [NSMutableDictionary dictionary];
    [dic_params2 setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params2 setObjectSafty:_str_trainingID forKey:@"TrainingId"];
    [self appendParams:dic_params2 toArray:arr_paramsWrapper requestId:@"3" requestName:@"GetTrainingStep"];
    
    NSMutableDictionary *dic_params3 = [NSMutableDictionary dictionary];
    [dic_params3 setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params3 setObjectSafty:_str_trainingID forKey:@"TrainingId"];
    [dic_params3 setObjectSafty:@"" forKey:@"Cursor"];
    [dic_params3 setObjectSafty:[NSNumber numberWithInteger:10] forKey:@"Count"];
    [self appendParams:dic_params3 toArray:arr_paramsWrapper requestId:@"4" requestName:@"GetTrainCommentList"];
    
    [self requestUrl:HOST(URL_TRAINING_GetTrainDetailPage) params:arr_paramsWrapper headers:dic_headers userinfo:_dic_userinfo];
   
}

#pragma mark - 获取用户收藏的训练项目列表
-(void)postRequest_GetFavoriteVideoList:(BOOL)_isFirstPage count:(NSInteger)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSString *_str_cursor = [self getCursorByURL:HOST(URL_TRAINING_GetFavoriteVideoList) isFirstPage:_isFirstPage];
    if(!_str_cursor)
        return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求

    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *_dic_singleParams = [NSMutableDictionary dictionary];
    [_dic_singleParams setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [_dic_singleParams setObjectSafty:_str_cursor forKey:@"Cursor"];
    [_dic_singleParams setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    [self requestUrl:HOST(URL_TRAINING_GetFavoriteVideoList) params:_dic_singleParams headers:dic_headers userinfo:_dic_userinfo];

}

#pragma mark - 保存训练计划
-(void)postRequest_SetWorkoutPlan:(long)_timeStamp workouts:(NSMutableArray *)_arr_workoutsInfo
                         userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *_dic_singleParams = [NSMutableDictionary dictionary];
    [_dic_singleParams setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [_dic_singleParams setObjectSafty:[NSNumber numberWithLong:_timeStamp] forKey:@"TimeStamp"];
    [_dic_singleParams setObjectSafty:_arr_workoutsInfo forKey:@"Workouts"];
    [self requestUrl:HOST(URL_TRAINING_SetWorkoutPlan) params:_dic_singleParams headers:dic_headers userinfo:_dic_userinfo];

}

#pragma mark - 制定新的训练计划，获取原始列表，列表只有一周
-(void)postRequest_GetOriginalWorkoutPlan:(int)_level equipment:(int)_equipment
                                     goal:(int)_goal weeks:(int)_weeks workoutPerWeek:(int)_workoutPerweek timeStamp:(long)_timeStamp userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *_dic_singleParams = [NSMutableDictionary dictionary];
    [_dic_singleParams setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [_dic_singleParams setObjectSafty:[NSNumber numberWithLong:_timeStamp] forKey:@"TimeStamp"];
    [_dic_singleParams setObjectSafty:[NSNumber numberWithInt:_level] forKey:@"Level"];
    [_dic_singleParams setObjectSafty:[NSNumber numberWithInt:_equipment] forKey:@"Equipment"];
    [_dic_singleParams setObjectSafty:[NSNumber numberWithInt:_goal] forKey:@"Goal"];
    [_dic_singleParams setObjectSafty:[NSNumber numberWithInt:_weeks] forKey:@"Weeks"];
    [_dic_singleParams setObjectSafty:[NSNumber numberWithInt:_workoutPerweek] forKey:@"WorkoutPerWeek"];
    [self requestUrl:HOST(URL_TRAINING_GetOriginalWorkoutPlan) params:_dic_singleParams headers:dic_headers userinfo:_dic_userinfo];

}

#pragma mark - 获取最后一次上传的训练计划
-(void)postRequest_GetWorkoutPlan:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *_dic_singleParams = [NSMutableDictionary dictionary];
    [_dic_singleParams setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    
    [self requestUrl:HOST(URL_TRAINING_GetWorkoutPlan) params:_dic_singleParams headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 举报某条评论
-(void)postReuqest_AccuseTrainComment:(NSString *)_str_commentId content:(NSString *)_str_content userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *_dic_singleParams = [NSMutableDictionary dictionary];
    [_dic_singleParams setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [_dic_singleParams setObjectSafty:_str_commentId forKey:@"CommentId"];
    [_dic_singleParams setObjectSafty:_str_content forKey:@"Content"];
    [self requestUrl:HOST(URL_TRAINING_AccuseTrainComment) params:_dic_singleParams headers:dic_headers userinfo:_dic_userinfo];

}

#pragma mark - 删除对某个内容的评论，此评论必须是自己发布的
-(void)postRequest_DeleteTrainComment:(NSString *)_str_commentId userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *_dic_singleParams = [NSMutableDictionary dictionary];
    [_dic_singleParams setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [_dic_singleParams setObjectSafty:_str_commentId forKey:@"CommentId"];
    [self requestUrl:HOST(URL_TRAINING_DeleteTrainComment) params:_dic_singleParams headers:dic_headers userinfo:_dic_userinfo];

}

#pragma mark - 继承自父类的方法: 用于持久化某些重要信息到本地
-(void)saveImportInfo:(NSMutableDictionary *)_dic_result url:(NSString *)_str_url userinfo:(NSMutableDictionary *)_dic_userinfo
{
    if(!_dic_result)
        return;
    if([_dic_result count]<=0)
        return;
    if(!_str_url)
        return;
}
@end

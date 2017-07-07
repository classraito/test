//
//  NetworkManager_Training.h
//  CSP
//
//  Created by Ryan Gong on 16/9/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NetworkManager.h"
/*删除对某个内容的评论，此评论必须是自己发布的*/
#define URL_TRAINING_DeleteTrainComment @"/Training/DeleteTrainComment.ashx"
/*举报某条评论*/
#define URL_TRAINING_AccuseTrainComment @"/Training/AccuseTrainComment.ashx"
/*获取个人定制训练项目列表*/
#define URL_TRAINING_GetFeaturedVideoList @"/Training/GetFeaturedVideoList.ashx"
/*获取付费定制训练项目列表*/
#define URL_TRAINING_GetVIPVideoList @"/Training/GetVIPVideoList.ashx"
/*获取某类训练项目列表*/
#define URL_TRAINING_GetWorkoutVideoList @"/Training/GetWorkoutVideoList.ashx"
/*获取用户收藏的训练项目列表*/
#define URL_TRAINING_GetFavoriteVideoList @"/Training/GetFavoriteVideoList.ashx"
/*获取所有动作视频列表*/
#define URL_TRAINING_GetAllStep @"/Training/GetAllStep.ashx"
/*取训练详细内容 包含了
 GetTrainDetail
 GetTrainLikeList
 GetTrainingStep
 GetTrainCommentList
 四个接口
 其中GetTrainCommentList需要在页面上多次调用*/
#define URL_TRAINING_GetTrainDetailPage @"/Training/GetTrainDetailPage.ashx"
/*获取某训练项目动作视频列表，注意这里没有分页，某训练项目中的动作视频全部下载*/
#define URL_TRAINING_GetTrainingStep @"/Training/GetTrainingStep.ashx"
/*获取某训练项目的评论列表*/
#define URL_TRAINING_GetTrainCommentList @"/Training/GetTrainCommentList.ashx"
/*对某训练项目的评论*/
#define URL_TRAINING_SubmitTrainComment @"/Training/SubmitTrainComment.ashx"
/*对某训练项目点攒或取消*/
#define URL_TRAINING_SetTrainLike @"/Training/SetTrainLike.ashx"
/*对某训练项目收藏或取消*/
#define URL_TRAINING_SetTrainFavorite @"/Training/SetTrainFavorite.ashx"
/*获取训练项目的详情*/
#define URL_TRAINING_GetTrainDetail @"/Training/GetTrainDetail.ashx"
/*获取训练项目点攒列表*/
#define URL_TRAINING_GetTrainLikeList @"/Training/GetTrainLikeList.ashx"
/*保存训练计划*/
#define URL_TRAINING_SetWorkoutPlan @"/Training/SetWorkoutPlan.ashx"
/*制定新的训练计划，获取原始列表格*/
#define URL_TRAINING_GetOriginalWorkoutPlan @"/Training/GetOriginalWorkoutPlan.ashx"
/*获取最后一次上传的训练计划*/
#define URL_TRAINING_GetWorkoutPlan @"/Training/GetWorkoutPlan.ashx"

typedef enum {
    
    WorkoutType_SingleWithEquipment = 0,
    WorkoutType_SingleWithNoEquipment = 1,
    WorkoutType_Paired = 2,
    WorkoutType_Footwork = 3,
    WorkoutType_Conditioning = 4,
    WorkoutType_Bag = 5,
    WorkoutType_HeadMovement = 6,
    WorkoutType_Pad = 7
}WorkoutType;

@interface NetworkManager_Training : NetworkManager
{
    
}
#pragma mark - 取训练详细内容
-(void)postRequest_GetTrainDetailPageBytrainingID:(NSString *)_str_trainingID userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取个人定制训练项目列表
-(void)postRequest_GetFeaturedVideoList:(BOOL )_isFirstPage count:(NSInteger)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 获取付费定制训练项目列表

-(void)postReqeust_GetVIPVideoList:(BOOL )_isFirstPage count:(NSInteger)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 获取某类训练项目列表

-(void)postReqeust_GetWorkoutVideoList:(BOOL )_isFirstPage count:(NSInteger)_count workoutType:(WorkoutType)_workoutType userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 获取所有动作视频列表

-(void)postReqeust_GetAllStep:(BOOL )_isFirstPage count:(NSInteger)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 获取某训练项目动作视频列表，注意这里没有分页，某训练项目中的动作视频全部下载
-(void)postRequest_GetTrainingStep:(NSString *)_str_trainingID userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 获取某训练项目的评论列表
-(void)postRequest_GetTrainCommentList:(int )cursor trainingID:(NSString *)_str_trainingID count:(NSInteger)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 对某训练项目的评论
-(void)postRequest_SubmitTrainComment:(NSString *)_str_trainingID content:(NSString *)_str_content userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 对某训练项目点攒或取消
-(void)postRequest_SetTrainLike:(NSString *)_str_trainingID isLike:(BOOL)_isLike userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 对某训练项目点攒或取消
-(void)postRequest_SetTrainFavorite:(NSString *)_str_trainingID isFavorite:(BOOL)_isFavorite userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 获取训练项目的详情
-(void)postRequest_GetTrainDetail:(NSString *)_str_trainingID  userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 获取训练项目点攒列表
-(void)postRequest_GetTrainLikeList:(BOOL )_isFirstPage count:(NSInteger)_count trainingID:(NSString *)_str_trainingID userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 获取用户收藏的训练项目列表
-(void)postRequest_GetFavoriteVideoList:(BOOL)_isFirstPage count:(NSInteger)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 保存训练计划
-(void)postRequest_SetWorkoutPlan:(long)_timeStamp workouts:(NSMutableArray *)_arr_workoutsInfo
                         userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 制定新的训练计划，获取原始列表，列表只有一周
-(void)postRequest_GetOriginalWorkoutPlan:(int)_level equipment:(int)_equipment
                                     goal:(int)_goal weeks:(int)_weeks workoutPerWeek:(int)_workoutPerweek timeStamp:(long)_timeStamp userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 获取最后一次上传的训练计划
-(void)postRequest_GetWorkoutPlan:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 举报某条评论
-(void)postReuqest_AccuseTrainComment:(NSString *)_str_commentId content:(NSString *)_str_content userinfo:(NSMutableDictionary *)_dic_userinfo;

#pragma mark - 删除对某个内容的评论，此评论必须是自己发布的
-(void)postRequest_DeleteTrainComment:(NSString *)_str_commentId userinfo:(NSMutableDictionary *)_dic_userinfo;


@end

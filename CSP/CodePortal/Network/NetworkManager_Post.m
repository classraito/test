//
//  NetworkManager_Post.m
//  CSP
//
//  Created by Ryan Gong on 16/11/4.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NetworkManager_Post.h"
#import "Global.h"
#import "MemoryCache.h"
@implementation NetworkManager_Post
#pragma mark - 获取主题，一般用于#
-(void)postRequest_GetTopicList:(NSString *)_str_keywords cursor:(NSInteger )_cursor count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_keywords forKey:@"Keywords"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_cursor] forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    
    [self requestUrl:HOST(URL_POST_GetTopicList) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 发送推文
-(void)postRequest_SubmitPost:(BOOL)_private images:(NSMutableArray *)_arr_images imageThumbnails:(NSMutableArray *)_arr_thumbnails video:(NSString *)_str_video videoThumbnail:(NSString *)_str_videoThumbnail content:(NSString *)_str_content
                     location:(NSString *)_str_location lat:(long)_lat lng:(long)_lng userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:[NSNumber numberWithBool:_private] forKey:@"Private"];
    
    if(_arr_images)
    {
        [dic_params setObjectSafty:_arr_images forKey:@"Images"];
        [dic_params setObjectSafty:_arr_thumbnails forKey:@"ImageThumbnails"];
    }
    else
    {
        [dic_params setObjectSafty:@[] forKey:@"Images"];
        [dic_params setObjectSafty:@[] forKey:@"ImageThumbnails"];
    }
   
    
        [dic_params setObjectSafty:_str_video forKey:@"Video"];
        [dic_params setObjectSafty:_str_videoThumbnail forKey:@"VideoThumbnail"];
    
    [dic_params setObjectSafty:_str_content forKey:@"Content"];
    [dic_params setObjectSafty:_str_location forKey:@"Location"];
    [dic_params setObjectSafty:[NSNumber numberWithLong:_lat] forKey:@"Lat"];
    [dic_params setObjectSafty:[NSNumber numberWithLong:_lng] forKey:@"Lng"];
    
    [self requestUrl:HOST(URL_POST_Update_SubmitPost) params:dic_params headers:dic_headers userinfo:_dic_userinfo];

}

#pragma mark - 对某条推文点攒或取消
-(void)postRequest_setPostLike:(NSString *)_str_postId like:(BOOL)_like userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_postId forKey:@"PostId"];
    [dic_params setObjectSafty:[NSNumber numberWithBool:_like] forKey:@"Like"];
    
    [self requestUrl:HOST(URL_POST_SetPostLike) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取推文点攒列表
-(void)postRequest_getPostLikeList:(NSString *)_str_postId cursor:(NSInteger)_cursor count:(int)_count  userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_postId forKey:@"PostId"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_cursor] forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    [self requestUrl:HOST(URL_POST_GetPostLikeList) params:dic_params headers:dic_headers userinfo:_dic_userinfo];

}

#pragma mark - 删除推文
-(void)postRequest_deletePost:(NSString *)_str_postId userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_postId forKey:@"PostId"];
    [self requestUrl:HOST(URL_POST_DeletePost) params:dic_params headers:dic_headers userinfo:_dic_userinfo];

}

#pragma mark - 获取Post列表
-(void)postRequest_getPostList:(NSString *)_str_filter keyword:(NSString *)_str_keyword cursor:(NSInteger)_cursor count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_filter forKey:@"Filter"];
    [dic_params setObjectSafty:_str_keyword forKey:@"Keywords"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_cursor] forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInt:_count] forKey:@"Count"];
    [self requestUrl:HOST(URL_POST_GetPostList) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 设置拉黑已关注我的用户
-(void)postRequest_setBlackList:(NSString *)_str_blacks setBlack:(BOOL)_isSetBlack userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_blacks forKey:@"Blacks"];
    [dic_params setObjectSafty:[NSNumber numberWithBool:_isSetBlack] forKey:@"SetBlack"];
    [self requestUrl:HOST(URL_POST_SetBlackList) params:dic_params headers:dic_headers userinfo:_dic_userinfo];

}

#pragma mark - 添加关注或取消关注
-(void)postRequest_setFollow:(NSString *)_str_follows
                    isFollow:(BOOL)_isFollow userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_follows forKey:@"Follows"];
    [dic_params setObjectSafty:[NSNumber numberWithBool:_isFollow] forKey:@"SetFollow"];
    [self requestUrl:HOST(URL_POST_SetFollow) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取关注我的用户列表(Who follow me)
-(void)postRequest_getFollowMeList:(NSInteger)_cursor count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_cursor] forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInt:_count] forKey:@"Count"];
    [self requestUrl:HOST(URL_POST_GetFollowMeList) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取我关注的用户列表(I follows who)
-(void)postRequest_getFollowList:(NSInteger)_cursor count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_cursor] forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInt:_count] forKey:@"Count"];
    [self requestUrl:HOST(URL_POST_GetFollowList) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取某条Post的评论列表
-(void)postRequest_getCommentList:(NSString *)_str_postId cursor:(NSInteger)_cursor count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_postId forKey:@"PostId"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_cursor] forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInt:_count] forKey:@"Count"];
    [self requestUrl:HOST(URL_POST_GetCommentList) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 对某条评论点攒或取消
-(void)postRequest_setCommentLike:(NSString *)_str_commentId
                             isLike:(BOOL)_isLike userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_commentId forKey:@"CommentId"];
    [dic_params setObjectSafty:[NSNumber numberWithBool:_isLike] forKey:@"Like"];
    [self requestUrl:HOST(URL_POST_SetCommentLike) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 对某条推文评论
-(void)postRequest_submitComment:(NSString *)_str_postId content:(NSString *)_str_content userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_postId forKey:@"PostId"];
    [dic_params setObjectSafty:_str_content forKey:@"Content"];
    [self requestUrl:HOST(URL_POST_SubmitComment) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 获取推文点赞列表
-(void)postRequest_getCommentLikeList:(NSString *)_str_commentId cursor:(NSInteger)_cursor count:(int )_count  userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_commentId forKey:@"CommentId"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_cursor] forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInt:_count] forKey:@"Count"];
    [self requestUrl:HOST(URL_POST_SubmitComment) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 举报某条评论
-(void)postRequest_accusePost:(NSString *)_str_postId content:(NSString *)_str_content userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_postId forKey:@"PostId"];
    [dic_params setObjectSafty:_str_content forKey:@"Content"];
    [self requestUrl:HOST(URL_POST_AccusePost) params:dic_params headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 删除对某个内容的评论，此评论必须是自己发布的
-(void)postRequest_deletePostComment:(NSString *)_str_commentId userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *_dic_singleParams = [NSMutableDictionary dictionary];
    [_dic_singleParams setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [_dic_singleParams setObjectSafty:_str_commentId forKey:@"CommentId"];
    [self requestUrl:HOST(URL_POST_DeletePostComment) params:_dic_singleParams headers:dic_headers userinfo:_dic_userinfo];
}

#pragma mark - 举报某条评论
-(void)postRequest_AccuseComment:(NSString *)_str_commentId content:(NSString *)_str_content userinfo:(NSMutableDictionary *)_dic_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *_dic_singleParams = [NSMutableDictionary dictionary];
    [_dic_singleParams setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [_dic_singleParams setObjectSafty:_str_commentId forKey:@"CommentId"];
    [_dic_singleParams setObjectSafty:_str_content forKey:@"Content"];
    [self requestUrl:HOST(URL_POST_AccuseComment) params:_dic_singleParams headers:dic_headers userinfo:_dic_userinfo];
}
@end

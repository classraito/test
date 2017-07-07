//
//  NetworkManager_Post.h
//  CSP
//
//  Created by Ryan Gong on 16/11/4.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NetworkManager.h"
/*获取主题，一般用于#*/
#define URL_POST_GetTopicList @"/Social/GetTopicList.ashx"
/*发送推文*/
#define URL_POST_Update_SubmitPost @"/Social/SubmitPost.ashx"
/*对某条推文点攒或取消*/
#define URL_POST_SetPostLike @"/Social/SetPostLike.ashx"
/*获取推文点攒列表*/
#define URL_POST_GetPostLikeList @"/Social/GetPostLikeList.ashx"
/*删除推文*/
#define URL_POST_DeletePost @"/Social/DeletePost.ashx"
/*获取Post列表*/
#define URL_POST_GetPostList @"/Social/GetPostList.ashx"
/*设置拉黑已关注我的用户*/
#define URL_POST_SetBlackList @"/Social/xxx.ashx"
/*添加关注或取消关注*/
#define URL_POST_SetFollow @"/Social/SetFollow.ashx"
/*获取关注我的用户列表(Who follow me)*/
#define URL_POST_GetFollowMeList @"/Social/xxx.ashx"
/*获取我关注的用户列表(I follows who)*/
#define URL_POST_GetFollowList @"/Social/xxx.ashx"
/*获取某条Post的评论列表*/
#define URL_POST_GetCommentList @"/Social/GetCommentList.ashx"
/*对某条评论点攒或取消*/
#define URL_POST_SetCommentLike @"/Social/xxx.ashx"
/*对某条推文评论*/
#define URL_POST_SubmitComment @"/Social/SubmitComment.ashx"
/*获取推文点攒列表*/
#define URL_POST_GetCommentLikeList @"/Social/xxx.ashx"
/*举报某条评论*/
#define URL_POST_AccusePost @"/Social/AccusePost.ashx"
/*删除对某个内容的评论，此评论必须是自己发布的*/
#define URL_POST_DeletePostComment @"/Social/DeletePostComment.ashx"
/*举报某条评论*/
#define URL_POST_AccuseComment @"/Social/AccuseComment.ashx"


@interface NetworkManager_Post : NetworkManager
{
    
}
#pragma mark - 获取主题，一般用于#
-(void)postRequest_GetTopicList:(NSString *)_str_keywords cursor:(NSInteger )_cursor count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 发送推文
-(void)postRequest_SubmitPost:(BOOL)_private images:(NSMutableArray *)_arr_images imageThumbnails:(NSMutableArray *)_arr_thumbnails video:(NSString *)_str_video videoThumbnail:(NSString *)_str_videoThumbnail content:(NSString *)_str_content
                     location:(NSString *)_str_location lat:(long)_lat lng:(long)_lng userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 对某条推文点攒或取消
-(void)postRequest_setPostLike:(NSString *)_str_postId like:(BOOL)_like userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 获取推文点攒列表
-(void)postRequest_getPostLikeList:(NSString *)_str_postId cursor:(NSInteger)_cursor count:(int)_count  userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 删除推文
-(void)postRequest_deletePost:(NSString *)_str_postId userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 获取Post列表
-(void)postRequest_getPostList:(NSString *)_str_filter keyword:(NSString *)_str_keyword cursor:(NSInteger)_cursor count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 设置拉黑已关注我的用户
-(void)postRequest_setBlackList:(NSString *)_str_blacks setBlack:(BOOL)_isSetBlack userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 添加关注或取消关注
-(void)postRequest_setFollow:(NSString *)_str_follows
                    isFollow:(BOOL)_isFollow userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 获取关注我的用户列表(Who follow me)
-(void)postRequest_getFollowMeList:(NSInteger)_cursor count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 获取我关注的用户列表(I follows who)
-(void)postRequest_getFollowList:(NSInteger)_cursor count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 获取某条Post的评论列表
-(void)postRequest_getCommentList:(NSString *)_str_postId cursor:(NSInteger)_cursor count:(int)_count userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 对某条评论点攒或取消
-(void)postRequest_setCommentLike:(NSString *)_str_commentId isLike:(BOOL)_isLike userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 对某条推文评论
-(void)postRequest_submitComment:(NSString *)_str_postId content:(NSString *)_str_content userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 获取推文点赞列表
-(void)postRequest_getCommentLikeList:(NSString *)_str_commentId cursor:(NSInteger)_cursor count:(int )_count  userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 举报某条评论
-(void)postRequest_accusePost:(NSString *)_str_postId content:(NSString *)_str_content userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 删除对某个内容的评论，此评论必须是自己发布的
-(void)postRequest_deletePostComment:(NSString *)_str_commentId userinfo:(NSMutableDictionary *)_dic_userinfo;
#pragma mark - 举报某条评论
-(void)postRequest_AccuseComment:(NSString *)_str_commentId content:(NSString *)_str_content userinfo:(NSMutableDictionary *)_dic_userinfo;


@end

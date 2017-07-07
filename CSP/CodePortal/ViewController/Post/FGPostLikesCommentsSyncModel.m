//
//  FGPostLikesCommentsSyncModel.m
//  CSP
//
//  Created by Ryan Gong on 17/2/8.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGPostLikesCommentsSyncModel.h"
#import "Global.h"

static FGPostLikesCommentsSyncModel *postSyncModel;

@implementation FGPostLikesCommentsSyncModel
@synthesize arr_syncsDatas;
#pragma mark - 生命周期
+(FGPostLikesCommentsSyncModel *)sharedModel
{
    @synchronized(self)     {
        if(!postSyncModel)
        {
            postSyncModel=[[FGPostLikesCommentsSyncModel alloc]init];
            
            
            return postSyncModel;
        }
    }
    return postSyncModel;
}

-(id)init
{
    if(self = [super init])
    {
        arr_syncsDatas = [[NSMutableArray alloc] initWithCapacity:1];
        [commond setUserDefaults:arr_syncsDatas forKey:KEY_POST_SYNCSDATA];
    }
    return self;
}

+(id)alloc
{
    @synchronized(self)     {
        NSAssert(postSyncModel == nil, @"企圖重复創建一個singleton模式下的FGPostLikesCommentsSyncModel");
        return [super alloc];
    }
    return nil;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [arr_syncsDatas removeAllObjects];
    [commond setUserDefaults:arr_syncsDatas forKey:KEY_POST_SYNCSDATA];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
}

+(void)clearModel
{
    if(!postSyncModel)
        return;
    
    
    
    postSyncModel = nil;
}

#pragma mark - 设置全局数据
-(void)setLikes:(int)_likesCount byPostId:(NSString *)_str_postId
{
    if(!_str_postId)
        return;
    if([_str_postId isEmptyStr])
        return;
    
    NSMutableDictionary *_dic_infoNeedUpdate = [self getPostSyncDatasByPostID:_str_postId];
    if(_dic_infoNeedUpdate)
        [_dic_infoNeedUpdate setObject:[NSNumber numberWithInt:_likesCount] forKey:KEY_LIKES_COUNT];
    else
    {
        _dic_infoNeedUpdate = [NSMutableDictionary dictionaryWithCapacity:1];
        [_dic_infoNeedUpdate setObject:[NSNumber numberWithInt:_likesCount] forKey:KEY_LIKES_COUNT];
        [_dic_infoNeedUpdate setObject:VALUE_NODATA forKey:KEY_COMMENTS_COUNT];
        [_dic_infoNeedUpdate setObject:VALUE_NODATA forKey:KEY_ISLIKE];
        [_dic_infoNeedUpdate setObject:_str_postId forKey:KEY_SYNC_POSTID];
        [arr_syncsDatas addObject:_dic_infoNeedUpdate];
    }
    [self saveDatas];
    
}

-(void)setCommentsCount:(int)_commentsCount byPostId:(NSString *)_str_postId
{
    if(!_str_postId)
        return;
    if([_str_postId isEmptyStr])
        return;
    
    NSMutableDictionary *_dic_infoNeedUpdate = [self getPostSyncDatasByPostID:_str_postId];
    if(_dic_infoNeedUpdate)
        [_dic_infoNeedUpdate setObject:[NSNumber numberWithInt:_commentsCount] forKey:KEY_COMMENTS_COUNT];
    else
    {
        _dic_infoNeedUpdate = [NSMutableDictionary dictionaryWithCapacity:1];
        [_dic_infoNeedUpdate setObject:VALUE_NODATA forKey:KEY_LIKES_COUNT];
        [_dic_infoNeedUpdate setObject:[NSNumber numberWithInt:_commentsCount] forKey:KEY_COMMENTS_COUNT];
        [_dic_infoNeedUpdate setObject:VALUE_NODATA forKey:KEY_ISLIKE];
        [_dic_infoNeedUpdate setObject:_str_postId forKey:KEY_SYNC_POSTID];
        [arr_syncsDatas addObject:_dic_infoNeedUpdate];
    }
    [self saveDatas];
}

-(void)setIsLike:(BOOL)_isLike byPostId:(NSString *)_str_postId
{
    if(!_str_postId)
        return;
    if([_str_postId isEmptyStr])
        return;
    
    NSMutableDictionary *_dic_infoNeedUpdate = [self getPostSyncDatasByPostID:_str_postId];
    if(_dic_infoNeedUpdate)
        [_dic_infoNeedUpdate setObject:[NSNumber numberWithInt:_isLike] forKey:KEY_ISLIKE];
    else
    {
        _dic_infoNeedUpdate = [NSMutableDictionary dictionaryWithCapacity:1];
        [_dic_infoNeedUpdate setObject:VALUE_NODATA forKey:KEY_LIKES_COUNT];
        [_dic_infoNeedUpdate setObject:VALUE_NODATA forKey:KEY_COMMENTS_COUNT];
        [_dic_infoNeedUpdate setObject:[NSNumber numberWithInt:_isLike] forKey:KEY_ISLIKE];
        [_dic_infoNeedUpdate setObject:_str_postId forKey:KEY_SYNC_POSTID];
        [arr_syncsDatas addObject:_dic_infoNeedUpdate];
    }
    [self saveDatas];
}

-(void)saveDatas
{
    [commond setUserDefaults:arr_syncsDatas forKey:KEY_POST_SYNCSDATA];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATE_POST_SYNC object:nil];
}

/*根据post id 获得最新的数据*/
-(NSMutableDictionary *)getPostSyncDatasByPostID:(NSString *)_str_postId
{
    if(!_str_postId)
        return nil;
    if([_str_postId isEmptyStr])
        return nil;
    
    for(NSMutableDictionary *_dic_singleData in arr_syncsDatas)
    {
        NSString *__str_postId = [_dic_singleData objectForKey:KEY_SYNC_POSTID];
        if([__str_postId isEqualToString:_str_postId])
        {
            return _dic_singleData;
        }
    }
    return nil;
}
@end

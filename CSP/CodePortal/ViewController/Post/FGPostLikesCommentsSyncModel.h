//
//  FGPostLikesCommentsSyncModel.h
//  CSP
//
//  Created by Ryan Gong on 17/2/8.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#define KEY_POST_SYNCSDATA @"KEY_POST_SYNCSDATA"

#define KEY_LIKES_COUNT @"KEY_LIKESCOUNT"
#define KEY_COMMENTS_COUNT @"KEY_COMMENTS_COUNT"
#define KEY_ISLIKE @"KEY_ISLIKE"
#define KEY_SYNC_POSTID @"KEY_SYNC_POSTID"

#define VALUE_NODATA @"VALUE_NODATA"

#define NOTIFICATION_UPDATE_POST_SYNC @"NOTIFICATION_UPDATE_POST_SYNC"
@interface FGPostLikesCommentsSyncModel : NSObject
{
    
}
@property(nonatomic,strong)NSMutableArray *arr_syncsDatas;
+(FGPostLikesCommentsSyncModel *)sharedModel;
+(void)clearModel;

/*根据post id 获得最新的数据*/
-(NSMutableDictionary *)getPostSyncDatasByPostID:(NSString *)_str_postId;

-(void)setLikes:(int)_likesCount byPostId:(NSString *)_str_postId;
-(void)setCommentsCount:(int)_commentsCount byPostId:(NSString *)_str_postId;
-(void)setIsLike:(BOOL)_isLike byPostId:(NSString *)_str_postId;
@end

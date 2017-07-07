//
//  FGPostsFollowingCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "FGSNSManager.h"
#import "FGPostsFollowingCellView.h"
#import "Global.h"
#import "NetworkManager_Post.h"
@interface FGPostsFollowingCellView () {
}
@property (nonatomic, strong) NSDictionary *dic_dataInfo;
@end

@implementation FGPostsFollowingCellView
@synthesize dic_dataInfo;
@synthesize iv_like;
@synthesize lb_likes;
@synthesize iv_comments;
@synthesize lb_comments;
@synthesize iv_shares;
@synthesize lb_shares;
@synthesize iv_dots;
@synthesize btn_likes;
@synthesize btn_shares;
@synthesize btn_comments;
@synthesize btn_more;
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView: iv_like];
    [commond useDefaultRatioToScaleView: lb_likes];
    [commond useDefaultRatioToScaleView: iv_comments];
    [commond useDefaultRatioToScaleView: lb_comments];
    [commond useDefaultRatioToScaleView: iv_shares];
    [commond useDefaultRatioToScaleView: lb_shares];
    [commond useDefaultRatioToScaleView: iv_dots];
    [commond useDefaultRatioToScaleView: btn_likes];
    [commond useDefaultRatioToScaleView: btn_shares];
    [commond useDefaultRatioToScaleView: btn_comments];
    [commond useDefaultRatioToScaleView: btn_more];
    
    lb_likes.font = font(FONT_TEXT_REGULAR, 15);
    lb_comments.font = font(FONT_TEXT_REGULAR, 15);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncPostLikesCommentsInfo) name:NOTIFICATION_UPDATE_POST_SYNC object:nil];
}

/*一旦别处的cell有更新isLike LikesCount CommentCount 这里会收到通知 如果postID相同 那么更新*/
-(void)syncPostLikesCommentsInfo
{
    NSMutableArray *arr_datas = (NSMutableArray *)[commond getUserDefaults:KEY_POST_SYNCSDATA];
    
    
    
    
    NSMutableDictionary *_dic_postInfo = [[FGPostLikesCommentsSyncModel sharedModel] getPostSyncDatasByPostID:self.str_postId];
    
    if(!_dic_postInfo)
        return;
    
    NSLog(@"self.str_postId = %@ arr_datas = %@",self.str_postId,arr_datas);
    
    id obj_isLike = [_dic_postInfo objectForKey:KEY_ISLIKE];
    id obj_likes = [_dic_postInfo objectForKey:KEY_LIKES_COUNT];
    id obj_comments = [_dic_postInfo objectForKey:KEY_COMMENTS_COUNT];
    
    if(obj_isLike && ![obj_isLike isEqual:VALUE_NODATA])
        iv_like.highlighted = [[_dic_postInfo objectForKey:KEY_ISLIKE] boolValue];
    
    if(obj_likes && ![obj_likes isEqual:VALUE_NODATA])
        lb_likes.text = [NSString stringWithFormat:@"(%@)",[_dic_postInfo objectForKey:KEY_LIKES_COUNT]];
    
    if(obj_comments && ![obj_comments isEqual:VALUE_NODATA])
        lb_comments.text = [NSString stringWithFormat:@"(%@)",[_dic_postInfo objectForKey:KEY_COMMENTS_COUNT]];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat offsetY = self.frame.size.height - btn_likes.frame.size.height / 2;
    [self setCenterByOffsetY:offsetY inView:iv_like];
    [self setCenterByOffsetY:offsetY inView:lb_likes];
    [self setCenterByOffsetY:offsetY inView:iv_comments];
    [self setCenterByOffsetY:offsetY inView:lb_comments];
    [self setCenterByOffsetY:offsetY inView:iv_shares];
    [self setCenterByOffsetY:offsetY inView:lb_shares];
    [self setCenterByOffsetY:offsetY inView:iv_dots];
    [self setCenterByOffsetY:offsetY inView:btn_likes];
    [self setCenterByOffsetY:offsetY inView:btn_shares];
    [self setCenterByOffsetY:offsetY inView:btn_comments];
    [self setCenterByOffsetY:offsetY inView:btn_more];
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
  if (_dataInfo == nil)
    return;
    dic_dataInfo = [NSDictionary dictionaryWithDictionary:_dataInfo];
  
    [super updateCellViewWithInfo:_dataInfo];
    iv_like.highlighted = [[_dataInfo objectForKey:@"IsLike"] boolValue];
    self.str_postId = [NSString stringWithFormat:@"%@",[_dataInfo objectForKey:@"PostId"]];
    lb_likes.text = [NSString stringWithFormat:@"(%@)",[_dataInfo objectForKey:@"Like"]];
    lb_comments.text = [NSString stringWithFormat:@"(%@)",[_dataInfo objectForKey:@"Comment"]];
    
    [self syncPostLikesCommentsInfo];//从本地更新 isLike LikesCount CommentCount
}

-(void)setCenterByOffsetY:(CGFloat)_offsetY inView:(UIView *)_view
{
    _view.center  = CGPointMake(_view.center.x, _offsetY);
}

-(IBAction)buttonAction_like:(id)_sender
{
    iv_like.highlighted = iv_like.highlighted ? NO : YES;
    if(iv_like.highlighted)
    {
        [UIView animateWithDuration:.2 animations:^{
            iv_like.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            if(finished)
            {
                [UIView animateWithDuration:.2 animations:^{
                    iv_like.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }
        }];
    }
    
    NSString *_str_likes = [lb_likes.text stringByReplacingOccurrencesOfString:@"(" withString:@""];
    _str_likes = [_str_likes stringByReplacingOccurrencesOfString:@")" withString:@""];//去掉两遍的括号
    
    int likes = [_str_likes intValue];
    likes = iv_like.highlighted ? likes + 1 : likes - 1;
    likes = likes <= 0 ? 0 : likes;
    lb_likes.text = [NSString stringWithFormat:@"(%d)",likes];
    NSMutableDictionary *_dic_userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_userinfo setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
    [_dic_userinfo setObject:self.str_postId forKey:@"SetLike_PostId"];
    [_dic_userinfo setObject:@(likes) forKey:@"Like"];
    [_dic_userinfo setObject:[NSNumber numberWithBool:iv_like.highlighted] forKey:@"IsLike"];
    [[NetworkManager_Post sharedManager] postRequest_setPostLike:self.str_postId like:iv_like.highlighted userinfo:_dic_userinfo];
}

-(IBAction)buttonAction_share:(id)_sender;
{
  // FIXME: share
//  [[FGSNSManager shareInstance] actionToShareWithTitle:@"" text:@"" url:@"" images:@[]];
  
  //可能是图片可能是视频链接
  NSString *_str_video = dic_dataInfo[@"Video"];
  if ([_str_video isEmptyStr]) {
    //图片拿一张图片的链接
    NSArray *_arr_images = dic_dataInfo[@"Images"];
    NSArray *_arr_imageThumbnails = dic_dataInfo[@"ImageThumbnails"];

    //视频链接
    [[FGSNSManager shareInstance] actionToSharePostOnView:self title:@"" text:dic_dataInfo[@"Content"] url:@"" image:_arr_imageThumbnails link:_arr_images[0]];
  } else {
    //视频链接
    [[FGSNSManager shareInstance] actionToSharePostOnView:self title:@"" text:dic_dataInfo[@"Content"] url:@"" image:nil link:_str_video];
  }
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    dic_dataInfo = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UPDATE_POST_SYNC object:nil];
}

@end

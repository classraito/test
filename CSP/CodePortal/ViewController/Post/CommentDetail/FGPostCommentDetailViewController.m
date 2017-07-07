//
//  FGPostCommentDetailViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostCommentDetailViewController.h"
#import "Global.h"
#import "NetworkManager_Post.h"
@interface FGPostCommentDetailViewController ()

@end

@implementation FGPostCommentDetailViewController
@synthesize view_comment;
@synthesize dic_postInfo;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil postInfo:(NSMutableDictionary *)_dic_postInfo
{
    if(self  = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        dic_postInfo = _dic_postInfo;
    }
    return self;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view_topPanel.str_title = multiLanguage(@"COMMENT");
    // Do any additional setup after loading the view from its nib.
    [self internalInitalCommentDetail];
    [self hideBottomPanelWithAnimtaion:NO];
}

-(void)manullyFixSize
{
    [super manullyFixSize];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
    
    NSString *_str_postid = [dic_postInfo objectForKey:@"PostId"];
    [view_comment setupPostId:_str_postid];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [view_comment clearMemory];
    [view_comment.tb setRefreshFooter:nil];
    view_comment.tb.mj_header = nil;
    view_comment = nil;
    dic_postInfo = nil;;
}

#pragma mark - 初始化相关
-(void)internalInitalCommentDetail
{
    if(view_comment)
        return;
    
    view_comment = (FGPostCommentDetailView *)[[[NSBundle mainBundle] loadNibNamed:@"FGPostCommentDetailView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_comment];
    CGRect _frame = view_comment.frame;
    _frame.origin.y = self.view_topPanel.frame.size.height;
    view_comment.frame = _frame;
    [self.view addSubview:view_comment];
    
}

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    
    if ([HOST(URL_POST_GetCommentList) isEqualToString:_str_url]) {
        if([[_dic_requestInfo allKeys] containsObject:@"Post_GetMoreComment"])
        {
            [view_comment loadMoreComments];
        }
        else
        {
            [view_comment bindDataToUI:dic_postInfo];
        }
    
    }
    
    if ([HOST(URL_POST_SetPostLike) isEqualToString:_str_url])
    {
        NSString *_str_postId = [_dic_requestInfo objectForKey:@"SetLike_PostId"];
        BOOL isLike = [[_dic_requestInfo objectForKey:@"IsLike"] boolValue];
        int likes = [[_dic_requestInfo objectForKey:@"Like"] intValue];
        [view_comment updateLikeStatusByPostId:_str_postId isLike:isLike likes:likes];
    }
    
    if([HOST(URL_POST_SubmitComment) isEqualToString:_str_url])
    {
        NSString *_str_postid = [dic_postInfo objectForKey:@"PostId"];
        [view_comment.tb.pullToRefreshView startAnimating];
        NetworkRequestInfo *_dic_userinfo = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self repelKEY:nil];
        [[NetworkManager_Post sharedManager] postRequest_getCommentList:_str_postid cursor:0 count:10 userinfo:_dic_userinfo];
        [NetworkEventTrack track:KEY_TRACK_EVENTID_SUBMITCOMMENT attrs:nil];//追踪 发布评论
    }
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork: _notification];
}
@end

//
//  FGPostViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/9/13.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostViewController.h"
#import "Global.h"
#import "NetworkManager_Post.h"
@interface FGPostViewController ()
{
    
}
@end

@implementation FGPostViewController
@synthesize view_allPosts;
@synthesize view_following;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"Post");
    SAFE_RemoveSupreView(self.view_topPanel.iv_left);
    SAFE_RemoveSupreView(self.view_topPanel.btn_left);
    self.view_topPanel.iv_right.image = [UIImage imageNamed:@"addfriends.png"];
  [self.view_topPanel.btn_right addTarget:self action:@selector(buttonAction_gotoAddFrideds) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSection:) name:KEY_HandleSection object:nil];
    
    [self internalInitalAllPostsCollectionView];
   }

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(view_allPosts)
    {
        [view_allPosts beginRefresh];
    }
    else if(view_following)
    {
        [view_following beginRefresh];
    }

}

-(void)manullyFixSize
{
    [super manullyFixSize];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    if(view_following)
    {
        [view_following.tb setRefreshFooter:nil];
        view_following.tb.mj_header = nil;
    }
    if(view_allPosts)
    {
        [view_allPosts.cv_allPosts setRefreshFooter:nil];
        view_allPosts.cv_allPosts.mj_header = nil;
    }
    
    view_following = nil;
    view_allPosts = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KEY_HandleSection object:nil];
}

#pragma mark - 初始化
-(void)internalInitalAllPostsCollectionView
{
    if(!view_allPosts)
    {
        view_allPosts = (FGPostAllPostsCollectView *)[[[NSBundle mainBundle] loadNibNamed:@"FGPostAllPostsCollectView" owner:nil options:nil] objectAtIndex:0];
        [commond useDefaultRatioToScaleView:view_allPosts];
        CGRect _frame = view_allPosts.frame;
        _frame.origin.y = self.view_topPanel.frame.size.height;
        view_allPosts.frame = _frame;
        [self.view addSubview:view_allPosts];
    }
}

-(void)internalInitalFollowingView
{
    if(!view_following)
    {
        view_following = (FGPostFollwingPostsView *)[[[NSBundle mainBundle] loadNibNamed:@"FGPostFollwingPostsView" owner:nil options:nil] objectAtIndex:0];
        [commond useDefaultRatioToScaleView:view_following];
        CGRect _frame = view_following.frame;
        _frame.origin.y = self.view_topPanel.frame.size.height;
        view_following.frame = _frame;
        [self.view addSubview:view_following];
    }
}

-(void)handleSection:(NSNotification *)_notification
{
    NSString *str_type = _notification.object;
    if([@"allPosts" isEqualToString:str_type])
    {
        [self internalInitalAllPostsCollectionView];
        [view_allPosts beginRefresh];
        if(view_following)
        {
            [view_following.tb setRefreshFooter:nil];
            view_following.tb.mj_header = nil;
            SAFE_RemoveSupreView(view_following);
            view_following = nil;
        }
        
    }
    else if([@"following" isEqualToString:str_type])
    {
        [self internalInitalFollowingView];
        [view_following beginRefresh];
        if(view_allPosts)
        {
            [view_allPosts.cv_allPosts setRefreshFooter:nil];
            view_allPosts.cv_allPosts.mj_header = nil;
            SAFE_RemoveSupreView(view_allPosts);
            view_allPosts = nil;
        }
        
    }
}

#pragma mark - 按钮事件
- (void)buttonAction_gotoAddFrideds {
  FGControllerManager *manager = [FGControllerManager sharedManager];
  [manager pushControllerByName:@"FGAddFriendViewController" inNavigation:nav_current];
}

#pragma mark - 从父类继承的
-(void)buttonAction_right:(id)_sender
{
    
}

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSLog(@"_dic_requestInfo = %@",_dic_requestInfo);
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    NSString *_str_alias                  = [_dic_requestInfo objectForKey:KEY_NOTIFY_ALIAS];
   
    if([HOST(URL_POST_GetPostList) isEqualToString:_str_url])
    {
        if ([@"AllPost" isEqualToString:_str_alias]) {
            
            if(view_allPosts)
            {
                [view_allPosts bindDataToUI];//加载最新的
            }
        }
        else if ([@"AllPost_loadMore" isEqualToString:_str_alias]) {
            if(view_allPosts)
            {
                [view_allPosts loadMorePosts];
            }
            
        }
        else if ([@"GetPost" isEqualToString:_str_alias]) {
            
            if(view_following)
            {
                [view_following bindDataToUI];//加载最新的
            }
        }
        else if ([@"GetPost_loadMore" isEqualToString:_str_alias]) {
            if(view_following)
            {
                [view_following loadMoreFollowing];
            }
        }
    }
    
    if ([HOST(URL_POST_SetPostLike) isEqualToString:_str_url])
    {
        NSString *_str_postId = [_dic_requestInfo objectForKey:@"SetLike_PostId"];
        BOOL isLike = [[_dic_requestInfo objectForKey:@"IsLike"] boolValue];
        int likes = [[_dic_requestInfo objectForKey:@"Like"] intValue];
        [view_following updateLikeStatusByPostId:_str_postId isLike:isLike likes:likes];
    }
    
    if([HOST(URL_POST_DeletePost) isEqualToString:_str_url])
    {
        if(view_following)
        {
            [view_following afterDeletePost];
        }
    }
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork: _notification];
}
@end

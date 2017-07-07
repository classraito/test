//
//  FGTopicViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/12/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTopicViewController.h"
#import "Global.h"
#import "NetworkManager_Post.h"
@interface FGTopicViewController ()
{
    NSString *str_topicId;
    NSString *str_topicName;
}
@end

@implementation FGTopicViewController
@synthesize view_topic;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil topicId:(NSString *)_str_topicId topicName:(NSString *)_str_topicName
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        str_topicId = [_str_topicId mutableCopy];
        str_topicName = [_str_topicName mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"TOPICS");
    SAFE_RemoveSupreView(self.view_topPanel.iv_right);
    SAFE_RemoveSupreView(self.view_topPanel.btn_right);
    
    [self internalInitalTopicView];
    [self hideBottomPanelWithAnimtaion:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
}

-(void)manullyFixSize
{
    [super manullyFixSize];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    view_topic = nil;
    str_topicId = nil;
    str_topicName = nil;
}

#pragma mark - 初始化
-(void)internalInitalTopicView
{
    if(!view_topic)
    {
        view_topic = (FGTopicView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTopicView" owner:nil options:nil] objectAtIndex:0];
        [commond useDefaultRatioToScaleView:view_topic];
        CGRect _frame = view_topic.frame;
        _frame.origin.y = self.view_topPanel.frame.size.height;
        view_topic.frame = _frame;
        view_topic.str_topicId = str_topicId;
        view_topic.str_topicName = str_topicName;
        [self.view addSubview:view_topic];
    }
    [view_topic beginRefresh];
}

#pragma mark - 从父类继承的

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    
    if ([HOST(URL_POST_GetPostList) isEqualToString:_str_url])
    {
        if([[_dic_requestInfo allKeys] containsObject:@"Filter"])
        {
            NSString *_str_filter  = [_dic_requestInfo objectForKey:@"Filter"];
            if([_str_filter containsString:@"#"])
            {
                if(view_topic)
                {
                    if([[_dic_requestInfo allKeys] containsObject:@"GetPost_loadMore"])
                    {
                        [view_topic loadMoreFollowing];
                    }
                    else
                    {
                        [view_topic bindDataToUI];
                    }
                }
            }
        }//不筛选Post
    }
    
    if([HOST(URL_POST_DeletePost) isEqualToString:_str_url])
    {
        if(view_topic)
        {
            [view_topic afterDeletePost];
        }
    }
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork: _notification];
}
@end

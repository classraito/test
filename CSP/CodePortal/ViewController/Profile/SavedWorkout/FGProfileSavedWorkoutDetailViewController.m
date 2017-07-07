//
//  FGProfileSavedWorkoutDetailViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGProfileSavedWorkoutDetailViewController.h"
#import "Global.h"
@interface FGProfileSavedWorkoutDetailViewController ()
{
    
}
@end

@implementation FGProfileSavedWorkoutDetailViewController
@synthesize view_savedWorkoutDetail;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)dealloc
{
    view_savedWorkoutDetail = nil;
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

#pragma mark - 覆盖父类的方法
-(void)internalInitalTrainingDetailView
{
    if(view_savedWorkoutDetail)
        return;
    
    view_savedWorkoutDetail = (FGProfilleSavedWorkoutDetailView *)[[[NSBundle mainBundle] loadNibNamed:@"FGProfilleSavedWorkoutDetailView" owner:nil options:nil] objectAtIndex:0];
    view_savedWorkoutDetail.str_workoutId = self.workoutID;
    [commond useDefaultRatioToScaleView:view_savedWorkoutDetail];
    CGRect _frame = view_savedWorkoutDetail.frame;
    _frame.origin.y = self.view_topPanel.frame.size.height;
    view_savedWorkoutDetail.frame = _frame;
    [self.view addSubview:view_savedWorkoutDetail];
    
    [view_savedWorkoutDetail bindDataToUI];
    
    
}

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
   
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    [commond removeLoading];
    // 验证码请求
    if ([HOST(URL_TRAINING_GetTrainDetailPage) isEqualToString:_str_url]) {
        if(view_savedWorkoutDetail)
            [view_savedWorkoutDetail bindDataToUI];
    }
    if ([HOST(URL_TRAINING_GetTrainCommentList) isEqualToString:_str_url])
    {
        if(view_savedWorkoutDetail)
        {
            if([[_dic_requestInfo allKeys] containsObject:@"RefreshComment"])
            {
                [view_savedWorkoutDetail reloadComments];
            }
            else
            {
                [view_savedWorkoutDetail loadMoreComments];
            }
        }
    }
    if([HOST(URL_TRAINING_SubmitTrainComment) isEqualToString:_str_url])
    {
        if(view_savedWorkoutDetail)
            [view_savedWorkoutDetail afterSubmitComment];
        
        [NetworkEventTrack track:KEY_TRACK_EVENTID_SUBMITCOMMENT attrs:nil]; //追踪 发布评论
    }
    if([HOST(URL_TRAINING_SetTrainLike) isEqualToString:_str_url])
    {
        [[NetworkManager_Training sharedManager] postRequest_GetTrainDetail:self.workoutID userinfo:nil];
        
    }
    
    if([HOST(URL_TRAINING_GetTrainLikeList) isEqualToString:_str_url])
    {
        if(view_savedWorkoutDetail)
            [view_savedWorkoutDetail afterUpdateTranLikes];
        
    }
    if([HOST(URL_TRAINING_GetTrainDetail) isEqualToString:_str_url])
    {
        if(view_savedWorkoutDetail)
        {
            [view_savedWorkoutDetail afterUpdateTranDetail];
        }
    }

    
}

@end

//
//  FGTrainingDetailViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "FGSNSManager.h"
#import "FGTrainingDetailViewController.h"
#import "Global.h"
@interface FGTrainingDetailViewController ()
{
    
}

@end

@implementation FGTrainingDetailViewController
@synthesize view_trainingDetail;
@synthesize workoutID;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil workoutID:(id)_workoutID
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        workoutID = _workoutID;
      
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"WORKOUTS");
    self.view_topPanel.iv_right.image = [UIImage imageNamed:@"share_black.png"];
    
    [self internalInitalTrainingDetailView];
    [self hideBottomPanelWithAnimtaion:NO];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setWhiteBGStyle];
    if(view_trainingDetail)
    {
        [view_trainingDetail refreshDownloadButtonStatus];
        [view_trainingDetail.tb triggerRecoveryAnimationIfNeeded];
    }
    
}

-(void)manullyFixSize
{
    [super manullyFixSize];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    workoutID = nil;
    FGVideoModel *model_video = [FGVideoModel sharedModel];
    [model_video cancelDownloading];
    [FGVideoModel clearVideoModel];
    [view_trainingDetail.tb setRefreshFooter:nil];
    [view_trainingDetail.tb setPullToRefreshWindowsStyleView:nil];
    [view_trainingDetail clearMemory];
    view_trainingDetail = nil;
    
}

#pragma mark - 初始化FGTrainingDetailView
-(void)internalInitalTrainingDetailView
{
    if(view_trainingDetail)
        return;
    
    view_trainingDetail = (FGTrainingDetailView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingDetailView" owner:nil options:nil] objectAtIndex:0];
    view_trainingDetail.str_workoutId = workoutID;
    [commond useDefaultRatioToScaleView:view_trainingDetail];
    CGRect _frame = view_trainingDetail.frame;
    _frame.origin.y = self.view_topPanel.frame.size.height;
    view_trainingDetail.frame = _frame;
    [self.view addSubview:view_trainingDetail];
    
    [view_trainingDetail postRequest];
}


#pragma mark - 从父类继承的
-(void)buttonAction_right:(id)_sender
{
  // FIXME: share
//  [[FGSNSManager shareInstance] actionToShareWithTitle:@"" text:@"" url:@"" images:@[]];
  [[FGSNSManager shareInstance] actionToShareTrainingOnView:self.view
                                                      title:@""
                                                       text:[NSString stringWithFormat:@"%@;%@;%@",                         share_training_content1,                                     share_training_content2,share_training_link]
                                                        url:share_training_link];
  
  
  
}



-(id)giveMeResponseContentByResponseName:(NSString *)_str_responseName
{
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_TRAINING_GetTrainDetailPage)];
    NSMutableArray *_arr_datas = [_dic_result objectForKey:@"Responses"];
    for(NSMutableDictionary *_dic_data in _arr_datas)
    {
        NSString *str_responseName = [_dic_data objectForKey:@"ResponseName"];
        if([_str_responseName isEqualToString:str_responseName])
        {
            id _obj_responseContent = [_dic_data objectForKey:@"ResponseContent"];
            return _obj_responseContent;
        }
    }
    return nil;
}

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    [commond removeLoading];
    // 验证码请求
    if ([HOST(URL_TRAINING_GetTrainDetailPage) isEqualToString:_str_url]) {
      if(view_trainingDetail) {
//        NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_TRAINING_GetTrainDetailPage)];
//        NSMutableArray *_arr_datas       = [_dic_result objectForKey:@"Responses"];
//        NSDictionary *_dic_trainingDetailInfo = nil;
//        for (NSMutableDictionary *_dic_data in _arr_datas) {
//          NSString *str_responseName = [_dic_data objectForKey:@"ResponseName"];
//          if ([@"GetTrainDetail" isEqualToString:str_responseName]) {
//            id _obj_responseContent = [_dic_data objectForKey:@"ResponseContent"];
//            _dic_trainingDetailInfo =  _obj_responseContent;
//            break;
//          }
//        }
//        NSLog(@"_dic_trainingDetailInfo==%@",_dic_trainingDetailInfo);
        
        [view_trainingDetail bindDataToUI];
      }
    }
    if ([HOST(URL_TRAINING_GetTrainCommentList) isEqualToString:_str_url])
    {
        if(view_trainingDetail)
        {
            if([[_dic_requestInfo allKeys] containsObject:@"RefreshComment"])
            {
                [view_trainingDetail reloadComments];
            }
            else
            {
               [view_trainingDetail loadMoreComments];
            }
        }
    }
    if([HOST(URL_TRAINING_SubmitTrainComment) isEqualToString:_str_url])
    {
        if(view_trainingDetail)
            [view_trainingDetail afterSubmitComment];
        
        [NetworkEventTrack track:KEY_TRACK_EVENTID_SUBMITCOMMENT attrs:nil]; //追踪 发布评论
    }
    if([HOST(URL_TRAINING_SetTrainLike) isEqualToString:_str_url])
    {
        [[NetworkManager_Training sharedManager] postRequest_GetTrainDetail:workoutID userinfo:nil];
            
    }
    
    if([HOST(URL_TRAINING_GetTrainLikeList) isEqualToString:_str_url])
    {
        if(view_trainingDetail)
            [view_trainingDetail afterUpdateTranLikes];
        
    }
    if([HOST(URL_TRAINING_GetTrainDetail) isEqualToString:_str_url])
    {
        if(view_trainingDetail)
        {
            [view_trainingDetail afterUpdateTranDetail];
        }
    }
   
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
}
@end

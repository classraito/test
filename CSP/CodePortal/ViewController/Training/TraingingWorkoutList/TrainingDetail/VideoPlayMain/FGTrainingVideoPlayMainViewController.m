//
//  FGTrainingVideoPlayMainViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingVideoPlayMainViewController.h"
#import "Global.h"

@interface FGTrainingVideoPlayMainViewController ()
{
    FGVideoModel *model;
    NSMutableArray *arr_videoRestInfo;
    BOOL isWarmUpVideo;
    BOOL isCoolDownVideo;
}
@end

@implementation FGTrainingVideoPlayMainViewController
@synthesize str_workoutID;
@synthesize str_userCalories;
@synthesize view_playVideoQueue;
@synthesize view_training_getReady;
@synthesize view_training_watchVideo;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil workoutID:(id)_workoutID
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        str_workoutID = _workoutID ;
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil workoutID:(id)_workoutID userCalories:(NSString *)_str_userCalories
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        str_workoutID = _workoutID ;
        str_userCalories = [NSString stringWithFormat:@"%@",_str_userCalories];
    }
    return self;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.hidden = YES;
    arr_videoRestInfo = [[NSMutableArray alloc] initWithCapacity:1];
    [self hideBottomPanelWithAnimtaion:NO];
    [self internalInitalPlayVideoQueueView];
    [self internalInital_warmupWatchVideoByDuration:5];
    [view_training_watchVideo.btn_watchVideo addTarget:self action:@selector(buttonAction_training_watchVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self internalInitalRestVideoInfos];
    model = [FGVideoModel sharedModel];
    model.delegate_playVideoQueue = self;
}

-(void)manullyFixSize
{
    [super manullyFixSize];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    view_playVideoQueue = nil;
    view_training_watchVideo = nil;
    view_training_getReady = nil;
    model.delegate_playVideoQueue = nil;
    model = nil;
    arr_videoRestInfo = nil;
    str_workoutID = nil;
    str_userCalories = nil;
}

#pragma mark - 初始化
-(void)internalInitalRestVideoInfos
{
    
    NSMutableDictionary *_dic_info =  [self giveMeResponseContentByResponseName:@"GetTrainingStep"];
    NSMutableArray *_arr_stepByStep = [_dic_info objectForKey:@"StepVideos"];
  
    NSString *_str_lastVideoId;
    for(NSMutableDictionary *_dic_singleData in _arr_stepByStep)
    {
        NSString *_str_url = [_dic_singleData objectForKey:@"VideoUrl"];
        
        
        if([_str_url isEmptyStr])
        {
            NSMutableDictionary *_dic_singleRestInfo = [NSMutableDictionary dictionaryWithCapacity:1];
            [_dic_singleRestInfo setObject:_str_lastVideoId forKey:@"RestAfterVideoId"];
            [_dic_singleRestInfo setObject:[_dic_singleData objectForKey:@"Duration"] forKey:@"Duration"];
            [_dic_singleRestInfo setObject:[_dic_singleData objectForKey:@"VideoName"] forKey:@"VideoName"];
            [arr_videoRestInfo addObject:_dic_singleRestInfo];
        }
        else
        {
            _str_lastVideoId = [_dic_singleData objectForKey:@"VideoId"];
        }
    }//创建一个休息的模型， 模型中 RestAfterVideoId 标示了 这个reset是在哪个videoId后
    NSLog(@"arr_videoRestInfo = %@",arr_videoRestInfo);
    
}

-(void)internalInitalPlayVideoQueueView
{
    if(view_playVideoQueue)
        return;
    
    view_playVideoQueue = (FGTrainingVideoPlayMainView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingVideoPlayMainView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_playVideoQueue];
    [self.view addSubview:view_playVideoQueue];
}

-(void)internalInital_warmupWatchVideoByDuration:(int)_duration
{
    if(view_training_watchVideo)
        return;
    view_training_watchVideo = (FGTrainingVideoPlayMainPopupView_WatchVideo *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingVideoPlayMainPopupView" owner:nil options:nil] objectAtIndex:PopUpType_Training_PlayMainVideo_WatchVideo];
    [self.view addSubview:view_training_watchVideo];
    [self.view bringSubviewToFront:view_training_watchVideo];
    [commond useDefaultRatioToScaleView:view_training_watchVideo];
    view_training_watchVideo.numCount = _duration;
    [view_training_watchVideo setupTimer];
    view_training_watchVideo.delegate = self;
    [view_training_watchVideo.cub_skip.btn addTarget:self action:@selector(buttonAction_skip:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)internalInital_coolDown
{
    if(view_training_watchVideo)
        return;
    
    [self internalInital_warmupWatchVideoByDuration:0];
    view_training_watchVideo.lb_commingup.text =
    [NSString stringWithFormat:@"%@\n%@ %@",multiLanguage(@"CONGRATULATIONS!"),str_userCalories, multiLanguage(@"CALORIES BURNED!") ];
    [view_training_watchVideo.lb_commingup setCustomColor:color_red_panel searchText:str_userCalories font:font(FONT_TEXT_BOLD, 34)];
    
    
    view_training_watchVideo.lb_makesure.text = multiLanguage(@"Don’t forget\nto cool down");
    [view_training_watchVideo.cub_watchVideo.btn setTitle:multiLanguage(@"Watch the cool down video") forState:UIControlStateNormal];
    [view_training_watchVideo.cub_watchVideo.btn setTitle:multiLanguage(@"Watch the cool down video") forState:UIControlStateHighlighted];
    view_training_watchVideo.cub_skip.hidden = YES;
    view_training_watchVideo.lb_count.hidden = YES;
    [view_training_watchVideo invalidateTimer];
    CGRect _frame = view_training_watchVideo.lb_commingup.frame;
    _frame.origin.y = 100 * ratioH;
    view_training_watchVideo.lb_commingup.frame = _frame;
    
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getsure_cancelCoolDownVideo:)];
    _tap.cancelsTouchesInView = NO;
    [view_training_watchVideo.view_bg addGestureRecognizer:_tap];
    _tap = nil;
    
    [view_training_watchVideo.btn_watchVideo addTarget:self action:@selector(buttonAction_training_coolDownVideo:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)internalInital_getReadyByDuration:(int)_duration
{
    if(view_training_getReady)
        return;
    view_training_getReady = (FGTrainingVideoPlayMainPopupView_GetReady *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingVideoPlayMainPopupView" owner:nil options:nil] objectAtIndex:PopUpType_Training_PlayMainVideo_GetReady];
    [commond useDefaultRatioToScaleView:view_training_getReady];
    view_training_getReady.numCount = _duration;
    [view_training_getReady setupTimer];
    view_training_getReady.delegate = self;
    [self.view addSubview:view_training_getReady];
    
}

#pragma mark - 动画
-(void)fadeinView:(UIView *)_aView
{
    _aView.alpha = 0;
    [UIView animateWithDuration:.5 animations:^{
        _aView.alpha = 1;
    }completion:^(BOOL finished) {
    }];
}

#pragma mark - buttonAction
/*播放warmup 视频*/
-(void)buttonAction_training_watchVideo:(id)_sender
{
    view_training_watchVideo.delegate = nil;
    SAFE_RemoveSupreView(view_training_watchVideo);
    view_training_watchVideo = nil;
    [model.arr_urlInfos removeAllObjects];
    [model.arr_urls removeAllObjects];
    
    NSString *_str_warmupVideoPath = [[NSBundle mainBundle] pathForResource:WARMUPVIDEONAME ofType:@"mp4"];
    [model.arr_urls addObject:_str_warmupVideoPath];
    [model.arr_urlInfos addObject:_str_warmupVideoPath];//创建warmup 模型
    [model filteRepeatedUrlAndRecordTheCount];
    [view_playVideoQueue setupModel];
    [model playVideoByCurrentPlayerItemInVideoQueue];
    isWarmUpVideo = YES;
    
}

-(void)buttonAction_skip:(id)_sender
{
    [self timerDisCountFinished_warmup];
}

-(void)trackWorkoutFinish
{
    
    NSMutableDictionary *_dic_attr = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_attr setObject:model.str_workoutID forKey:KEY_TRACK_ATTRID_WORKOUT_ID];
    [_dic_attr setObject:[NSNumber numberWithInt:model.totoalTime_playVideoQueue] forKey:KEY_TRACK_ATTRID_WORKOUT_DURATION];
    [NetworkEventTrack track:KEY_TRACK_EVENTID_WORKOUT attrs:_dic_attr];
    NSLog(@"workoutID: %@",model.str_workoutID);
    NSLog(@"duration : %f",model.totoalTime_playVideoQueue);
}

/*不播放cooldown视频 并返回前一页面*/
-(void)getsure_cancelCoolDownVideo:(id)_sender
{
    
    
    if(!view_training_watchVideo)
        return;
    
    
    view_training_watchVideo.delegate = nil;
    SAFE_RemoveSupreView(view_training_watchVideo);
    view_training_watchVideo = nil;
    
    if(!view_playVideoQueue)
        return;
    [view_playVideoQueue buttonAction_stop:nil];
    
    
    
    
}

/*播放cooldown视频*/
-(void)buttonAction_training_coolDownVideo:(id)_sender
{
    if(!view_training_watchVideo)
        return;
    
    
    view_training_watchVideo.delegate = nil;
    SAFE_RemoveSupreView(view_training_watchVideo);
    view_training_watchVideo = nil;
    
    /*销毁当前模型*/
    [model cancelDownloading];
    [FGVideoModel clearVideoModel];
    [self createCoolDownModel];//创建cooldown模型
}

#pragma mark - json数据

- (id)giveMeResponseContentByResponseName:(NSString *)_str_responseName {
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_TRAINING_GetTrainDetailPage)];
    NSMutableArray *_arr_datas       = [_dic_result objectForKey:@"Responses"];
    for (NSMutableDictionary *_dic_data in _arr_datas) {
        NSString *str_responseName = [_dic_data objectForKey:@"ResponseName"];
        if ([_str_responseName isEqualToString:str_responseName]) {
            id _obj_responseContent = [_dic_data objectForKey:@"ResponseContent"];
            return _obj_responseContent;
        }
    }
    return nil;
}

#pragma mark - 判断视频后是否有休息
-(NSMutableDictionary *)giveMeRestInfoIfHave
{
    NSMutableDictionary *_dic_singleUrlInfo = [model.arr_urlInfos objectAtIndex:model.currentPlayerItemIndex];
    NSString *_str_videoId = [_dic_singleUrlInfo objectForKey:@"VideoId"];
    for(NSMutableDictionary *_dic_singleResetInfo in arr_videoRestInfo)
    {
        NSString *str_restAfterVideoId = [_dic_singleResetInfo objectForKey:@"RestAfterVideoId"];

        if( [str_restAfterVideoId intValue] == [_str_videoId intValue] )
        {
            
            return _dic_singleResetInfo;
        }
    }
    return nil;
}

#pragma mark - FGVideoModelPlayQueueVideoDelegate
-(void)singleVideoDidFinishAtIndex:(int)_videoIndex_finished nextIndex:(int)_videoIndex_next
{
    if(isWarmUpVideo)
        return;
    if(isCoolDownVideo)
        return;
    
    NSMutableDictionary *_dic_resetInfo = [self giveMeRestInfoIfHave];
    if(_dic_resetInfo)
    {
        int duration = [[_dic_resetInfo objectForKey:@"Duration"] intValue];
        NSLog(@"duration = %d",duration);
        [self internalInital_getReadyByDuration:duration];
        view_training_getReady.lb_getReady.text = [_dic_resetInfo objectForKey:@"VideoName"];
        model.currentPlayerItemIndex = _videoIndex_next;
    }
    else
    {
        model.currentPlayerItemIndex = _videoIndex_next;
        [model playVideoByCurrentPlayerItemInVideoQueue];
    }
}

-(void)videoQueueDidFinishedPlay:(id)_sender
{
    if(isWarmUpVideo)
    {
        [self internalInital_getReadyByDuration:10];
        [self fadeinView:view_training_getReady];
        
        [self resetTrainingModelIfNeeded];
        /*创建training视频的模型*/
        [view_playVideoQueue setupModel];
        isWarmUpVideo = NO;

    }//warmup视频播放结束
    else if(isCoolDownVideo)
    {
        if(!view_playVideoQueue)
            return;
        
        [view_playVideoQueue buttonAction_stop:nil];
        
       
        
        
        
    }//cooldown视频播放结束
    else
    {
        model = [FGVideoModel sharedModel];
        model.str_workoutID = str_workoutID ;
        model.delegate_playVideoQueue = self;
        
        [self trackWorkoutFinish];//追踪 workout 播放结束
        [model resetVideoPlayQueue];
        
        [self internalInital_coolDown];
        [self fadeinView:view_training_watchVideo];
       
    }//视频播放结束
  
}

#pragma mark - 模型操作
-(void)createCoolDownModel
{
    model = [FGVideoModel sharedModel];
    model.delegate_playVideoQueue = self;
    model.str_workoutID = str_workoutID ;
    [model.arr_urlInfos removeAllObjects];
    [model.arr_urls removeAllObjects];
    
    NSString *_str_coolDownVideoPath = [[NSBundle mainBundle] pathForResource:COOLDOWNVIDEONAME ofType:@"mp4"];
    [model.arr_urls addObject:_str_coolDownVideoPath];
    [model.arr_urlInfos addObject:_str_coolDownVideoPath];
    [model filteRepeatedUrlAndRecordTheCount];
    [view_playVideoQueue setupModel];
    [model playVideoByCurrentPlayerItemInVideoQueue];
    isCoolDownVideo = YES;
    
}

-(void)resetTrainingModelIfNeeded
{
    /*销毁warmup 模型*/
    [model cancelDownloading];
    [FGVideoModel clearVideoModel];
    
    
    /*重建training视频的数据*/
     model      = [FGVideoModel sharedModel];
    model.str_workoutID = str_workoutID;
    [model.arr_urlInfos removeAllObjects];
    [model.arr_urls removeAllObjects];
    model.delegate_playVideoQueue = self;
    NSMutableDictionary *_dic_step = [self giveMeResponseContentByResponseName:@"GetTrainingStep"];
    NSMutableArray *_arr_tmp_url  = [_dic_step objectForKey:@"StepVideos"];
    for (NSMutableDictionary *_dic_singleInfo in _arr_tmp_url) {
        NSString *str_url = [_dic_singleInfo objectForKey:@"VideoUrl"];
        NSString *str_audioUrl = [_dic_singleInfo objectForKey:@"AudioUrl"];
        if(![str_url isEmptyStr])
        {
            [model.arr_urls addObject:str_url];
            [model.arr_urlInfos addObject:_dic_singleInfo];
        }
        if(![str_audioUrl isEmptyStr])
        {
            if(![model.arr_audioUrls containsObject:str_audioUrl])
                [model.arr_audioUrls addObject:str_audioUrl];//去除重复的url
        }
    }
    [model filteRepeatedAudioUrlAndRecordThePlayIndex];
    [model filteRepeatedUrlAndRecordTheCount];
}

#pragma mark - FGTrainingVideoPlayMainPopupView_GetReadyDelegate
-(void)timerDisCountFinished
{
    if(!view_training_getReady)
        return;
    view_training_getReady.delegate = nil;
    SAFE_RemoveSupreView(view_training_getReady);
    view_training_getReady = nil;
}

#pragma mark - FGTrainingVideoPlayMainPopupView_WatchVideoDelegate
-(void)timerDisCountFinished_warmup
{
    if(!view_training_watchVideo)
        return;
    
    view_training_watchVideo.delegate = nil;
    SAFE_RemoveSupreView(view_training_watchVideo);
    view_training_watchVideo = nil;
    
    [self internalInital_getReadyByDuration:10];
    [self fadeinView:view_training_getReady];
    [view_playVideoQueue setupModel];
}

#pragma mark - 从父类继承的

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
}


@end

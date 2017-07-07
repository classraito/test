//
//  FGProfileFitnessLevelTestViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGProfileFitnessLevelTestViewController.h"
#import "Global.h"
#import "FGTrainingVideoPlayMainViewController.h"
@interface FGProfileFitnessLevelTestViewController ()
{
    BOOL isWarmUpVideo;
}
@end

@implementation FGProfileFitnessLevelTestViewController
@synthesize view_fitness_inquiry;
@synthesize view_fitness_fillBodyData;
@synthesize view_fitness_pushUps;
@synthesize view_fitness_plankFinished;
@synthesize view_fitness_howLongInsist;
@synthesize view_fitness_caloriesBurned;
@synthesize view_training_getReady;
@synthesize view_training_watchVideo;
@synthesize view_playVideoQueue;
@synthesize view_fitness_takePic;
@synthesize view_fitness_wonBadge;
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    SAFE_RemoveSupreView(self.view_topPanel);
    [self hideBottomPanelWithAnimtaion:NO];
    
    [self internalInital_inquiry];
    
    self.iv_bg.image = [UIImage imageNamed:@"fitness_bg.jpg"];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    FGVideoModel *model_video = [FGVideoModel sharedModel];
    [model_video cancelDownloading];
    [FGVideoModel clearVideoModel];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    view_fitness_inquiry = nil;
    view_fitness_fillBodyData = nil;
    view_fitness_pushUps = nil;
    view_fitness_plankFinished = nil;
    view_fitness_howLongInsist = nil;
    view_fitness_caloriesBurned = nil;
    view_training_getReady = nil;
    view_training_watchVideo = nil;
    view_playVideoQueue = nil;
    view_fitness_takePic = nil;
    view_fitness_wonBadge = nil;
}

-(void)resetFitnessLevelTestModel
{
    FGVideoModel *model_video = [FGVideoModel sharedModel];
    [model_video cancelDownloading];
    [FGVideoModel clearVideoModel];
    model_video = [FGVideoModel sharedModel];
    model_video.delegate_playVideoQueue = self;
    view_playVideoQueue.delegate_fitnessVideo = self;
     NSMutableArray *_arr_firnessJson = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fitnesstest_urlinfo" ofType:@"json"]];
     NSLog(@"_arr_fitnessJson = %@",_arr_firnessJson);  //加载配置数据
    for (NSMutableDictionary *_dic_singleInfo in _arr_firnessJson) {
        NSString *str_url = [_dic_singleInfo objectForKey:@"VideoUrl"];
        NSString *str_audioUrl = [_dic_singleInfo objectForKey:@"AudioUrl"];
        
        str_url = [[NSBundle mainBundle] pathForResource:str_url ofType:@"mp4"];
        str_audioUrl = [[NSBundle mainBundle] pathForResource:str_audioUrl ofType:@"mp3"];//将配置文件中的路径转换为包路径
        
        if(![str_url isEmptyStr])
        {
            [model_video.arr_urls addObject:str_url];
            [model_video.arr_urlInfos addObject:_dic_singleInfo];
        }
        if(![str_audioUrl isEmptyStr])
        {
            if(![model_video.arr_audioUrls containsObject:str_audioUrl])
                [model_video.arr_audioUrls addObject:str_audioUrl];//去除重复的url
        }
    }

    
    [model_video filteRepeatedAudioUrlAndRecordThePlayIndex];
    [model_video filteRepeatedUrlAndRecordTheCount];
}

#pragma mark - 初始化各个view
-(void)internalInital_inquiry
{
    if(view_fitness_inquiry)
        return;
    view_fitness_inquiry = (FGFitnessLevelTestPopupView_Inquiry *)[[[NSBundle mainBundle] loadNibNamed:@"FGFitnessLevelTestPopupView_Inquiry" owner:nil options:nil] objectAtIndex:0];
    [self.view addSubview:view_fitness_inquiry];
    view_fitness_inquiry.view_bg.backgroundColor = [UIColor clearColor];
    [commond useDefaultRatioToScaleView:view_fitness_inquiry];
    [view_fitness_inquiry.cb_yes.button addTarget:self action:@selector(buttonAction_inquiry_yes:) forControlEvents:UIControlEventTouchUpInside];
    [view_fitness_inquiry.btn_notNow addTarget:self action:@selector(buttonAction_inquiry_notNow:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)internalInital_fillBodyData
{
    if(view_fitness_fillBodyData)
        return;
    view_fitness_fillBodyData = (FGFitnessLevelTestPopupView_FillBodyData *)[[[NSBundle mainBundle] loadNibNamed:@"FGFitnessLevelTestPopupView_FillBodyData" owner:nil options:nil] objectAtIndex:0];
    [self.view addSubview:view_fitness_fillBodyData];
    view_fitness_fillBodyData.backgroundColor = [UIColor clearColor];
    [commond useDefaultRatioToScaleView:view_fitness_fillBodyData];
    [view_fitness_fillBodyData setupByOriginalContentSize:view_fitness_fillBodyData.bounds.size];
    [view_fitness_fillBodyData.cb_getStarted.button addTarget:self action:@selector(buttonAction_fillBody_getStarted:) forControlEvents:UIControlEventTouchUpInside];
    [view_fitness_fillBodyData.btn_skip addTarget:self action:@selector(buttonAction_fillBody_skip:) forControlEvents:UIControlEventTouchUpInside];
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
     [view_training_watchVideo.btn_watchVideo addTarget:self action:@selector(buttonAction_training_watchVideo:) forControlEvents:UIControlEventTouchUpInside];
    [view_training_watchVideo.cub_skip.btn addTarget:self action:@selector(buttonAction_skip:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)internalInital_getReady
{
    if(view_training_getReady)
        return;
    view_training_getReady = (FGTrainingVideoPlayMainPopupView_GetReady *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingVideoPlayMainPopupView" owner:nil options:nil] objectAtIndex:PopUpType_Training_PlayMainVideo_GetReady];
    [self.view addSubview:view_training_getReady];
    [commond useDefaultRatioToScaleView:view_training_getReady];
    [view_training_getReady setupTimer];
    view_training_getReady.delegate = self;
}

-(void)internalInital_howManyPushUps
{
    if(view_fitness_pushUps)
        return;
    view_fitness_pushUps = (FGFitnessLevelTestPopupView_HowManayPushUps *)[[[NSBundle mainBundle] loadNibNamed:@"FGFitnessLevelTestPopupView_HowManayPushUps" owner:nil options:nil] objectAtIndex:0];
    [self.view addSubview:view_fitness_pushUps];
    [commond useDefaultRatioToScaleView:view_fitness_pushUps];
    [view_fitness_pushUps.cb_done.button addTarget:self action:@selector(buttonAction_pushUps_done:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)internalInital_plankFinished
{
    if(view_fitness_plankFinished)
        return;
    view_fitness_plankFinished = (FGFitnessLevelTestPopupView_PlankExerciseFinished *)[[[NSBundle mainBundle] loadNibNamed:@"FGFitnessLevelTestPopupView_PlankExerciseFinished" owner:nil options:nil] objectAtIndex:0];
    [self.view addSubview:view_fitness_plankFinished];
    [commond useDefaultRatioToScaleView:view_fitness_plankFinished];
    [view_fitness_plankFinished.cb_yes.button addTarget:self action:@selector(buttonAction_plankFinished_yes:) forControlEvents:UIControlEventTouchUpInside];
    [view_fitness_plankFinished.btn_no addTarget:self action:@selector(buttonAction_plankFinished_no:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)internalInital_howLongInsist
{
    if(view_fitness_howLongInsist)
        return;
    view_fitness_howLongInsist = (FGFitnessLevelTestPopupView_HowLongInsist *)[[[NSBundle mainBundle] loadNibNamed:@"FGFitnessLevelTestPopupView_HowLongInsist" owner:nil options:nil] objectAtIndex:0];
    [self.view addSubview:view_fitness_howLongInsist];
    [commond useDefaultRatioToScaleView:view_fitness_howLongInsist];
    [view_fitness_howLongInsist.cb_done.button addTarget:self action:@selector(buttonAction_howLongInsist_done:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)internalInital_caloriesBurned
{
    if(view_fitness_caloriesBurned)
        return;
    view_fitness_caloriesBurned = (FGFitnessLevelTestPopupView_CaloriesBurned *)[[[NSBundle mainBundle] loadNibNamed:@"FGFitnessLevelTestPopupView_CaloriesBurned" owner:nil options:nil] objectAtIndex:0];
    [self.view addSubview:view_fitness_caloriesBurned];
    [commond useDefaultRatioToScaleView:view_fitness_caloriesBurned];
    [view_fitness_caloriesBurned.cb_finished.button addTarget:self action:@selector(buttonAction_caloriesBurned_done:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)internalIntal_VideoQueueView
{
    if(view_playVideoQueue)
        return;
    
    view_playVideoQueue = (FGFitnessVideoPlayMainView *)[[[NSBundle mainBundle] loadNibNamed:@"FGFitnessVideoPlayMainView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_playVideoQueue];
    [self.view addSubview:view_playVideoQueue];
    view_playVideoQueue.model_video.delegate_playVideoQueue = self;
    view_playVideoQueue.delegate_fitnessVideo = self;
//    view_playVideoQueue.model_video.currentPlayerItemIndex = 4; //解除注释测试最后一个视频
}

-(void)internalInital_wonBadge
{
    if(view_fitness_wonBadge)
        return;
    view_fitness_wonBadge = (FGFitnessLevelTestPopupView_WonBadge *)[[[NSBundle mainBundle] loadNibNamed:@"FGFitnessLevelTestPopupView_WonBadge" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_fitness_wonBadge];
    [self.view addSubview:view_fitness_wonBadge];
    [view_fitness_wonBadge.btn_share addTarget:self action:@selector(buttonAction_wonBadge_share:) forControlEvents:UIControlEventTouchUpInside];
    [view_fitness_wonBadge.btn_close addTarget:self action:@selector(buttonAction_wonBadge_close:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)internalInital_takePic
{
    if(view_fitness_takePic)
        return;
    
    view_fitness_takePic = (FGFitnessLevelTestPopupView_TakePic *)[[[NSBundle mainBundle] loadNibNamed:@"FGFitnessLevelTestPopupView_TakePic" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_fitness_takePic];
    [self.view addSubview:view_fitness_takePic];
    [view_fitness_takePic.btn_done addTarget:self action:@selector(buttonAction_takePic_done:) forControlEvents:UIControlEventTouchUpInside];
    [view_fitness_takePic.btn_no addTarget:self action:@selector(buttonAction_takePic_no:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)go2WatchVideoFromFillBodyData
{
    SAFE_RemoveSupreView(view_fitness_fillBodyData);
    [self internalIntal_VideoQueueView];
    [self internalInital_warmupWatchVideoByDuration:5];
    [self fadeinView:view_training_watchVideo];
}

#pragma mark - 按钮事件
//=======================Inquiry======================
-(void)buttonAction_inquiry_yes:(id)_sender
{
    
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
    [[NetworkManager_Profile sharedManager] postRequest_Profile_getUserProfile:_dic_info];
    
}

-(void)go2FitnessFillBodyData
{
    SAFE_RemoveSupreView(view_fitness_inquiry);
    [self internalInital_fillBodyData];
    [self fadeinView:view_fitness_fillBodyData];
}

-(void)buttonAction_inquiry_notNow:(id)_sender
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager popViewControllerInNavigation:&nav_current animated:YES];//TODO: need to fix it
}

//=======================fill body======================
-(void)buttonAction_fillBody_getStarted:(id)_sender
{
    if(view_fitness_fillBodyData)
    {
        [view_fitness_fillBodyData postRequest_submitBodyData];
    }
    
}

-(void)buttonAction_fillBody_skip:(id)_sender
{
    SAFE_RemoveSupreView(view_fitness_fillBodyData);
    [self internalIntal_VideoQueueView];
    [self internalInital_warmupWatchVideoByDuration:5];
    [self fadeinView:view_playVideoQueue];
    [self fadeinView:view_training_watchVideo];
}

//=======================watch warmup video======================
-(void)buttonAction_training_watchVideo:(id)_sender
{
    view_training_watchVideo.delegate = nil;
    SAFE_RemoveSupreView(view_training_watchVideo);
    
    FGVideoModel *model = [FGVideoModel sharedModel];
    model.delegate_playVideoQueue = self;
    view_playVideoQueue.delegate_fitnessVideo = self;
    [model.arr_urlInfos removeAllObjects];
    [model.arr_urls removeAllObjects];
    
    NSString *_str_warmupVideoPath = [[NSBundle mainBundle] pathForResource:WARMUPVIDEONAME ofType:@"mp4"];
    [model.arr_urls addObject:_str_warmupVideoPath];
    [model.arr_urlInfos addObject:_str_warmupVideoPath];
    [model filteRepeatedUrlAndRecordTheCount];
    [view_playVideoQueue setupModel];
    [model playVideoByCurrentPlayerItemInVideoQueue];
    isWarmUpVideo = YES;

}

-(void)buttonAction_skip:(id)_sender
{
    [self timerDisCountFinished_warmup];
}


//=======================push up done======================
-(void)buttonAction_pushUps_done:(UIButton *)_sender
{
    HowManyTypes type = view_fitness_pushUps.type;
    FGProfileFitnessTestModel *fitnessModel = [FGProfileFitnessTestModel sharedModel];
    if(type == HowManyTypes_pushups)
    {
        fitnessModel.pushupsCount = (int)view_fitness_pushUps.pushupsCount;
    }
    else if(type == HowManyTypes_stiups)
    {
        fitnessModel.situpsCount = (int)view_fitness_pushUps.pushupsCount;
    }
    else if(type == HowManyTypes_squats)
    {
        fitnessModel.squatsCount = (int)view_fitness_pushUps.pushupsCount;
        FGProfileFitnessTestModel *model = [FGProfileFitnessTestModel sharedModel];
        [model initalTimer];//开始plank计时
    }
    else if(type == HowManyTypes_planks)
    {
        fitnessModel.plankSecs = (int)view_fitness_pushUps;
        
        
    }
    
    SAFE_RemoveSupreView(view_fitness_pushUps);
    view_playVideoQueue.model_video.currentPlayerItemIndex += 1;
    [view_playVideoQueue.model_video playVideoByCurrentPlayerItemInVideoQueue];//播放下一个视频
}


//=======================plankFinished======================
-(void)buttonAction_plankFinished_yes:(id)_sender
{
    FGProfileFitnessTestModel *model = [FGProfileFitnessTestModel sharedModel];
    
    
    model.totalTime = view_playVideoQueue.model_video.totoalTime_playVideoQueue + model.plankSecs;
    
    [model invalidateTimer];//结束plank计时 并计算总时长(不包含暂停和界面交互占用的时间)
    
    [view_playVideoQueue.model_video resetVideoPlayQueue];
    SAFE_RemoveSupreView(view_fitness_plankFinished);
    [self internalInital_howLongInsist];
    [self fadeinView:view_fitness_howLongInsist];
    
    
    
}

-(void)buttonAction_plankFinished_no:(id)_sender
{
    SAFE_RemoveSupreView(view_fitness_plankFinished);
    [view_playVideoQueue.model_video.playerLayer_playVideoQueue.player play];
    [view_playVideoQueue.model_video playAudio];
}


//=======================plank insisted how much time======================
-(void)buttonAction_howLongInsist_done:(id)_sender
{
    [self postRequest_submitInfo:@""];
}

-(void)go2CaloriesBurned
{
    SAFE_RemoveSupreView(view_fitness_howLongInsist);
    SAFE_RemoveSupreView(view_playVideoQueue);
    view_playVideoQueue = nil;
    [self internalInital_caloriesBurned];
    [self fadeinView:view_fitness_caloriesBurned];
}


//=======================caloriesBurned_done======================
-(void)buttonAction_caloriesBurned_done:(id)_sender
{
    SAFE_RemoveSupreView(view_fitness_caloriesBurned);
   // [self internalInital_wonBadge];
   // [self fadeinView:view_fitness_wonBadge]; //TODO:暂时跳过赢得Badges
    [self internalInital_takePic];
    [self fadeinView:view_fitness_takePic];
}

//========================WonBadge share=========================
-(void)buttonAction_wonBadge_share:(id)_sender
{
    
}

-(void)buttonAction_wonBadge_close:(id)_sender
{
    SAFE_RemoveSupreView(view_fitness_wonBadge);
    [self internalInital_takePic];
    [self fadeinView:view_fitness_takePic];
}

//========================takePic =========================
-(void)buttonAction_takePic_done:(UIButton *)_button
{
    NSString *_str_buttonName = _button.titleLabel.text;
    if([_str_buttonName isEqualToString:multiLanguage(@"YES")])
    {
        [view_fitness_takePic buttonAction_takePic_TakeAPhoto:nil];
    }
    else
    {
        [self startUploadImage];
    }
}

-(void)buttonAction_takePic_no:(id)_sender
{
    [self postRequest_updateInfo:@""];
}

-(void)popFitnessTest
{
    [NetworkEventTrack track:KEY_TRACK_EVENTID_FITNESSTEST attrs:nil];
    
    SAFE_RemoveSupreView(view_fitness_takePic);
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager popViewControllerInNavigation:&nav_current animated:YES];
}

-(void)startUploadImage
{
    [commond showLoading];
    UIImage *imgNeedUpload = [view_fitness_takePic.iv_pic.image rescaleImageToPX:800];
    ASINetworkQueue *asiQueue = [[NetworkManager_UploadFile sharedManager] startUploadImages:(NSMutableArray *)@[imgNeedUpload]];
    asiQueue.delegate = self;
    asiQueue.requestDidFinishSelector = @selector(didFinishUploadFilesInQueue:);
    asiQueue.requestDidFailSelector = @selector(didFailedUploadFilesInQueue:);
}

#pragma mark - FGVideoModelPlayQueueVideoDelegate
-(void)singleVideoDidFinishAtIndex:(int)_videoIndex_finished nextIndex:(int)_videoIndex_next
{
    if(isWarmUpVideo)
        return;

    
    if(!view_playVideoQueue)
        return;
    
    if(_videoIndex_finished <= 3)
    {
        [self internalInital_howManyPushUps];
        [self fadeinView:view_fitness_pushUps];
        
        
        
        NSString *str_title = nil;
        switch (_videoIndex_finished) {
            case 0:
                str_title = multiLanguage(@"How many push-ups\ndid you finish?");
                view_fitness_pushUps.type = HowManyTypes_pushups;
                break;
                
            case 1:
                str_title = multiLanguage(@"How many Situps\ndid you finish?");
                view_fitness_pushUps.type = HowManyTypes_stiups;
                break;
            
            case 2:
                str_title = multiLanguage(@"How many Squats\ndid you finish?");
                view_fitness_pushUps.type = HowManyTypes_squats;
                break;
            
            case 3:
                str_title = multiLanguage(@"Are you sure you finished your plank?");
                view_fitness_pushUps.type = HowManyTypes_planks;
                break;
        }
        view_fitness_pushUps.lb_title.text = str_title;
    }//弹出push up视图
    else
    {
        [view_playVideoQueue restartTimer];
        view_playVideoQueue.model_video.currentPlayerItemIndex = _videoIndex_next;
        [view_playVideoQueue.model_video playVideoByCurrentPlayerItemInVideoQueue];
    }//播放下一个视频
    
    
}

-(void)videoQueueDidFinishedPlay:(id)_sender
{
    if(!view_playVideoQueue)
        return;
    
    if(isWarmUpVideo)
    {
        [self timerDisCountFinished_warmup];
        
        isWarmUpVideo = NO;
        
    }//warmup视频播放结束
    else
    {
        if(view_playVideoQueue.model_video.currentPlayerItemIndex != 3)
        {
            [view_playVideoQueue.model_video resetVideoPlayQueue];
        }
        else
        {
            [view_playVideoQueue.model_video playVideoByCurrentPlayerItemInVideoQueue];//重复播放当前视频
        }
    }
}

#pragma mark - FGTrainingVideoPlayMainPopupView_GetReadyDelegate
-(void)timerDisCountFinished
{
    if(!view_training_getReady)
        return;
    view_training_getReady.delegate = nil;
    SAFE_RemoveSupreView(view_training_getReady);
}

#pragma mark - FGTrainingVideoPlayMainPopupView_WatchVideoDelegate
-(void)timerDisCountFinished_warmup
{
    
    if(view_training_watchVideo)
    {
        view_training_watchVideo.delegate = nil;
        SAFE_RemoveSupreView(view_training_watchVideo);
    }
    
    
    [self internalInital_getReady];
    [self fadeinView:view_training_getReady];
    [self resetFitnessLevelTestModel];
    [view_playVideoQueue setupModel];
}

#pragma mark - FGFitnessVideoPlayMainViewDelegate
-(void)didTapOnPlankExerciseVideo
{
    [self internalInital_plankFinished];
    [self fadeinView:view_fitness_plankFinished];
    [view_playVideoQueue.model_video.playerLayer_playVideoQueue.player pause];
    [view_playVideoQueue.model_video pauseAudio];
}

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    
    // 验证码请求
    if ([HOST(URL_PROFILE_FitnessTest) isEqualToString:_str_url]) {
        NSString *_str_method = [_dic_requestInfo objectForKey:@"METHOD"];
        if([_str_method isEqualToString:@"INSERT"])
        {
            NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_PROFILE_FitnessTest)];
            FGProfileFitnessTestModel *model = [FGProfileFitnessTestModel sharedModel];
            model.str_fitnessTestID = [_dic_result objectForKey:@"FitnessTestId"];
            model.calorious = [[_dic_result objectForKey:@"Total"] intValue];
            [self go2CaloriesBurned];
            
        }
        else if([_str_method isEqualToString:@"UPDATE"])
        {
            [self popFitnessTest];
        }
    }
    
    if ([HOST(URL_USER_SetUserProfile) isEqualToString:_str_url]) {
        if([[_dic_requestInfo allKeys] containsObject:KEY_NOTIFY_ALIAS])
        {
            [NetworkEventTrack track:KEY_TRACK_EVENTID_PROFILE attrs:nil];//追踪 修改个人资料
            [self go2WatchVideoFromFillBodyData];
        }
    }
    
    if ([HOST(URL_PROFILE_GetUserProfile) isEqualToString:_str_url]) {
        NSMutableDictionary *_dic_userinfo = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_PROFILE_GetUserProfile)];
        NSNumber *gender = [_dic_userinfo objectForKey:@"Gender"];
        NSNumber *age = [_dic_userinfo objectForKey:@"Age"];
        NSNumber *weight = [_dic_userinfo objectForKey:@"Weight"];
        NSNumber *height = [_dic_userinfo objectForKey:@"Height"];
        
        
        [self go2FitnessFillBodyData];
        if(gender )
        {
            view_fitness_fillBodyData.tf_gender.text = GenderToString([gender intValue]);
        }
        
        if(age && [age intValue]!=0)
        {
            view_fitness_fillBodyData.tf_age.text = [NSString stringWithFormat:@"%d",[age intValue]];
        }
        
        if(weight && [weight intValue]!=0)
        {
            view_fitness_fillBodyData.tf_weight.text = [NSString stringWithFormat:@"%@",weight];
        }
        
        if(height && [height intValue]!=0)
        {
            view_fitness_fillBodyData.tf_height.text = [NSString stringWithFormat:@"%@",height];
        }
        
        
    }
    
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
}

#pragma mark - 上传文件结束回调
-(void)didFinishUploadFilesInQueue:(ASIHTTPRequest *)request
{
    [commond removeLoading];
    NSString *str_response = request.responseString;
    
    int responseCode = request.responseStatusCode;
    
    if (responseCode != 200) {
        [commond removeLoading];
        [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please check your network connection!") callback:nil];
        return; //第一级检查返回码,(http 返回码)
    }
    
    NSMutableDictionary *_dic_json = [str_response mutableObjectFromJSONString]; //转json对象
    
    if (!_dic_json || [_dic_json count]<=0) //第二次检查
        return;
    
   
    NSString *_str_fileUrl1 = [_dic_json objectForKey:@"Url1"];
   
    
    responseCode = [[_dic_json objectForKey:@"Code"] intValue];
    if(responseCode != 0 )
            return;
    [self postRequest_updateInfo:_str_fileUrl1];
    
}

-(void)didFailedUploadFilesInQueue:(ASIHTTPRequest *)request
{
    [commond removeLoading];
}

-(void)postRequest_submitInfo:(NSString *)_str_fileUrl
{
    [commond showLoading];
    FGProfileFitnessTestModel *model = [FGProfileFitnessTestModel sharedModel];
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
    [_dic_info setObject:@"INSERT" forKey:@"METHOD"];
    [[NetworkManager_Profile sharedManager] postRequest_Profile_SubmitFitnessTestByPushUp:model.pushupsCount situps:model.situpsCount squats:model.squatsCount burpees:model.burpees plank:model.plankSecs url:_str_fileUrl fitnessID:@""  userinfo:_dic_info];
}

-(void)postRequest_updateInfo:(NSString *)_str_fileUrl
{
    [commond showLoading];
    FGProfileFitnessTestModel *model = [FGProfileFitnessTestModel sharedModel];
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
    [_dic_info setObject:@"UPDATE" forKey:@"METHOD"];
    [[NetworkManager_Profile sharedManager] postRequest_Profile_SubmitFitnessTestByPushUp:model.pushupsCount situps:model.situpsCount squats:model.squatsCount burpees:model.burpees plank:model.plankSecs url:_str_fileUrl fitnessID:model.str_fitnessTestID  userinfo:_dic_info];
}

@end

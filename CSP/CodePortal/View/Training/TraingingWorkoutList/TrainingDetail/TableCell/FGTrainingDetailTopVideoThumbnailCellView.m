//
//  FGTrainingDetailTopVideoThumnailView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingDetailTopVideoThumbnailCellView.h"
#import "Global.h"
#import "FGTrainingStepByStepViewController.h"
#import "FGTrainingVideoPlayMainViewController.h"
#import "FGTrainingDetailViewController.h"
#import "FGCircularWithProcessingButton.h"
@interface FGTrainingDetailTopVideoThumbnailCellView()
{
    
}
@end

@implementation FGTrainingDetailTopVideoThumbnailCellView
@synthesize cpb_download;
@synthesize iv_videoThumbnail;
@synthesize view_bottomPanelBG;
@synthesize btn_likes;
@synthesize btn_stepByStep;
@synthesize btn_favorite;
@synthesize iv_likes;
@synthesize iv_stepByStep;
@synthesize iv_favorite;
@synthesize lb_likes;
@synthesize lb_stepByStep;
@synthesize lb_favorite;
@synthesize _str_trainId;
@synthesize str_UserCalories;
#pragma mark - 生命周期
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [commond useDefaultRatioToScaleView:cpb_download];
    [commond useDefaultRatioToScaleView:iv_videoThumbnail];
    [commond useDefaultRatioToScaleView:view_bottomPanelBG];
    [commond useDefaultRatioToScaleView:btn_likes];
    [commond useDefaultRatioToScaleView:btn_stepByStep];
    [commond useDefaultRatioToScaleView:btn_favorite];
    [commond useDefaultRatioToScaleView:iv_likes];
    [commond useDefaultRatioToScaleView:iv_stepByStep];
    [commond useDefaultRatioToScaleView:iv_favorite];
    [commond useDefaultRatioToScaleView:lb_likes];
    [commond useDefaultRatioToScaleView:lb_stepByStep];
    [commond useDefaultRatioToScaleView:lb_favorite];
    
    
    lb_likes.font = font(FONT_TEXT_REGULAR, 13);
    lb_stepByStep.font = font(FONT_TEXT_REGULAR, 13);
    lb_favorite.font = font(FONT_TEXT_REGULAR, 13);
    
    lb_likes.text = multiLanguage(@"Likes");
    lb_stepByStep.text = multiLanguage(@"Step by step");
    lb_favorite.text = multiLanguage(@"Favorite");
    
    
    [cpb_download.btn_download_play addTarget:self action:@selector(buttonAction_download_play:) forControlEvents:UIControlEventTouchUpInside ];
    
}

-(void)updateDownloadButtonStatus
{
    FGVideoModel *model_video = [FGVideoModel sharedModel];
    model_video.delegate_download = self;
    if([model_video isNeedDownloadByURLS:model_video.arr_urls audioURLS:model_video.arr_audioUrls])
        [cpb_download setStatusToNotDownload];
    else
    {
        [cpb_download setStatusToReadyToPlay];
        [self saveWorkoutDatas];
       // [self saveWorkoutListDatas];
    }
    
}

/*如果下载完成 保存workout 原始数据到本地setting bundle里*/
-(void)saveWorkoutDatas
{
    FGTrainingDetailViewController *vc = (FGTrainingDetailViewController *)[self viewController];
    NSString *str_workoutId = [NSString stringWithFormat:@"%@",vc.workoutID];
    if(!str_workoutId || [str_workoutId isEmptyStr] )
        return;
    
    
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_TRAINING_GetTrainDetailPage)];
    
    id obj = [commond getUserDefaults:KEY_SAVEDWORKOUT_DATAS];
    NSMutableDictionary *_dic_workoutDatas;
    if(!obj )
    {
        _dic_workoutDatas = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    else
    {
        _dic_workoutDatas = [[commond getUserDefaults:KEY_SAVEDWORKOUT_DATAS] mutableCopy];
    }
    
    if([[_dic_workoutDatas allKeys] containsObject:str_workoutId])
    {
        return;
    }
    
    [_dic_workoutDatas setObject:_dic_result forKey:str_workoutId];
    [commond setUserDefaults:_dic_workoutDatas forKey:KEY_SAVEDWORKOUT_DATAS];
}

/*如果下载完成 保存workoutlist 原始数据到本地setting bundle里*/
-(void)saveWorkoutListDatas
{
    FGTrainingDetailViewController *vc = (FGTrainingDetailViewController *)[self viewController];
    NSString *str_workoutId = [NSString stringWithFormat:@"%@",vc.workoutID];
    if(!str_workoutId || [str_workoutId isEmptyStr])
        return;
    
    
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_TRAINING_GetWorkoutVideoList)];
    id obj = [commond getUserDefaults:KEY_SAVEDWORKOUTLIST_DATAS];
    NSMutableArray *_arr_workoutListDatas;
    if(!obj )
    {
        _arr_workoutListDatas = [NSMutableArray arrayWithCapacity:1];
    }
    else
    {
        _arr_workoutListDatas = [[commond getUserDefaults:KEY_SAVEDWORKOUTLIST_DATAS] mutableCopy];
    }
    
    for(NSMutableDictionary *_dic_singleinfo in _arr_workoutListDatas)
    {
        NSString *_str_trainingId = [NSString stringWithFormat:@"%@",[_dic_singleinfo objectForKey:@"TrainingId"]];
        if([_str_trainingId isEqualToString:str_workoutId])
        {
            return;
        }
    }//判断如果本地已经保存过了该trainingId了就不保存了
    
    NSMutableArray *_arr_workoutlist = [_dic_result objectForKey:@"Trains"];
    for(NSMutableDictionary *_dic_singleWorkoutInfo in _arr_workoutlist)
    {
        NSString *_str_trainingId = [NSString stringWithFormat:@"%@",[_dic_singleWorkoutInfo objectForKey:@"TrainingId"]];
        if([_str_trainingId isEqualToString:str_workoutId])
        {
            [_arr_workoutListDatas addObject:_dic_singleWorkoutInfo];
        }
    }
    [commond setUserDefaults:_arr_workoutListDatas forKey:KEY_SAVEDWORKOUTLIST_DATAS];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    _str_trainId = nil;
    str_UserCalories = nil;
}

-(void)go2VideoPlayMainViewController
{
    FGVideoModel *model = [FGVideoModel sharedModel];
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGTrainingVideoPlayMainViewController *vc_playVideoMain = [[FGTrainingVideoPlayMainViewController alloc] initWithNibName:@"FGTrainingVideoPlayMainViewController" bundle:nil workoutID:model.str_workoutID userCalories:str_UserCalories];
    [manager pushController:vc_playVideoMain navigationController:nav_current];
    
}

#pragma mark - 按钮事件
-(IBAction)buttonAction_likes:(id)_sender;
{
    [[NetworkManager_Training sharedManager] postRequest_SetTrainLike:_str_trainId isLike:!iv_likes.highlighted userinfo:nil];
}

-(IBAction)buttonAction_stepByStep:(id)_sender;
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGTrainingStepByStepViewController *vc_stepByStep = [[FGTrainingStepByStepViewController alloc] initWithNibName:@"FGTrainingStepByStepViewController" bundle:nil];
    [manager pushController:vc_stepByStep navigationController:nav_current];
}

-(IBAction)buttonAction_favorite:(id)_sender;
{
    iv_favorite.highlighted = iv_favorite.highlighted ? NO : YES;
    if(iv_favorite.highlighted)
        lb_favorite.textColor = rgb(64, 162, 158);
    else
        lb_favorite.textColor = [UIColor whiteColor];
    
    [[NetworkManager_Training sharedManager] postRequest_SetTrainFavorite:_str_trainId isFavorite:iv_favorite.highlighted userinfo:nil];
    
}

-(void)buttonAction_download_play:(id)_sender;
{
    FGVideoModel *model_video = [FGVideoModel sharedModel];
   
    switch (cpb_download.status) {
        case ProcessingButtonStatus_NotDownload:
                [model_video startDownloadVideosByURLsUseASIQueueIfNeeded:model_video.arr_urls audioUrls:model_video.arr_audioUrls];
                [cpb_download setStatusToDownloading];
            break;
            
        case ProcessingButtonStatus_Downloading:
            
            break;
            
        case ProcessingButtonStatus_ReadyToPlay:
                [self go2VideoPlayMainViewController];
            break;
        
    }
    
    
  
}

#pragma mark - FGVideoModelDelegate
-(void)didUpdateDownloadProcess:(CGFloat)_percent
{
    cpb_download.processPercent = _percent;
    [cpb_download setNeedsDisplay];
    [cpb_download setStatusToDownloading];
}

-(void)didFinishDownloadAllVideos:(FGVideoModel *)_model
{
    [self updateDownloadButtonStatus];
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
    iv_likes.highlighted = [[_dataInfo objectForKey:@"IsLike"] boolValue];
    if(iv_likes.highlighted)
        lb_likes.textColor = rgb(64, 162, 158);
    else
        lb_likes.textColor = [UIColor whiteColor];
    
    iv_favorite.highlighted = [[_dataInfo objectForKey:@"IsFavorite"] boolValue];
    
    if(iv_favorite.highlighted)
        lb_favorite.textColor = rgb(64, 162, 158);
    else
        lb_favorite.textColor = [UIColor whiteColor];
    
    [iv_videoThumbnail sd_setImageWithURL:[NSURL URLWithString:[_dataInfo objectForKey:@"Thumbnail"]]];
}
@end

//
//  FGTrainingStepByStepPreviewVideoView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingStepByStepPreviewVideoView.h"
#import "Global.h"
#import "FGTrainingVideoPreviewViewController.h"
@interface FGTrainingStepByStepPreviewVideoView()
{
    FGVideoModel *model_video;
}
@end

@implementation FGTrainingStepByStepPreviewVideoView
@synthesize sv;
@synthesize iv_left;
@synthesize iv_right;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [commond useDefaultRatioToScaleView:sv];
    [commond useDefaultRatioToScaleView:iv_right];
    [commond useDefaultRatioToScaleView:iv_left];
    
    model_video = [FGVideoModel sharedModel];
    model_video.delegate_download = self;
    [model_video internalInitalFilePathsByUrls:model_video.arr_urls];
    [model_video initalAllPlayerItemsByCurrentFilePaths];
    [model_video initPlayerLayerPool];
    
    //NSLog(@"::::::>model_video.arr_videoFilePaths = %@",model_video.arr_videoFilePaths);
    sv.pagingEnabled = YES;
    sv.delegate  = self;
    sv.backgroundColor = rgb(198, 198, 198);
    self.backgroundColor = rgb(198, 198, 198);
    
    [self internalInitalVideoContainerViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:)
                                                 name:UIApplicationWillTerminateNotification object:nil];//监听是否触发home键挂起程序.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];//监听是否重新进入程序程序.
}

-(void)internalInitalVideoContainerViews
{
    for(int i=0;i<[model_video.arr_videoFilePaths count];i++)
    {
        UIView *_view_videoContainer = [[UIView alloc] initWithFrame:self.bounds];
        _view_videoContainer.tag = i + 1;
        _view_videoContainer.alpha = 0;
        _view_videoContainer.backgroundColor = rgb(198, 198, 198);
        CGRect _frame = sv.frame;
        _frame.origin.x = i * sv.frame.size.width;
        _view_videoContainer.frame = _frame;//创建视频容器view
        
        UILabel *_lb_progress = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200 * ratioW, 60 * ratioH)];
        _lb_progress.backgroundColor = [UIColor clearColor];
        _lb_progress.textColor = [UIColor whiteColor];
        _lb_progress.font = font(FONT_TEXT_BOLD, 20);
        _lb_progress.alpha = 0;
        _lb_progress.textAlignment = NSTextAlignmentCenter;
        _lb_progress.text = [NSString stringWithFormat:@"%@\n%d%%",multiLanguage(@"LOADING..."),0];
        _lb_progress.numberOfLines = 0;
        _lb_progress.center = CGPointMake(_view_videoContainer.frame.size.width / 2, _view_videoContainer.frame.size.height / 2);
        [_view_videoContainer addSubview:_lb_progress];//创建下载进度说明文字
        
        [sv addSubview:_view_videoContainer];
    }
    sv.contentSize = CGSizeMake([model_video.arr_videoFilePaths count] * sv.frame.size.width, sv.frame.size.height);
    [sv scrollRectToVisible:CGRectMake(sv.frame.size.width * model_video.currentPlayerItemIndex, 0, sv.frame.size.width, sv.frame.size.height) animated:NO];
    [self updateVideoContainer];
    [model_video playSinglePlayerItemByCurrentPlayerItemIndexIfExist_OtherWiseToDownloadIt];
}

-(void)dealloc
{
    NSLog(@"::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [model_video resetAllPlayerItemsInPool];
    [model_video cancelDownloading];
    model_video.delegate_download = nil;
    for(id obj in model_video.arr_playerLayerPool)
    {
        if([obj isKindOfClass:[AVPlayerLayer class]])
        {
            [obj removeFromSuperlayer];
        }
    }
    [sv.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    sv = nil;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)updateVideoContainer
{
    for(UIView *_subview in sv.subviews)
    {
        if(_subview.tag != 0)
        {
            NSInteger _playerItemIndex = _subview.tag - 1;
            UIView *_view_videoContainer = _subview;
            [model_video updatePlayerLayerToVideoContainViewIfNeeded:_view_videoContainer playerItemIndex:(int)_playerItemIndex];
            
            
            [UIView animateWithDuration:.6 animations:^{
                _view_videoContainer.alpha = 1;
            }];
            //NSLog(@"_view_videoContainer.layer.sublayers %ld = %@",_playerItemIndex,_view_videoContainer.layer.sublayers);
        }
    }
}

/*获得视频容器对象*/
-(UIView *)giveMeVideoContainerAtVideoIndex:(int)_videoIndex
{
    for(UIView *_subview in sv.subviews)
    {
        if(_subview.tag != 0)
        {
            NSInteger _playerItemIndex = _subview.tag - 1;
            if(_playerItemIndex == _videoIndex)
            {
                return _subview;
            }
        }
    }
    return nil;
}

/*获得进度条对象*/
-(UILabel *)giveMeVideoProgressLabelAtVideoIndex:(int)_videoIndex
{
    UIView *_view_videoContainer = [self giveMeVideoContainerAtVideoIndex:_videoIndex];
    for(UIView *_subview in _view_videoContainer.subviews)
    {
        if([_subview isKindOfClass:[UILabel class]])
        {
            UILabel *_lb_progress = (UILabel *)_subview;
            return _lb_progress;
        }
    }
    return nil;
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static int lastCurrentPlayerItemIndex = -1;
    
     model_video.currentPlayerItemIndex =  scrollView.contentOffset.x / scrollView.frame.size.width;
    
    if(lastCurrentPlayerItemIndex == model_video.currentPlayerItemIndex)
        return;//避免以下代码多次调用
    
    [model_video pauseAllPlayerLayerInPool];
    [model_video updatePlayerLayerByCurrentPlayerItemIndex];
    [self updateVideoContainer];
    lastCurrentPlayerItemIndex = model_video.currentPlayerItemIndex;
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [model_video playSinglePlayerItemByCurrentPlayerItemIndexIfExist_OtherWiseToDownloadIt:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_KEY_VIDEOPAGE_CHANGED object:nil];
}

#pragma mark - FGVideoModel
-(void)didUpdateSingleVideoProcess:(CGFloat)_percent atVideoIndex:(int)_downloadingIndex;
{
    if(_percent == 0)
        return;
    UILabel *_lb_progress = [self giveMeVideoProgressLabelAtVideoIndex:_downloadingIndex];
    [UIView animateWithDuration:.1 animations:^{
        _lb_progress.alpha = 1;
    }];
    NSLog(@"_percent = %f",_percent);
    _lb_progress.text = [NSString stringWithFormat:@"%@\n%d%%",multiLanguage(@"LOADING..."),(int)(_percent * 100.0f)];
}

-(void)didFinishDownloadSingleVideo:(NSString *)_str_downloadedfilePath
{
    NSString *str_currentFilePath = [model_video.arr_videoFilePaths objectAtIndex:model_video.currentPlayerItemIndex];
    NSLog(@"str_currentFilePath = %@",str_currentFilePath);
    NSLog(@"_str_downloadedfilePath = %@",_str_downloadedfilePath);
    if([model_video isLocaleFilePath:str_currentFilePath])//如果现在的文件就是当前要播放的文件 那么播放它
    {
        
        if([str_currentFilePath isEqualToString:_str_downloadedfilePath])
        {
            [model_video pauseAllPlayerLayerInPool];
            [model_video updatePlayerLayerByCurrentPlayerItemIndex];
            [self updateVideoContainer];
            [model_video playCurrentPlayerLayer];
        }
    }
}

-(void)didFinishDownloadAllVideos:(FGVideoModel *)_model
{
    
}

#pragma mark - 处理程序生命周期  如果程序中断 那么暂停视频
-(void)applicationWillResignActive:(UIApplication *)application
{
   
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if(model_video)
    {
        [model_video pauseAllPlayerLayerInPool];
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if(model_video)
    {
        
        [model_video pauseAllPlayerLayerInPool];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if(model_video)
    {
        
        [model_video playCurrentPlayerLayer];
    }

    
}
@end

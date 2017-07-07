    //
    //  FGVideoStatusMachine.m
    //  DurexBaby
    //
    //  Created by luyang on 12-8-24.
    //  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
    //

#import "FGVideoModel.h"
#import "Global.h"

#define KEY_FILE_DOWNLOAD_PATH @"KEY_FILE_DOWNLOAD_PATH"
#define KEY_FILENAME @"KEY_FILENAME"

static FGVideoModel *videoModel;


@interface FGVideoModel()
{
     unsigned long long videoTotalFileSize;
     unsigned long long currentDownloadedVideoFileSize;
     unsigned long long existedFileSize;
    
    NSMutableArray *arr_requestPool;//我发现队列里会有不是我自己添加的request(可能ASI自己创建了一些请求),用这个数组保存我自己发起的请求
}
@end

@implementation FGVideoModel
#pragma mark - 属性
@synthesize arr_urlInfos;
@synthesize arr_urls;
@synthesize arr_videoFilePaths;
@synthesize arr_playerLayerPool;
@synthesize arr_playerItemPool;
@synthesize arr_videoPlayRemaingCount;
@synthesize delegate_download;
@synthesize delegate_playVideoQueue;
@synthesize playerLayer_playVideoQueue;
@synthesize totoalTime_playVideoQueue;
@synthesize currentTime_playVideoQueue;
@synthesize currentPlayerItemIndex;
@synthesize asiQueue;
@synthesize arr_PlayerItemIndexPool;
@synthesize arr_videoPlayedCount;
@synthesize arr_videoNeedPlayCount;

@synthesize arr_audioUrls;
@synthesize audioPlayer;
@synthesize arr_audioFilePaths;
@synthesize arr_audioPlayAtCount;
@synthesize currentDownloadingVideoIndex;
@synthesize isVideoRollbacking;
#pragma mark - 生命周期
+(FGVideoModel *)sharedModel
{
	@synchronized(self)     {
		if(!videoModel)
		{
			videoModel=[[FGVideoModel alloc]init];
			return videoModel;
		}
	}
	return videoModel;
}

-(id)init
{
    if(self = [super init])
    {
        arr_playerLayerPool = [[NSMutableArray alloc] initWithCapacity:3];
        arr_playerItemPool = [[NSMutableArray alloc] initWithCapacity:1];
        arr_videoFilePaths = [[NSMutableArray alloc] initWithCapacity:1];
      //  arr_requestPool = [[NSMutableArray alloc] initWithCapacity:1];
        arr_urlInfos = [[NSMutableArray alloc] initWithCapacity:1];
        arr_urls = [[NSMutableArray alloc] initWithCapacity:1];
        arr_PlayerItemIndexPool = [[NSMutableArray alloc] initWithCapacity:3];
        arr_videoPlayRemaingCount = [[NSMutableArray alloc] initWithCapacity:1];
        arr_videoPlayedCount = [[NSMutableArray alloc] initWithCapacity:1];
        
        arr_audioUrls = [[NSMutableArray alloc] initWithCapacity:1];
        arr_audioFilePaths = [[NSMutableArray alloc] initWithCapacity:1];
        arr_audioPlayAtCount = [[NSMutableArray alloc] initWithCapacity:1];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
    }
    return self;
}

+(id)alloc
{
    @synchronized(self)     {
        NSAssert(videoModel == nil, @"企圖重复創建一個singleton模式下的FGVideoStatusMachine");
        return [super alloc];
    }
    return nil;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];

    [playerLayer_playVideoQueue removeFromSuperlayer];
  //  arr_requestPool = nil;
    arr_videoFilePaths = nil;
    arr_playerLayerPool = nil;
    arr_playerItemPool = nil;
    playerLayer_playVideoQueue = nil;
    arr_urls = nil;
    arr_urlInfos = nil;
    arr_PlayerItemIndexPool = nil;
    arr_videoPlayRemaingCount = nil;
    arr_videoPlayedCount = nil;
    arr_videoNeedPlayCount = nil;
    audioPlayer = nil;
    arr_audioFilePaths = nil;
    arr_audioUrls = nil;
    arr_audioPlayAtCount = nil;
}


#pragma mark - 外部方法

#pragma mark 公用
/*用当前文件路径数组 初始化arr_playerItemPool (视频文件播放项)*/
-(void)initalAllPlayerItemsByCurrentFilePaths
{
    [self do_initalAllPlayerItemsByFilePaths:arr_videoFilePaths];
}

/*初始化文件路径数组 这个数组模型可标示 哪些没下载 哪些下载了*/
-(void)internalInitalFilePathsByUrls:(NSMutableArray *)_arr_videoUrls
{
    [arr_videoFilePaths removeAllObjects];
    for(int i=0 ; i < [_arr_videoUrls count];i++)
    {
        NSString *_str_url = [_arr_videoUrls objectAtIndex:i];
        NSString *_str_filename = [self convertUrlToFilePaths:_str_url];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        //目的路径，设置一个目的路径用来存储下载下来的文件
        NSString *savePath = [path stringByAppendingPathComponent:_str_filename];
        if(![self isFileExsitAtPath:savePath])
        {
            [arr_videoFilePaths addObject:_str_url];
        }//如果url对应的文件名不在本地 那么就用url表示路径 ，界面看到路径 是 http url 时 就知道还没下载过这个视频
        else
        {
            [arr_videoFilePaths addObject:savePath];
        }//如果文件名已经存在，那么就用本地路径表示 界面就会从本地路径去加载视频
    }
}

/*判断是否时http:// 或 https://风格的URL*/
-(BOOL)isUrlsScheme:(NSString *)_str
{
    if([_str hasPrefix:@"http://"] || [_str hasPrefix:@"https://"])
        return YES;
    else
        return NO;
}

/*判断是否是本地路径*/
-(BOOL)isLocaleFilePath:(NSString *)_str
{
    if([self isUrlsScheme:_str])
    {
        return NO;
    }
    else
        return YES;
}


-(void)cancelDownloading
{
    if(asiQueue)
    {
        asiQueue.delegate = nil;
        asiQueue.downloadProgressDelegate = nil;
        asiQueue.requestDidFinishSelector = nil;
        asiQueue.requestDidFailSelector = nil;
        [asiQueue.operations makeObjectsPerformSelector:@selector(clearDelegatesAndCancel)];
        [asiQueue cancelAllOperations];
        asiQueue = nil;
    }
}

+(void)clearVideoModel
{
    if(!videoModel)
        return;
    videoModel.delegate_download = nil;
    videoModel.delegate_playVideoQueue = nil;
    videoModel = nil;
}

#pragma mark step by step 用到的
/*初始化3个playerLayer 用于preview时轮流装载playerItem*/
-(void)initPlayerLayerPool
{
    [arr_playerLayerPool removeAllObjects];
    [arr_PlayerItemIndexPool removeAllObjects];
    
    for(int i=0;i<3;i++)
    {
        int startIndex = [self do_setupStartIndexOfPlayerItemIndex];
        AVPlayer *player = [[AVPlayer alloc]init];
        player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        [playerLayer.player pause];
        playerLayer.player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [arr_playerLayerPool addObject:playerLayer];
        [arr_PlayerItemIndexPool addObject:[NSNumber numberWithInt:startIndex + i]];
    }
    [self do_replacePlayerItemInPlayerLayerPool];
}

/*根据currentPlayerItemIndex 更新arr_PlayerItemIndexPool*/
-(void)updatePlayerLayerByCurrentPlayerItemIndex
{
    
    if(currentPlayerItemIndex == [self do_getmaxPlayerItemIndexInPlayerItemIndexPool])
    {
        if(currentPlayerItemIndex < [arr_videoFilePaths count]-1)
        {
            int indexOfNeedToBeReplace = [self do_getIndexOfMinimalPlayerItemIndex];
            int replaceWithPlayerItemIndex = currentPlayerItemIndex + 1;
            [arr_PlayerItemIndexPool replaceObjectAtIndex:indexOfNeedToBeReplace withObject:[NSNumber numberWithInt:replaceWithPlayerItemIndex]];
        }
    }//往右
    else if(currentPlayerItemIndex == [self do_getminPlayerItemIndexInPlayeItemIndexPool])
    {
        if(currentPlayerItemIndex != 0)
        {
            int indexOfNeedToBeReplace = [self do_getIndexOfMaxPlayerItemIndex];
            int replaceWithPlayerItemIndex = currentPlayerItemIndex - 1;
            [arr_PlayerItemIndexPool replaceObjectAtIndex:indexOfNeedToBeReplace withObject:[NSNumber numberWithInt:replaceWithPlayerItemIndex]];
        }
        
    }//往左
    
    
    [self do_replacePlayerItemInPlayerLayerPool];
}



/*播放currentPlayerItemIndex 指定的视频*/
-(void)playCurrentPlayerLayer
{
    AVPlayerLayer *_playerLayer = [self do_getPlayerLayerByPlayerItemIndex:currentPlayerItemIndex];
    [self do_playSinglePlayerItemInPlayerLayer:_playerLayer];
}

/* 根据currentPlayerItemIndex 播放单个playerLayer 如果 不存在 那么就去下载*/
-(void)playSinglePlayerItemByCurrentPlayerItemIndexIfExist_OtherWiseToDownloadIt
{
    [self do_startDownloadVideosByURLsUseASIQueueIfNeeded:arr_urls audioUrls:nil];
    [self playSinglePlayerItemByCurrentPlayerItemIndexIfExist_OtherWiseToDownloadIt:NO];
}

/*根据currentPlayerItemIndex 播放单个playerLayer 如果 不存在 那么就去下载*/
-(void)playSinglePlayerItemByCurrentPlayerItemIndexIfExist_OtherWiseToDownloadIt:(BOOL)isResetDownload
{
    /*  NSLog(@":::::>%s %d",__FUNCTION__,__LINE__);
     NSLog(@"arr_videoFilePaths = %@",arr_videoFilePaths);
     NSLog(@"arr_playerItemPool = %@",arr_playerItemPool);
     NSLog(@"arr_playerLayerPool = %@",arr_playerLayerPool);
     NSLog(@"arr_urls = %@",arr_urls);*/
    id obj = [arr_videoFilePaths objectAtIndex:currentPlayerItemIndex];
    if([self isUrlsScheme:obj])
    {
            //if(isResetDownload)
            {
               
                [self do_startDownloadVideosByURLsUseASIQueueIfNeeded:arr_urls audioUrls:nil];//每次step by step翻页都重置 队列 不然优先级可能会出错
                
            }
            NSLog(@"arr_videoFilePaths = %@",arr_videoFilePaths);
            [self do_setDownloadThreadPriorityByCurrentPlayerItemIndex];
    }
    else
    {
        NSLog(@"::::::>start play :%@",obj);
        [self playCurrentPlayerLayer];
    }
}

/*根据playerItemIndex 判断 是否有必要把playerLayer添加到view中*/
-(void)updatePlayerLayerToVideoContainViewIfNeeded:(UIView *)_view_videoContainer playerItemIndex:(int)_comparePlayerItemIndex
{
    
    if(![arr_playerItemPool objectAtIndex:_comparePlayerItemIndex])
        return;
    
    for(NSNumber *num in arr_PlayerItemIndexPool)
    {
        int _playerItemIndex = [num intValue];
        if(_playerItemIndex == _comparePlayerItemIndex)
        {
            AVPlayerLayer *_playerLayer = [self do_getPlayerLayerByPlayerItemIndex:_playerItemIndex];
            [self do_resetSinglePlayerLayer:_playerLayer];
            [_playerLayer  removeFromSuperlayer];
            [_view_videoContainer.layer addSublayer:_playerLayer];
            _playerLayer.frame = _view_videoContainer.bounds;
            //          NSLog(@"show view on %ld",_view_videoContainer.tag-1);
        }
        
    }
}

/*暂停在arr_playerLayerPool中所有的视频*/
-(void)pauseAllPlayerLayerInPool
{
    for(AVPlayerLayer *_playerLayer in arr_playerLayerPool)
    {
        if(_playerLayer.player.currentItem)
        {
            [_playerLayer.player pause];
        }
    }
}

/*重置在arr_playerItemsPool中所有的视频*/
-(void)resetAllPlayerItemsInPool
{
    
    for(AVPlayerLayer *_playerLayer in arr_playerLayerPool)
    {
        if(_playerLayer.player.currentItem)
        {
            [_playerLayer.player pause];
        }
    }
    
    for(id obj in arr_playerItemPool)
    {
        if(![obj isEqual:VIDEO_NOT_EXIST_ON_LOCALE])
        {
            AVPlayerItem *_playerItem = (AVPlayerItem *)obj;
            [self do_resetSinglePlayerItem:_playerItem];
        }
    }
}

#pragma mark  播放器视频相关方法
/*用arr_playerItemPool中第一个个playerItem 来初始化playerLayer_playVideoQueue*/
-(void)initalVideoQueuePlayerLayer
{
    currentPlayerItemIndex = 0;
    playerLayer_playVideoQueue = [self do_initalSinglePlayerLayerByPlayerItem:[arr_playerItemPool objectAtIndex:currentPlayerItemIndex]];
    [playerLayer_playVideoQueue.player pause];
    playerLayer_playVideoQueue.player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    playerLayer_playVideoQueue.videoGravity = AVLayerVideoGravityResizeAspect;
}


/*确保playerLayer初始化成功的前提下 把playerLayer加到 视频容器视图 的 layer 中*/
-(void)addPlayerLayerToVideoContainerView:(UIView *)_view_videoContainer
{
    if(!playerLayer_playVideoQueue)
        return;
    _view_videoContainer.alpha = 0;
    [UIView animateWithDuration:2 animations:^{
        _view_videoContainer.alpha = 1;
    }];
    [_view_videoContainer.layer addSublayer:playerLayer_playVideoQueue];
    playerLayer_playVideoQueue.frame = _view_videoContainer.bounds;
}

/*确保playerLayer初始化成功的前提下 把playerLayer加到 视频容器视图 的 layer 中*/
-(void)addPlayerLayer:(AVPlayerLayer *)_playerLayer ToVideoContainerView:(UIView *)_view_videoContainer
{
    if(!_playerLayer)
        return;
    
    [_view_videoContainer.layer addSublayer:_playerLayer];
    _playerLayer.frame = _view_videoContainer.bounds;
}

/*过滤重复的video url 并记录下它重复的次数*/
-(void)filteRepeatedUrlAndRecordTheCount
{
    NSMutableArray *_arr_filtedUrls = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *_arr_filtedUrlsInfo = [NSMutableArray arrayWithCapacity:1];
    
    [arr_videoPlayedCount removeAllObjects];
    [arr_videoPlayRemaingCount removeAllObjects];
    int repeatCount = 1;
    NSString *_str_lasturl = @"xxx";
    
    for(int i=0;i<[arr_urls count];i++)
    {
        NSString *_str_url = [arr_urls objectAtIndex:i];
        if(![_str_url isEqualToString:_str_lasturl])
        {
            [_arr_filtedUrls addObject:_str_url];
            [_arr_filtedUrlsInfo addObject:[arr_urlInfos objectAtIndex:i]];
            if(i!=0)
            {
                [arr_videoPlayRemaingCount addObject:[NSNumber numberWithInt:repeatCount]];
                repeatCount = 1;
            }
        }
        else
        {
            repeatCount++;
        }
        
        if(i == [arr_urls count]-1)
        {
            [arr_videoPlayRemaingCount addObject:[NSNumber numberWithInt:repeatCount]];
        }
        _str_lasturl = _str_url;
    }
    [arr_urls removeAllObjects];
    [arr_urlInfos removeAllObjects];
    arr_urls = nil;
    arr_urlInfos = nil;
    
    arr_urls = [_arr_filtedUrls mutableCopy];
    arr_urlInfos = [_arr_filtedUrlsInfo mutableCopy];
    arr_videoNeedPlayCount = [arr_videoPlayRemaingCount mutableCopy];
    for(int i=0;i<[arr_urls count];i++)
    {
        [arr_videoPlayedCount addObject:[NSNumber numberWithInt:0]];
    }
    
    NSLog(@"arr_videoPlayedCount = %@[%ld]",arr_videoPlayedCount,arr_videoPlayedCount.count);
    NSLog(@"arr_videoPlayRemaingCount = %@[%ld]",arr_videoPlayRemaingCount,arr_videoPlayRemaingCount.count);
    NSLog(@"arr_videoNeedPlayCount = %@[%ld]",arr_videoNeedPlayCount,arr_videoNeedPlayCount.count);
    NSLog(@"arr_urlInfos = %@[%ld]",arr_urlInfos,arr_urlInfos.count);
    NSLog(@"arr_urls = %@[%ld]",arr_urls,arr_urls.count);
    NSLog(@"arr_audioUrls = %@[%ld]",arr_audioUrls,arr_audioUrls.count);
    NSLog(@"arr_audioPlayAtCount = %@[%ld]",arr_audioPlayAtCount,arr_audioPlayAtCount.count);
}

/*播放当前currentPlayerItemIndex指定的视频*/
-(void)playVideoByCurrentPlayerItemInVideoQueue
{
    [self do_continueToPlayerItem:[arr_playerItemPool objectAtIndex:currentPlayerItemIndex] inPlayerLayer:playerLayer_playVideoQueue];
    [self do_playSoundLogicAtVideoCount];
}

/*从外部 方便 调用 isUrlExistInVideoFilePathsArray*/
-(BOOL)isNeedDownloadByURLS:(NSMutableArray *)_arr_videoUrls audioURLS:(NSMutableArray *)_arr_audioUrls
{
    [self internalInitalFilePathsByUrls:_arr_videoUrls];
    [self internalInitalAudioFilePathsByUrls:_arr_audioUrls];
    return [self do_isUrlExistInVideoFilePathsAndAudioFilePath];
}


/*根据arr_videoUrl 和 arr_audioUrl 来初始化下载队列*/
-(BOOL)startDownloadVideosByURLsUseASIQueueIfNeeded:(NSMutableArray *)_arr_videoUrls audioUrls:(NSMutableArray *)_arr_audioUrls
{
    return [self do_startDownloadVideosByURLsUseASIQueueIfNeeded:_arr_videoUrls audioUrls:_arr_audioUrls];
}

-(BOOL)do_startDownloadVideosByURLsUseASIQueueIfNeeded:(NSMutableArray *)_arr_videoUrls audioUrls:(NSMutableArray *)_arr_audioUrls
{
    
    [self do_calculateLocaleFileSize];
    
    NSLog(@"locale videoTotalFileSize = %lld",existedFileSize/1024/1024);
    if(![self do_isUrlExistInVideoFilePathsAndAudioFilePath])
        return NO;
    
    
    
        if(!asiQueue)
            asiQueue=[[ASINetworkQueue alloc]init];//开启队列
        //[arr_requestPool removeAllObjects];
        [asiQueue.operations makeObjectsPerformSelector:@selector(clearDelegatesAndCancel)];
        [asiQueue reset];//nil
        asiQueue.showAccurateProgress=YES;//进度
    
   
    
    
    //    asiQueue.downloadProgressDelegate = self;//下载进度的代理，用于断点续传
    asiQueue.delegate = self;
    [asiQueue setMaxConcurrentOperationCount:1];
    asiQueue.requestDidFinishSelector = @selector(didFinishDownloadVideosInQueue:);
    
    
    
    NSMutableArray *_arr_removeRepeat_video = [_arr_videoUrls removeRepeatObj];//即便arr_urls已经过滤掉 临近重复的数据 但是对于下载来说 还要再过滤掉不临近重复的url
    
    NSMutableArray *_arr_removeRepeat_audio = [_arr_audioUrls removeRepeatObj];//即便arr_urls已经过滤掉 临近重复的数据 但是对于下载来说 还要再过滤掉不临近重复的url
    
    
    for(int i=0 ; i < [_arr_removeRepeat_video count];i++)
    {
        NSString *_str_url = [_arr_removeRepeat_video objectAtIndex:i];
        [self do_createSingleRequestByURL:_str_url  filePath:arr_videoFilePaths];
        
    }
    for(int i=0 ; i < [_arr_removeRepeat_audio count];i++)
    {
        NSString *_str_url = [_arr_removeRepeat_audio objectAtIndex:i];
        [self do_createSingleRequestByURL:_str_url filePath:arr_audioFilePaths];
        
    }
    
    [asiQueue go];
    
    return YES;
}

/*重置播放器的一些相关属性*/
-(void)resetVideoPlayQueue
{
    isVideoRollbacking =  NO;
    currentPlayerItemIndex = 0;
    [arr_videoPlayedCount removeAllObjects];
    for(int i=0;i<[arr_urls count];i++)
    {
        [arr_videoPlayedCount addObject:[NSNumber numberWithInt:0]];
    }
    arr_videoPlayRemaingCount = nil;
    arr_videoPlayRemaingCount = [arr_videoNeedPlayCount mutableCopy];
    [playerLayer_playVideoQueue.player replaceCurrentItemWithPlayerItem:[arr_playerItemPool objectAtIndex:currentPlayerItemIndex]];
}

/*移除playerLayer_playVideoQueue*/
-(void)finishVideoQueue
{
    isVideoRollbacking = NO;
    [playerLayer_playVideoQueue.player pause];
    
    [playerLayer_playVideoQueue removeFromSuperlayer];
    playerLayer_playVideoQueue = nil;
    
}

/*获得当前播放到第几个视频和总视频的 字符串*/
-(NSString *)giveMeCurrentPlayerItemIndexInAllItems
{
    NSString *_str_retval = [NSString stringWithFormat:@"%d / %ld",currentPlayerItemIndex + 1,[arr_playerItemPool count]];
    return _str_retval;
}

/*获得视频总时长的字符串*/
-(NSString *)giveMeTotalVideoTimeInQueue
{
    NSString *_str_retval = [NSString stringWithFormat:@"%@",[commond clockFormatBySeconds:[self do_giveMeTotalVideoDuration]] ];
    return _str_retval;
}

/*获得视频总剩余时长的字符串*/
-(NSString *)giveMeTotalVideoRemainingTimeInQueue
{
    NSString *_str_retval = [NSString stringWithFormat:@"%@",[commond clockFormatBySeconds:[self do_giveMeTotalRemainingVideoDuration]]];
    return _str_retval;
}

/*获得当前播放的视频剩余时长的字符串*/
-(NSString *)giveMeCurrentRemainingTimeWithClockFormat
{
    NSString *_str_retval = [NSString stringWithFormat:@"%@",[commond clockFormatBySeconds:[self do_giveMeCurrentRemainingVideoDuration]]];
    return _str_retval;
}

/*获得当前播放视频的进度值*/
-(float)giveMeCurrentVideoPlayedProcessInQueue
{
    
    float currentDuration = [self do_giveVideoDurationByPlayerItemIndex:currentPlayerItemIndex];
    float currentRemaining = [self do_giveMeCurrentRemainingVideoDuration];
    float _percent = currentRemaining / currentDuration;
    _percent = currentDuration == 0? 0 : _percent;
    return  _percent;
}

#pragma mark  播放器音频相关方法
/*根据音频url初始化arr_audioFilePath 如果url对应的文件名不在本地 那么就用url表示路径 如果文件名已经存在，那么就用本地路径表示*/
-(void)internalInitalAudioFilePathsByUrls:(NSMutableArray *)_arr_audioUrls
{
    [arr_audioFilePaths removeAllObjects];
    for(int i=0 ; i < [_arr_audioUrls count];i++)
    {
        NSString *_str_url = [_arr_audioUrls objectAtIndex:i];
        NSString *_str_filename = [self convertUrlToFilePaths:_str_url];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        //目的路径，设置一个目的路径用来存储下载下来的文件
        NSString *savePath = [path stringByAppendingPathComponent:_str_filename];
        if(![self isFileExsitAtPath:savePath])
        {
            [arr_audioFilePaths addObject:_str_url];
        }//如果url对应的文件名不在本地 那么就用url表示路径 ，界面看到路径 是 http url 时 就知道还没下载过这个视频
        else
        {
            [arr_audioFilePaths addObject:savePath];
        }//如果文件名已经存在，那么就用本地路径表示 界面就会从本地路径去加载视频
    }
}

/*过滤重复的audio url 并记录下它需要在video播放的第几遍播放*/
-(void)filteRepeatedAudioUrlAndRecordThePlayIndex
{
    if(!arr_urlInfos)
        return;
    
    if([arr_urlInfos count]<=0)
        return;
    
    [arr_audioPlayAtCount removeAllObjects];
    NSString *_str_lasturl = [[arr_urlInfos objectAtIndex:0] objectForKey:@"VideoUrl"];
    int repeatCount = 0;
    NSMutableArray *arr_singleAudioPlayAtCount = [NSMutableArray arrayWithCapacity:1];
    for(int i=0;i<[arr_urlInfos count];i++)
    {
        NSString *_str_url = [[arr_urlInfos objectAtIndex:i] objectForKey:@"VideoUrl"];
        NSString *_str_audioUrl = [[arr_urlInfos objectAtIndex:i] objectForKey:@"AudioUrl"];
        
        if(![_str_url isEqualToString:_str_lasturl])
        {
            repeatCount = 1;
            if(arr_singleAudioPlayAtCount)
                [arr_audioPlayAtCount addObject:arr_singleAudioPlayAtCount];
            arr_singleAudioPlayAtCount = [NSMutableArray arrayWithCapacity:1];
        }
        else
        {
            repeatCount++;
        }
        
        if(i == [arr_urlInfos count]-1)
        {
            [arr_audioPlayAtCount addObject:arr_singleAudioPlayAtCount];
        }
        
        if(_str_audioUrl && ![_str_audioUrl isEmptyStr])
        {
            [arr_singleAudioPlayAtCount addObject:[NSNumber numberWithInt:repeatCount]];
        }
        _str_lasturl = _str_url;
    }
    
}



/*暂停播放音频*/
-(void)pauseAudio
{
    if(!audioPlayer)
        return;
    
    [audioPlayer pause];
}

/*开始播放音频*/
-(void)playAudio
{
    if(!audioPlayer)
        return;
    
    NSLog(@"audioPlayer.currentTime = %f",audioPlayer.currentTime);
    if(audioPlayer.currentTime != 0)
        [audioPlayer play];
}



#pragma mark - 内部方法
#pragma mark 公用
/* 初始化单个PlayerItem*/
-(AVPlayerItem *)do_initalSinglePlayerItemByPath:(NSString *)str_filepath
{
    str_filepath = [str_filepath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:str_filepath] options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    return playerItem;
}


/* 根据playerItem初始化单个AVPlayerLayer*/
-(AVPlayerLayer *)do_initalSinglePlayerLayerByPlayerItem:(AVPlayerItem *)_playerItem
{
    /*
     AVF_EXPORT NSString *const AVLayerVideoGravityResizeAspect NS_AVAILABLE(10_7, 4_0);
     AVF_EXPORT NSString *const AVLayerVideoGravityResizeAspectFill NS_AVAILABLE(10_7, 4_0);
     AVF_EXPORT NSString *const AVLayerVideoGravityResize NS_AVAILABLE(10_7, 4_0);
     */
    AVPlayer *player = [[AVPlayer alloc]initWithPlayerItem:_playerItem];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [playerLayer.player pause];
    playerLayer.player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    return playerLayer;
}

/*初始化所有AVPlayerItem并存放到arr_playerItemPool中*/
-(void)do_initalAllPlayerItemsByFilePaths:(NSMutableArray *)_arr_filePaths
{
    [arr_playerItemPool removeAllObjects];
    for(NSString *str_filepath in _arr_filePaths)
    {
        if(![self isLocaleFilePath:str_filepath])
        {
            [arr_playerItemPool addObject:VIDEO_NOT_EXIST_ON_LOCALE];
        }
        else
        {
            AVPlayerItem *_playerItem = [self do_initalSinglePlayerItemByPath:str_filepath];
            [arr_playerItemPool addObject:_playerItem];
        }
        
    }
}



#pragma mark  播放器视频相关方法
/* 让一个 _playerLayer 播放下一个playerItem*/
-(void)do_continueToPlayerItem:(AVPlayerItem *)_playerItem inPlayerLayer:(AVPlayerLayer *)_playerLayer
{
    if(_playerLayer.player)
    {
        if(_playerLayer.player.status == AVPlayerStatusReadyToPlay)
        {
            isVideoRollbacking = YES;
            [_playerLayer.player replaceCurrentItemWithPlayerItem:_playerItem];
            [_playerLayer.player.currentItem seekToTime: kCMTimeZero
                                        toleranceBefore: kCMTimeZero
                                         toleranceAfter: kCMTimeZero
                                      completionHandler: ^(BOOL finished)
             {
                 if(finished)
                 {
                     isVideoRollbacking = NO;
                    [_playerLayer.player play];
                 }
                 
             }];
            
        }
        else if(_playerLayer.player.status == AVPlayerStatusUnknown)
        {
            [_playerLayer.player play];
        }
        
    }
    
}

//<<<<<======================================与计算播放器 时间相关的方法===========================================>>>>>>>>>>>
/*根据playerItem获得 单个视频时长*/
-(float )do_giveVideoDurationByPlayerItemIndex:(NSInteger )_playerItemIndex//fixed
{
    AVPlayerItem *_playerItem = [arr_playerItemPool  objectAtIndex:_playerItemIndex];
    float singleDuration = _playerItem.asset.duration.value/_playerItem.asset.duration.timescale;
    int repeatCount = [[arr_videoNeedPlayCount objectAtIndex:_playerItemIndex] intValue];
    return singleDuration * (float)repeatCount;
}

/*根据playerItem获得 单个视频当前播放的时长*/
-(float)do_giveVideoCurrentTimeByPlayerItemIndex:(NSInteger)_playerItemIndex//fixed
{
    AVPlayerItem *_playerItem = [arr_playerItemPool  objectAtIndex:_playerItemIndex];
    float singleCurrentTime = _playerItem.currentTime.value/_playerItem.currentTime.timescale;
    float singleDuration = _playerItem.asset.duration.value/_playerItem.asset.duration.timescale;
    int playedTimes = [[arr_videoPlayedCount objectAtIndex:_playerItemIndex] intValue];
    float currentTime = (float)playedTimes * singleDuration + singleCurrentTime;
    return currentTime;
}

/*计算arr_playerItemPool 中所有 视频 item 的总时长*/
-(float)do_giveMeTotalVideoDuration//fixed
{
    totoalTime_playVideoQueue = 0;
    for(int i=0;i<[ arr_playerItemPool count];i++)
    {
        totoalTime_playVideoQueue += [self do_giveVideoDurationByPlayerItemIndex:i];
    }
    
    return totoalTime_playVideoQueue;
}

/*返回当前剩余要播放的时间*/
-(float)do_giveMeTotalRemainingVideoDuration//fixed
{
    currentTime_playVideoQueue = [self do_giveMeCurrentTimeInPlayerItemPools];
    float totalDuration = [self do_giveMeTotalVideoDuration];
    float remainingTime = totalDuration - currentTime_playVideoQueue;
    return remainingTime;
}

/*计算arr_playerItemPool 中下标 currentPlayerItemIndex 之前的 视频的总时长*/
-(float)do_giveMeTotalVideoDurationByCurrentPlayerItemIndex//fixed
{
    float totalDurationBeforeIndex = 0;
    for(int i=0 ; i<currentPlayerItemIndex; i++)
    {
        totalDurationBeforeIndex += [self do_giveVideoDurationByPlayerItemIndex:i];
    }
    return totalDurationBeforeIndex;
}

/*计算arr_playerItemPool中下标 currentPlayerItemIndex 正在播放的那个视频的 时长*/
-(float)do_giveMeCurrentPlayerItemTime//fixed
{
    float _currentPlayedTime = [self do_giveVideoCurrentTimeByPlayerItemIndex:currentPlayerItemIndex];
    return _currentPlayedTime;
}

/*返回当前正在播放的视频的剩余时间*/
-(float)do_giveMeCurrentRemainingVideoDuration//fixed
{
    float currentDuration = [self do_giveVideoDurationByPlayerItemIndex:currentPlayerItemIndex];
    float currentPlayed = [self do_giveMeCurrentPlayerItemTime];
    float currentRemaining = currentDuration - currentPlayed;
    return currentRemaining;
}

/*计算arr_playerItemPool中下标 currentPlayerItemIndex 正在播放的那个视频 占所有视频长度的 时长*/
-(float)do_giveMeCurrentTimeInPlayerItemPools//fixed
{
    float totalDurationBeforeIndex = [self do_giveMeTotalVideoDurationByCurrentPlayerItemIndex];
    float _currentPlayedTime = [self do_giveMeCurrentPlayerItemTime];
    currentTime_playVideoQueue = totalDurationBeforeIndex + _currentPlayedTime;
    return currentTime_playVideoQueue;
}
//<<<<<======================================与计算播放器 时间相关的方法===========================================>>>>>>>>>>>



#pragma mark  播放器音频相关方法
/*根据当前播放视频的下标 播放音频 不支持视频循环播放时播放不同音频*/
-(void)do_playSoundBycurrentPlayerItemIndex
{
    
    
    
    if(audioPlayer)
    {
        [audioPlayer stop];
        audioPlayer = nil;
    }
    
    NSString *_str_filepath;
    if(arr_urlInfos && [arr_urlInfos count]>0)
    {
        NSMutableDictionary *_dic_singleInfo = [arr_urlInfos objectAtIndex:currentPlayerItemIndex];
        NSString *_str_audioUrl = [_dic_singleInfo objectForKey:@"AudioUrl"];
        
        if([self isUrlsScheme:_str_audioUrl])
        {
            NSString *str_filename = [self convertUrlToFilePaths:_str_audioUrl];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            //目的路径，设置一个目的路径用来存储下载下来的文件
            _str_filepath = [path stringByAppendingPathComponent:str_filename];
        }
        else
        {
            _str_filepath = [[NSBundle mainBundle] pathForResource:_str_audioUrl ofType:@"mp3"];//读取本地音频文件
        }
        
        
        
        
        audioPlayer =[ [AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:_str_filepath] error:nil];
        [audioPlayer prepareToPlay];
        audioPlayer.numberOfLoops=0;
        [audioPlayer play];
        
        
        NSLog(@"arr_audioFilePaths = %@[%ld]",arr_audioFilePaths,arr_audioFilePaths.count);
        NSLog(@"_str_filepath = %@",_str_filepath);
    }
   
    
   
}

/*根据arr_videoPlayedCount中保存的信息 决定在当前视频循环到第几次的时候 播放音频*/
-(void)do_playSoundLogicAtVideoCount
{
    if(!arr_audioFilePaths)
        return;
    if([arr_audioFilePaths count] <= 0)
        return;
    
    
    int _videoPlayedCount = [[arr_videoPlayedCount objectAtIndex:currentPlayerItemIndex] intValue];//arr_videoPlayedCount中保存了应该在每个视频的第几个循环播放音频
    NSMutableArray *_arr_currentAudioPlayAtCount = [arr_audioPlayAtCount objectAtIndex:currentPlayerItemIndex];
    BOOL isNeedPlaySound = NO;
    for(NSNumber *playAtCount in _arr_currentAudioPlayAtCount)
    {
        if([playAtCount intValue] - 1 == _videoPlayedCount)
        {
            isNeedPlaySound = YES;
        }
    }
    
    if(!isNeedPlaySound)
        return;
    
    /*以下代码实际播放音频 在单个视频循环的第几秒播放*/
    NSMutableDictionary *_dic_singleInfo = [arr_urlInfos objectAtIndex:currentPlayerItemIndex];
    if([_dic_singleInfo isKindOfClass:[NSMutableDictionary class]] && [[_dic_singleInfo allKeys] containsObject:@"AudioStart"])
    {
        float audioStartAtTime = [[_dic_singleInfo objectForKey:@"AudioStart"] floatValue];//需要播放的音频的时间
        float leadValue = .5;
        audioStartAtTime = audioStartAtTime - leadValue <=0 ? 0 : audioStartAtTime - leadValue;//修正音频播放时间，因为音频初始化需要时间
        NSLog(@"audioStartAtTime = %f",audioStartAtTime);
        [self performSelector:@selector(do_playSoundBycurrentPlayerItemIndex) withObject:nil afterDelay:audioStartAtTime];//过 audioStartAtTime 秒 后播放音频
    }
}

#pragma mark  step by step 视频相关
/*根据playerItemIndex获得PlayerLayer*/
-(AVPlayerLayer *)do_getPlayerLayerByPlayerItemIndex:(int)_playerItemIndex
{
    int index= 0;
    for(int i = 0;i<[arr_PlayerItemIndexPool count];i++)
    {
        NSNumber *num = [arr_PlayerItemIndexPool objectAtIndex:i];
        int playerItemIndex = [num intValue];
        if(playerItemIndex == _playerItemIndex)
            index = i;
        
    }
    AVPlayerLayer *_playerLayer = [arr_playerLayerPool objectAtIndex:index];
    return _playerLayer;
}

//<<<<<===============与更新 playerItemIndexPool 相关, playerItemIndexPool里的内容是 playerItemPool中的下标=================
/*根据currentPlayerItemIndex 初始化 playerLayerPool中 playerItemIndex 的 起始值*/
-(int)do_setupStartIndexOfPlayerItemIndex
{
    int startIndex = 0;
    if(currentPlayerItemIndex==[arr_videoFilePaths count] - 1)
    {
        startIndex = currentPlayerItemIndex - 2;
    }
    else if(currentPlayerItemIndex == 0)
    {
        startIndex = 0;
    }
    else
    {
        startIndex = currentPlayerItemIndex-1;
    }
    return startIndex;
}

/*获得arr_PlayerItemIndexPool中 playerItemIndex 最小的值*/
-(int)do_getminPlayerItemIndexInPlayeItemIndexPool
{
    int minPlayerItemIndex = INT_MAX;
    for(NSNumber *_playerItemIndex in arr_PlayerItemIndexPool)
    {
        int playerItemIndex = [_playerItemIndex intValue];
        if(playerItemIndex < minPlayerItemIndex)
            minPlayerItemIndex = playerItemIndex;
    }
    return minPlayerItemIndex;
}
/*获得arr_PlayerItemIndexPool中 playerItemIndex 最大的值*/
-(int)do_getmaxPlayerItemIndexInPlayerItemIndexPool
{
    int maxPlayerItemIndex = -1;
    for(NSNumber *_playerItemIndex in arr_PlayerItemIndexPool)
    {
        int playerItemIndex = [_playerItemIndex intValue];
        if(playerItemIndex > maxPlayerItemIndex)
            maxPlayerItemIndex = playerItemIndex;
    }
    return maxPlayerItemIndex;
}

/*获得arr_PlayerItemIndexPool 中 最小值的下标*/
-(int)do_getIndexOfMinimalPlayerItemIndex
{
    int minPlayerItemIndex = INT_MAX;
    int index = 0;
    for(int i=0;i<[arr_PlayerItemIndexPool count];i++)
    {
        NSNumber *num = [arr_PlayerItemIndexPool objectAtIndex:i];
        int playerItemIndex = [num intValue];
        if(playerItemIndex < minPlayerItemIndex)
        {
            minPlayerItemIndex = playerItemIndex;
            index = i;
        }
        
    }
    return index;
}

/*获得arr_PlayerItemIndexPool 中 最大值的下标*/
-(int)do_getIndexOfMaxPlayerItemIndex
{
    int maxPlayerItemIndex = -1;
    int index = 0;
    for(int i=0;i<[arr_PlayerItemIndexPool count];i++)
    {
        NSNumber *num = [arr_PlayerItemIndexPool objectAtIndex:i];
        int playerItemIndex = [num intValue];
        if(playerItemIndex > maxPlayerItemIndex)
        {
            maxPlayerItemIndex = playerItemIndex;
            index = i;
        }
        
    }
    return index;
}
//===============与更新 playerItemIndexPool 相关, playerItemIndexPool里的内容是 playerItemPool中的下标=================>>>>


/*根据arr_PlayerItemIndexPool 中的playerItemIndex 信息替换playerLayer中的playerItem*/
-(void)do_replacePlayerItemInPlayerLayerPool
{
    for(NSNumber *num in arr_PlayerItemIndexPool)
    {
        int playerItemIndex = [num intValue];
        AVPlayerLayer * _playerLayer = [self do_getPlayerLayerByPlayerItemIndex:playerItemIndex];
        id obj = [arr_playerItemPool objectAtIndex:playerItemIndex];
        if(![obj isEqual:VIDEO_NOT_EXIST_ON_LOCALE])
        {
            AVPlayerItem *_playerItem = (AVPlayerItem *)obj;
            [_playerLayer.player replaceCurrentItemWithPlayerItem:_playerItem];
            _playerLayer.hidden = NO;
        }
        else
        {
            _playerLayer.hidden = YES;
        }
        
    }
}

/*播放单个playerLayer*/
-(void)do_playSinglePlayerItemInPlayerLayer:(AVPlayerLayer *)_playerLayer
{
    if(_playerLayer.player)
    {
        if(_playerLayer.player.status == AVPlayerStatusReadyToPlay)
        {
            isVideoRollbacking = YES;
            [_playerLayer.player replaceCurrentItemWithPlayerItem:_playerLayer.player.currentItem];
            [_playerLayer.player.currentItem seekToTime: kCMTimeZero
                                        toleranceBefore: kCMTimeZero
                                         toleranceAfter: kCMTimeZero
                                      completionHandler: ^(BOOL finished)
             {
                 
                 if(finished)
                 {
                     isVideoRollbacking = NO;
                     [_playerLayer.player play];
                 }
                 
             }];
        }
        else if(_playerLayer.player.status == AVPlayerStatusUnknown)
        {
            [_playerLayer.player play];
        }
        
    }
}

/*重置一个playerItem的视频状态*/
-(void)do_resetSinglePlayerItem:(AVPlayerItem *)_playerItem
{
    if(_playerItem && _playerItem.status == AVPlayerItemStatusReadyToPlay)
    {
        isVideoRollbacking = YES;
        [_playerItem seekToTime: kCMTimeZero
                                        toleranceBefore: kCMTimeZero
                                         toleranceAfter: kCMTimeZero
                                      completionHandler: ^(BOOL finished)
            {
                if(finished)
                {
                    isVideoRollbacking = NO;
                }
            }
         
         ];
        
    }
}

/*重置一个PlayerLayer的视频状态*/
-(void)do_resetSinglePlayerLayer:(AVPlayerLayer *)_playerLayer
{
    if(_playerLayer.player)
    {
        if(_playerLayer.player.status == AVPlayerStatusReadyToPlay )
        {
            isVideoRollbacking = YES;
            [_playerLayer.player pause];
            [_playerLayer.player.currentItem seekToTime: kCMTimeZero
                                        toleranceBefore: kCMTimeZero
                                         toleranceAfter: kCMTimeZero
                                      completionHandler: ^(BOOL finished)
             {
                 if(finished)
                 {
                     isVideoRollbacking = NO;
                 }
             }];
        }
    }
}



#pragma mark - 下载和本地文件相关方法
#pragma mark 公用
//<<<<<<<<=================================文件相关============================>>>>>>>>
/*判断一个文件是否存在*/
-(BOOL)isFileExsitAtPath:(NSString *)_str_filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:_str_filePath];
    return  fileExists;
}

/*把一个url 转换成文件名*/
-(NSString *)convertUrlToFilePaths:(NSString *)_str_videoUrl
{
    _str_videoUrl = [_str_videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *_str_filename = [_str_videoUrl stringByReplacingOccurrencesOfString:@"://" withString:@"__"];
    _str_filename = [_str_filename stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return _str_filename;
}

/*获取单个文件的文件大小*/
-(unsigned long long)do_giveMeFileSizeByFilPath:(NSString *)_str_filePath
{
    NSFileManager *fileManager  = [NSFileManager defaultManager];
    NSError *error = nil;
    NSDictionary* dictFile = [fileManager attributesOfItemAtPath:_str_filePath error:&error];
    
    if (error)
    {
        NSLog(@"getfilesize error: %@", error);
        return 0;
    }
    
    unsigned long long nFileSize = [dictFile fileSize]; //得到文件大小
    return nFileSize;
}

/*计算总共的已下载文件大小(包括已经下载和未下载的 视频和音频)*/
-(void)do_calculateLocaleFileSize
{
    existedFileSize = 0;
    NSMutableArray *_arr_videofilePath_removeRepeat = [arr_videoFilePaths removeRepeatObj];
    for(NSString *_str_urlOrFilePath in _arr_videofilePath_removeRepeat)
    {
        if([self isLocaleFilePath: _str_urlOrFilePath])
        {
            existedFileSize += [self do_giveMeFileSizeByFilPath:_str_urlOrFilePath];
            NSLog(@"%@ : %lld",_str_urlOrFilePath,[self do_giveMeFileSizeByFilPath:_str_urlOrFilePath]);
        }
    }//统计本地已下载的视频文件的总和
    
    NSMutableArray *_arr_audiofilePath_removeRepeat = [arr_audioFilePaths removeRepeatObj];
    for(NSString *_str_urlOrFilePath in _arr_audiofilePath_removeRepeat)
    {
        if([self isLocaleFilePath: _str_urlOrFilePath])
        {
            existedFileSize += [self do_giveMeFileSizeByFilPath:_str_urlOrFilePath];
        }
    }//统计本地已下载的音频文件的总和
}

//计算总计需下载的文件大小
-(void)do_calculateVideoTotalSize
{
    if(!asiQueue)
        return;
    
    videoTotalFileSize = existedFileSize + asiQueue.totalBytesToDownload;
}

//计算队列中当前已下载的文件大小
-(void)do_calculateCurrentDownloadedVideoSize
{
    if(!asiQueue)
        return;
    
    currentDownloadedVideoFileSize = existedFileSize + asiQueue.bytesDownloadedSoFar;
}
//<<<<<<<<=================================文件相关============================>>>>>>>>


-(void)do_createSingleRequestByURL:(NSString *)_str_url  filePath:(NSMutableArray *)_arr_filePath
{
    
    
    NSURL *url = [NSURL URLWithString:[_str_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *_str_filename = [self convertUrlToFilePaths:_str_url];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    //目的路径，设置一个目的路径用来存储下载下来的文件
    NSString *savePath = [path stringByAppendingPathComponent:_str_filename];
    //    NSLog(@"savePath = %@",savePath);
    if([_arr_filePath containsObject:savePath])
    {
        return;
    }//如果本地已经存在 ，跳过到下一个url连接
    
    /*
     临时路径:
     1.设置一个临时路径用来存储下载过程中的文件
     2.当下载完后会把这个文件拷贝到目的路径中，并删除临时路径中的文件
     3.断点续传：当设置断点续传的属性为YES后，每次执行都会到临时路径中寻找要下载的文件是否存在，下载的进度等等。。。然后就会在此基础上继续下载，从而实现续传的效果
     设置临时路径在这个过程中是相当重要的。。。
     */
    NSString *temp = [path stringByAppendingPathComponent:@"temp"];
    
    /*
     又在临时路径中添加了一个mp3格式的文件,这就相当于设置了一个假的要下载的文件，其实是不存在的，可以这么理解：这里提供了一个容器，下载的内容填充到了这个容器中。
     这个容器是必须要设置的，要不然它会不知道要下载到什么里面。。。
     
     会有人说：问什么不和上面的临时路径拚在一起，不是一样么：NSString *temp = [path stringByAppendingPathComponent:@"temp/qgw.mp3"];
     这是不行的，因为你的临时路径必须要保证是正确的、是拥有的，所以在下面你要用NSFileManager来判断是否存在这么一个路径，如果不存在就去创建，
     当你创建的时候会把qgw.mp3当作是一个文件夹来创建的，所以每次断点续传的时候都会进入到qgw.mp3这个文件夹中寻找，当然是找不到的（因为qwg.mp3就是）
     so，要分开来写。。。
     
     */
    NSString *tempPath = [temp stringByAppendingPathComponent:_str_filename];
    
    if(![self isFileExsitAtPath:temp])//判断temp文件夹是否存在
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:temp
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }//如果不存在则创建,因为下载时,不会自动创建文件夹
    
    
    
    /*加入单个下载任务*/
    ASIHTTPRequest *asiHttpRequest=[ASIHTTPRequest requestWithURL:url];
    
    asiHttpRequest.delegate=self;
    asiHttpRequest.downloadProgressDelegate = self;
    asiHttpRequest.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                               _str_filename,KEY_FILENAME ,
                               savePath,KEY_FILE_DOWNLOAD_PATH,nil];
    
    [ asiHttpRequest setDownloadDestinationPath:savePath ];//下载路径
    [ asiHttpRequest setTemporaryFileDownloadPath:tempPath ];//临时路径，一定要设置临时路径。。
    asiHttpRequest.allowResumeForFileDownloads = YES;//打开断点，是否要断点续传
    asiHttpRequest.downloadProgressDelegate = self;//下载进度的代理，用于断点续传
    [asiQueue addOperation:asiHttpRequest];//加入队列
   // [arr_requestPool addObject:asiHttpRequest];
    NSLog(@"::::::>create download url:%@",_str_url);
}

#pragma mark  播放器视频相关
/*判断arr_videoFilePaths和arr_audioFilePaths数组中是否存在http url 如果不存在 说明没有url需要下载*/
-(BOOL)do_isUrlExistInVideoFilePathsAndAudioFilePath
{
    BOOL isVideoExist = NO;
    BOOL isAudioExist = NO;
    for(NSString *_str_urlOrFilePath in arr_videoFilePaths)
    {
        if([self isUrlsScheme: _str_urlOrFilePath])
        {
            isVideoExist = YES;
        }
    }
    for(NSString *_str_urlOrFilePath in arr_audioFilePaths)
    {
        if([self isUrlsScheme: _str_urlOrFilePath])
        {
            isAudioExist = YES;
        }
    }
    
    return isVideoExist || isAudioExist;
}

#pragma mark step by step 下载相关
/*step by step 下载优先级算法 设置当前正要播放的视频 为最优先  两边为次  其他再次*/
-(void)do_setDownloadThreadPriorityByCurrentPlayerItemIndex
{
    if(!asiQueue)
        return;
    
    NSMutableArray *arr_indexSort = [NSMutableArray array];//下标排序数组,最接近当前下标的下标排最前面
    
    for(int i=0;i<[arr_videoFilePaths count] ;i++)
    {
        int closestDistance = INT_MAX;
        int closestIndex = 0;
        for(int videoIndex = 0 ; videoIndex<[arr_videoFilePaths count];videoIndex++)
        {
            
                if(![arr_indexSort containsObject:[NSNumber numberWithInt:videoIndex]])//排过的过滤掉
                {
                    int distance = videoIndex - currentPlayerItemIndex;//距离当前下标的实际位置,正值代表在当前下标之后，反之在前
                    
                    if( abs(distance) <= closestDistance )
                    {
                        closestDistance = abs(distance);
                        closestIndex = videoIndex;
                    }
                    
                }
        }
        [arr_indexSort addObject:[NSNumber numberWithInt:closestIndex]];//把最近的下标放入排序数组
        
    }//构建下标排序数组,最接近当前下标的下标排最前面
    NSLog(@"arr_indexSort = %@",arr_indexSort);
    currentDownloadingVideoIndex = [[arr_indexSort firstObject] intValue];
    NSMutableArray *_arr_downloadPriority = [NSMutableArray arrayWithCapacity:1];//装载按优先级排序的url地址
    for(NSInteger i=0;    i<[arr_indexSort count];   i++)
    {
        int videoIndex = [[arr_indexSort objectAtIndex:i] intValue];
        NSString *_str_urlOrFilePath = [arr_videoFilePaths objectAtIndex:videoIndex];
        if([self isUrlsScheme:_str_urlOrFilePath])
        {
            [_arr_downloadPriority addObject:_str_urlOrFilePath];
        }
    }
    
    _arr_downloadPriority = [_arr_downloadPriority removeRepeatObj];//去除重复项
    NSLog(@"_arr_downloadPriority = %@",_arr_downloadPriority);
    
    
    int priority[5] = {
        NSOperationQueuePriorityVeryHigh,
        NSOperationQueuePriorityHigh,
        NSOperationQueuePriorityNormal,
        NSOperationQueuePriorityLow,
        NSOperationQueuePriorityVeryLow};
    
    for(ASIHTTPRequest *_request in asiQueue.operations)
    {
        _request.queuePriority = NSOperationQueuePriorityVeryLow;
    }//重置优先级

    for(int i = 0 ; i<[_arr_downloadPriority count];i++)
    {
        NSString *_str_priorityUrl = [_arr_downloadPriority objectAtIndex:i];
        for(ASIHTTPRequest *_request in asiQueue.operations)
        {
          //  NSLog(@"_request.url = %@",_request.url);
            
            NSString *_str_requestUrl = [_request.url absoluteString];
            
            if([_str_requestUrl isEqualToString:_str_priorityUrl])
            {
                NSLog(@"::::>priority[%d] %@",i,_str_requestUrl);
                if(i<5)
                {
                    _request.queuePriority = priority[i];
                }
                else
                {
                    _request.queuePriority = priority[4];
                }
                
            }
        }
    }//优先级赋值
}

/*根据本地文件路径 和 下标 创建一个playerItem 并加到arr_playerItemPool中*/
-(AVPlayerItem *)do_setSinglePlayerItemByPath:(NSString *)_str_filepath atIndex:(int)_index
{
    AVPlayerItem *_item = [self do_initalSinglePlayerItemByPath:_str_filepath];
    [arr_playerItemPool replaceObjectAtIndex:_index withObject:_item];
    
    return _item;
}

#pragma mark - ASIHTTPRequestDelegate 回调
- (void)requestStarted:(ASIHTTPRequest *)request;
{
    NSString *_str_filedownloadPath =  [request.userInfo objectForKey:KEY_FILE_DOWNLOAD_PATH];
    NSString *_str_url = [request.url absoluteString];
    
    NSLog(@"::::>start download at[%d] %@ %@",currentDownloadingVideoIndex,_str_url,_str_filedownloadPath);
}

- (void)requestFinished:(ASIHTTPRequest *)request;
{
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request;
{
    NSLog(@":::::>requestFailed %@",request.error);
    [self cancelDownloading];
}

#pragma mark - 下载进度更新
- (void)setProgress:(float)newProgress{
        NSLog(@":::::>currentDownloadingVideoIndex = %d newProgress = %f",currentDownloadingVideoIndex,newProgress);
    
    
    //==================以下是单个视频下载进度
    if(delegate_download && [delegate_download respondsToSelector:@selector(didUpdateSingleVideoProcess:atVideoIndex:)])
    {
        if(currentDownloadingVideoIndex >= 0)//如果是负数说明当前下载的不是一个视频
        {
            [delegate_download didUpdateSingleVideoProcess:newProgress atVideoIndex:currentDownloadingVideoIndex];
            
            return;
        }
    }
    
    
    //===================以下是队列里的总进度
    
    [self do_calculateCurrentDownloadedVideoSize];//计算队列中当前下载的视频大小
    [self do_calculateVideoTotalSize];//计算总计的视频大小
    
    CGFloat _percent = 0;
    
    if([self do_isUrlExistInVideoFilePathsAndAudioFilePath])
    {
        _percent = (CGFloat)currentDownloadedVideoFileSize / (CGFloat)videoTotalFileSize;
        //        NSLog(@"progress:(%lld/%lld)",currentDownloadedVideoFileSize,videoTotalFileSize);
        if( delegate_download && [delegate_download respondsToSelector:@selector(didUpdateDownloadProcess:)] )
        {
            if(_percent < 1)
            {
                [delegate_download didUpdateDownloadProcess:_percent];
            }//在没下载完的情况下 过滤掉 _percent >=1 的值
        }
    }//如果没下载完
    else
    {
        _percent = 1;//如果全部下载完成 手动设_percent为1 以防因精度损失 _percent不为1的情况
        if(delegate_download && [delegate_download respondsToSelector:@selector(didFinishDownloadAllVideos:)])
        {
            [delegate_download didFinishDownloadAllVideos:self];
        }
    }
    
}

#pragma mark - 下载完成回调
-(void)didFinishDownloadVideosInQueue:(ASIHTTPRequest *)_request
{
    if(_request && [[_request.userInfo allKeys] containsObject:KEY_FILE_DOWNLOAD_PATH] && [_request.userInfo count]>0)
    {
        NSString *str_filepath = [_request.userInfo objectForKey:KEY_FILE_DOWNLOAD_PATH];
        NSString *str_url = _request.url.absoluteString;
        if([str_filepath containsString:@"mp3"])
        {
            [arr_audioFilePaths replaceObject:str_url withObj:str_filepath];
            
        }
        else if([str_filepath containsString:@"mp4"])
        {
            [arr_videoFilePaths replaceObject:str_url withObj:str_filepath];
        }
        
        
       // NSLog(@"after download arr_videoFilePaths = %@[%ld] arr_audioFilePaths = %@[%ld]",arr_videoFilePaths,arr_videoFilePaths.count,arr_audioFilePaths,arr_audioFilePaths.count);
        [self setProgress:0];//补上最后一个进度更新
        
        if(delegate_download && [delegate_download respondsToSelector:@selector(didFinishDownloadSingleVideo:)])
        {
            
            NSIndexSet *indexSet = [arr_videoFilePaths giveMeIndexSetsOfObject:str_filepath];
            [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                [self do_setSinglePlayerItemByPath:str_filepath atIndex:(int)idx];
            }];
            
            [delegate_download didFinishDownloadSingleVideo:str_filepath];
            
        }
        if(currentPlayerItemIndex == currentDownloadingVideoIndex)
            currentDownloadingVideoIndex = -1;//避免重复刷新进度)
        
    }
}




#pragma mark - 视频播放结束时的回调
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    //    NSLog(@"notification = %@",notification);
    AVPlayerItem *_playerItem = [notification object];
    
    
    //===================================完整视频 playerLayer_playVideoQueue 中的playerItem播放到底====================================
    if(playerLayer_playVideoQueue && [_playerItem isEqual:playerLayer_playVideoQueue.player.currentItem])
    {
        if(playerLayer_playVideoQueue.player.status == AVPlayerItemStatusReadyToPlay)
        {
            isVideoRollbacking = YES;
            [playerLayer_playVideoQueue.player.currentItem seekToTime: kCMTimeZero
                                                      toleranceBefore: kCMTimeZero
                                                       toleranceAfter: kCMTimeZero
                                                    completionHandler: ^(BOOL finished)
             {
                 if(finished)
                 {
                     isVideoRollbacking = NO;
                     int repeatCount = [[arr_videoPlayRemaingCount objectAtIndex:currentPlayerItemIndex] intValue];
                     int playedCount = [[arr_videoPlayedCount objectAtIndex:currentPlayerItemIndex] intValue];
                     playedCount ++;
                     [arr_videoPlayedCount replaceObjectAtIndex:currentPlayerItemIndex withObject:[NSNumber numberWithInt:playedCount]];
                     //                 NSLog(@"arr_videoPlayedCount = %@",arr_videoPlayedCount);
                     //                 NSLog(@"arr_videoPlayRemaingCount = %@",arr_videoPlayRemaingCount);
                     
                     if(repeatCount > 1)
                     {
                         repeatCount --;
                         
                         [arr_videoPlayRemaingCount replaceObjectAtIndex:currentPlayerItemIndex withObject:[NSNumber numberWithInt:repeatCount]];
                         
                         
                         //                     NSLog(@"arr_videoPlayRemaingCount = %@",arr_videoPlayRemaingCount);
                         [self playVideoByCurrentPlayerItemInVideoQueue];//播放视频 如果有音频的话播放音频
                     }//继续重复播放视频
                     else
                     {
                         [self pauseAudio];//保证每次播放结束 音频都结束 即便音频还没有完成播放
                         if(currentPlayerItemIndex < [arr_playerItemPool count] - 1)
                         {
                             
                             if(delegate_playVideoQueue && [delegate_playVideoQueue respondsToSelector:@selector(singleVideoDidFinishAtIndex:nextIndex:)])
                             {
                                 [delegate_playVideoQueue singleVideoDidFinishAtIndex:currentPlayerItemIndex nextIndex:currentPlayerItemIndex + 1];
                             }
                             
                         }//每个视频播放结束都会掉用该代理 决定是否继续播放
                         else
                         {
                             if(finished)
                             {
                                 
                                 if(delegate_playVideoQueue && [delegate_playVideoQueue respondsToSelector:@selector(videoQueueDidFinishedPlay:)])
                                 {
                                     [delegate_playVideoQueue videoQueueDidFinishedPlay:self];
                                 }
                             }
                         }//播到最后一个playerItem通知delegate
                     }//播放下一个视频

                 }
                 
                 
             }];
        }
        
    }
    
    
    //===============================================预览视频step by step的事件=================================================
    else
    {
        if(arr_playerItemPool && [arr_playerItemPool containsObject:_playerItem])
        {
            
            isVideoRollbacking = YES;
            [_playerItem seekToTime: kCMTimeZero
                    toleranceBefore: kCMTimeZero
                     toleranceAfter: kCMTimeZero
                  completionHandler: ^(BOOL finished)
             {
                 if(finished)
                 {
                     isVideoRollbacking = NO;
                     [self playCurrentPlayerLayer];
                 }
             }];
        }
        
    }
}


#pragma mark - 未使用的方法
-(void)cleanAllVideoFile:(id)sender;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSError *error = nil;
    [fileManager removeItemAtPath:path error:&error];
    NSLog(@"error : %@",error);
}

-(void)setVolumeWithPlayerItem:(AVPlayerItem *)playerItem volume:(float )volume
{
    NSArray *audioTracks = [playerItem.asset tracksWithMediaType:AVMediaTypeAudio];
    
    NSMutableArray *allAudioParams = [NSMutableArray array];
    for (AVAssetTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *audioInputParams =
        [AVMutableAudioMixInputParameters audioMixInputParameters];
        [audioInputParams setVolume:volume atTime:kCMTimeZero];
        [audioInputParams setTrackID:[track trackID]];
        [allAudioParams addObject:audioInputParams];
    }
    
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    [audioMix setInputParameters:allAudioParams];
    
    [playerItem setAudioMix:audioMix];
}

- (UIImage *)thumbnailImageFromVideoURL:(NSURL *)_vidURL cmTime:(CMTime)_time
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:_vidURL options:nil];
    return  [self thumbnailImageFromAsset:asset cmTime:_time];
}

-(UIImage *)thumbnailImageFromAsset:(AVAsset *)_asset cmTime:(CMTime)_time
{
    AVAssetImageGenerator *generate = [AVAssetImageGenerator assetImageGeneratorWithAsset:_asset];
    
    generate.appliesPreferredTrackTransform=TRUE;
    generate.requestedTimeToleranceAfter=kCMTimeZero;
    generate.requestedTimeToleranceBefore=kCMTimeZero;
    
    NSError *err = NULL;
    CGImageRef imgRef = [generate copyCGImageAtTime:_time actualTime:NULL error:&err];
    if(!err)
        NSLog(@"err==%@, imageRef==%@", err, imgRef);
    
    UIImage *image = [UIImage imageWithCGImage:imgRef];
    imgRef= nil;
    NSLog(@"image=%@ size:%@",image,NSStringFromCGSize(image.size));
    return image;
}

-(UIImage *)thumbnailImageFromPlayerLayer:(AVPlayerLayer *)_currentPlayerLayer
{
    NSLog(@"current asset sec:%f",(float)_currentPlayerLayer.player.currentItem.currentTime.value/(float)_currentPlayerLayer.player.currentItem.currentTime.timescale);
    return [self thumbnailImageFromAsset:_currentPlayerLayer.player.currentItem.asset cmTime:_currentPlayerLayer.player.currentItem.currentTime];
}
@end

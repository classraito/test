//
//  FGVideoStatusMachine.h
//  DurexBaby
//
//  Created by luyang on 12-8-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
@class FGVideoModel;
#define VIDEO_NOT_EXIST_ON_LOCALE @"VIDEO_NOT_EXIST_ON_LOCALE" //视频不存在于本地

extern void copyFileWithFormatnameToDocument(NSString *_str_formatname);

@protocol FGVideoModelDownloadDelegate <NSObject>
-(void)didUpdateDownloadProcess:(CGFloat)_percent;   //下载总进度,在TrainingDetailPage中用到
-(void)didUpdateSingleVideoProcess:(CGFloat)_percent atVideoIndex:(int)_downloadingIndex;   //在step by step preview中用到
-(void)didFinishDownloadAllVideos:(FGVideoModel *)_model;                                   //都用到
-(void)didFinishDownloadSingleVideo:(NSString *)_str_filePath;  //在step by step preview中用到
@end

@protocol FGVideoModelPlayQueueVideoDelegate <NSObject>
-(void)singleVideoDidFinishAtIndex:(int)_videoIndex_finished nextIndex:(int)_videoIndex_next ; //在完整视频播放器中用到
-(void)videoQueueDidFinishedPlay:(id)_sender;                                                   //在完整视频播放器中用到
@end


@interface FGVideoModel : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>
{
    AVMutableVideoComposition *videoComposition;
    
}

@property(nonatomic,strong)NSMutableArray *arr_playerItemPool;//存放所有分视频的playerItem的数组(总视频的playerLayer由此数组提供playerItem数据)

#pragma mark - 公用的
@property int currentPlayerItemIndex;
@property(nonatomic,strong)NSString *str_workoutID;
@property(nonatomic,weak)id<FGVideoModelDownloadDelegate> delegate_download;

@property(nonatomic,copy)NSMutableArray *arr_urlInfos;//视频信息数组(从网络获得)    arr_audioPlayAtCount 和 音频播放依赖该数据 所以如果要播放本地音频 需要构造一个arr_urlInfos
@property(nonatomic,copy)NSMutableArray *arr_urls;//视频httpUrls数组
@property(nonatomic,strong)NSMutableArray *arr_videoFilePaths;//视频文件保存路径,如果没有下载过 那么就用http URL 代替 这样 界面就知道 如果是url 表示没下载过 如果是本地文件路径 则已下载过

#pragma mark - step by step 用到的
@property(nonatomic,strong)NSMutableArray *arr_playerLayerPool;//存放3个playerLayer的数组
@property(nonatomic,strong)NSMutableArray *arr_PlayerItemIndexPool;//存放3个playerLayer需加载的playerItem 在 playerItemPool中的下标
@property int currentDownloadingVideoIndex;
#pragma mark - 视频播放器用到的
@property(nonatomic,strong)ASINetworkQueue *asiQueue;
@property float totoalTime_playVideoQueue;
@property float currentTime_playVideoQueue;
@property(nonatomic,weak)id<FGVideoModelPlayQueueVideoDelegate> delegate_playVideoQueue;
@property(nonatomic,strong)AVPlayerLayer *playerLayer_playVideoQueue;//播放总视频的playerLayer

/*用于计算循环*/
@property(nonatomic,strong)NSMutableArray *arr_videoPlayRemaingCount;//保存每个视频当前剩余循环次数
@property(nonatomic,strong)NSMutableArray *arr_videoNeedPlayCount;//保存每个视频需要循环的次数
@property(nonatomic,strong)NSMutableArray *arr_videoPlayedCount;//保存每个视频当前播放的次数

@property(nonatomic,strong)NSMutableArray *arr_audioPlayAtCount;//记录了音频该在哪个视频的第几次循环播放的信息
@property(nonatomic,strong)NSMutableArray *arr_audioUrls;//音频httpUrls数组
@property(nonatomic,strong)AVAudioPlayer  *audioPlayer;//音频播放器
@property(nonatomic,strong)NSMutableArray *arr_audioFilePaths;//音频文件保存路径，如果没有下载过 那么久用http URL 代替 这样 界面久之道 如果是url 表示没下载过 如果是本地文件路径 则已下载过
@property BOOL isVideoRollbacking;


+(FGVideoModel *)sharedModel;

#pragma mark - 外部方法

#pragma mark 公用
/*用当前文件路径数组 初始化arr_playerItemPool (视频文件播放项)*/
-(void)initalAllPlayerItemsByCurrentFilePaths;

/*取消下载*/
-(void)cancelDownloading;

/*销毁model*/
+(void)clearVideoModel;

#pragma mark step by step 用到的
/*初始化3个playerLayer 用于preview时轮流装载playerItem*/
-(void)initPlayerLayerPool;

/*根据currentPlayerItemIndex 更新arr_PlayerItemIndexPool*/
-(void)updatePlayerLayerByCurrentPlayerItemIndex;

/*播放currentPlayerItemIndex 指定的视频*/
-(void)playCurrentPlayerLayer;

/* 根据currentPlayerItemIndex 播放单个playerLayer 如果 不存在 那么就去下载*/
-(void)playSinglePlayerItemByCurrentPlayerItemIndexIfExist_OtherWiseToDownloadIt;

/*根据currentPlayerItemIndex 播放单个playerLayer 如果 不存在 那么就去下载*/
-(void)playSinglePlayerItemByCurrentPlayerItemIndexIfExist_OtherWiseToDownloadIt:(BOOL)isResetDownload;

/*根据playerItemIndex 判断 是否有必要把playerLayer添加到view中*/
-(void)updatePlayerLayerToVideoContainViewIfNeeded:(UIView *)_view_videoContainer playerItemIndex:(int)_comparePlayerItemIndex;

/*暂停在arr_playerLayerPool中所有的视频*/
-(void)pauseAllPlayerLayerInPool;

/*重置在arr_playerItemsPool中所有的视频*/
-(void)resetAllPlayerItemsInPool;

#pragma mark  播放器视频相关方法
/*用arr_playerItemPool中第一个个playerItem 来初始化playerLayer_playVideoQueue*/
-(void)initalVideoQueuePlayerLayer;

/*初始化文件路径数组 这个数组模型可标示 哪些没下载 哪些下载了*/
-(void)internalInitalFilePathsByUrls:(NSMutableArray *)_arr_videoUrls;

/*确保playerLayer初始化成功的前提下 把playerLayer加到 视频容器视图 的 layer 中*/
-(void)addPlayerLayerToVideoContainerView:(UIView *)_view_videoContainer;

/*确保playerLayer初始化成功的前提下 把playerLayer加到 视频容器视图 的 layer 中*/
-(void)addPlayerLayer:(AVPlayerLayer *)_playerLayer ToVideoContainerView:(UIView *)_view_videoContainer;

/*过滤重复的video url 并记录下它重复的次数*/
-(void)filteRepeatedUrlAndRecordTheCount;

/*播放当前currentPlayerItemIndex指定的视频*/
-(void)playVideoByCurrentPlayerItemInVideoQueue;

/*从外部 方便 调用 isUrlExistInVideoFilePathsArray*/
-(BOOL)isNeedDownloadByURLS:(NSMutableArray *)_arr_videoUrls audioURLS:(NSMutableArray *)_arr_audioUrls;

/*根据arr_videoUrl 和 arr_audioUrl 来初始化下载队列*/
-(BOOL)startDownloadVideosByURLsUseASIQueueIfNeeded:(NSMutableArray *)_arr_videoUrls audioUrls:(NSMutableArray *)_arr_audioUrls;

/*重置播放器的一些相关属性*/
-(void)resetVideoPlayQueue;

/*移除playerLayer_playVideoQueue*/
-(void)finishVideoQueue;

/*获得当前播放到第几个视频和总视频的 字符串*/
-(NSString *)giveMeCurrentPlayerItemIndexInAllItems;

/*获得视频总时长的字符串*/
-(NSString *)giveMeTotalVideoTimeInQueue;

/*获得视频总剩余时长的字符串*/
-(NSString *)giveMeTotalVideoRemainingTimeInQueue;

/*获得当前播放的视频剩余时长的字符串*/
-(NSString *)giveMeCurrentRemainingTimeWithClockFormat;

/*获得当前播放视频的进度值*/
-(float)giveMeCurrentVideoPlayedProcessInQueue;

/*判断是否时http:// 或 https://风格的URL*/
-(BOOL)isUrlsScheme:(NSString *)_str;
/*判断是否是本地路径*/
-(BOOL)isLocaleFilePath:(NSString *)_str;

-(float )do_giveVideoDurationByPlayerItemIndex:(NSInteger )_playerItemIndex;//fixed

#pragma mark  播放器音频相关方法
/*根据音频url初始化arr_audioFilePath 如果url对应的文件名不在本地 那么就用url表示路径 如果文件名已经存在，那么就用本地路径表示*/
-(void)internalInitalAudioFilePathsByUrls:(NSMutableArray *)_arr_audioUrls;

/*过滤重复的audio url 并记录下它需要在video播放的第几遍播放*/
-(void)filteRepeatedAudioUrlAndRecordThePlayIndex;

/*暂停播放音频*/
-(void)pauseAudio;

/*开始播放音频*/
-(void)playAudio;
@end

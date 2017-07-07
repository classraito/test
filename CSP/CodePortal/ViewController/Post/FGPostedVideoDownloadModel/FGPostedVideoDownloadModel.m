//
//  FGPostedVideoDownloadModel.m
//  CSP
//
//  Created by Ryan Gong on 16/11/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostedVideoDownloadModel.h"
#import "Global.h"



FGPostedVideoDownloadModel *postedVideoDowmloadModel;
@implementation FGPostedVideoDownloadModel
@synthesize asiQueue;
#pragma mark - 生命周期
+(FGPostedVideoDownloadModel *)sharedModel
{
    @synchronized(self)     {
        if(!postedVideoDowmloadModel)
        {
            postedVideoDowmloadModel=[[FGPostedVideoDownloadModel alloc]init];
            
            
            return postedVideoDowmloadModel;
        }
    }
    return postedVideoDowmloadModel;
}

-(id)init
{
    if(self = [super init])
    {
      
        
    }
    return self;
}

+(id)alloc
{
    @synchronized(self)     {
        NSAssert(postedVideoDowmloadModel == nil, @"企圖重复創建一個singleton模式下的postedVideoDowmloadModel");
        return [super alloc];
    }
    return nil;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
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
    if(!postedVideoDowmloadModel)
        return;
    postedVideoDowmloadModel = nil;
}

#pragma mark - 把一个url 转换成文件名
-(NSString *)convertUrlToFilePaths:(NSString *)_str_videoUrl
{
    _str_videoUrl = [_str_videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *_str_filename = [_str_videoUrl stringByReplacingOccurrencesOfString:@"://" withString:@"__"];
    _str_filename = [_str_filename stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return _str_filename;
}

#pragma mark - 根据videoUrl 获取 相应的下载后的存放地址
-(NSString *)getDownlaodPathByVideoUrl:(NSString *)_str_videoUrlNeedToDownload
{
    NSString *_str_filename = [self convertUrlToFilePaths:_str_videoUrlNeedToDownload];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *_filepath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"cached_post_video/%@",_str_filename]];
    return _filepath;
}

#pragma mark - 下载和本地文件相关方法
-(BOOL)isFileExsitAtPath:(NSString *)_str_filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:_str_filePath];
    return  fileExists;
}

#pragma mark - 获得下载状态
-(PostedVideoDownloadStatuts)getDownloadStatusByVideoUrl:(NSString *)_str_videoUrlNeedToDownload
{
    //各种防奔溃安全检查
    if(!_str_videoUrlNeedToDownload)
        return PostedVideoDownloadStatuts_UNKNOW;
    
    //检查是否已下载
    NSString *_filepath = [self getDownlaodPathByVideoUrl:_str_videoUrlNeedToDownload];
    if([self isFileExsitAtPath:_filepath])
        return PostedVideoDownloadStatuts_DOWNLOADED;
    
    
    //检查是否正在下载
    NSArray *arr_allOperations =  asiQueue.operations;
    for(id obj in arr_allOperations)
    {
        if([obj isKindOfClass:[ASIHTTPRequest class]])
        {
            ASIHTTPRequest *_request = (ASIHTTPRequest *)obj;
            if(_request.userInfo && [[_request.userInfo allKeys] containsObject:KEY_POSTVIDEO_VIDEOURL])
            {
                NSString *_str_videoUrl = [_request.userInfo objectForKey:KEY_POSTVIDEO_VIDEOURL];
                if([_str_videoUrl isEqualToString:_str_videoUrlNeedToDownload])
                {
                    return PostedVideoDownloadStatuts_DOWNLOADING;
                }
            }
        }
    }
    
    //都不匹配 返回 没有开始下载
    return PostedVideoDownloadStatuts_NOTDOWNLOAD;
    
}

#pragma mark - 开始下载队列 如果已经下载过的 不会下载 ，下载到一半的会断点续传,如果无需下载 则不下载
-(void)startDownloadByVideoUrl:(NSString *)_str_url postId:(NSString *)_str_postId notifyVC:(UIViewController *)_notifyVC
{
    if(!_str_url)
        return ;
    if(!_str_postId)
        return;
    
    PostedVideoDownloadStatuts status = [self getDownloadStatusByVideoUrl:_str_url];
    if(status == PostedVideoDownloadStatuts_UNKNOW)
        return;
    if(status == PostedVideoDownloadStatuts_DOWNLOADING)
        return;
    if(status == PostedVideoDownloadStatuts_DOWNLOADED)
        return;
    
    
    if(!asiQueue)
        asiQueue=[[ASINetworkQueue alloc]init];//开启队列
    
    asiQueue.showAccurateProgress=YES;//进度
    asiQueue.downloadProgressDelegate = self;//下载进度的代理，用于断点续传
    asiQueue.delegate = self;
    [asiQueue setMaxConcurrentOperationCount:1];
    asiQueue.requestDidFinishSelector = @selector(didFinishDownloadVideosInQueue:);
    asiQueue.requestDidFailSelector= @selector(didFailedDownloadVideosInQueue:);
        
    
        NSString *_str_filename = [self convertUrlToFilePaths:_str_url];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        //目的路径，设置一个目的路径用来存储下载下来的文件
        NSString *savePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"cached_post_video/%@",_str_filename]];
        NSLog(@"savePath = %@",savePath);
        
        /*
         临时路径:
         1.设置一个临时路径用来存储下载过程中的文件
         2.当下载完后会把这个文件拷贝到目的路径中，并删除临时路径中的文件
         3.断点续传：当设置断点续传的属性为YES后，每次执行都会到临时路径中寻找要下载的文件是否存在，下载的进度等等。。。然后就会在此基础上继续下载，从而实现续传的效果
         设置临时路径在这个过程中是相当重要的。。。
         */
        NSString *temp = [path stringByAppendingPathComponent:@"cached_post_video/temp"];
        
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
        
        
        NSURL *url = [NSURL URLWithString:[_str_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        /*加入单个下载任务*/
        ASIHTTPRequest *asiHttpRequest=[ASIHTTPRequest requestWithURL:url];
        
        asiHttpRequest.delegate=self;
        
        asiHttpRequest.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   _str_url,KEY_POSTVIDEO_VIDEOURL ,
                                   _str_postId,KEY_POSTVIDEO_POSTID,
                                   savePath,KEY_POSTVIDEO_DOWNLOADED_PATH,
                                   [NSNumber numberWithLong:[_notifyVC hash]],KEY_POSTVIDEO_VIEWCONTROLLER_HASHCODE,nil];
        
        [ asiHttpRequest setDownloadDestinationPath:savePath ];//下载路径
        [ asiHttpRequest setTemporaryFileDownloadPath:tempPath ];//临时路径，一定要设置临时路径。。
        asiHttpRequest.allowResumeForFileDownloads = YES;//打开断点，是否要断点续传
        [asiQueue addOperation:asiHttpRequest];//加入队列
        
    
    
    [asiQueue go];
}

- (void)setProgress:(float)newProgress{
       NSLog(@"newProgress = %f",newProgress);
}

-(void)didFinishDownloadVideosInQueue:(ASIHTTPRequest *)_request
{
    
    NSLog(@":::::>didFinishDownloadVideosInQueue");
    if(_request && [[_request.userInfo allKeys] containsObject:KEY_POSTVIDEO_VIDEOURL] && [_request.userInfo count]>0)
    {
        
       
        NSMutableDictionary *__dic_info = [_request.userInfo mutableCopy];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_POSTEDVIDEODOWNLOAD_FINISHED object:__dic_info userInfo:nil];
       
    }
}

-(void)didFailedDownloadVideosInQueue:(ASIHTTPRequest *)_request
{
    if(_request && [[_request.userInfo allKeys] containsObject:KEY_POSTVIDEO_VIDEOURL] && [_request.userInfo count]>0)
    {
        
        NSMutableDictionary *__dic_info = [_request.userInfo mutableCopy];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_POSTEDVIDEODOWNLOAD_FAILED object:__dic_info userInfo:nil];
    }
}

#pragma ASI 回调
- (void)requestFinished:(ASIHTTPRequest *)request;
{
    NSString *str_response = request.responseString;
    NSLog(@"str_response = %@",str_response);
    
}

- (void)requestFailed:(ASIHTTPRequest *)request;
{
    NSString *str_response = request.responseString;
    NSLog(@"str_response = %@",str_response);
}
@end

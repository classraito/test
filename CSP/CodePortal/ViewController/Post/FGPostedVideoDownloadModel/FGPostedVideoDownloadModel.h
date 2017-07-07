//
//  FGPostedVideoDownloadModel.h
//  CSP
//
//  Created by Ryan Gong on 16/11/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
typedef enum
{
    PostedVideoDownloadStatuts_UNKNOW = 0,
    PostedVideoDownloadStatuts_NOTDOWNLOAD = 1,
    PostedVideoDownloadStatuts_DOWNLOADING = 2,
    PostedVideoDownloadStatuts_DOWNLOADED = 3
}PostedVideoDownloadStatuts;
#define NOTIFICATION_POSTEDVIDEODOWNLOAD_FINISHED @"NOTIFICATION_POSTEDVIDEODOWNLOAD_FINISHED"
#define NOTIFICATION_POSTEDVIDEODOWNLOAD_FAILED @"NOTIFICATION_POSTEDVIDEODOWNLOAD_FAILED"
#define KEY_POSTVIDEO_VIDEOURL @"KEY_POSTVIDEO_VIDEOURL"
#define KEY_POSTVIDEO_POSTID @"KEY_POSTVIDEO_POSTID"
#define KEY_POSTVIDEO_DOWNLOADED_PATH @"KEY_POSTVIDEO_DOWNLOADED_PATH"
#define KEY_POSTVIDEO_VIEWCONTROLLER_HASHCODE @"KEY_POSTVIDEO_VIEWCONTROLLER_HASHCODE"

@interface FGPostedVideoDownloadModel : NSObject
{
    
}
@property(nonatomic,strong)ASINetworkQueue *asiQueue;
+(FGPostedVideoDownloadModel *)sharedModel;
-(NSString *)getDownlaodPathByVideoUrl:(NSString *)_str_videoUrlNeedToDownload;
-(PostedVideoDownloadStatuts)getDownloadStatusByVideoUrl:(NSString *)_str_videoUrlNeedToDownload;
-(void)startDownloadByVideoUrl:(NSString *)_str_url postId:(NSString *)_str_postId notifyVC:(UIViewController *)_notifyVC;
-(void)cancelDownloading;
+(void)clearVideoModel;
@end

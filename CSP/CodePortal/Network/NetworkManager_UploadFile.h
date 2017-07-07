//
//  NetworkManager_UploadFile.h
//  CSP
//
//  Created by Ryan Gong on 16/11/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NetworkManager.h"
#define URL_UPLOAD_FILE @"/Upload/PostFile.ashx"

@protocol NetworkManagerUploadFileDelegate <NSObject>

-(void)updateProgress:(float)_progress;

@end

@interface NetworkManager_UploadFile : NetworkManager
{
    
}
@property(nonatomic,assign)id<NetworkManagerUploadFileDelegate> delegate_progress;
-(ASINetworkQueue *)startUploadImages:(NSMutableArray *)_arr_images;
-(ASINetworkQueue *)startUploadVideo:(NSString *)_str_videoFilePath;
-(void)cancelDownloading;
@end

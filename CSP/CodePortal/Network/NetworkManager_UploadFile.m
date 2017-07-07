//
//  NetworkManager_UploadFile.m
//  CSP
//
//  Created by Ryan Gong on 16/11/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NetworkManager_UploadFile.h"
#import "Global.h"
@interface NetworkManager_UploadFile()
{
    ASINetworkQueue *asiQueue;
}
@end

@implementation NetworkManager_UploadFile
@synthesize delegate_progress;
#pragma mark - 开始下载队列 如果已经下载过的 不会下载 ，下载到一半的会断点续传,如果无需下载 返回NO
-(ASINetworkQueue *)startUploadImages:(NSMutableArray *)_arr_images
{
    @try {
        if (![[Reachability reachabilityForInternetConnection] isReachable]) {
            [commond removeLoading];
            [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please check your network connection!") callback:nil];
            return nil;
        }
        asiQueue = [self internalInitalASINetworkQueue];
        for(int i=0 ; i < [_arr_images count];i++)
        {
            UIImage *_img = [_arr_images objectAtIndex:i];
            NSData *_data  = UIImagePNGRepresentation(_img);
            
            
            ASIFormDataRequest *request = [self initalUploadFileWithFilePath:nil data:_data];
            
            [asiQueue addOperation:request];//加入队列
            
            [request setUploadProgressDelegate:self];
            request.showAccurateProgress = YES;
        }
        
        [asiQueue go];

    }
    @catch (NSException *exception) {
        NSLog(@"exception = %@", exception);
        [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please check your network connection!") callback:nil];
    }
    
    return asiQueue;
}

-(ASINetworkQueue *)startUploadVideo:(NSString *)_str_videoFilePath
{
    @try {
        if (![[Reachability reachabilityForInternetConnection] isReachable]) {
            [commond removeLoading];
            [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please check your network connection!") callback:nil];
            return nil;
          }
            asiQueue = [self internalInitalASINetworkQueue];
             ASIFormDataRequest *request = [self initalUploadFileWithFilePath:_str_videoFilePath data:nil];
            [asiQueue addOperation:request];//加入队列
            [request setUploadProgressDelegate:self];
            request.showAccurateProgress = YES;
            
            [asiQueue go];
        
    }
    @catch (NSException *exception) {
        NSLog(@"exception = %@", exception);
        [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please check your network connection!") callback:nil];
    }
    
    return asiQueue;
}

-(ASINetworkQueue *)internalInitalASINetworkQueue
{
    if(!asiQueue)
        asiQueue=[[ASINetworkQueue alloc]init];//开启队列
    
    [asiQueue.operations makeObjectsPerformSelector:@selector(clearDelegatesAndCancel)];
    [asiQueue reset];//nil
    [asiQueue setMaxConcurrentOperationCount:1];
    
    
    return asiQueue;
}

#pragma mark - 更新上传文件进度
-(void)setProgress:(float)newProgress{
    
    if(delegate_progress && [delegate_progress respondsToSelector:@selector(updateProgress :)])
    {
        [delegate_progress updateProgress:newProgress];
    }
    
}


/*上传文件方法*/
-(ASIFormDataRequest *)initalUploadFileWithFilePath:(NSString *)_str_filePath data:(NSData *)_data
{
        if(_str_filePath && _data)
            return nil;
        
        NSURL *url                  = [NSURL URLWithString:[HOST(URL_UPLOAD_FILE)  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        [request setTimeOutSeconds:300]; //TODO: 超时改到5分钟
        [request setRequestMethod:@"POST"];
        [request setValidatesSecureCertificate:NO];
    
        
        NSMutableDictionary *_dic_headers = [NSMutableDictionary dictionaryWithCapacity:1];
        [_dic_headers setObject:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
        
        NSString *_str_contentType = @"";
        if(_str_filePath)
        {
            _str_contentType = @"vedio/mp4";
            [request setFile:_str_filePath withFileName:@"tmp.mp4" andContentType:_str_contentType forKey:@"postvideo"];//如果有路径，上传文件
        }
        if(_data)
        {
            _str_contentType = @"image/png";
            [request setData:_data withFileName:@"tmp.png" andContentType:_str_contentType forKey:@"postimg"];
            
        }
        
        
        [_dic_headers setObject:_str_contentType forKey:@"Content-Type"];
        
        if (_dic_headers && [_dic_headers count] > 0) {
            for (int i = 0; i < [_dic_headers count]; i++) {
                id key = [[_dic_headers allKeys] objectAtIndex:i];
                [request addRequestHeader:key value:[_dic_headers objectForKey:key]];
            }
        }
    
    
    
        NSLog(@"::::::::::::::::::>request:[%@] %@", url, request.requestHeaders);
        return request;
    
}

-(void)cancelDownloading
{
    
    if(asiQueue)
    {
        delegate_progress = nil;
        asiQueue.delegate = nil;
        asiQueue.downloadProgressDelegate = nil;
        asiQueue.requestDidFinishSelector = nil;
        asiQueue.requestDidFailSelector = nil;
        [asiQueue.operations makeObjectsPerformSelector:@selector(clearDelegatesAndCancel)];
        [asiQueue cancelAllOperations];
        asiQueue = nil;
    }
    
}
@end

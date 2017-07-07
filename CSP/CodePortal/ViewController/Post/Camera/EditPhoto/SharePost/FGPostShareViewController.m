//
//  FGPostShareViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/11/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostShareViewController.h"
#import "Global.h"
#import "FGPostCameraViewController.h"
#import "FGPostCameraView.h"
#import "NetworkManager_UploadFile.h"
#import "FGCircularUploadProgressView.h"
#import "NetworkManager_Post.h"
@interface FGPostShareViewController ()
{
    NSMutableArray *arr_imageNeedToPost;
    FGCircularUploadProgressView *view_uploading;
    int currentUploadingImamgeIndex;
    NSMutableArray *arr_uploadedFileUrl;
    NSMutableArray *arr_uploadedImageThumbnail;
    NSString *str_videoThumbnail;
}
@end

@implementation FGPostShareViewController
@synthesize view_postShare;
@synthesize str_videoFilePath;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage *)_img videoFilePath:(NSString *)_str_videoFilePath
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        
        if(_img)
        {
            arr_imageNeedToPost = [[NSMutableArray alloc] initWithCapacity:1];
            arr_uploadedFileUrl = [[NSMutableArray alloc] initWithCapacity:1];
            arr_uploadedImageThumbnail = [[NSMutableArray alloc] initWithCapacity:1];
            
            [arr_imageNeedToPost addObject:_img];
        }
        
        
        if(_str_videoFilePath)
            str_videoFilePath = [_str_videoFilePath mutableCopy];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"SHARE POST");
    self.view_topPanel.iv_right.hidden = YES;
    
    [self.view_topPanel.btn_right setTitle:multiLanguage(@"Share") forState:UIControlStateNormal];
    [self.view_topPanel.btn_right setTitle:multiLanguage(@"Share") forState:UIControlStateHighlighted];
    [self.view_topPanel.btn_right setTitleColor:color_red_panel forState:UIControlStateNormal];
    [self.view_topPanel.btn_right setTitleColor:color_red_panel forState:UIControlStateHighlighted];
//  self.view_topPanel.iv_right_indise1.image = [UIImage imageNamed:@"share_red"];
//  self.view_topPanel.iv_right_indise1.hidden = NO;
//  self.view_topPanel.btn_right_inside1.hidden = NO;//隐藏所有视频 按钮
//  CGRect _rect = self.view_topPanel.btn_right_inside1.frame;
//  self.view_topPanel.btn_right_inside1.frame = CGRectMake(_rect.origin.x-15, _rect.origin.y, _rect.size.width, _rect.size.height);
//  _rect = self.view_topPanel.iv_right_indise1.frame;
//   self.view_topPanel.iv_right_indise1.frame = CGRectMake(_rect.origin.x-15, _rect.origin.y, _rect.size.width, _rect.size.height);
  
    self.view_topPanel.iv_left.hidden = NO;
    self.view_topPanel.btn_left.titleLabel.font = font(FONT_TEXT_REGULAR, 14);
    self.view_topPanel.btn_right.titleLabel.font = font(FONT_TEXT_REGULAR, 20);
    CGRect _frame =  self.view_topPanel.btn_right.frame;
    _frame.origin.x = W - self.view_topPanel.btn_right.frame.size.width - 5 * ratioW;
    self.view_topPanel.btn_right.frame = _frame;
    
    [self internalInitalPostShareView];
    [self hideBottomPanelWithAnimtaion:NO];
    
    self.view_topPanel.iv_left.image = [UIImage imageNamed:@"ic_trash.png"];
    self.view_topPanel.iv_left.highlightedImage = [UIImage imageNamed:@"ic_trash.png"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self setWhiteBGStyle];
    self.view_topPanel.iv_left.image = [UIImage imageNamed:@"ic_trash.png"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)manullyFixSize
{
    [super manullyFixSize];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_imageNeedToPost = nil;
    arr_uploadedFileUrl = nil;
    str_videoFilePath = nil;
    
    [view_postShare clearMemory];
    [view_postShare removeFromSuperview];
    view_postShare = nil;
}

-(void)addImage:(UIImage *)_img orVideoFilePath:(NSString *)_str_videoFilePath
{
    if(!arr_imageNeedToPost)
        return;
    if(!view_postShare)
        return;
    
    if(_img)
        [arr_imageNeedToPost addObject:_img];
    
    [view_postShare bindDataToUI:arr_imageNeedToPost videoFilePath:_str_videoFilePath];
}

#pragma mark - 按钮事件
-(void)buttonAction_closeImage:(UIButton *)_sender
{
    if(!view_postShare)
        return;
    
    NSInteger index = _sender.tag - 1;
    
    switch (index) {
        case 0:
            [arr_imageNeedToPost removeObject:view_postShare.iv_imgPlaceHolder1.image];
            view_postShare.iv_imgPlaceHolder1.image = [UIImage imageNamed:@"addphoto.png"];
            view_postShare.iv_close1.hidden = YES;
            view_postShare.btn_close1.hidden = YES;
            
            break;
            
        case 1:
            [arr_imageNeedToPost removeObject:view_postShare.iv_imgPlaceHolder2.image];
            view_postShare.iv_imgPlaceHolder2.image = [UIImage imageNamed:@"addphoto.png"];
            view_postShare.iv_close2.hidden = YES;
            view_postShare.btn_close2.hidden = YES;
            
            break;
            
        case 2:
            [arr_imageNeedToPost removeObject:view_postShare.iv_imgPlaceHolder3.image];
            view_postShare.iv_imgPlaceHolder3.image = [UIImage imageNamed:@"addphoto.png"];
            view_postShare.iv_close3.hidden = YES;
            view_postShare.btn_close3.hidden = YES;
            
            break;
    }
    [view_postShare bindDataToUI:arr_imageNeedToPost videoFilePath:nil];
}

-(void)buttonAction_imgPlaceHolder:(UIButton *)_sender;
{
    if(!view_postShare)
        return;
    
    NSInteger index = _sender.tag - 1;
    BOOL canAddPhoto = NO;
    
    NSMutableArray *arr_sourceImgs = [NSMutableArray arrayWithCapacity:1];
    if(!view_postShare.iv_close1.hidden)
        [arr_sourceImgs addObject:view_postShare.iv_imgPlaceHolder1];
    if(!view_postShare.iv_close2.hidden)
        [arr_sourceImgs addObject:view_postShare.iv_imgPlaceHolder2];
    if(!view_postShare.iv_close3.hidden)
        [arr_sourceImgs addObject:view_postShare.iv_imgPlaceHolder3];
    
    if(index == 0)
    {
        if(view_postShare.iv_close1.hidden)
            canAddPhoto = YES;
        else{
            
            [[FGPhotoGalleryManager sharedManager] showPhotoGalleryFromSourceViews:arr_sourceImgs imgUrls:nil atIndex:0];
        }
    }
    else if(index == 1)
    {
        if(view_postShare.iv_close2.hidden)
            canAddPhoto = YES;
        else{
           [[FGPhotoGalleryManager sharedManager] showPhotoGalleryFromSourceViews:arr_sourceImgs imgUrls:nil atIndex:1];
        }
    }
    else if(index == 2)
    {
        if(view_postShare.iv_close3.hidden)
            canAddPhoto = YES;
        else{
             [[FGPhotoGalleryManager sharedManager] showPhotoGalleryFromSourceViews:arr_sourceImgs imgUrls:nil atIndex:2];
        }
    }
    
    
    if(canAddPhoto)
    {
        FGPostCameraViewController *vc_postCamera = [[FGPostCameraViewController alloc] initWithNibName:@"FGPostCameraViewController" bundle:nil];
        [self presentViewController:vc_postCamera animated:YES completion:^{
            
            if(view_postShare.view_videoContainer)
            {
                [vc_postCamera.view_camera setCameraType:CameraType_Video];
            }
            else
            {
                [vc_postCamera.view_camera setCameraType:CameraType_Photo];
            }
            
        }];
    }
}

// FIXME: share
- (void)buttonAction_qzone:(UIButton *)_sender {
  [[FGSNSManager shareInstance] shareToPlatformWithTitle:@"" text:@"" url:@"" images:@[IMGWITHNAME(@"featured-user1"),IMGWITHNAME(@"featured-user2"),IMGWITHNAME(@"featured-user3")] platformType:SSDKPlatformSubTypeQZone contentType:SSDKContentTypeAuto];
}

- (void)buttonAction_weibo:(UIButton *)_sender {
  [[FGSNSManager shareInstance] shareToPlatformWithTitle:@"" text:@"" url:@"" images:arr_imageNeedToPost platformType:SSDKPlatformTypeSinaWeibo contentType:SSDKContentTypeImage];
}

- (void)buttonAction_facebook:(UIButton *)_sender {
 [[FGSNSManager shareInstance] shareToPlatformWithTitle:@"" text:@"" url:@"" images:@[IMGWITHNAME(@"trending1"),IMGWITHNAME(@"trending2"),IMGWITHNAME(@"trending1")] platformType:SSDKPlatformTypeFacebook contentType:SSDKContentTypeAuto];
}

- (void)buttonAction_wechatMoment:(UIButton *)_sender {
//  [[FGSNSManager shareInstance] shareToPlatformWithTitle:@"" text:@"" url:@"" images:@[IMGWITHNAME(@"featured-user1"),IMGWITHNAME(@"featured-user2"),IMGWITHNAME(@"featured-user3")] platformType:SSDKPlatformSubTypeWechatTimeline contentType:SSDKContentTypeImage];
  
  UIImage *imageToShare = IMGWITHNAME(@"featured-user1");
  UIImage *imageToShare1 = IMGWITHNAME(@"featured-user2");
  UIImage *imageToShare2 = IMGWITHNAME(@"featured-user3");

  NSArray *activityItems = @[imageToShare,imageToShare1, imageToShare2];
  UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
  [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)buttonAction_wechatFriend:(UIButton *)_sender {
  [[FGSNSManager shareInstance] shareToPlatformWithTitle:@"" text:@"" url:@"" images:@[IMGWITHNAME(@"featured-user1"),IMGWITHNAME(@"featured-user2"),IMGWITHNAME(@"featured-user3")] platformType:SSDKPlatformSubTypeWechatSession contentType:SSDKContentTypeImage];
}

- (void)buttonAction_instagram:(UIButton *)_sender {
  [[FGSNSManager shareInstance] shareToPlatformWithTitle:@"" text:@"" url:@"" images:@[IMGWITHNAME(@"featured-user1"),IMGWITHNAME(@"featured-user2"),IMGWITHNAME(@"featured-user3")] platformType:SSDKPlatformTypeInstagram contentType:SSDKContentTypeImage];
}

- (void)buttonAction_toShare:(UIButton *)_sender {
  if ([arr_imageNeedToPost count]>0) {
    [[FGSNSManager shareInstance] actionToShareEditPostWithImages:arr_imageNeedToPost text:view_postShare.tv_post.text onViewController:self];
    return;
  }
  
  //分享视频链接
  [[FGSNSManager shareInstance] actionToShareEditPostOnView:self.view title:@"" text:view_postShare.tv_post.text link:str_videoFilePath];
}

#pragma mark - 初始化
-(void)internalInitalPostShareView
{
    if(view_postShare)
        return;
    
    view_postShare = (FGPostShareView *)[[[NSBundle mainBundle] loadNibNamed:@"FGPostShareView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_postShare];
    [view_postShare setupByOriginalContentSize:view_postShare.bounds.size];
    [self.view addSubview:view_postShare];
    [view_postShare bindDataToUI:arr_imageNeedToPost videoFilePath:str_videoFilePath];
    [view_postShare.btn_placeHolder1 addTarget:self action:@selector(buttonAction_imgPlaceHolder:) forControlEvents:UIControlEventTouchUpInside];
    [view_postShare.btn_placeHolder2 addTarget:self action:@selector(buttonAction_imgPlaceHolder:) forControlEvents:UIControlEventTouchUpInside];
    [view_postShare.btn_placeHolder3 addTarget:self action:@selector(buttonAction_imgPlaceHolder:) forControlEvents:UIControlEventTouchUpInside];
    [view_postShare.btn_close1 addTarget:self action:@selector(buttonAction_closeImage:) forControlEvents:UIControlEventTouchUpInside];
    [view_postShare.btn_close2 addTarget:self action:@selector(buttonAction_closeImage:) forControlEvents:UIControlEventTouchUpInside];
    [view_postShare.btn_close3 addTarget:self action:@selector(buttonAction_closeImage:) forControlEvents:UIControlEventTouchUpInside];
  
  [view_postShare.btn_qzone addTarget:self action:@selector(buttonAction_qzone:) forControlEvents:UIControlEventTouchUpInside];
  [view_postShare.btn_weibo addTarget:self action:@selector(buttonAction_weibo:) forControlEvents:UIControlEventTouchUpInside];
  [view_postShare.btn_facebook addTarget:self action:@selector(buttonAction_facebook:) forControlEvents:UIControlEventTouchUpInside];
  [view_postShare.btn_wechat addTarget:self action:@selector(buttonAction_wechatFriend:) forControlEvents:UIControlEventTouchUpInside];
  [view_postShare.btn_moment addTarget:self action:@selector(buttonAction_wechatMoment:) forControlEvents:UIControlEventTouchUpInside];
  [view_postShare.btn_instagram addTarget:self action:@selector(buttonAction_instagram:) forControlEvents:UIControlEventTouchUpInside];
  
  [view_postShare.btn_share addTarget:self action:@selector(buttonAction_toShare:) forControlEvents:UIControlEventTouchUpInside];

  
}

-(void)internalInitalCircularUploadingView
{
    if(view_uploading)
        return;
    view_uploading = (FGCircularUploadProgressView *)[[[NSBundle mainBundle] loadNibNamed:@"FGCircularUploadProgressView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_uploading];
    view_uploading.center = CGPointMake(W/2, H/2);
    view_uploading.lb_title.font = font(FONT_TEXT_BOLD, 15);
    view_uploading.lb_title.textColor = [UIColor whiteColor];
    if(str_videoFilePath)
        view_uploading.iv_uploading.backgroundColor = [UIColor blackColor];
    else
        view_uploading.iv_uploading.image = [arr_imageNeedToPost objectAtIndex:0];
    [view_uploading setStatusToUpLoading];
    [self.view addSubview:view_uploading];
    appDelegate.window.userInteractionEnabled = NO;
    view_uploading.view_mask.hidden = NO;
}

#pragma mark - postRequest 
-(void)postRequest_postShare
{
    [[FGLocationManagerWrapper sharedManager] startUpdatingLocation:^(CLLocationDegrees lat, CLLocationDegrees lng) {
        if(lat != DEFAULT_LATITUDE && lng != DEFAULT_LONTITUDE)
        {
            long lat = [commond EnCodeCoordinate:[FGLocationManagerWrapper sharedManager].currentLatitude];
            long lng = [commond EnCodeCoordinate:[FGLocationManagerWrapper sharedManager].currentLontitude];
            NSString *_htmlWrapped = [FGUtils formatToHtmlStringWithString:view_postShare.tv_post.attributedText.string useMatchPatterns:[view_postShare.tv_post textlinkInfos]];
            NSLog(@"_htmlWrapped = %@",_htmlWrapped);
            [[NetworkManager_Post sharedManager] postRequest_SubmitPost:NO images:arr_uploadedFileUrl imageThumbnails:arr_uploadedImageThumbnail video:str_videoFilePath videoThumbnail:str_videoThumbnail content:_htmlWrapped location:@"" lat:lat lng:lng userinfo:nil];
        }
    }];
}

- (void)action_postSuccessToBack {
  [self dismissViewControllerAnimated:YES completion:nil];
  [[UIApplication sharedApplication] setStatusBarHidden:NO];
  [[NSNotificationCenter defaultCenter] postNotificationName:KEY_HandleSection object:@"allPosts"];//让post首页刷新数据
  [NetworkEventTrack track:KEY_TRACK_EVENTID_SUBMITPOST attrs:nil]; //追踪 发布一个动态
}

#pragma mark - 从父类继承的
-(void)buttonAction_left:(id)_sender
{
    [commond alertWithButtons:@[multiLanguage(@"YES"),multiLanguage(@"NO")] title:multiLanguage(@"ALERT") message:multiLanguage(@"Are you sure?") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
        if(buttonIndex == 0)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }
    }];
}

-(void)buttonAction_right:(id)_sender
{
    if([view_postShare.tv_post.text isEmptyStr])
    {
        [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"you can not post an empty content.") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        return;
    }
    if(!str_videoFilePath && [arr_imageNeedToPost count]<=0)
    {
        [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please take a picture.") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        return;
    }
     currentUploadingImamgeIndex = 0;
    [arr_uploadedFileUrl removeAllObjects];
    
    [self internalInitalCircularUploadingView];
   
    [NetworkManager_UploadFile sharedManager].delegate_progress = self;
    if(str_videoFilePath)
    {
        ASINetworkQueue *asiQueue = [[NetworkManager_UploadFile sharedManager] startUploadVideo:str_videoFilePath];
        
        asiQueue.delegate = self;
        asiQueue.requestDidFinishSelector = @selector(didFinishUploadFilesInQueue:);
        asiQueue.requestDidFailSelector = @selector(didFailedUploadFilesInQueue:);
        asiQueue.requestDidStartSelector = @selector(didStartUploadFilesInQueue:);
    }
    else if(arr_imageNeedToPost && [arr_imageNeedToPost count] > 0)
    {
        ASINetworkQueue *asiQueue = [[NetworkManager_UploadFile sharedManager] startUploadImages:arr_imageNeedToPost];
        
        asiQueue.delegate = self;
        asiQueue.requestDidFinishSelector = @selector(didFinishUploadFilesInQueue:);
        asiQueue.requestDidFailSelector = @selector(didFailedUploadFilesInQueue:);
        asiQueue.requestDidStartSelector = @selector(didStartUploadFilesInQueue:);
    }
}

//-(void)buttonAction_right_inside1:(id)_sender
//{
//  [self buttonAction_toShare:nil];
//}

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    
    if ([HOST(URL_POST_Update_SubmitPost) isEqualToString:_str_url]) {
      
      //在dismiss之前需要弹出分享其他平台
      [commond alertWithButtons:@[multiLanguage(@"YES"),multiLanguage(@"NO")] title:multiLanguage(@"ALERT") message:multiLanguage(@"Do you want to share to other plateforms?") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
        if(buttonIndex == 0)
        {
          [self buttonAction_toShare:nil];
        } else if (buttonIndex == 1) {
          [self action_postSuccessToBack];
        }
      } dismissWithButtonIndex:1];
    }

}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!view_postShare)
        return;
    
    [view_postShare resetVisibleRegion];
}

#pragma mark - 上传进度回调
-(void)updateProgress:(float)_progress
{
    NSString *_str_progress = [NSString stringWithFormat:@"%@ %d \n%0.f%%",multiLanguage(@"UPLOADING"),currentUploadingImamgeIndex + 1,_progress*100];
    
    if(!view_uploading)
        return;
    
    view_uploading.processPercent = _progress;
    [view_uploading setNeedsDisplay];
    view_uploading.lb_title.text = _str_progress;
}

-(void)didStartUploadFilesInQueue:(id)_sender
{
    if(!view_uploading)
        return;
    
    view_uploading.iv_uploading.image = [arr_imageNeedToPost objectAtIndex:currentUploadingImamgeIndex];
}

#pragma mark - 上传文件结束回调
-(void)didFinishUploadFilesInQueue:(ASIHTTPRequest *)request
{
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
    
    currentUploadingImamgeIndex = currentUploadingImamgeIndex < [arr_imageNeedToPost count]? currentUploadingImamgeIndex+1 : currentUploadingImamgeIndex;
    
    NSString *_str_fileUrl;
    if(str_videoFilePath)
    {
        str_videoFilePath = [_dic_json objectForKey:@"Url1"];
        str_videoThumbnail = [[_dic_json objectForKey:@"Url2"] mutableCopy];
    }
    else
    {
        _str_fileUrl = [_dic_json objectForKey:@"Url1"];
        [arr_uploadedFileUrl addObject:_str_fileUrl];
        [arr_uploadedImageThumbnail addObject:[_dic_json objectForKey:@"Url2"]];
    }

    
    if(currentUploadingImamgeIndex == [arr_imageNeedToPost count])
    {
        appDelegate.window.userInteractionEnabled = YES;
        SAFE_RemoveSupreView(view_uploading);
        view_uploading = nil;
        int responseCode = [[_dic_json objectForKey:@"Code"] intValue];
        if(responseCode != 0 )
            return;
        
        [self postRequest_postShare];
    }
}

-(void)didFailedUploadFilesInQueue:(ASIHTTPRequest *)request
{
    appDelegate.window.userInteractionEnabled = YES;
    SAFE_RemoveSupreView(view_uploading);
    view_uploading = nil;
    [commond removeLoading];
}

@end

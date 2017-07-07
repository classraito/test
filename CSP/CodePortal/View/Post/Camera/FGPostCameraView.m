//
//  FGPostCameraView.m
//  CSP
//
//  Created by Ryan Gong on 16/10/26.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostCameraView.h"
#import "Global.h"
#import "UIImage+SubImage.h"
#import "UIView+ViewController.h"
#define RECORD_VIDEO_MOVEOUT_VALUE -30 * ratioH
#define MIN_RECORD_SECONDS 2.0f
#define MAX_RECORD_SECONDS 10.0f

@interface FGPostCameraView()
{
    CGPoint originalVideoContainerCenter;
    NSDate *date_startRecordVideo;
    NSDate *date_endRecordVideo;
    NSTimer *timer_recordVideoProgress;
    BOOL isCancelRecord;
    UIImagePickerController *pc_picker;
}
@end


@implementation FGPostCameraView
@synthesize view_videoContainer;
@synthesize view_swithCameraType;
@synthesize view_separator;
@synthesize btn_swithToCamera;
@synthesize btn_switchToSight;
@synthesize iv_album;
@synthesize btn_album;
@synthesize btn_cameraShoot;
@synthesize btn_revert;
@synthesize btn_torch;
@synthesize btn_sightShoot;
@synthesize btn_cancel;
@synthesize captureManager;
@synthesize captureVideoPreviewLayer;
@synthesize currentCameraType;
@synthesize iv_focus;
@synthesize view_tipsBG;
@synthesize view_progress;
@synthesize lb_tips;
@synthesize iv_torch;
@synthesize iv_reverse;

#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:view_videoContainer];
    [commond useDefaultRatioToScaleView:view_swithCameraType];
    [commond useDefaultRatioToScaleView:view_separator];
    [commond useDefaultRatioToScaleView:btn_swithToCamera];
    [commond useDefaultRatioToScaleView:btn_switchToSight];
    [commond useDefaultRatioToScaleView:btn_album];
    [commond useDefaultRatioToScaleView:btn_cameraShoot];
    [commond useDefaultRatioToScaleView:btn_sightShoot];
    [commond useDefaultRatioToScaleView:btn_revert];
    [commond useDefaultRatioToScaleView:btn_torch];
    [commond useDefaultRatioToScaleView:btn_cancel];
    [commond useDefaultRatioToScaleView:iv_focus];
    [commond useDefaultRatioToScaleView:view_tipsBG];
    [commond useDefaultRatioToScaleView:iv_album];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_progress];
    [commond useDefaultRatioToScaleView:lb_tips];
    [commond useDefaultRatioToScaleView:iv_reverse];
    [commond useDefaultRatioToScaleView:iv_torch];
    
    originalVideoContainerCenter = view_videoContainer.center;
    btn_sightShoot.alpha = 0;
    currentCameraType = CameraType_Photo;
    view_progress.hidden = YES;
    lb_tips.alpha = 0;
    view_tipsBG.alpha = 0;
    CGRect _frame = view_progress.frame;
    _frame.size.width = W;
    view_progress.frame = _frame;
    
    btn_cancel.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    [btn_cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    UISwipeGestureRecognizer *_swipe_left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    _swipe_left.cancelsTouchesInView = NO;
    _swipe_left.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *_swipe_right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    _swipe_right.cancelsTouchesInView = NO;
    _swipe_right.direction = UISwipeGestureRecognizerDirectionRight;
    
    [view_videoContainer addGestureRecognizer:_swipe_left];
    [self addGestureRecognizer:_swipe_left];
    [view_videoContainer addGestureRecognizer:_swipe_right];
    [self addGestureRecognizer:_swipe_right];
    _swipe_left = nil;
    _swipe_right = nil;
    
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnVideoAction:)];
    _tap.cancelsTouchesInView = NO;
    [view_videoContainer addGestureRecognizer:_tap];
    _tap = nil;
    
    UIPanGestureRecognizer *_pan  = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOnVideoAction:)];
    _pan.cancelsTouchesInView = NO;
    [btn_sightShoot addGestureRecognizer:_pan];
    _pan = nil;
    
}

-(void)dealloc
{
    NSLog(@"::::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [self stopAVCamSession];
    captureVideoPreviewLayer = nil;
    captureManager.delegate = nil;
    captureManager = nil;
}


-(void)setupUI
{
    iv_focus.hidden = YES;
    
    btn_swithToCamera.tag = CameraType_Photo;
    btn_switchToSight.tag = CameraType_Video;
    
    view_swithCameraType.backgroundColor = [UIColor clearColor];
    btn_swithToCamera.titleLabel.font = font(FONT_TEXT_REGULAR, 14);
    btn_switchToSight.titleLabel.font = font(FONT_TEXT_REGULAR, 14);
    btn_cancel.titleLabel.font = font(FONT_TEXT_REGULAR, 14);
    lb_tips.font = font(FONT_TEXT_REGULAR, 14);
    
    lb_tips.text = multiLanguage(@"Tap and hold to record");
    
    [btn_cancel setTitle:multiLanguage(@"Cancel") forState:UIControlStateNormal];
    [btn_cancel setTitle:multiLanguage(@"Cancel") forState:UIControlStateHighlighted];
    [btn_switchToSight setTitle:multiLanguage(@"Sight") forState:UIControlStateNormal];
    [btn_switchToSight setTitle:multiLanguage(@"Sight") forState:UIControlStateHighlighted];
    [btn_swithToCamera setTitle:multiLanguage(@"Camera") forState:UIControlStateNormal];
    [btn_swithToCamera setTitle:multiLanguage(@"Camera") forState:UIControlStateHighlighted];
    
    [self initcamera];
    [self setupCamera];
    [self runAVCamSession];
}

-(void)setCameraType:(CameraType)_cameraTypes
{
   
    [self updateSwitchTypeByCameraType:_cameraTypes];
    [self.layer removeAllAnimations];
    if(_cameraTypes == CameraType_Photo)
    {
        btn_switchToSight.hidden = YES;
    }
    else if(_cameraTypes == CameraType_Video)
    {
        btn_swithToCamera.hidden = YES;
        
    }
    
}

-(void)updateSwitchTypeByCameraType:(CameraType)_cameraType
{
    if(currentCameraType == _cameraType)
        return;
    
    [UIView animateWithDuration:.2 animations:^{
        
        CGRect _frame = view_swithCameraType.frame;
        if(_cameraType == CameraType_Photo)
        {
            _frame.origin.x += view_swithCameraType.frame.size.width / 2;
            btn_sightShoot.alpha = 0;
            btn_cameraShoot.alpha = 1;
            btn_album.alpha = 1;
            iv_album.alpha = 1;
            view_tipsBG.alpha = 0;
            lb_tips.alpha = 0;
        }
        else if(_cameraType == CameraType_Video)
        {
            _frame.origin.x -= view_swithCameraType.frame.size.width / 2;
            btn_sightShoot.alpha = 1;
            btn_cameraShoot.alpha = 0;
            btn_album.alpha = 0;
            iv_album.alpha = 0;
            view_tipsBG.alpha = 1;
            lb_tips.alpha = 1;
            
           
        }
        view_swithCameraType.frame = _frame;
        
        
        
    } completion:^(BOOL finished) {
        if(finished)
        {
            currentCameraType = _cameraType;
            
            [self setupCamera];
        }
    }];
    
}


#pragma mark - 摄像相关
-(void)initcamera
{
    if(self.captureManager == nil) {
        self.captureManager = [[AVCamCaptureManager alloc] init];
        self.captureManager.delegate = self;
        self.captureManager.orientation = AVCaptureVideoOrientationPortrait;
        if (self.captureManager.cameraCount != 0 && [self.captureManager setupSession]) {
            // Create video preview layer and add it to the UI
            captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[self.captureManager session]];
            
            CALayer *viewLayer = view_videoContainer.layer;
            [viewLayer setMasksToBounds:YES];
            [viewLayer insertSublayer:captureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
            [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        }
    }
}

-(void)setupCamera
{
    /*
     //     拿到的图像的大小可以自行设定
     //    AVCaptureSessionPreset320x240
     //    AVCaptureSessionPreset352x288
     //    AVCaptureSessionPreset640x480
     //    AVCaptureSessionPreset960x540
     //    AVCaptureSessionPreset1280x720
     //    AVCaptureSessionPreset1920x1080
     //    AVCaptureSessionPreset3840x2160
     */
    [UIView beginAnimations:nil context:nil];
    if(currentCameraType == CameraType_Photo)
    {
        CGFloat videoRatio = 640.0f / 480.0f;
        view_videoContainer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width * videoRatio);
        view_videoContainer.center = originalVideoContainerCenter;
        captureVideoPreviewLayer.frame = view_videoContainer.bounds;
        
        if ([captureVideoPreviewLayer respondsToSelector:@selector(connection)])
        {
            if ([captureVideoPreviewLayer.connection isVideoOrientationSupported])
            {
                
                [captureVideoPreviewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
            }
        }
    }
    else if(currentCameraType == CameraType_Video)
    {
        CGFloat videoRatio = 480.0f / 640.0f;
        view_videoContainer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width * videoRatio);
        view_videoContainer.center = originalVideoContainerCenter;
        captureVideoPreviewLayer.frame = view_videoContainer.bounds;
        if ([captureVideoPreviewLayer respondsToSelector:@selector(connection)])
        {
            if ([captureVideoPreviewLayer.connection isVideoOrientationSupported])
            {
                [captureVideoPreviewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
            }
        }
    }
    
    CGRect _frame = view_tipsBG.frame;
    _frame.origin.y = view_videoContainer.frame.origin.y + view_videoContainer.frame.size.height ;
    view_tipsBG.frame = _frame;
    
    lb_tips.center = view_tipsBG.center;
    
    _frame = view_progress.frame;
    _frame.size.width = 0;
    _frame.origin.y = view_tipsBG.frame.origin.y + view_tipsBG.frame.size.height;
    view_progress.frame = _frame;
    
    [UIView commitAnimations];
    
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [[self captureManager].session setSessionPreset:AVCaptureSessionPreset640x480];//640 / 480 = 1.33333333
    
}

-(void)runAVCamSession
{
    if(self.captureManager.cameraCount == 0)
        return;
    if(![self.captureManager.session isRunning])
        [[[self captureManager] session] startRunning];
}

-(void)stopAVCamSession
{
    if(self.captureManager.cameraCount == 0)
        return;
    if([self.captureManager.session isRunning])
        [[[self captureManager] session] stopRunning];
}

-(void)startAVCamRecording
{
    if (![[self captureManager] isRecording])
        [[self captureManager] startRecording];
}

-(void)stopAVCamRecording
{
    if ([[self captureManager] isRecording])
        [[self captureManager] stopRecording];
}

-(void)captureStillImage
{
    if( [[self captureManager] session].running)
    {
        [[self captureManager] captureStillImage];
    }
}

-(void)toggleCamera
{
    if([[self captureManager] session].running)
        [[self captureManager] toggleCamera];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ){
            return device;
        }
    return nil;
}

#pragma mark - AVCamCaptureManagerDelegate
- (void)captureManager:(AVCamCaptureManager *)captureManager didFailWithError:(NSError *)error
{
    NSLog(@":::::>%s %d",__FUNCTION__,__LINE__);
}

- (void)captureManagerRecordingBegan:(AVCamCaptureManager *)captureManager
{
    NSLog(@":::::>%s %d",__FUNCTION__,__LINE__);
}

- (void)captureManagerRecordingFinished:(AVCamCaptureManager *)captureManager filePath:(NSString *)_str_filePath
{
    NSLog(@":::::>%s %d",__FUNCTION__,__LINE__);
    if(!isCancelRecord)
    {
        NSLog(@"not CancelRecord");
        [self go2SharePost:_str_filePath];
        [self setStopRecordStatus];
    }
    else
    {
        NSLog(@"CancelRecord");
    }
 
}

- (void)captureManagerStillImageCaptured:(AVCamCaptureManager *)captureManager
{
    NSLog(@":::::>%s %d",__FUNCTION__,__LINE__);
   

}

-(void)captureManagerStillImage:(UIImage *)_capturedImage
{
    NSLog(@"_capturedImage=%@",_capturedImage);
    NSLog(@":::::>%s %d",__FUNCTION__,__LINE__);
    if(!_capturedImage)
        return;
    [commond showLoading];
    FGPostCameraViewController *vc = (FGPostCameraViewController *)[self viewController];
    [vc dismissViewControllerAnimated:YES completion:^{
        [self performSelector:@selector(go2EditPostViewController:) withObject:[_capturedImage fixOrientation] afterDelay:.2];
    }];
}

- (void)captureManagerDeviceConfigurationChanged:(AVCamCaptureManager *)captureManager
{
    NSLog(@":::::>%s %d",__FUNCTION__,__LINE__);
}

#pragma mark - 相册相关
-(void)presentImagePickerFromVC:(UIViewController *)_parentVC
{
    if(pc_picker)
        return;
    
    pc_picker = [[UIImagePickerController alloc] init];
    pc_picker.delegate = self;
    [_parentVC presentViewController:pc_picker animated:YES completion:^{
        
    }];

}

#pragma mark - go2 edit 
-(void)go2EditPostViewController:(UIImage *)_img
{
        [commond removeLoading];
        [self stopAVCamSession];
        FGPostEditPhotoViewController *vc_postEdit = [[FGPostEditPhotoViewController alloc] initWithNibName:@"FGPostEditPhotoViewController" bundle:nil image:_img videoPath:nil];
    
    if(nav_current.presentedViewController)
    {
        [nav_current.presentedViewController presentViewController:vc_postEdit animated:YES completion:nil];
    }
    else
    {
        [nav_current presentViewController:vc_postEdit animated:YES completion:nil];
    }
    
    vc_postEdit = nil;
}

#pragma mark - go 2 share post
-(void)go2SharePost:(NSString *)_str_videoFilePath
{
    appDelegate.window.userInteractionEnabled = NO;
        [self stopAVCamSession];
    
        FGPostCameraViewController *vc = (FGPostCameraViewController *)[self viewController];
        [vc dismissViewControllerAnimated:YES completion:^{
            
//            NSString *_str_videoFilePath = self.captureManager.tempFileURL.path;
            NSLog(@"_str_videoFilePath = %@",_str_videoFilePath);
            FGPostShareViewController *vc_postShare = [[FGPostShareViewController alloc] initWithNibName:@"FGPostShareViewController" bundle:nil image:nil videoFilePath:_str_videoFilePath];
            [nav_current presentViewController:vc_postShare animated:YES completion:nil];
            vc_postShare = nil;
            appDelegate.window.userInteractionEnabled = YES;
        }];
        vc = nil;
    
}

#pragma mark - UIImagePickerControllerDelegate 

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    [commond showLoading];
    [pc_picker dismissViewControllerAnimated:NO completion:^{
        pc_picker = nil;
        UIImage *_tmp = [image fixOrientation];
        
        if(_tmp.size.height > 1080)
        {
           FGPostCameraViewController *vc = (FGPostCameraViewController *)[self viewController];
           [vc dismissViewControllerAnimated:NO completion:^{
               [self go2EditPostViewController:[_tmp rescaleImageToPX:1080]];
           }];
           vc = nil;
            
        }
        else
        {
            FGPostCameraViewController *vc = (FGPostCameraViewController *)[self viewController];
            
            [vc dismissViewControllerAnimated:NO completion:^{
                [self go2EditPostViewController:[_tmp rescaleImageToPX:1080]];
            }];
            vc = nil;
        }
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [pc_picker dismissViewControllerAnimated:YES completion:^{
        
        pc_picker = nil;
    }];
}


#pragma mark - buttonAction
-(IBAction)buttonAction_switchCamera:(UIButton *)_sender;
{
    CameraType _cameraType = (int)_sender.tag;
    if(currentCameraType == _cameraType)
        return;
    [self updateSwitchTypeByCameraType:_cameraType];
}



-(IBAction)buttonAction_cameraShoot:(id)_sender;
{
    [self captureStillImage];
}



-(IBAction)buttonAction_revert:(id)_sender;
{
    [self.captureManager toggleCamera];
}

-(IBAction)buttonAction_torch:(id)_sender;
{
    if([[self captureManager] session].running && [[self captureManager].videoInput device].position == AVCaptureDevicePositionBack)
    {
        AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        AVCaptureTorchMode torchMode = device.torchActive ? AVCaptureTorchModeOff : AVCaptureTorchModeOn;
        [device lockForConfiguration:nil];
        [device setTorchMode:torchMode];
        [device unlockForConfiguration];
    }
}



-(void)swipeAction:(UISwipeGestureRecognizer *)_sender
{
    if(btn_switchToSight.hidden)
        return;
    
    if(btn_swithToCamera.hidden)
        return;
    
    if( _sender.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self updateSwitchTypeByCameraType:CameraType_Video];
    }
    else if( _sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self updateSwitchTypeByCameraType:CameraType_Photo];
    }
}

-(void)tapOnVideoAction:(UITapGestureRecognizer *)_tap
{
    if(btn_switchToSight.hidden)
        return;
    
    if(btn_swithToCamera.hidden)
        return;
    
    CGPoint _tapPoint = [_tap locationInView:_tap.view];
    iv_focus.center = _tapPoint;
    CGSize size = view_videoContainer.bounds.size;
    CGPoint focusPoint = CGPointMake( _tapPoint.y /size.height ,1-_tapPoint.x/size.width );
    [self.captureManager continuousFocusAtPoint:focusPoint];
    iv_focus.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        iv_focus.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }completion:^(BOOL finished) {
        if(finished)
        {
            [UIView animateWithDuration:0.2 animations:^{
                iv_focus.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if(finished)
                    iv_focus.hidden = YES;
            }];
        }
        
    }];
}

/*获取录制时间*/
-(NSTimeInterval)getRecordTime:(NSDate *)_date_startRecordVideo
{
    date_endRecordVideo = [NSDate date];
    NSTimeInterval _recordTime = [date_endRecordVideo timeIntervalSinceDate:_date_startRecordVideo];
    return _recordTime;
}

/*timer 调用的方法*/
-(void)updateRecordPregoressView:(id)_sender
{
    CGFloat _recordTime = [self getRecordTime:date_startRecordVideo];
    CGFloat _percent = 1.0f - _recordTime / MAX_RECORD_SECONDS;
    CGRect _frame = view_progress.frame;
    _frame.size.width = W * _percent;
    view_progress.frame = _frame;
    view_progress.center = CGPointMake(W/2, view_progress.center.y);
    if((int)view_progress.frame.size.width <= 2)
    {
        [self cancelTimer];
        [self stopAVCamRecording];
        [self setStopRecordStatus];
        lb_tips.text = multiLanguage(@"Record Finished.");
    }
}

-(void)cancelTimer
{
    if(!timer_recordVideoProgress)
        return;
    SAFE_INVALIDATE_TIMER(timer_recordVideoProgress);
    timer_recordVideoProgress = nil;
    
}

-(void)setStartRecordStatus
{
    view_progress.hidden = NO;
    CGRect _frame = view_progress.frame;
    _frame.size.width = W;
    view_progress.frame = _frame;
    
}

-(void)setStopRecordStatus
{
    NSTimeInterval _recordTime = [self getRecordTime:date_startRecordVideo];
    view_progress.hidden = YES;
    if(_recordTime < MIN_RECORD_SECONDS)
        isCancelRecord = YES;
    else
        isCancelRecord = NO;
    CGRect _frame = view_progress.frame;
    _frame.size.width = 0;
    view_progress.frame = _frame;
    view_tipsBG.backgroundColor = [UIColor blackColor];
    lb_tips.text = multiLanguage(@"Tap and hold to record");
    [self cancelTimer];
    
}

/*以下4个方法组合定义了 视频拍摄按钮的行为*/
-(IBAction)buttonAction_sightShoot:(id)_sender;
{
    view_progress.hidden = NO;
    date_startRecordVideo = [NSDate date];
    [self setStartRecordStatus];
    [self startAVCamRecording];
    if(!timer_recordVideoProgress)
    {
        timer_recordVideoProgress = [NSTimer scheduledTimerWithTimeInterval:.06 target:self selector:@selector(updateRecordPregoressView:) userInfo:nil repeats:YES];
    }
    lb_tips.text = multiLanguage(@"Pull up to cancel.");
}

-(IBAction)buttonAction_sightShoot_upInside:(id)_sender;
{
    [self stopAVCamRecording];
    [self setStopRecordStatus];
}

-(IBAction)buttonAction_sightShoot_upOutside:(id)_sender;
{
    [self stopAVCamRecording];
    [self setStopRecordStatus];
}

-(void)panOnVideoAction:(UIPanGestureRecognizer *)_pan
{
    CGPoint _panPoint = [_pan locationInView:_pan.view];
    if(_panPoint.y <= RECORD_VIDEO_MOVEOUT_VALUE)
    {
        [self setStopRecordStatus];
        lb_tips.text = multiLanguage(@"Relase to cancel.");
        view_tipsBG.backgroundColor = color_red_panel;
        [self stopAVCamRecording];
        isCancelRecord = YES;
    }//cancel record
}


@end

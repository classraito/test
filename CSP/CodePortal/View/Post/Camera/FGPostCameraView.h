//
//  FGPostCameraView.h
//  CSP
//
//  Created by Ryan Gong on 16/10/26.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVCamCaptureManager.h"
#import "AVCamRecorder.h"
#import "AVCamUtilities.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/CGImageProperties.h>
typedef enum
{
    CameraType_Photo = 1,
    CameraType_Video = 2
}CameraType;

@interface FGPostCameraView : UIView<AVCamCaptureManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
}
@property(nonatomic,weak)IBOutlet UIView *view_videoContainer;
@property(nonatomic,weak)IBOutlet UIView *view_swithCameraType;
@property(nonatomic,weak)IBOutlet UIView *view_separator;
@property(nonatomic,weak)IBOutlet UIButton *btn_swithToCamera;
@property(nonatomic,weak)IBOutlet UIButton *btn_switchToSight;
@property(nonatomic,weak)IBOutlet UIImageView *iv_album;
@property(nonatomic,weak)IBOutlet UIButton *btn_album;
@property(nonatomic,weak)IBOutlet UIButton *btn_cameraShoot;
@property(nonatomic,weak)IBOutlet UIButton *btn_sightShoot;
@property(nonatomic,weak)IBOutlet UIButton *btn_revert;
@property(nonatomic,weak)IBOutlet UIButton *btn_torch;
@property(nonatomic,weak)IBOutlet UIButton *btn_cancel;
@property(nonatomic,weak)IBOutlet UIImageView *iv_focus;
@property (nonatomic,strong) AVCamCaptureManager *captureManager;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property(nonatomic,weak)IBOutlet UIView *view_progress;
@property(nonatomic,weak)IBOutlet UIView *view_tipsBG;
@property(nonatomic,weak)IBOutlet UILabel *lb_tips;
@property(nonatomic,weak)IBOutlet UIImageView *iv_torch;
@property(nonatomic,weak)IBOutlet UIImageView *iv_reverse;


@property CameraType currentCameraType;
-(void)setCameraType:(CameraType)_cameraTypes;
-(void)presentImagePickerFromVC:(UIViewController *)_parentVC;
-(IBAction)buttonAction_switchCamera:(id)_sender;
-(IBAction)buttonAction_cameraShoot:(id)_sender;
-(IBAction)buttonAction_revert:(id)_sender;
-(IBAction)buttonAction_torch:(id)_sender;
-(IBAction)buttonAction_sightShoot:(id)_sender;
-(IBAction)buttonAction_sightShoot_upInside:(id)_sender;
-(IBAction)buttonAction_sightShoot_upOutside:(id)_sender;
-(void)setupUI;
-(void)cancelTimer;
-(void)runAVCamSession;
-(void)stopAVCamSession;
@end

//
//  FGPostCameraViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/10/26.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostCameraViewController.h"

@interface FGPostCameraViewController ()

@end

@implementation FGPostCameraViewController
@synthesize view_camera;
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    SAFE_RemoveSupreView(self.view_topPanel);
    [self hideBottomPanelWithAnimtaion:NO];
    [self internalInitalPostCameraView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    if(view_camera)
    {
        [view_camera runAVCamSession];
    }
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
    view_camera = nil;
    
}

#pragma mark - 初始化
-(void)internalInitalPostCameraView
{
    if(view_camera)
        return;
    view_camera = (FGPostCameraView *)[[[NSBundle mainBundle] loadNibNamed:@"FGPostCameraView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_camera];
    [view_camera setupUI];
    [self.view addSubview:view_camera];
    
    [view_camera.btn_album addTarget:self action:@selector(buttonAction_album:) forControlEvents:UIControlEventTouchUpInside];
    [view_camera.btn_cancel addTarget:self action:@selector(buttonAction_cancel:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)buttonAction_cancel:(id)_sender;
{
    if(!view_camera)
        return;
    
    [view_camera cancelTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - 从父类继承的

-(void)buttonAction_album:(id)_sender;
{
    if(!view_camera)
        return;
    
    [view_camera presentImagePickerFromVC:self];
}

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
}
@end

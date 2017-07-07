//
//  FGPostEditPhotoViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/10/26.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostEditPhotoViewController.h"
#import "Global.h"
#import "FGPostShareViewController.h"
@interface FGPostEditPhotoViewController ()
{
    UIImage *image;
}
@end

@implementation FGPostEditPhotoViewController
@synthesize view_editPhoto;
@synthesize str_videoPath;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage *)_img videoPath:(NSString *)_str_videoPath
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        image = [_img copy];
        str_videoPath = [_str_videoPath mutableCopy];
    }
    return self;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // Do any additional setup after loading the view from its nib.
   
    self.view_topPanel.hidden = YES;
    
    self.view_topPanel.btn_right.titleLabel.font = font(FONT_TEXT_REGULAR, 14);
    
    
    [self internalInitalEditPhotoView];
    [self hideBottomPanelWithAnimtaion:NO];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self setWhiteBGStyle];
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
    view_editPhoto = nil;
    image = nil;
    str_videoPath = nil;
}

#pragma mark - 初始化
-(void)internalInitalEditPhotoView
{
    if(view_editPhoto)
        return;
    
    view_editPhoto = (FGPostEditPhotoView *)[[[NSBundle mainBundle] loadNibNamed:@"FGPostEditPhotoView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_editPhoto];
    [view_editPhoto setupNeedEditedImage:image];
    [self.view addSubview:view_editPhoto];
    [view_editPhoto.btn_cancel addTarget:self action:@selector(buttonAction_cancel:) forControlEvents:UIControlEventTouchUpInside];
    [view_editPhoto.btn_next addTarget:self action:@selector(buttonAction_next:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 从父类继承的

-(void)buttonAction_cancel:(id)_sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)buttonAction_next:(id)_sender
{
    [commond showLoading];
    [self dismissViewControllerAnimated:YES completion:^{
        
        UIImage *img_edited = [view_editPhoto getEditedImg];
        if(!nav_current.presentedViewController)
        {
            FGPostShareViewController *vc_postShare = [[FGPostShareViewController alloc] initWithNibName:@"FGPostShareViewController" bundle:nil image:img_edited videoFilePath:nil];
            [nav_current presentViewController:vc_postShare animated:YES completion:nil];
        }
        else
        {
            FGPostShareViewController *vc_postShare = (FGPostShareViewController *)nav_current.presentedViewController;
            [vc_postShare addImage:img_edited orVideoFilePath:nil];
        }
        [commond removeLoading];
        
    }];
    
    
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

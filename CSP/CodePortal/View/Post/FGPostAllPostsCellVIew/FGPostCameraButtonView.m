//
//  FGPostCameraButtonView.m
//  CSP
//
//  Created by Ryan Gong on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostCameraButtonView.h"
#import "Global.h"
#import "UIView+ViewController.h"
@implementation FGPostCameraButtonView
@synthesize iv_camera;
@synthesize btn_camera;
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:iv_camera];
    [commond useDefaultRatioToScaleView:btn_camera];
   
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(IBAction)buttonAction_go2Camera:(id)_sender;
{
    FGPostCameraViewController *vc_postCamera = [[FGPostCameraViewController alloc] initWithNibName:@"FGPostCameraViewController" bundle:nil];
    [nav_current presentViewController:vc_postCamera animated:YES completion:nil];
}
@end

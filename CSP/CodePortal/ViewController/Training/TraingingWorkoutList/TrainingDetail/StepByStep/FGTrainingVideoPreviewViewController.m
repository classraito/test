//
//  FGTrainingVideoPreviewViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingVideoPreviewViewController.h"
#import "Global.h"
@interface FGTrainingVideoPreviewViewController ()
{
    
}
@end

@implementation FGTrainingVideoPreviewViewController
@synthesize view_previewVideo;
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"VIDEO");
    self.view_topPanel.iv_right.hidden = YES;
    self.view_topPanel.btn_right.hidden = YES;
    [self hideBottomPanelWithAnimtaion:NO];
    
    [self internalInitalVideoPreviewView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPageDidChange) name:NOTIFICATION_KEY_VIDEOPAGE_CHANGED object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
}

-(void)manullyFixSize
{
    [super manullyFixSize];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_KEY_VIDEOPAGE_CHANGED object:nil];
    view_previewVideo = nil;
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(void)internalInitalVideoPreviewView
{
    if(view_previewVideo)
        return;
    view_previewVideo = (FGTrainingStepByStepPreviewVideoView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingStepByStepPreviewVideoView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_previewVideo];
    [self.view addSubview:view_previewVideo];
    [self videoPageDidChange];
}

#pragma mark - 当页面滑动时会通知此方法
-(void)videoPageDidChange
{
    FGVideoModel *model = [FGVideoModel sharedModel];
    self.view_topPanel.str_title = [[model.arr_urlInfos objectAtIndex:model.currentPlayerItemIndex] objectForKey:@"VideoName"];
}

#pragma mark - 从父类继承的

-(void)buttonAction_right:(id)_sender
{
    
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

//
//  FGFitnessVideoPlayMainView.m
//  CSP
//
//  Created by Ryan Gong on 16/10/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGFitnessVideoPlayMainView.h"
#import "Global.h"
@interface FGFitnessVideoPlayMainView()
{
}
@end

@implementation FGFitnessVideoPlayMainView
@synthesize arr_filepath;
@synthesize delegate_fitnessVideo;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_filepath = nil;
}

#pragma mark - 覆盖父类的功能
-(void)setupModel
{
    self.model_video = [FGVideoModel sharedModel];
    self.model_video.currentPlayerItemIndex = 0;
    [self.model_video internalInitalFilePathsByUrls:self.model_video.arr_urls];
    [self.model_video internalInitalAudioFilePathsByUrls:self.model_video.arr_audioUrls];//TODO:rui.gong update it
    [self.model_video initalAllPlayerItemsByCurrentFilePaths];
    [self.model_video initalVideoQueuePlayerLayer];
    [self.model_video addPlayerLayerToVideoContainerView:self.view_videoContainer];
    
    [self restartTimer];
    
}


-(void)tap_pause:(id)_sender
{
    if(self.model_video.currentPlayerItemIndex != 3)
        [super tap_pause:_sender];//如果不是plank excise,才触发父类功能
    else
    {
        if(delegate_fitnessVideo && [delegate_fitnessVideo respondsToSelector:@selector(didTapOnPlankExerciseVideo)])
        {
            
            [delegate_fitnessVideo didTapOnPlankExerciseVideo];
        }
    }
}

#pragma mark - 扩展父类的功能
-(void)updateUI
{
        [super updateUI];
       
       if(self.model_video.currentPlayerItemIndex == 3)
       {
           NSString *_str_currentVideoTime = @"∞";
           [self.cirB_currentVideTome.btn setTitle:_str_currentVideoTime forState:UIControlStateNormal];
           [self.cirB_currentVideTome.btn setTitle:_str_currentVideoTime forState:UIControlStateHighlighted];
           self.lb_totalVideoTime.text = _str_currentVideoTime;
           self.lb_pressToPause.text = multiLanguage(@"Press screen when you finish your plank");
           
           [UIView beginAnimations:nil context:nil];
           [UIView setAnimationDuration:1];
           [UIView setAnimationCurve:UIViewAnimationCurveLinear];
           float _progressPercent = 1;
           CGRect _frame = self.view_processBar.frame;
           _frame.size.width = self.view_processBarBG.frame.size.width * _progressPercent;
           self.view_processBar.frame = _frame;
           [UIView commitAnimations];
           [self cancelTimer];
       }
    
}

-(void)buttonAction_stop:(id)_sender
{
    if(self.popupView_pause)
    {
        [self.popupView_pause closePopup];
        self.popupView_pause = nil;
    }
    
    [self cancelTimer];
    
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager popViewControllerInNavigation:&nav_current animated:YES];
}

@end

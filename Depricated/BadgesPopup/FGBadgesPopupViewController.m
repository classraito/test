//
//  FGBadgesPopupViewController.m
//  CSP
//
//  Created by Ryan Gong on 17/1/11.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGBadgesPopupViewController.h"

@interface FGBadgesPopupViewController ()
{
    
}
@end

@implementation FGBadgesPopupViewController
@synthesize iv_badgeThumbnail;
@synthesize lb_title;
@synthesize cub_shareNow;
@synthesize btn_seeMyBadges;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    SAFE_RemoveSupreView(self.view_topPanel);
    [self hideBottomPanelWithAnimtaion:NO];
    
    [commond useDefaultRatioToScaleView:iv_badgeThumbnail];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:cub_shareNow];
    [commond useDefaultRatioToScaleView:btn_seeMyBadges];
    
    lb_title.font = font(FONT_TEXT_BOLD, 18);
    [cub_shareNow setupStyleWithButtonColor:[UIColor blackColor] underlineColor:[UIColor blackColor]];
    [cub_shareNow.btn setTitle:multiLanguage(@"SHARE NOW") forState:UIControlStateNormal];
    [cub_shareNow.btn setTitle:multiLanguage(@"SHARE NOW") forState:UIControlStateHighlighted];
    
    [btn_seeMyBadges setTitle:multiLanguage(@"SEE MY BADGES") forState:UIControlStateNormal];
    [btn_seeMyBadges setTitle:multiLanguage(@"SEE MY BADGES") forState:UIControlStateHighlighted];
    
    [btn_seeMyBadges addTarget:self action:@selector(buttonAction_seeMyBadges:) forControlEvents:UIControlEventTouchUpInside];
    [cub_shareNow.btn addTarget:self action:@selector(buttonAction_shareNow:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)updateBadgesPopup:(id)_sender
{
    NSString *str_thumbnail = [_sender objectForKey:@"Thumbnail"];
    NSString *str_brief = [_sender objectForKey:@"Brief"];
    [iv_badgeThumbnail sd_setImageWithURL:[NSURL URLWithString:str_thumbnail]];
    lb_title.text = str_brief;
}



-(void)dealloc
{
    NSLog(@"::::>dealloc %s %d",__FUNCTION__,__LINE__);
    vc_popup = nil;
}


-(void)buttonAction_shareNow:(id)_sender
{
    [self.popupController dismissWithCompletionAndNoAnimation:^{}];
    vc_popup = nil;
    //TODO: 分享
}

-(void)buttonAction_seeMyBadges:(id)_sender;
{
    [self.popupController dismissWithCompletionAndNoAnimation:^{}];
    vc_popup = nil;
    
    NSString *_str_id = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGMyBadgesViewController *vc_badges = [[FGMyBadgesViewController alloc] initWithNibName:@"FGMyBadgesViewController" bundle:nil withId:_str_id];
    [manager pushController:vc_badges navigationController:nav_current];
    
}
@end

//
//  FGBottomPanelView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/12.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBottomPanelView.h"
#import "Global.h"
@implementation FGBottomPanelView
@synthesize iv_home;
@synthesize iv_traning;
@synthesize iv_post;
@synthesize iv_profile;
@synthesize iv_location;

@synthesize lb_home;
@synthesize lb_post;
@synthesize lb_profile;
@synthesize lb_training;
@synthesize lb_locations;

@synthesize btn_home;
@synthesize btn_post;
@synthesize btn_profile;
@synthesize btn_traning;
@synthesize btn_location;

#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:iv_home];
    [commond useDefaultRatioToScaleView:iv_traning];
    [commond useDefaultRatioToScaleView:iv_post];
    [commond useDefaultRatioToScaleView:iv_profile];
    [commond useDefaultRatioToScaleView:iv_location];
    
    [commond useDefaultRatioToScaleView:lb_home];
    [commond useDefaultRatioToScaleView:lb_post];
    [commond useDefaultRatioToScaleView:lb_profile];
    [commond useDefaultRatioToScaleView:lb_training];
    [commond useDefaultRatioToScaleView:lb_locations];
    
    [commond useDefaultRatioToScaleView:btn_home];
    [commond useDefaultRatioToScaleView:btn_post];
    [commond useDefaultRatioToScaleView:btn_profile];
    [commond useDefaultRatioToScaleView:btn_traning];
    [commond useDefaultRatioToScaleView:btn_location];
    
    lb_home.text = multiLanguage(@"News");
    lb_training.text = multiLanguage(@"Training");
    lb_post.text = multiLanguage(@"Post");
    lb_locations.text = multiLanguage(@"Location_Booking");
    lb_profile.text = multiLanguage(@"Profile");
    
    lb_home.font = font(FONT_TEXT_REGULAR, 12);
    lb_training.font = font(FONT_TEXT_REGULAR, 12);
    lb_post.font = font(FONT_TEXT_REGULAR, 12);
    lb_locations.font = font(FONT_TEXT_REGULAR, 12);
    lb_profile.font = font(FONT_TEXT_REGULAR, 12);
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

#pragma mark - 切换按钮状态
-(void)setAllButtonNormalStatus
{
    iv_home.highlighted = NO;
    iv_traning.highlighted = NO;
    iv_post.highlighted = NO;
    iv_location.highlighted = NO;
    iv_profile.highlighted = NO;
}

#pragma mark - 设置按钮高亮
-(void)setButtonHighlightedByStatus:(int)_navigationStatus
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    manager.currentNavigationStatus = _navigationStatus;
    [self setAllButtonNormalStatus];
    
    switch (manager.currentNavigationStatus) {
        case NavigationStatus_Home:
                iv_home.highlighted = YES;
            break;
        case NavigationStatus_Training:
                iv_traning.highlighted = YES;
            break;
        case NavigationStatus_Post:
                iv_post.highlighted = YES;
            break;
        case NavigationStatus_Location:
                iv_location.highlighted = YES;
            break;
        case NavigationStatus_Profile:
                iv_profile.highlighted = YES;
            break;
    }
}

@end

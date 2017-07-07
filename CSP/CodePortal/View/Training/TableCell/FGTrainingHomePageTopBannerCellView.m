//
//  FGTrainingHomePageTopBannerView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingHomePageTopBannerCellView.h"
#import "Global.h"
@implementation FGTrainingHomePageTopBannerCellView
@synthesize iv_banner;
@synthesize btn;
@synthesize lb_title;
@synthesize iv_shadow;
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:iv_banner];
    [commond useDefaultRatioToScaleView:btn];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:iv_shadow];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 30);
    lb_title.numberOfLines = 2;
    
    lb_title.text = multiLanguage(@"FIND A TRAINER");
    
}

-(void)dealloc
{
    NSLog(@"::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(IBAction)buttonAction_go2SetPlan:(id)_sender;
{
    [self go2FindATrainer];
}

-(void)go2GetWorkoutPlan
{
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:[self viewController]];
    [[NetworkManager_Training sharedManager] postRequest_GetWorkoutPlan:_dic_info];
}

-(void)go2FindATrainer
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager pushControllerByName:@"FGLocationFindATrainerViewController" inNavigation:nav_current];
    
}


@end

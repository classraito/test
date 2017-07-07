//
//  FGPostCommentMorePopupView.m
//  CSP
//
//  Created by Ryan Gong on 16/10/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingMyPlanMorePopupView.h"
#import "Global.h"
@implementation FGTrainingMyPlanMorePopupView
@synthesize cb_cancel;
@synthesize cb_download;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:cb_cancel];
    [commond useDefaultRatioToScaleView:cb_download];
    
    [cb_cancel setFrame:cb_cancel.frame title:multiLanguage(@"CANCEL PLAN") arrimg:nil borderColor:color_red_panel textColor:color_red_panel bgColor:[UIColor whiteColor]];
    [cb_download setFrame:cb_download.frame title:multiLanguage(@"DOWNLOAD ALL") arrimg:nil borderColor:color_red_panel textColor:color_red_panel bgColor:[UIColor whiteColor]];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

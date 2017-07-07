//
//  FGPostCommentMorePopupView.m
//  CSP
//
//  Created by Ryan Gong on 16/10/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostCommentMorePopupView.h"
#import "Global.h"
@implementation FGPostCommentMorePopupView
@synthesize cb_cancel;
@synthesize cb_repoert;
@synthesize cb_deletePost;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:cb_cancel];
    [commond useDefaultRatioToScaleView:cb_repoert];
    [commond useDefaultRatioToScaleView:cb_deletePost];
    
    [cb_cancel setFrame:cb_cancel.frame title:multiLanguage(@"CANCEL") arrimg:nil borderColor:color_red_panel textColor:color_red_panel bgColor:[UIColor whiteColor]];
    [cb_repoert setFrame:cb_repoert.frame title:multiLanguage(@"REPORT") arrimg:nil borderColor:color_red_panel textColor:color_red_panel bgColor:[UIColor whiteColor]];
    [cb_deletePost setFrame:cb_deletePost.frame title:multiLanguage(@"DELETE") arrimg:nil borderColor:color_red_panel textColor:color_red_panel bgColor:[UIColor whiteColor]];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

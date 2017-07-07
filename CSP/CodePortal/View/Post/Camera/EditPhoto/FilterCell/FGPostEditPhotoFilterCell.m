//
//  FGPostEditPhotoFilterCell.m
//  CSP
//
//  Created by Ryan Gong on 16/11/2.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostEditPhotoFilterCell.h"
#import "Global.h"


@implementation FGPostEditPhotoFilterCell
@synthesize lb_filterName;
@synthesize iv_filter;
@synthesize btn_filter;
#pragma mark - 生命周期

-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:lb_filterName];
    [commond useDefaultRatioToScaleView:iv_filter];
    [commond useDefaultRatioToScaleView:btn_filter];
    
    lb_filterName.font = font(FONT_TEXT_BOLD, 14);
}

-(void)dealloc
{
    NSLog(@"::::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

//
//  FGStopWatchLogCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/6.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGStopWatchLogCellView.h"
#import "Global.h"

@implementation FGStopWatchLogCellView
@synthesize lb_lapTime;
@synthesize lb_lapname;
@synthesize view_separatorLine;
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:lb_lapTime];
    [commond useDefaultRatioToScaleView:lb_lapname];
    
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separatorLine];
    
    lb_lapname.font = font(FONT_TEXT_REGULAR, 18);
    lb_lapTime.font = font(FONT_NUM_REGULAR, 18);
}



-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

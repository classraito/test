//
//  FGTopPanelView.m
//  DunkinDonuts
//
//  Created by Ryan Gong on 15/11/16.
//  Copyright © 2015年 Ryan Gong. All rights reserved.
//

#import "FGTopPanelView.h"
#import "Global.h"

@implementation FGTopPanelView
@synthesize lb_title;
@synthesize iv_left;
@synthesize btn_left;
@synthesize iv_right;
@synthesize btn_right;
@synthesize btn_right_inside1;
@synthesize iv_right_indise1;
@synthesize cs_search;
@synthesize view_separator;
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.str_title = nil;
    lb_title.text = @"";
    
    
    lb_title.font = font(FONT_TEXT_BOLD, 20);
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:iv_left];
    [commond useDefaultRatioToScaleView:btn_left];
    [commond useDefaultRatioToScaleView:iv_right];
    [commond useDefaultRatioToScaleView:btn_right];
    [commond useDefaultRatioToScaleView:iv_right_indise1];
    [commond useDefaultRatioToScaleView:btn_right_inside1];
    [commond useDefaultRatioToScaleView:cs_search];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separator];
    
    view_separator.hidden = YES;
    iv_right_indise1.hidden = YES;
    btn_right_inside1.hidden = YES;
    cs_search.hidden = YES;

}

-(NSString *)getMyTitle
{
    return self.str_title;
}

-(void)setMyTitle:(NSString *)__str_title
{
    lb_title.text = __str_title;
    str_title = __str_title;
    
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

@end

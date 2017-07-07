//
//  FGTrainingSetPlanWeekSectionView.m
//  CSP
//
//  Created by Ryan Gong on 16/12/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingSetPlanWeekSectionView.h"
#import "Global.h"
@implementation FGTrainingSetPlanWeekSectionView
@synthesize lb_title;
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:lb_title];
    lb_title.font = font(FONT_TEXT_REGULAR, 14);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

//
//  FGTrainingWorkoutTypeCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingWorkoutTypeCellView.h"
#import "Global.h"
@implementation FGTrainingWorkoutTypeCellView
@synthesize iv_arr_right;
@synthesize iv_thumbnail;
@synthesize iv_shadow;
@synthesize lb_title;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [commond useDefaultRatioToScaleView:iv_arr_right];
    [commond useDefaultRatioToScaleView:iv_thumbnail];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:iv_shadow];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 22);
    lb_title.numberOfLines = 2;
    
    
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
    lb_title.text = _dataInfo;
}

-(void)dealloc
{
    NSLog(@"::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

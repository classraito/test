//
//  FGTrainingStepByStepCellViewTableViewCell.m
//  CSP
//
//  Created by Ryan Gong on 16/9/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingStepByStepCellViewTableViewCell.h"
#import "Global.h"
@interface FGTrainingStepByStepCellViewTableViewCell()
{
    
}
@end

@implementation FGTrainingStepByStepCellViewTableViewCell
@synthesize iv_arr_right;
@synthesize iv_thumbnail;
@synthesize lb_title;
@synthesize lb_duration;
@synthesize view_separator;
#pragma mark - 生命周期
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [commond useDefaultRatioToScaleView:iv_thumbnail];
    [commond useDefaultRatioToScaleView:iv_arr_right];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_duration];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separator];
    
    lb_duration.font = font(FONT_NUM_REGULAR, 15);
    lb_title.font = font(FONT_TEXT_REGULAR, 15);
    
    lb_duration.textColor = [UIColor lightGrayColor];
    lb_title.textColor = [UIColor blackColor];
    iv_thumbnail.backgroundColor = [UIColor lightGrayColor];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

#pragma mark - 填充数据
-(void)updateCellViewWithInfo:(id)_dataInfo
{
    NSMutableDictionary *_dic_dataInfo = (NSMutableDictionary *)_dataInfo;
    NSInteger sec = [[_dic_dataInfo objectForKey:@"Duration"] integerValue];
    lb_duration.text = [commond clockFormatBySeconds:sec ];
    lb_title.text = [_dic_dataInfo objectForKey:@"VideoName"];
    [iv_thumbnail sd_setImageWithURL:[NSURL URLWithString:[_dic_dataInfo objectForKey:@"Thumbnail"]]];
}
@end

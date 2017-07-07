//
//  FGTrainingDetailSubjectcCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingDetailSubjectcCellView.h"
#import "Global.h"
@implementation FGTrainingDetailSubjectcCellView
@synthesize view_separator;
@synthesize lb_title;
@synthesize lb_subtitle;
@synthesize iv_thumbnail;
@synthesize qv_images;
#pragma mark - 生命周期
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separator];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_subtitle];
    [commond useDefaultRatioToScaleView:iv_thumbnail];
    [commond useDefaultRatioToScaleView:qv_images];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 14);
    lb_subtitle.font = font(FONT_TEXT_REGULAR, 14);
    
    lb_title.textColor = color_qingse;
    lb_subtitle.textColor = [UIColor blackColor];
    
    qv_images.hidden = YES;
    
     [qv_images initalQueueByImageNames:@[@"hardness2.png",@"hardness2.png",@"hardness2.png",@"hardness2.png",@"hardness2.png"] highlightedImageNames:@[@"hardness1.png",@"hardness1.png",@"hardness1.png",@"hardness1.png",@"hardness1.png"] padding:1 imgBounds:CGRectMake(0, 0, 12 * ratioW, 12 * ratioW) increaseMode:ViewsQueueIncreaseMode_CENTER];
    
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
    NSMutableDictionary *_dic_dataInfo = (NSMutableDictionary *)_dataInfo;
    NSString *_str_key = [_dic_dataInfo objectForKey:@"Key"];
    lb_title.text = _str_key;
    
    NSString *_str_intensity = @"Intensity";
    NSString *_str_Level = @"Level";
    NSString *_str_Duration = @"Duration";
    NSString *_str_Equipment_Needed = @"Equipment_Needed";
    NSString *_str_Workout_Type = @"Workout_Type";
    NSString *_str_Estimated_Calories_Burned = @"Estimated_Calories_Burned";
    
    if([_str_intensity isEqualToString:_str_key])
    {
        iv_thumbnail.image = [UIImage imageNamed:@"Intensity.png"];
        lb_subtitle.hidden = YES;
        qv_images.hidden = NO;
        [qv_images updateHighliteByCount:[[_dic_dataInfo objectForKey:@"Value"] intValue]];
        lb_title.text = multiLanguage(_str_intensity);
        
    }
    else if([_str_Level isEqualToString:_str_key])
    {
        iv_thumbnail.image = [UIImage imageNamed:@"level.png"];
        lb_subtitle.text = [_dic_dataInfo objectForKey:@"Value"];
        lb_title.text = multiLanguage(_str_Level);
    }
    else if([_str_Duration isEqualToString:_str_key])
    {
        iv_thumbnail.image = [UIImage imageNamed:@"time.png"];
        lb_subtitle.text = [_dic_dataInfo objectForKey:@"Value"];
        lb_title.text = multiLanguage(_str_Duration);
    }
    else if([_str_Equipment_Needed isEqualToString:_str_key])
    {
        iv_thumbnail.image = [UIImage imageNamed:@"workout_training.png"];
        lb_subtitle.text = [_dic_dataInfo objectForKey:@"Value"];
        lb_title.text = multiLanguage(_str_Equipment_Needed);
    }
    else if([_str_Workout_Type isEqualToString:_str_key])
    {
        iv_thumbnail.image = [UIImage imageNamed:@"type.png"];
        lb_subtitle.text = [_dic_dataInfo objectForKey:@"Value"];
        lb_title.text = multiLanguage(_str_Workout_Type);
    }
    else if([_str_Estimated_Calories_Burned isEqualToString:_str_key])
    {
        iv_thumbnail.image = [UIImage imageNamed:@"fire.png"];
        lb_subtitle.text = [NSString stringWithFormat:@"%@ %@",[_dic_dataInfo objectForKey:@"Value"],multiLanguage(@"Cal")];
        lb_title.text = multiLanguage(_str_Estimated_Calories_Burned);
    }
    else if([@"Goal" isEqualToString:_str_key])
    {
        iv_thumbnail.image = [UIImage imageNamed:@"checklist.png"];
        lb_subtitle.text = [_dic_dataInfo objectForKey:@"Value"];
        
    }
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

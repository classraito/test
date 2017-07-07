//
//  FGTrainingSetPlanScheduleCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/12/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingSetPlanScheduleCellView.h"
#import "Global.h"
@interface FGTrainingSetPlanScheduleCellView()
{
    
}
@end

@implementation FGTrainingSetPlanScheduleCellView
@synthesize lb_weekDay;
@synthesize lb_monthDay;
@synthesize lb_title;
@synthesize lb_duration;
@synthesize lb_calorious;
@synthesize iv_duration;
@synthesize iv_calorious;
@synthesize iv_rightIcon;
@synthesize btn_rightAction;
@synthesize iconType;
@synthesize str_workoutId;
@synthesize arr_weeksName_CN;
@synthesize arr_weeksName_EN;
@synthesize dic_sports_Thumbnail;
@synthesize indexPathInTable;
@synthesize delegate;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [commond useDefaultRatioToScaleView:lb_weekDay];
    [commond useDefaultRatioToScaleView:lb_monthDay];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_duration];
    [commond useDefaultRatioToScaleView:lb_calorious];
    [commond useDefaultRatioToScaleView:iv_duration];
    [commond useDefaultRatioToScaleView:iv_calorious];
    [commond useDefaultRatioToScaleView:iv_rightIcon];
    [commond useDefaultRatioToScaleView:btn_rightAction];
    
    
    lb_title.font = font(FONT_TEXT_REGULAR, 14);
    lb_duration.font = font(FONT_TEXT_REGULAR, 13);
    lb_calorious.font = font(FONT_TEXT_REGULAR, 13);
    
    arr_weeksName_EN = @[@"S",@"M",@"T",@"W",@"T",@"F",@"S"];
    arr_weeksName_CN = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    
    dic_sports_Thumbnail = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic_sports_Thumbnail setObject:@"badmiton_green.png" forKey:@"Badminton"];
    [dic_sports_Thumbnail setObject:@"basketball_green.png" forKey:@"Basketball"];
    [dic_sports_Thumbnail setObject:@"other_green.png" forKey:@"Other"];
    [dic_sports_Thumbnail setObject:@"running_green.png" forKey:@"Running"];
    [dic_sports_Thumbnail setObject:@"soccer_green.png" forKey:@"Soccer"];
    [dic_sports_Thumbnail setObject:@"swimming_green.png" forKey:@"Swimming"];
    [dic_sports_Thumbnail setObject:@"tennis_green.png" forKey:@"Tennis"];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    str_workoutId = nil;
    arr_weeksName_EN = nil;
    arr_weeksName_CN = nil;
}

-(void)sharedPart:(id)_dataInfo
{
    
    str_workoutId = [_dataInfo objectForKey:@"TrainingId"];
    
    long dateValue = [[_dataInfo objectForKey:@"Date"] longValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateValue];
    NSDateComponents *components = [commond dateComponentsWithDate:date];
    NSInteger weekdayIndex = components.weekday - 1;
    NSInteger dayInMonth = components.day;
    NSString *_str_weekName = @"";
    if([commond isChinese])
        _str_weekName = [arr_weeksName_CN objectAtIndex:weekdayIndex];
    else
        _str_weekName = [arr_weeksName_EN objectAtIndex:weekdayIndex];
    lb_weekDay.text = _str_weekName;
    lb_monthDay.text = [NSString stringWithFormat:@"%ld",dayInMonth];
    
    if([@"rest" isEqualToString:str_workoutId])
    {
        iv_rightIcon.image = [UIImage imageNamed:@"plus.png"];
        iv_duration.hidden = YES;
        lb_duration.hidden = YES;
        iv_calorious.hidden = YES;
        lb_calorious.hidden = YES;
        lb_title.textColor = [UIColor lightGrayColor];
        lb_title.text = multiLanguage(@"Recovery Day");
        iconType = IconType_Black_Plus;
    }
    else if([@"sport" isEqualToString:str_workoutId])
    {
        iv_rightIcon.image = [UIImage imageNamed:@"min.png"];
        iv_duration.hidden = NO;
        lb_duration.hidden = NO;
        iv_calorious.hidden = YES;
        lb_calorious.hidden = YES;
        lb_title.textColor = [UIColor lightGrayColor];
        lb_title.text = multiLanguage(@"Recovery Day");
        iconType = IconType_Black_Minus;
        lb_duration.text = [_dataInfo objectForKey:@"ScreenName"];
        NSString *_str_screenNameEN = [_dataInfo objectForKey:@"ScreenNameEN"];
        NSString *str_imgName = [dic_sports_Thumbnail objectForKey:_str_screenNameEN];
        
        iv_duration.image = [UIImage imageNamed:str_imgName];
    }
    else
    {
        iv_rightIcon.image = [UIImage imageNamed:@"min.png"];
        iv_duration.hidden = NO;
        lb_duration.hidden = NO;
        iv_calorious.hidden = NO;
        lb_calorious.hidden = NO;
        lb_title.textColor = [UIColor blackColor];
        
        NSString *_str_ScreenName = [_dataInfo objectForKey:@"ScreenName"];
        lb_title.text = _str_ScreenName;
        NSInteger minutes = [[_dataInfo objectForKey:@"Minutes"] integerValue];
        lb_duration.text = [commond clockFormatBySeconds:minutes];
        lb_calorious.text = [NSString stringWithFormat:@"%@",[_dataInfo objectForKey:@"Consume"]];
        iconType = IconType_Black_Minus;
        iv_duration.image = [UIImage imageNamed:@"time.png"];
    }
}

-(void)updateCellViewWithInfo_EditPlan:(id)_dataInfo
{
    [self sharedPart:_dataInfo];
}

-(void)updateCellViewWithInfo_MyPlan:(id)_dataInfo
{
    [self sharedPart:_dataInfo];
    if([@"rest" isEqualToString:str_workoutId])
    {
        iv_rightIcon.image = [UIImage imageNamed:@"plus_green.png"];
        iconType = IconType_Blue_Plus;
    }
    else if([@"sport" isEqualToString:str_workoutId])
    {
        BOOL isComplete = [[_dataInfo objectForKey:@"IsComplete"] boolValue];
        if(isComplete)
        {
           iv_rightIcon.image = [UIImage imageNamed:@"done.png"];
            iconType = IconType_Blue_Dot;
        }
        else
        {
            iv_rightIcon.image = [UIImage imageNamed:@"notdone.png"];
            iconType = IconType_Blue_EmptyDot;
        }
    }
    else
    {
        BOOL isComplete = [[_dataInfo objectForKey:@"IsComplete"] boolValue];
        if(isComplete)
        {
            iv_rightIcon.image = [UIImage imageNamed:@"done.png"];
            iconType = IconType_Blue_Dot;
        }
        else
        {
            iv_rightIcon.image = [UIImage imageNamed:@"notdone.png"];
            iconType = IconType_Blue_EmptyDot;
        }
    }
    
    
    
    long myDate = [[_dataInfo objectForKey:@"Date"] longValue];
    NSDate *itemDate = [NSDate dateWithTimeIntervalSince1970:myDate];
    NSDate *currentDate = [NSDate date];
    BOOL _isSameDay = [currentDate isSameDay:itemDate];
    NSInteger hoursFrom = [currentDate hoursFrom:itemDate];
    if(_isSameDay)//同一天
    {
        lb_weekDay.font = font(FONT_TEXT_BOLD, 16);
        lb_monthDay.font = font(FONT_TEXT_BOLD, 16);
    }
    else
    {
        lb_weekDay.font = font(FONT_TEXT_REGULAR, 14);
        lb_monthDay.font = font(FONT_TEXT_REGULAR, 14);
        if(hoursFrom > 0 )//比今天早
        {
            iv_rightIcon.image = [UIImage imageNamed:@"close1.png"];
        }
    }
}

-(IBAction)buttonAction_rightAction:(id)_sender;
{
    if(delegate && [delegate respondsToSelector:@selector(didClickRightButtonActionAtCell:)])
    {
        [delegate didClickRightButtonActionAtCell:self];
    }
}
@end

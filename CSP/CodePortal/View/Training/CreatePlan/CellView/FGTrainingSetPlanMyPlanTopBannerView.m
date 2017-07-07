//
//  FGTrainingSetPlanMyPlanTopBannerView.m
//  CSP
//
//  Created by Ryan Gong on 16/12/15.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingSetPlanMyPlanTopBannerView.h"
#import "Global.h"
@implementation FGTrainingSetPlanMyPlanTopBannerView
@synthesize view_infoContainer;
@synthesize lb_title;
@synthesize lb_date;
@synthesize btn_doWorkout;
@synthesize iv_thumbnail;
@synthesize str_workoutId;
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:view_infoContainer];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_date];
    [commond useDefaultRatioToScaleView:btn_doWorkout];
    [commond useDefaultRatioToScaleView:iv_thumbnail];
    
    lb_title.font = font(FONT_TEXT_BOLD, 28);
    lb_date.font = font(FONT_TEXT_REGULAR, 20);
    btn_doWorkout.layer.cornerRadius = btn_doWorkout.frame.size.height / 2;
    btn_doWorkout.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    NSString *_str_doWorkout = multiLanguage(@"Start workout");
    [btn_doWorkout setTitle:_str_doWorkout forState:UIControlStateNormal];
    [btn_doWorkout setTitle:_str_doWorkout forState:UIControlStateHighlighted];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    str_workoutId = nil;
}

-(void)initalCellWithInfo:(id)_dataInfo
{
    NSMutableArray *_arr_data = (NSMutableArray *)_dataInfo;
    
    for(NSMutableArray *_arr_singleWeek in _arr_data)
    {
        for(NSMutableDictionary *_dic_singleDay in _arr_singleWeek)
        {
            str_workoutId = [_dic_singleDay objectForKey:@"TrainingId"];
            long myDate = [[_dic_singleDay objectForKey:@"Date"] longValue];
            NSDate *itemDate = [NSDate dateWithTimeIntervalSince1970:myDate];
            NSDate *currentDate = [NSDate date];
            BOOL _isSameDay = [currentDate isSameDay:itemDate];
            if(_isSameDay)
            {
                
                NSString *str_dateFormat = @"MM / dd";
                if([commond isChinese])
                {
                    str_dateFormat = @"MM月dd日";
                    lb_date.text = [commond dateStringBySince1970:myDate dateFormat:str_dateFormat];
                }
                else
                {
                    lb_date.text = [NSString stringWithFormat:@"DAY %@",[commond dateStringBySince1970:myDate dateFormat:str_dateFormat]];
                }
                
                
                if([@"rest" isEqualToString:str_workoutId] || [@"sport" isEqualToString:str_workoutId])
                {
                    lb_title.text = multiLanguage(@"RECOVERY DAY");
                    
                    btn_doWorkout.hidden = YES;
                    view_infoContainer.center = CGPointMake(view_infoContainer.center.x, self.frame.size.height / 2);
                }
                else
                {
                    lb_title.text = [_dic_singleDay objectForKey:@"ScreenName"];
                    btn_doWorkout.hidden = NO;
                    CGRect _frame = view_infoContainer.frame;
                    _frame.origin.y = 40 * ratioH;
                    view_infoContainer.frame = _frame;
                    return;
                }
                
            }
        }
    }
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
    str_workoutId = [_dataInfo objectForKey:@"TrainingId"];
    long myDate = [[_dataInfo objectForKey:@"Date"] longValue];
   
        NSString *str_dateFormat = @"MM / dd";
        if([commond isChinese])
        {
            str_dateFormat = @"MM月dd日";
            lb_date.text = [commond dateStringBySince1970:myDate dateFormat:str_dateFormat];
        }
        else
        {
            lb_date.text = [NSString stringWithFormat:@"DAY %@",[commond dateStringBySince1970:myDate dateFormat:str_dateFormat]];
        }
        
        
        if([@"rest" isEqualToString:str_workoutId] || [@"sport" isEqualToString:str_workoutId])
        {
            lb_title.text = multiLanguage(@"RECOVERY DAY");
            
            btn_doWorkout.hidden = YES;
            view_infoContainer.center = CGPointMake(view_infoContainer.center.x, self.frame.size.height / 2);
        }
        else
        {
            lb_title.text = [_dataInfo objectForKey:@"ScreenName"];
            
            CGRect _frame = view_infoContainer.frame;
            _frame.origin.y = 40 * ratioH;
            view_infoContainer.frame = _frame;
            
            long myDate = [[_dataInfo objectForKey:@"Date"] longValue];
            NSDate *itemDate = [NSDate dateWithTimeIntervalSince1970:myDate];
            NSDate *currentDate = [NSDate date];
            BOOL _isSameDay = [currentDate isSameDay:itemDate];
            if(_isSameDay)
            {
                btn_doWorkout.hidden = NO;
            }
            else
            {
                btn_doWorkout.hidden = YES;
                view_infoContainer.center = CGPointMake(view_infoContainer.center.x, self.frame.size.height / 2);
            }
        }
        
    
}

-(IBAction)buttonAction_doWorkout:(id)_sender;
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGTrainingDetailViewController *vc = [[FGTrainingDetailViewController alloc] initWithNibName:@"FGTrainingDetailViewController" bundle:nil workoutID:str_workoutId];
    [manager pushController:vc navigationController:nav_current];
}
@end

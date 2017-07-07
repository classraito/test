//
//  FGTrainingSetplanView.m
//  CSP
//
//  Created by Ryan Gong on 16/12/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingSetplanView.h"
#import "Global.h"
#import "FGTrainingSetPlanModel.h"
#define MAX_DATE_DAYS 30
@interface FGTrainingSetplanView()
{
    NSMutableArray *arr_options_level;
    NSMutableArray *arr_options_equipment;
    NSMutableArray *arr_options_goal;
    NSMutableArray *arr_options_week;
    NSMutableArray *arr_options_workoutPerWeek;
}
@end

@implementation FGTrainingSetplanView
@synthesize lb_key_level;
@synthesize lb_value_level;
@synthesize lb_key_equipment;
@synthesize lb_value_equipment;
@synthesize lb_key_goal;
@synthesize lb_value_goal;
@synthesize lb_key_startdate;
@synthesize lb_value_startdate;
@synthesize lb_Key_week;
@synthesize lb_value_week;
@synthesize lb_key_workoutPerWeek;
@synthesize lb_value_workoutPerWeek;
@synthesize btn_next;
@synthesize view_separator1_h;
@synthesize view_separator2_h;
@synthesize view_separator3_h;
@synthesize view_separator4_h;
@synthesize view_separator5_h;
@synthesize view_separator6_h;
@synthesize dp_picker;
@synthesize btn_level;
@synthesize btn_equipment;
@synthesize btn_goal;
@synthesize btn_startDate;
@synthesize btn_week;
@synthesize btn_workoutPerWeek;
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:lb_key_level];
    [commond useDefaultRatioToScaleView:lb_value_level];
    [commond useDefaultRatioToScaleView:lb_key_equipment];
    [commond useDefaultRatioToScaleView:lb_value_equipment];
    [commond useDefaultRatioToScaleView:lb_key_goal];
    [commond useDefaultRatioToScaleView:lb_value_goal];
    [commond useDefaultRatioToScaleView:lb_key_startdate];
    [commond useDefaultRatioToScaleView:lb_value_startdate];
    [commond useDefaultRatioToScaleView:lb_Key_week];
    [commond useDefaultRatioToScaleView:lb_value_week];
    [commond useDefaultRatioToScaleView:lb_key_workoutPerWeek];
    [commond useDefaultRatioToScaleView:lb_value_workoutPerWeek];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separator1_h];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separator2_h];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separator3_h];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separator4_h];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separator5_h];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separator6_h];
    [commond useDefaultRatioToScaleView:dp_picker];
    [commond useDefaultRatioToScaleView:btn_next];
    [commond useDefaultRatioToScaleView:btn_level];
    [commond useDefaultRatioToScaleView:btn_equipment];
    [commond useDefaultRatioToScaleView:btn_goal];
    [commond useDefaultRatioToScaleView:btn_startDate];
    [commond useDefaultRatioToScaleView:btn_week];
    [commond useDefaultRatioToScaleView:btn_workoutPerWeek];
    
    lb_key_level.font = font(FONT_TEXT_REGULAR, 14);
    lb_value_level.font = font(FONT_TEXT_REGULAR, 14);
    lb_key_equipment.font = font(FONT_TEXT_REGULAR, 14);
    lb_value_equipment.font = font(FONT_TEXT_REGULAR, 14);
    lb_key_goal.font = font(FONT_TEXT_REGULAR, 14);
    lb_value_goal.font = font(FONT_TEXT_REGULAR, 14);
    lb_key_startdate.font = font(FONT_TEXT_REGULAR, 14);
    lb_value_startdate.font = font(FONT_TEXT_REGULAR, 14);
    lb_Key_week.font = font(FONT_TEXT_REGULAR, 14);
    lb_value_week.font = font(FONT_TEXT_REGULAR, 14);
    lb_key_workoutPerWeek.font = font(FONT_TEXT_REGULAR, 14);
    lb_value_workoutPerWeek.font = font(FONT_TEXT_REGULAR, 14);
    
    btn_next.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    btn_next.backgroundColor = color_red_panel;
    [btn_next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_next setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setViewRoundCorner:btn_next.frame.size.height / 2 view:btn_next];
    
    lb_key_level.text = multiLanguage(@"Your level:");
    lb_key_equipment.text = multiLanguage(@"Equipment:");
    lb_key_goal.text = multiLanguage(@"Goal:");
    lb_key_startdate.text = multiLanguage(@"Start date:");
    lb_Key_week.text = multiLanguage(@"Week:");
    lb_key_workoutPerWeek.text = multiLanguage(@"Workout per week:");
    
    arr_options_level = [@[BoxingLevelToString(BL_Beginner),
                          BoxingLevelToString(BL_Intermediate),
                          BoxingLevelToString(BL_Advanced)] mutableCopy];
    
    arr_options_equipment = [@[multiLanguage(@"No Equipment"),multiLanguage(@"With Equipment")] mutableCopy];
    
    arr_options_goal = [@[
                        GoalToString(Goal_loseWeight),
                        GoalToString(Goal_gettoned),
                        GoalToString(Goal_howtobox)] mutableCopy];
    
    arr_options_week = [@[@"1",@"2",@"3",@"4"] mutableCopy];
    
    arr_options_workoutPerWeek = [@[@"2",@"3",@"4",@"5",@"6"] mutableCopy];
    
    lb_value_level.text = [arr_options_level objectAtIndex:0];
    lb_value_equipment.text = [arr_options_equipment objectAtIndex:0];
    lb_value_goal.text = [arr_options_goal objectAtIndex:0];
    lb_value_startdate.text = [[self giveMeDateFormatLaterThanNow] objectAtIndex:0];
    lb_value_week.text = [arr_options_week lastObject];
    lb_value_workoutPerWeek.text = [arr_options_workoutPerWeek objectAtIndex:2];
    
    
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_options_level = nil;
    arr_options_equipment = nil;
    arr_options_goal = nil;
    arr_options_week = nil;
    arr_options_workoutPerWeek = nil;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)updateGoalDatas
{
    if([lb_value_equipment.text isEqualToString:[arr_options_equipment objectAtIndex:1]])
    {
        lb_value_goal.text = [arr_options_goal lastObject];
        arr_options_goal = nil;
        arr_options_goal = [@[GoalToString(Goal_howtobox)] mutableCopy];
    }
    else
    {
        arr_options_goal = nil;
        arr_options_goal = [@[
                              GoalToString(Goal_loseWeight),
                              GoalToString(Goal_gettoned),
                              GoalToString(Goal_howtobox)] mutableCopy];
    }
}

#pragma mark - buttonAction
-(IBAction)buttonAction_yourLevel:(id)_sender;
{
    [self removeAllInputView];
    [self internalInitalDataPickerView:arr_options_level pickerType:SetPlanPickType_yourLevel];
}

-(IBAction)buttonAction_equipment:(id)_sender;
{
    [self updateGoalDatas];
    [self removeAllInputView];
    [self internalInitalDataPickerView:arr_options_equipment pickerType:SetPlanPickType_equipment];
}

-(IBAction)buttonAction_goal:(id)_sender;
{
    [self updateGoalDatas];
    [self removeAllInputView];
    [self internalInitalDataPickerView:arr_options_goal pickerType:SetPlanPickType_goal];
}

-(IBAction)buttonAction_startDate:(id)_sender;
{
    [self removeAllInputView];
    NSMutableArray *arr_dateFormat = [self giveMeDateFormatLaterThanNow];
    [self internalInitalDataPickerView:arr_dateFormat pickerType:SetPlanPickType_startDate];
}

-(IBAction)buttonAction_week:(id)_sender;
{
    [self removeAllInputView];
    [self internalInitalDataPickerView:arr_options_week pickerType:SetPlanPickType_week];
}

-(IBAction)buttonAction_workoutPerWeek:(id)_sender;
{
    [self removeAllInputView];
    [self internalInitalDataPickerView:arr_options_workoutPerWeek pickerType:SetPlanPickType_workoutPerWeek];
}

-(IBAction)buttonAction_next:(id)_sender;
{
    [self postRequest_setPlan];
}


#pragma mark - 生成时间选项
-(NSMutableArray *)giveMeDateFormatLaterThanNow
{
    NSMutableArray *arr_dates = [NSMutableArray arrayWithCapacity:1];
    NSDate * date = [NSDate date];
    NSString *str_dateFormatter = nil;
    if([commond isChinese])
    {
        str_dateFormatter = @"YYYY年MM月dd日";
    }
    else
    {
        str_dateFormatter = @"YYYY / MM / dd";
    }
    for(int i =0 ; i<MAX_DATE_DAYS;i++)
    {
        NSDate *newDate = [date dateByAddingDays:i];
        NSString *dateFormat = [newDate formattedDateWithFormat:str_dateFormatter ];
        
        [arr_dates addObject:dateFormat];
    }
    return arr_dates;
}

#pragma mark - 设置视图圆角
-(void)setViewRoundCorner:(CGFloat)_cornerRadius view:(UIView *)_view
{
    _view.layer.cornerRadius = _cornerRadius;
    _view.layer.masksToBounds = YES;
}

#pragma mark - 初始化 FGDataPickerView
-(void)internalInitalDataPickerView:(NSMutableArray *)_arr_datas pickerType:(SetPlanPickType)_pickType
{
    if(dp_picker)
        return;
    
    dp_picker = (FGDataPickeriView *)[[[NSBundle mainBundle] loadNibNamed:@"FGDataPickeriView" owner:nil options:nil] objectAtIndex:0];
    dp_picker.delegate = self;
    dp_picker.tag = _pickType;
    [dp_picker setupDatas:_arr_datas];
    CGRect _frame = dp_picker.frame;
    _frame.size.width = self.frame.size.width;
    _frame.origin.y = H;
    dp_picker.frame = _frame;
    dp_picker.center = CGPointMake(self.frame.size.width / 2, dp_picker.center.y);
    [appDelegate.window addSubview:dp_picker];
    
    
    [UIView beginAnimations:nil context:nil];
    _frame = dp_picker.frame;
    _frame.origin.y = H - dp_picker.frame.size.height;
    dp_picker.frame = _frame;
    [UIView commitAnimations];
    
    self.currentSlideUpHeight = dp_picker.frame.size.height;
    [self adjustVisibleRegion:self.currentSlideUpHeight];
    
    NSString *_str_firstDate = [_arr_datas objectAtIndex:0];
    [self didSelectData:_str_firstDate picker:dp_picker];
    
}

#pragma mark - 从父类继承的方法 实现移除全部弹出控件 父类只实现了移除所有键盘 其他自定义控件要在此实现移除
-(void)removeAllInputView
{
    [super removeAllInputView];
    if(dp_picker)
    {
        CGRect _frame = dp_picker.frame;
        _frame.origin.y = H;
        dp_picker.frame = _frame;
        [self resetVisibleRegion];
        
        [dp_picker removeFromSuperview];
        dp_picker = nil;
    }
}

-(void)fadeInForView:(UIView *)_view
{
    _view.alpha = 0;
    [UIView beginAnimations:nil context:nil];
    _view.alpha = 1;
    [UIView commitAnimations];
}

#pragma mark -  FGDataPickerViewDelegate
-(void)didSelectData:(NSString *)_str_selected picker:(id)_dataPicker;
{
   
    if([_dataPicker isKindOfClass:[FGDataPickeriView class]])
    {
        FGDataPickeriView *_picker = (FGDataPickeriView *)_dataPicker;
        SetPlanPickType pickType = (int)_picker.tag;
        switch (pickType) {
            case SetPlanPickType_yourLevel:
                lb_value_level.text = _str_selected;
                [self fadeInForView:lb_value_level];
                break;
                
            case SetPlanPickType_equipment:
                lb_value_equipment.text = _str_selected;
                [self fadeInForView:lb_value_equipment];
                if([lb_value_equipment.text isEqualToString:[arr_options_equipment objectAtIndex:1]])
                {
                    lb_value_goal.text = [arr_options_goal lastObject];
                }
                break;
            case SetPlanPickType_goal:
                lb_value_goal.text = _str_selected;
                [self fadeInForView:lb_value_goal];
                break;
            case SetPlanPickType_startDate:
                lb_value_startdate.text = _str_selected;
                [self fadeInForView:lb_value_startdate];
                break;
            case SetPlanPickType_week:
                lb_value_week.text = _str_selected;
                [self fadeInForView:lb_value_week];
                break;
            case SetPlanPickType_workoutPerWeek:
                lb_value_workoutPerWeek.text = _str_selected;
                [self fadeInForView:lb_value_workoutPerWeek];
                break;
        }
    }
    
}

-(void)didCloseDataPicker:(NSString *)_str_selected  picker:(id)_dataPicker;
{
    [self removeAllInputView];
}

-(void)postRequest_setPlan
{
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:[self viewController]];
    int level = BoxingLevelToInteger(lb_value_level.text);
    int equipment;
    if([lb_value_equipment.text isEqualToString:[arr_options_equipment objectAtIndex:0]])
    {
        equipment = 2;
    }
    else
    {
        equipment = 1;
    }
    int goal = GoalToInteger(lb_value_goal.text);
    int weeks = [lb_value_week.text intValue];
    int workoutPerWeek = [lb_value_workoutPerWeek.text intValue];
    NSString *str_dateFormatter = nil;
    if([commond isChinese])
    {
        str_dateFormatter = @"YYYY年MM月dd日";
    }
    else
    {
        str_dateFormatter = @"YYYY / MM / dd";
    }

    NSDate *date =  [commond dateFromString:lb_value_startdate.text formatter:str_dateFormatter];
    long timeStamp = [date timeIntervalSince1970];
    
    FGTrainingSetPlanModel *setPlanModel = [FGTrainingSetPlanModel sharedModel];
    setPlanModel.timeStamp = timeStamp;
    
    [[NetworkManager_Training sharedManager] postRequest_GetOriginalWorkoutPlan:level equipment:equipment goal:goal weeks:weeks workoutPerWeek:workoutPerWeek timeStamp:timeStamp userinfo:_dic_info];
}
@end

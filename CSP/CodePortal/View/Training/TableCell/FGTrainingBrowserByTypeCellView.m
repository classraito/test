//
//  FGTrainingBrowserByTypeCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingBrowserByTypeCellView.h"
#import "Global.h"
@interface FGTrainingBrowserByTypeCellView()
{
    WorkoutType currentWorkoutType;
    NSString *str_footwork;
    NSString *str_conditioning;
    NSString *str_bag;
    NSString *str_headMovement;
    NSString *str_pad;
}
@end

@implementation FGTrainingBrowserByTypeCellView
@synthesize lb_title;
@synthesize cb_footwork;
@synthesize cb_conditioning;
@synthesize cb_bag;
@synthesize cb_headMovement;
@synthesize cb_pad;
@synthesize delegate;
#pragma mark - 生命周期
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:cb_footwork];
    [commond useDefaultRatioToScaleView:cb_conditioning];
    [commond useDefaultRatioToScaleView:cb_bag];
    [commond useDefaultRatioToScaleView:cb_headMovement];
    [commond useDefaultRatioToScaleView:cb_pad];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 16);
    
    str_footwork = multiLanguage(@"FOOTWORK");
    str_conditioning = multiLanguage(@"CONDITIONING");
    str_bag = multiLanguage(@"BAG");
    str_headMovement = multiLanguage(@"HEAD MOVEMENT");
    str_pad = multiLanguage(@"PAD");
    
    [self setupCustomButtons];
}

-(void)setupCustomButtons
{
    [cb_footwork setFrame:cb_footwork.frame title:str_footwork arrimg:nil borderColor:[UIColor lightGrayColor] textColor:[UIColor lightGrayColor] bgColor:[UIColor clearColor]];
    
    [cb_conditioning setFrame:cb_conditioning.frame title:str_conditioning arrimg:nil borderColor:[UIColor lightGrayColor] textColor:[UIColor lightGrayColor] bgColor:[UIColor clearColor]];

    
    [cb_bag setFrame:cb_bag.frame title:str_bag arrimg:nil borderColor:[UIColor lightGrayColor] textColor:[UIColor lightGrayColor] bgColor:[UIColor clearColor]];

    
    [cb_headMovement setFrame:cb_headMovement.frame title:str_headMovement arrimg:nil borderColor:[UIColor lightGrayColor] textColor:[UIColor lightGrayColor] bgColor:[UIColor clearColor]];

    
    [cb_pad setFrame:cb_pad.frame title:str_pad arrimg:nil borderColor:[UIColor lightGrayColor] textColor:[UIColor lightGrayColor] bgColor:[UIColor clearColor]];

    
    cb_footwork.button.tag = WorkoutType_Footwork;
    cb_conditioning.button.tag = WorkoutType_Conditioning;
    cb_bag.button.tag = WorkoutType_Bag;
    cb_headMovement.button.tag = WorkoutType_HeadMovement;
    cb_pad.button.tag = WorkoutType_Pad;
    
    
    
    [cb_footwork.button addTarget:self action:@selector(buttonAction_filterClick:) forControlEvents:UIControlEventTouchUpInside];
    [cb_conditioning.button addTarget:self action:@selector(buttonAction_filterClick:) forControlEvents:UIControlEventTouchUpInside];
    [cb_bag.button addTarget:self action:@selector(buttonAction_filterClick:) forControlEvents:UIControlEventTouchUpInside];
    [cb_headMovement.button addTarget:self action:@selector(buttonAction_filterClick:) forControlEvents:UIControlEventTouchUpInside];
    [cb_pad.button addTarget:self action:@selector(buttonAction_filterClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 根据类型返回字符串
-(NSString *)giveMeTypeNameByType:(WorkoutType)_workoutType
{
    if(_workoutType == WorkoutType_Footwork)
        return str_footwork;
    if(_workoutType == WorkoutType_Conditioning)
        return str_conditioning;
    if(_workoutType == WorkoutType_Bag)
        return str_bag;
    if(_workoutType == WorkoutType_HeadMovement)
        return str_headMovement;
    if(_workoutType == WorkoutType_Pad)
        return str_pad;
    
    return nil;
    
}

#pragma mark - 点击事件
-(void)buttonAction_filterClick:(id)_sender
{
    UIButton *_btn = (UIButton *)_sender;
    
    currentWorkoutType = (int)_btn.tag;
    
    if(delegate && [delegate respondsToSelector:@selector(browserByTypeDidSelected:workoutType:)])
    {
        [delegate browserByTypeDidSelected:[self giveMeTypeNameByType:currentWorkoutType] workoutType:currentWorkoutType];
    }
    
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

@end

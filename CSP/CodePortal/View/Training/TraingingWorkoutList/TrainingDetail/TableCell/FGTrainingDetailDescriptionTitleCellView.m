//
//  FGTrainingDetailDescriptionTitleCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingDetailDescriptionTitleCellView.h"
#import "Global.h"
@interface FGTrainingDetailDescriptionTitleCellView()
{
    
}
@end

@implementation FGTrainingDetailDescriptionTitleCellView
@synthesize lb_title;
@synthesize iv_arr;
#pragma mark - 生命周期
- (void)awakeFromNib {
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:iv_arr];
    
    lb_title.font = font(FONT_TEXT_BOLD, 17);
    
}

-(void)openAnimation
{
    [self openAnimationWithAnimation:YES];
}

-(void)closeAnimation
{
    [self closeAnimationWithAnimation:YES];
}

-(void)openAnimationWithAnimation:(BOOL)_animation
{
    
    if(_animation)
        [UIView beginAnimations:nil context:nil];
    iv_arr.transform = CGAffineTransformMakeRotation(degreesToRadian(0) );
    if(_animation)
        [UIView commitAnimations];
}

-(void)closeAnimationWithAnimation:(BOOL)_animation
{
    if(_animation)
        [UIView beginAnimations:nil context:nil];
    iv_arr.transform = CGAffineTransformMakeRotation(degreesToRadian(-90) );
    if(_animation)
        [UIView commitAnimations];
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
    lb_title.text = _dataInfo;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

//
//  FGTrainingWorkoutCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingWorkoutCellView.h"
#import "Global.h"
@implementation FGTrainingWorkoutCellView
@synthesize iv_thumbnail;
@synthesize iv_shadow;
@synthesize lb_title;
@synthesize lb_key_level;
@synthesize lb_key_minutes;
@synthesize lb_key_intensity;
@synthesize lb_value_level;
@synthesize lb_value_minutes;
@synthesize qv_intensity;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [commond useDefaultRatioToScaleView:iv_thumbnail];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_key_minutes];
    [commond useDefaultRatioToScaleView:lb_key_level];
    [commond useDefaultRatioToScaleView:lb_key_intensity];
    [commond useDefaultRatioToScaleView:lb_value_minutes];
    [commond useDefaultRatioToScaleView:lb_value_level];
    [commond useDefaultRatioToScaleView:qv_intensity];
    [commond useDefaultRatioToScaleView:iv_shadow];
    
    [iv_thumbnail setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    iv_thumbnail.backgroundColor = [UIColor lightGrayColor];
    
    lb_title.font = font(FONT_TEXT_BOLD, 22);
    lb_key_minutes.font = font(FONT_TEXT_REGULAR, 15);
    lb_key_level.font = font(FONT_TEXT_REGULAR, 15);
    lb_key_intensity.font = font(FONT_TEXT_REGULAR, 15);
    lb_value_minutes.font = font(FONT_TEXT_REGULAR, 15);
    lb_value_level.font = font(FONT_TEXT_REGULAR, 15);
    
    [qv_intensity initalQueueByImageNames:@[@"hardness2.png",@"hardness2.png",@"hardness2.png",@"hardness2.png",@"hardness2.png"] highlightedImageNames:@[@"hardness1.png",@"hardness1.png",@"hardness1.png",@"hardness1.png",@"hardness1.png"] padding:1 imgBounds:CGRectMake(0, 0, 12 * ratioW, 12 * ratioW) increaseMode:ViewsQueueIncreaseMode_CENTER];
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
    if(!_dataInfo)
        return;
    if([_dataInfo count]<=0)
        return;
    
    lb_title.text = [_dataInfo objectForKey:@"ScreenName"];
    [qv_intensity updateHighliteByCount:[[_dataInfo objectForKey:@"Intensity"] integerValue]];
    lb_value_minutes.text = [_dataInfo objectForKey:@"Minutes"];
    lb_value_level.text = [_dataInfo objectForKey:@"Level"];
    [iv_thumbnail sd_setImageWithURL:[NSURL URLWithString:[_dataInfo objectForKey:@"Thumbnail"]] placeholderImage:nil];
    
}
@end

//
//  FGFitnessTestGroupCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGFitnessTestGroupCellView.h"
#import "Global.h"
@interface FGFitnessTestGroupCellView()
{
    BOOL haveImage;
    
}
@property(nonatomic,strong)NSString *str_url;
@end

@implementation FGFitnessTestGroupCellView
@synthesize lb_date;
@synthesize iv_time;
@synthesize lb_duration;
@synthesize iv_calorious;
@synthesize lb_calorious;
@synthesize iv_photoThumbnail;
@synthesize btn_photoThumbnail;
@synthesize str_url;
@synthesize view_separatorLine_h;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [commond useDefaultRatioToScaleView:lb_date];
    [commond useDefaultRatioToScaleView:iv_time];
    [commond useDefaultRatioToScaleView:lb_duration];
    [commond useDefaultRatioToScaleView:iv_calorious];
    [commond useDefaultRatioToScaleView:lb_calorious];
    [commond useDefaultRatioToScaleView:iv_photoThumbnail];
    [commond useDefaultRatioToScaleView:btn_photoThumbnail];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separatorLine_h];
    
    lb_date.font = font(FONT_TEXT_REGULAR, 14);
    lb_duration.font = font(FONT_TEXT_REGULAR, 14);
    lb_calorious.font = font(FONT_TEXT_REGULAR, 14);
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    str_url = nil;
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
    
    NSString *str_dateFormat = @"MM / dd / YYYY";
    if([commond isChinese])
        str_dateFormat = @"yyyy年MM月dd日";
    lb_date.text = [commond dateStringBySince1970:[[_dataInfo objectForKey:@"TestDate"] longValue] dateFormat:str_dateFormat];
    lb_duration.text = [commond clockFormatBySeconds:[[_dataInfo objectForKey:@"Duration"] intValue]];
    lb_calorious.text = [NSString stringWithFormat:@"%@",[_dataInfo objectForKey:@"Total"]];
    str_url = [_dataInfo objectForKey:@"URL"];
    if(str_url && ![str_url isEmptyStr])
    {
        haveImage = YES;
        iv_photoThumbnail.hidden = NO;
    }
    else
    {
        haveImage = NO;
        iv_photoThumbnail.hidden = YES;
    }
    iv_photoThumbnail.highlighted = !haveImage;
}

-(IBAction)buttonAction_openPhoto:(id)_sender
{
    if(!haveImage)
        return;
    
    
    [commond showPhotoVideoGalleryToView:appDelegate.window fromView:iv_photoThumbnail imgs:(NSMutableArray *)@[str_url] imgIndex:0 videoUrl:nil];
}
@end

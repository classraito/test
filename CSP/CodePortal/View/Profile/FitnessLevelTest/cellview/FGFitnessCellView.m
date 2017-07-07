//
//  FGFitnessCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGFitnessCellView.h"
#import "Global.h"
@implementation FGFitnessCellView
@synthesize lb_title;
@synthesize lb_subtitle;
@synthesize view_separatorLine_h;
- (void)awakeFromNib {
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_subtitle];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separatorLine_h];
    lb_title.font = font(FONT_TEXT_REGULAR, 15);
    lb_subtitle.font = font(FONT_TEXT_REGULAR, 14);
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
    lb_title.text = [_dataInfo objectForKey:@"key"];
    if([lb_title.text isEqualToString:@"Plank"])
    {
        int secs = [[_dataInfo objectForKey:@"value"] intValue];
        lb_subtitle.text = [commond clockFormatBySeconds:secs];
    }
    else
    {
        
        lb_subtitle.text = [NSString stringWithFormat:@"%@",[_dataInfo objectForKey:@"value"]];
    }
    
}
@end

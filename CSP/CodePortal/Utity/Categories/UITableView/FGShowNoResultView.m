//
//  FGShowNoResultView.m
//  CSP
//
//  Created by Ryan Gong on 17/1/12.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGShowNoResultView.h"
#import "Global.h"
@implementation FGShowNoResultView
@synthesize iv_thumbnail;
@synthesize lb_noResult;
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:iv_thumbnail];
    [commond useDefaultRatioToScaleView:lb_noResult];
    
    lb_noResult.font = font(FONT_TEXT_REGULAR, 20);
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

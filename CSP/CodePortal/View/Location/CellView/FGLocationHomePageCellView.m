//
//  FGLocationHomePageCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationHomePageCellView.h"
#import "Global.h"
@implementation FGLocationHomePageCellView
@synthesize lb_title;
@synthesize iv_thumbnail;
@synthesize iv_shadow;
@synthesize iv_arr;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:iv_thumbnail];
    [commond useDefaultRatioToScaleView:iv_shadow];
    [commond useDefaultRatioToScaleView:iv_arr];
    
    lb_title.numberOfLines = 0;
    lb_title.font = font(FONT_TEXT_REGULAR , 30);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
    lb_title.text = [_dataInfo objectForKey:@"title"];
    iv_thumbnail.image = [UIImage imageNamed:[_dataInfo objectForKey:@"thumbnail"]];
}
@end

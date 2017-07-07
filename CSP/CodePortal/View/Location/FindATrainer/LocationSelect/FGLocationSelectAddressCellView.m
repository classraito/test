//
//  FGLocationSelectAddressCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationSelectAddressCellView.h"
#import "Global.h"

@implementation FGLocationSelectAddressCellView
@synthesize lb_addressTitle;
@synthesize lb_addressDetail;
@synthesize iv_pin;
@synthesize view_separator;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:lb_addressTitle];
    [commond useDefaultRatioToScaleView:lb_addressDetail];
    [commond useDefaultRatioToScaleView:iv_pin];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separator];
    
    lb_addressTitle.font = font(FONT_TEXT_REGULAR, 15);
    lb_addressDetail.font = font(FONT_TEXT_REGULAR, 12);
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
    //AMapTip *_tip = (AMapTip *)_dataInfo;
    AMapPOI *_poi = (AMapPOI *)_dataInfo;
    lb_addressTitle.text = _poi.name;
    lb_addressDetail.text = _poi.address;
}
@end

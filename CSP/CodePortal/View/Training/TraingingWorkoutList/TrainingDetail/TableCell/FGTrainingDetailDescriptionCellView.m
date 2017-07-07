//
//  FGTrainingDetailDescriptionCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingDetailDescriptionCellView.h"
#import "Global.h"
@implementation FGTrainingDetailDescriptionCellView
@synthesize lb_description;
#pragma mark - 生命周期
- (void)awakeFromNib {
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:lb_description];
    // Initialization code
    lb_description.font = font(FONT_TEXT_REGULAR, 16);
    lb_description.textColor = color_qingse;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.lb_description setLineSpace:6 alignment:NSTextAlignmentLeft];
    [lb_description sizeToFit];
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
    lb_description.text = _dataInfo;
    [self sizeToFit];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

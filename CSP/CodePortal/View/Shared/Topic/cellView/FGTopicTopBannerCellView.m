//
//  FGTopicTopBannerCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/12/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTopicTopBannerCellView.h"
#import "Global.h"
@implementation FGTopicTopBannerCellView
@synthesize iv_topicBg;
@synthesize lb_postCount;
@synthesize lb_topicName;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [commond useDefaultRatioToScaleView:iv_topicBg];
    [commond useDefaultRatioToScaleView:lb_postCount];
    [commond useDefaultRatioToScaleView:lb_topicName];
    
    lb_postCount.font = font(FONT_TEXT_BOLD, 20);
    lb_topicName.font = font(FONT_TEXT_BOLD, 24);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

//
//  FGTrainingDetailCommentsTitleSectionView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingDetailCommentsTitleSectionView.h"
#import "Global.h"
@implementation FGTrainingDetailCommentsTitleSectionView
@synthesize lb_commentsCount;
#pragma mark - 生命周期
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [commond useDefaultRatioToScaleView:lb_commentsCount];
    
    lb_commentsCount.font = font(FONT_TEXT_REGULAR, 14);
    lb_commentsCount.textColor = [UIColor blackColor];
    
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = .95;
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end

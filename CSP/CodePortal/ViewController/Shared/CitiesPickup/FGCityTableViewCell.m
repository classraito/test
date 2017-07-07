//
//  FGCityTableViewCell.m
//  CSP
//
//  Created by JasonLu on 17/1/3.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGCityTableViewCell.h"

@implementation FGCityTableViewCell
@synthesize lb_topicTitle;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  [commond useDefaultRatioToScaleView:lb_topicTitle];
  lb_topicTitle.font = font(FONT_TEXT_BOLD, 18);
  lb_topicTitle.textAlignment = NSTextAlignmentLeft;
}

-(void)dealloc
{
  NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(void)updateCellViewWithInfo:(id)_dataInfo
{
  NSString *_str_cityAll = [NSString stringWithFormat:@"%@", _dataInfo];
  
  self.lb_topicTitle.text = [FGUtils getCityNameWithString: _str_cityAll];
}

@end

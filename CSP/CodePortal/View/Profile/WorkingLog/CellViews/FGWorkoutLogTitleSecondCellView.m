//
//  FGWorkoutLogTitleSecondCellView.m
//  CSP
//
//  Created by JasonLu on 16/12/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGWorkoutLogTitleSecondCellView.h"

@implementation FGWorkoutLogTitleSecondCellView

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  [commond useDefaultRatioToScaleView:self.view_separator];
  self.view_separator.hidden = YES;
}

- (void)updateCellViewWithInfo:(id)_dataInfo{
  if (_dataInfo == nil)
    return;
  
  [super updateCellViewWithInfo:_dataInfo];
  self.view_separator.hidden = NO;
}

@end

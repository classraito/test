//
//  FGHomepageSearchWorkoutInfoCellView.m
//  CSP
//
//  Created by JasonLu on 16/10/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGAlignmentLabel.h"
#import "FGHomepageSearchWorkoutInfoCellView.h"
#import "UIImageView+WebCache.h"
@interface FGHomepageSearchWorkoutInfoCellView ()
@property (weak, nonatomic) IBOutlet UIImageView *iv_icon;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet FGAlignmentLabel *lb_content;

@end

@implementation FGHomepageSearchWorkoutInfoCellView
@synthesize iv_icon;
@synthesize lb_title;
@synthesize lb_content;

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code

  // Initialization code
  [commond useDefaultRatioToScaleView:lb_content];
  [commond useDefaultRatioToScaleView:lb_title];
  [commond useDefaultRatioToScaleView:iv_icon];

  lb_title.font      = font(FONT_TEXT_BOLD, 22);
  lb_title.textColor = color_homepage_black;

  lb_content.font      = font(FONT_TEXT_REGULAR, 18);
  lb_content.textColor = color_homepage_lightGray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)updateCellViewWithInfo:(id)_dataInfo {
  if (_dataInfo == nil)
    return;
  
  NSString *title   = _dataInfo[@"workoutTitle"];
  NSString *content = _dataInfo[@"content"];
  NSString *imgStr  = _dataInfo[@"url"];

  [self.iv_icon sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:IMG_PLACEHOLDER];
  self.lb_title.text   = title;
  self.lb_content.text = content;
  
  self.lb_content.numberOfLines = 3;
}

@end

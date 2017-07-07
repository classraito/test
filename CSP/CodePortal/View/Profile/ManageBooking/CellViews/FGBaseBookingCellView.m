//
//  FGBaseBookingCellView.m
//  CSP
//
//  Created by JasonLu on 16/11/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseBookingCellView.h"
#import "UIImageView+Circle.h"
@implementation FGBaseBookingCellView
@synthesize view_separator;
@synthesize iv_thumbnail;
@synthesize lb_username;
@synthesize lb_content;
@synthesize lb_time;
@synthesize btn_userIcon;

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  //  [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, .5) toScaleView:view_separator];
  [commond useDefaultRatioToScaleView:view_separator];
  [commond useDefaultRatioToScaleView:iv_thumbnail];
  [commond useDefaultRatioToScaleView:lb_username];
  [commond useDefaultRatioToScaleView:lb_content];
  [commond useDefaultRatioToScaleView:lb_time];
  [commond useDefaultRatioToScaleView:btn_userIcon];
  
  lb_content.numberOfLines = 8;
  lb_content.lineBreakMode = NSLineBreakByTruncatingTail;
//  [btn_booking setBackgroundColor:color_red_panel];
//  [btn_booking makeWithCornerRadius:5.0];
  
  [iv_thumbnail makeCicleWithRaduis:iv_thumbnail.bounds.size.width/2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)updateCellViewWithInfo:(id)_dataInfo {

  NSMutableAttributedString *mattr_str = _dataInfo[@"content"];
  lb_content.attributedText = mattr_str;
  CGRect rect_mattrStr = [FGUtils calculatorAttributeString:mattr_str withWidth:self.lb_content.bounds.size.width];
  CGFloat cellHeight = rect_mattrStr.size.height;
  self.lb_content.frame = CGRectMake(lb_content.frame.origin.x, lb_content.frame.origin.y, self.lb_content.bounds.size.width, cellHeight);
  
  
  //  if ([title isEqualToString:@"newsfeed"]) {
  //    NSString *content = _dataInfo[@"content"];
  //    [self setupViewWithTitle:content color:_dataInfo[@"color"]];
  //  } else if ([title isEqualToString:@"trainer"]) {
  //    NSString *name   = _dataInfo[@"name"];
  //    NSString *imgStr = _dataInfo[@"url"];
  //    [self setupViewWithIcon:imgStr name:name];
  //  }
}
@end



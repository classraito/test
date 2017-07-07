//
//  FGMyBookingBundleListCellView.m
//  CSP
//
//  Created by JasonLu on 16/12/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGMyBookingBundleListCellView.h"

#define TAG_LAB_START 10

@interface FGMyBookingBundleListCellView () {
  NSInteger int_bundlesCount;
}
@end

@implementation FGMyBookingBundleListCellView
@synthesize lb_price;

@synthesize view_topLine;
@synthesize view_middleLine;
@synthesize view_bottomLine;

@synthesize view_v1;
@synthesize view_v2;
@synthesize view_v3;
@synthesize view_v4;
@synthesize view_v5;
@synthesize view_v6;
@synthesize view_v7;

@synthesize lb_b1;
@synthesize lb_b2;
@synthesize lb_b3;
@synthesize lb_b4;
@synthesize lb_b5;
@synthesize lb_b6;
@synthesize lb_b7;
@synthesize lb_b8;
@synthesize lb_b9;
@synthesize lb_10;
@synthesize lb_11;

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [commond useDefaultRatioToScaleView:self.lb_price];
  CGRect _rect_h = CGRectMake(ratioW, ratioH, ratioW, 0.5);
  [commond useRatio:_rect_h toScaleView:view_topLine];
  [commond useRatio:_rect_h toScaleView:view_middleLine];
  [commond useRatio:_rect_h toScaleView:view_bottomLine];
  
  CGRect _rect_v = CGRectMake(ratioW, ratioH, 0.5, ratioH);
  [commond useRatio:_rect_v toScaleView:view_v1];
  [commond useRatio:_rect_v toScaleView:view_v2];
  [commond useRatio:_rect_v toScaleView:view_v3];
  [commond useRatio:_rect_v toScaleView:view_v4];
  [commond useRatio:_rect_v toScaleView:view_v5];
  [commond useRatio:_rect_v toScaleView:view_v6];
  [commond useRatio:_rect_v toScaleView:view_v7];
  
  [commond useDefaultRatioToScaleView:lb_b1];
  [commond useDefaultRatioToScaleView:lb_b2];
  [commond useDefaultRatioToScaleView:lb_b3];
  [commond useDefaultRatioToScaleView:lb_b4];
  [commond useDefaultRatioToScaleView:lb_b5];
  [commond useDefaultRatioToScaleView:lb_b6];
  [commond useDefaultRatioToScaleView:lb_b7];
  [commond useDefaultRatioToScaleView:lb_b8];
  [commond useDefaultRatioToScaleView:lb_b9];
  [commond useDefaultRatioToScaleView:lb_10];
  [commond useDefaultRatioToScaleView:lb_11];
  
  self.lb_b1.font = font(FONT_TEXT_REGULAR, 18);
  self.lb_b2.font = font(FONT_TEXT_REGULAR, 18);
  self.lb_b3.font = font(FONT_TEXT_REGULAR, 18);
  self.lb_b4.font = font(FONT_TEXT_REGULAR, 18);
  self.lb_b5.font = font(FONT_TEXT_REGULAR, 18);
  self.lb_b6.font = font(FONT_TEXT_REGULAR, 18);
  self.lb_b7.font = font(FONT_TEXT_REGULAR, 18);
  self.lb_b8.font = font(FONT_TEXT_REGULAR, 18);
  self.lb_b9.font = font(FONT_TEXT_REGULAR, 18);
  self.lb_10.font = font(FONT_TEXT_REGULAR, 18);
  self.lb_11.font = font(FONT_TEXT_REGULAR, 18);
  
  self.lb_11.text = multiLanguage(@"Free");
  
  self.view_topLine.backgroundColor = color_homepage_lightGray;
  self.view_middleLine.backgroundColor = color_homepage_lightGray;
  self.view_bottomLine.backgroundColor = color_homepage_lightGray;

  self.view_v1.backgroundColor = color_homepage_lightGray;
  self.view_v2.backgroundColor = color_homepage_lightGray;
  self.view_v3.backgroundColor = color_homepage_lightGray;
  self.view_v4.backgroundColor = color_homepage_lightGray;
  self.view_v5.backgroundColor = color_homepage_lightGray;
  self.view_v6.backgroundColor = color_homepage_lightGray;
  self.view_v7.backgroundColor = color_homepage_lightGray;

  self.lb_price.font = font(FONT_TEXT_REGULAR, 20);
  self.lb_price.textColor = color_red_panel;
}

- (void)updateCellViewWithInfo:(id)_dataInfo {
  NSLog(@"_dataInfo=%@",_dataInfo);
  BOOL _bool_hidden = [_dataInfo[@"hidden"] boolValue];
  if (_bool_hidden) {
    self.hidden = YES;
    return;
  }
  
  for (int i = 0; i < 11;i++) {
    UILabel *_lb = [self viewWithTag:TAG_LAB_START + i];
    _lb.textColor = color_homepage_black;
  }

  
  NSArray *_arr_bundleLessons = _dataInfo[@"BundleLessons"];
  self.lb_price.text = [NSString stringWithFormat:@"¥ %ld",[_arr_bundleLessons[0][@"BundlePrice"] integerValue]];
  
  NSArray *_arr_bundles = [NSArray arrayWithArray:_dataInfo[@"Bundles"]];
  int_bundlesCount = _arr_bundles.count;
  for (int i = 0; i < 11 - int_bundlesCount;i++) {
    UILabel *_lb = [self viewWithTag:TAG_LAB_START + i];
    _lb.textColor = color_homepage_lightGray;
  }
  
  self.hidden = NO;
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
 
  //1.获取上下文
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  for (int i = 0; i < 11 - int_bundlesCount;i++) {
    UILabel *_lb = [self viewWithTag:TAG_LAB_START + i];

    //设置起始点
    CGContextMoveToPoint(context, _lb.frame.origin.x, _lb.frame.origin.y);
    //增加点
    CGContextAddLineToPoint(context, _lb.frame.origin.x+_lb.bounds.size.width, _lb.frame.origin.y+_lb.bounds.size.height);
    //关闭路径
    CGContextClosePath(context);
   
    [color_homepage_lightGray setStroke];
    //4.绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
    }
}
@end

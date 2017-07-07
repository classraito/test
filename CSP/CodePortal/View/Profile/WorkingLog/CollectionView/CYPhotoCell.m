//
//  CYPhotoCell.m
//  自定义流水布局
//
//  Created by 葛聪颖 on 15/11/13.
//  Copyright © 2015年 聪颖不聪颖. All rights reserved.
//

#import "CYPhotoCell.h"
#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
@interface CYPhotoCell()
@property (weak, nonatomic) IBOutlet UILabel *label_text;
@property (weak, nonatomic) IBOutlet UIView *view_line;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;

@property (assign, nonatomic) CGFloat flt_min;
@property (assign, nonatomic) CGFloat flt_max;
@property (assign, nonatomic) CGFloat flt_barWidth;
@property (assign, nonatomic) BOOL bool_isSelected;

@end

@implementation CYPhotoCell
@synthesize flt_min;
@synthesize flt_max;
@synthesize bool_isSelected;
@synthesize view_line;
- (void)awakeFromNib {
  [super awakeFromNib];
  [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, .5) toScaleView:view_line];
  [commond useDefaultRatioToScaleView:self.lb_content];
  
  self.lb_content.font = font(FONT_TEXT_REGULAR, 12);
  
  self.backgroundColor = [UIColor clearColor];
}

-(void)updateCellViewWithInfo:(id)_dataInfo {
  self.label_text.text = [NSString stringWithFormat:@"%@", _dataInfo[@"value"]];
  CGRect rect_label = self.label_text.frame;
  self.label_text.frame = CGRectMake(rect_label.origin.x, rect_label.origin.y, self.bounds.size.width, rect_label.size.height);
  
  self.flt_min = [_dataInfo[@"min"] floatValue];
  self.flt_max = [_dataInfo[@"max"] floatValue];
  
  NSArray *_arr_date = [_dataInfo[@"date"] componentsSeparatedByString:@" - "];
  self.lb_content.text = [NSString stringWithFormat:@"%@\n%@",_arr_date[0],_arr_date[1]];
  
  self.bool_isSelected = [_dataInfo[@"isSelected"] boolValue];
  [self updatePhotoCellStyleWithBarWidth:[_dataInfo[@"barWidth"] floatValue]];
  
  [self setNeedsDisplay];
}

- (void)updatePhotoCellStyleWithBarWidth:(CGFloat)barWidth {
  self.flt_barWidth = barWidth * ratioW;
}

- (void)drawRect:(CGRect)rect
{
  
  if (self.bool_isSelected) {
    self.lb_content.textColor = color_workoutlog_lightGreen;
    [color_workoutlog_darkGreen setFill];
    [color_workoutlog_darkGreen setStroke];
  } else {
    self.lb_content.textColor = color_homepage_lightGray;
    [color_workoutlog_lightGreen setFill];
    [color_workoutlog_lightGreen setStroke];
  }
  
  
  float value = [self.label_text.text floatValue];
  float height = (self.bounds.size.height-30*ratioH);
  float barHeight = height;
  
  if(self.flt_max != self.flt_min)
  {
    barHeight = (height * value) / flt_max;//((value-flt_min)/(flt_max-flt_min))*(height-20)+20;
  }
  
  
  CGRect bar = CGRectMake(
                          self.bounds.size.width/2-self.flt_barWidth/2,
                          (height - barHeight),
                          self.flt_barWidth,
                          barHeight);
  [self drawRectangle:bar];
}

@end

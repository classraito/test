//
//  FGCircluarWithBottomTitleButton.m
//  CSP
//
//  Created by JasonLu on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCircluarWithBottomTitleButton.h"
@interface FGCircluarWithBottomTitleButton () {
  BOOL isShowProcessBG;
  BOOL isShowProcess;
}
@end

@implementation FGCircluarWithBottomTitleButton
@synthesize lb_title;
@synthesize btn;
@synthesize vi_icon;
@synthesize processPercent;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];

  self.vi_icon.layer.borderColor   = [UIColor clearColor].CGColor;
  self.vi_icon.layer.cornerRadius  = self.vi_icon.bounds.size.width * ratioW / 2;
  self.vi_icon.layer.masksToBounds = YES;
  
  [commond useDefaultRatioToScaleView:self.vi_icon];
  [commond useDefaultRatioToScaleView:self.lb_title];
  [commond useDefaultRatioToScaleView:self.btn];

  isShowProcess   = NO;
  isShowProcessBG = NO;

  self.lb_title.font      = font(FONT_TEXT_REGULAR, 14);
  self.lb_title.textColor = color_homepage_black;
  self.backgroundColor    = [UIColor clearColor];
  [self.lb_title setTextAlignment:NSTextAlignmentCenter];
  
}

- (void)setupButtonInfoWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleAlignment:(VerticalAlignment)alignment buttonImageName:(NSString *)imgName {
  self.lb_title.text      = title;
  self.lb_title.textColor = titleColor;
  [self.lb_title setVerticalAlignment:alignment];

  if ([imgName hasPrefix:@"http:"])
    [self.vi_icon sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:IMG_PLACEHOLDER];
  else
    self.vi_icon.image = IMGWITHNAME(imgName);
}

- (void)setupButtonInfoWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleAlignment:(VerticalAlignment)alignment textAlignment:(NSTextAlignment)textAlignment buttonImageName:(NSString *)imgName {
  [self setupButtonInfoWithTitle:title titleColor:titleColor titleAlignment:alignment buttonImageName:imgName];
  [self.lb_title setTextAlignment:textAlignment];
}

- (void)setupButtonInfoWithTitle:(NSString *)title buttonImageName:(NSString *)imgName {
  [self setupButtonInfoWithTitle:title titleColor:color_homepage_black titleAlignment:VerticalAlignmentMiddle buttonImageName:imgName];
}

- (void)setupButtonInfoWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleAlignment:(VerticalAlignment)alignment textAlignment:(NSTextAlignment)textAlignment buttonImage:(UIImage *)image {
  self.lb_title.text      = title;
  self.lb_title.textColor = titleColor;
  [self.lb_title setVerticalAlignment:alignment];
  self.vi_icon.image = image;
  [self.lb_title setTextAlignment:textAlignment];
}

- (void)drawCircular:(CGContextRef)context { //画圆和椭圆
  float padding = 3 * ratioW;
  CGContextSetLineWidth(context, padding);
  //    CGContextSetLineCap(context, kCGLineCapRound);
  if (isShowProcessBG) {
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
    CGContextAddArc(context, self.vi_icon.center.x, self.bounds.size.height / 2, (self.vi_icon.frame.size.width + padding + 5) / 2, degreesToRadian(0), degreesToRadian(360), 0);
    CGContextStrokePath(context);
  }
  if (isShowProcess) {
    CGContextSetRGBStrokeColor(context, 64.0 / 255.0, 162.0 / 255.0, 158.0 / 255.0, 1);
    CGContextAddArc(context, self.vi_icon.center.x, self.bounds.size.height / 2, (self.vi_icon.frame.size.width + padding + 5) / 2, degreesToRadian(-90), degreesToRadian(360.0f * processPercent - 90), 0);
    CGContextStrokePath(context);
  }
}
#define ToRadian(radian) (radian * (M_PI / 180.0))
- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];

  CGRect frame       = self.vi_icon.frame;
  self.vi_icon.frame = CGRectMake(frame.origin.x, (self.bounds.size.height - self.vi_icon.bounds.size.height) / 2, frame.size.width, frame.size.height);

  CGContextRef context = UIGraphicsGetCurrentContext(); // 获取绘图上下文
  [self drawCircular:context];
}

- (void)setupStatusWithShowProcessBg:(BOOL)bgShow showProcess:(BOOL)procesShow {
  isShowProcessBG = bgShow;
  isShowProcess   = procesShow;
  [self setNeedsDisplay];
}
- (void)setupButtonInfoWithImage:(UIImage *)_img {
  self.vi_icon.image = _img;
}
@end

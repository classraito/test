//
//  UIImageView+Circle.m
//  CSP
//
//  Created by JasonLu on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "UIImageView+Circle.h"

@implementation UIImageView (Circle)
- (void)makeCicleWithRaduis:(float)raduis {
  CAShapeLayer *maskLayer = [CAShapeLayer layer];
  self.layer.mask         = maskLayer;
  //    maskLayer = maskLayer;

  // create shape layer for circle we'll draw on top of image (the boundary of the circle)
  //  CAShapeLayer *circleLayer = [CAShapeLayer layer];
  //  circleLayer.lineWidth     = 2;
  //  circleLayer.fillColor     = [[UIColor clearColor] CGColor];
  //  circleLayer.strokeColor   = [[UIColor whiteColor] CGColor];
  //  [self.layer addSublayer:circleLayer];

  UIBezierPath *path = [UIBezierPath bezierPath];
  [path addArcWithCenter:CGPointMake(raduis, raduis)
                  radius:raduis
              startAngle:0.0
                endAngle:M_PI * 2.0
               clockwise:YES];

  maskLayer.path = [path CGPath];
  //  circleLayer.path = [path CGPath];
  //    return self;
}
@end

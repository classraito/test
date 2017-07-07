//
//  UIImage+BlurEffect.m
//  CSP
//
//  Created by JasonLu on 16/10/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "GPUImageGaussianBlurFilter.h"
#import "UIImage+BlurEffect.h"
#import <Accelerate/Accelerate.h>
@implementation UIImage (BlurEffect)
- (UIImage *)blurEffectUseCoreImageWithLevel:(CGFloat)blur {
  CIContext *context  = [CIContext contextWithOptions:nil];
  CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
  CIFilter *filter    = [CIFilter filterWithName:@"CIGaussianBlur"
                                keysAndValues:kCIInputImageKey, inputImage,
                                              @"inputRadius", @(blur), nil];
  CIImage *outputImage = filter.outputImage;
  CGImageRef outImage  = [context createCGImage:outputImage
                                      fromRect:[outputImage extent]];
  return [UIImage imageWithCGImage:outImage];
}

- (UIImage *)blurEffectUseVImageWithBlurLevel:(CGFloat)blur {
  return self;
}

- (UIImage *)blurEffectUseGPUImageWithBlurLevel:(CGFloat)blur {
  UIImage *_img = [self blurEffectUseCoreImageWithLevel:5.0];
  return [_img subImageWithSquareWithInSize:CGSizeMake(_img.size.width-90, _img.size.height-90)];
  
  GPUImageGaussianBlurFilter * blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
  blurFilter.blurRadiusInPixels = 10.0;
  UIImage *blurredImage = [blurFilter imageByFilteringImage:self];
  return blurredImage;
}
@end

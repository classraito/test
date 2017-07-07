//
//  UIImage+BlurEffect.h
//  CSP
//
//  Created by JasonLu on 16/10/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BlurEffect)
//使用coreImage方法
- (UIImage *)blurEffectUseCoreImageWithLevel:(CGFloat)blur;
//使用vImage方法
- (UIImage *)blurEffectUseVImageWithBlurLevel:(CGFloat)blur;
//使用GPUImage方法
- (UIImage *)blurEffectUseGPUImageWithBlurLevel:(CGFloat)blur;
@end

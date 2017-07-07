//
//  UIImage+SubImage.m
//  UIImage+Categories
//
//  Created by JasonLu on 16/9/4.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "UIImage+SubImage.h"

@implementation UIImage (SubImage)
/** 指定宽度按比例缩放 */
-(UIImage *) imageCompressForTargetWidth:(CGFloat)defineWidth{
  
  UIImage *newImage = nil;
  CGSize imageSize = self.size;
  CGFloat width = imageSize.width;
  CGFloat height = imageSize.height;
  CGFloat targetWidth = defineWidth;
  CGFloat targetHeight = height / (width / targetWidth);
  CGSize size = CGSizeMake(targetWidth, targetHeight);
  CGFloat scaleFactor = 0.0;
  CGFloat scaledWidth = targetWidth;
  CGFloat scaledHeight = targetHeight;
  CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
  
  if(CGSizeEqualToSize(imageSize, size) == NO){
    
    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;
    
    if(widthFactor > heightFactor){
      scaleFactor = widthFactor;
    }
    else{
      scaleFactor = heightFactor;
    }
    scaledWidth = width * scaleFactor;
    scaledHeight = height * scaleFactor;
    
    if(widthFactor > heightFactor){
      
      thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
      
    }else if(widthFactor < heightFactor){
      
      thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
    }
  }
  
  UIGraphicsBeginImageContext(size);
  
  CGRect thumbnailRect = CGRectZero;
  thumbnailRect.origin = thumbnailPoint;
  thumbnailRect.size.width = scaledWidth;
  thumbnailRect.size.height = scaledHeight;
  
  [self drawInRect:thumbnailRect];
  
  newImage = UIGraphicsGetImageFromCurrentImageContext();
  
  if(newImage == nil){
    
    NSLog(@"scale image fail");
  }
  UIGraphicsEndImageContext();
  return newImage;
}

#pragma mark - 截取当前image对象rect区域内的图像
- (UIImage *)subImageWithRect:(CGRect)rect
{
//    CGImageRef newImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
//    
//    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//    
//    CGImageRelease(newImageRef);
//    
//    return newImage;
  
  CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
  CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
  
  UIGraphicsBeginImageContext(smallBounds.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextDrawImage(context, smallBounds, subImageRef);
  UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
  UIGraphicsEndImageContext();
  
  return smallImage;
}

- (UIImage *)subImageWithSquare {
  
  CGSize _size_sub;
  CGSize _size_img = self.size;
  CGFloat _flt_min = _size_img.width < _size_img.height?_size_img.width:_size_img.height;
  
  _size_sub = CGSizeMake(_flt_min, _flt_min);
  
  //中心点
  CGPoint _pt_center = CGPointMake(_size_img.width/2, _size_img.height/2);
  
  CGRect _rect_sub = CGRectMake(_pt_center.x-_flt_min/2, _pt_center.y-_flt_min/2, _size_sub.width, _size_sub.height);
  
  return [self subImageWithRect:_rect_sub];
}

- (UIImage *)subImageWithSquareWithInSize:(CGSize)_size {
  CGSize _size_img = self.size;
  //中心点
  CGPoint _pt_center = CGPointMake(_size_img.width/2, _size_img.height/2);
  
  CGRect _rect_sub = CGRectMake(_pt_center.x-_size.width/2, _pt_center.y-_size.height/2, _size.width, _size.height);
  
  return [self subImageWithRect:_rect_sub];
}

#pragma mark - 压缩图片至指定尺寸
- (UIImage *)rescaleImageToSize:(CGSize)size
{
    CGRect rect = (CGRect){CGPointZero, size};
    
    UIGraphicsBeginImageContext(rect.size);
    
    [self drawInRect:rect];
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resImage;
}

#pragma mark - 压缩图片至指定像素
- (UIImage *)rescaleImageToPX:(CGFloat )toPX
{
    CGSize size = self.size;
    
    if(size.width <= toPX && size.height <= toPX)
    {
        return self;
    }
    
    CGFloat scale = size.width / size.height;
    
    if(size.width > size.height)
    {
        size.width = toPX;
        size.height = size.width / scale;
    }
    else
    {
        size.height = toPX;
        size.width = size.height * scale;
    }
    
    return [self rescaleImageToSize:size];
}

#pragma mark - 指定大小生成一个平铺的图片
- (UIImage *)getTiledImageWithSize:(CGSize)size
{
    UIView *tempView = [[UIView alloc] init];
    tempView.bounds = (CGRect){CGPointZero, size};
    tempView.backgroundColor = [UIColor colorWithPatternImage:self];
    
    UIGraphicsBeginImageContext(size);
    [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return bgImage;
}

#pragma mark - UIView转化为UIImage
+ (UIImage *)imageFromView:(UIView *)view
{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 将两个图片生成一张图片
+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage
{
    CGImageRef firstImageRef = firstImage.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    CGImageRef secondImageRef = secondImage.CGImage;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    CGSize mergedSize = CGSizeMake(MAX(firstWidth, secondWidth), MAX(firstHeight, secondHeight));
    UIGraphicsBeginImageContext(mergedSize);
    [firstImage drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];
    [secondImage drawInRect:CGRectMake(0, 0, secondWidth, secondHeight)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

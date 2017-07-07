//
//  SDCycleManager.h
//  SDCycleFramework
//
//  Created by JasonLu on 16/9/7.
//  Copyright © 2016年 JasonLu. All rights reserved.
//

#import "SDCycleScrollView.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SDCycleManager : NSObject
+ (SDCycleManager *)shareInstance;

- (SDCycleScrollView *)
createCycleScollViewWithFrame:(CGRect)frame
                       images:(NSArray *)images
             PlaceholderImage:(UIImage *)placeholderImg
           scrollTimeInterval:(NSTimeInterval)timeInterval
           pageControlAliment:(SDCycleScrollViewPageContolAliment)aliment
             pageControlStyle:(SDCycleScrollViewPageContolStyle)style
                     delegate:(id<SDCycleScrollViewDelegate>)delegate;

- (SDCycleScrollView *)
createCycleScollViewWithFrame:(CGRect)frame
                       images:(NSArray *)images
             PlaceholderImage:(UIImage *)placeholderImg
           scrollTimeInterval:(NSTimeInterval)timeInterval
                     delegate:(id<SDCycleScrollViewDelegate>)delegate;

- (SDCycleScrollView *)
createCycleScollViewWithFrame:(CGRect)frame
                       images:(NSArray *)images
             PlaceholderImage:(UIImage *)placeholderImg
           scrollTimeInterval:(NSTimeInterval)timeInterval
          currentPageDotImage:(UIImage *)currentPageDotImage
                 pageDotImage:(UIImage *)pageDotImage
                     delegate:(id<SDCycleScrollViewDelegate>)delegate;

- (SDCycleScrollView *)
createCycleScollViewWithFrame:(CGRect)frame
                       images:(NSArray *)images
             PlaceholderImage:(UIImage *)placeholderImg
           scrollTimeInterval:(NSTimeInterval)timeInterval
          currentPageDotImage:(UIImage *)currentPageDotImage
                 pageDotImage:(UIImage *)pageDotImage
                 bottomHeight:(CGFloat)height
                     delegate:(id<SDCycleScrollViewDelegate>)delegate;

- (void)initLoadingScrollProperty;
@end

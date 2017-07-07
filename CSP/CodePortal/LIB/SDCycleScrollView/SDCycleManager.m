//
//  SDCycleManager.m
//  SDCycleFramework
//
//  Created by JasonLu on 16/9/7.
//  Copyright © 2016年 JasonLu. All rights reserved.
//

#import "SDCycleManager.h"

@interface SDCycleManager ()

@property (nonatomic, strong) SDCycleScrollView *scrollView;

@end

@implementation SDCycleManager
#pragma mark - 单例方法
+ (SDCycleManager *)shareInstance {
  static id _instance = nil;

  // Create a token that facilitates only creating this item once.
  static dispatch_once_t onceToken;

  // Use Grand Central Dispatch to create a single instance and do any initial
  // setup only once.
  dispatch_once(&onceToken, ^{
    // These are only invoked the onceToken has never been used before.
    _instance = [[self alloc] init];
  });
  // Returns the shared instance variable.
  return _instance;
}

- (SDCycleScrollView *)
createCycleScollViewWithFrame:(CGRect)frame
                       images:(NSArray *)images
             PlaceholderImage:(UIImage *)placeholderImg
           scrollTimeInterval:(NSTimeInterval)timeInterval
           pageControlAliment:(SDCycleScrollViewPageContolAliment)aliment
             pageControlStyle:(SDCycleScrollViewPageContolStyle)style
                     delegate:(id<SDCycleScrollViewDelegate>)delegate {
  // 网络加载 --- 创建带标题的图片轮播器
  
  if (self.scrollView) {
    self.scrollView = nil;
//    self.scrollView.imageURLStringsGroup = images;
//    return self.scrollView;
  }
  
  SDCycleScrollView *cycleScrollView =
      [SDCycleScrollView cycleScrollViewWithFrame:frame
                                         delegate:delegate
                                 placeholderImage:placeholderImg];
  // pagecontrol位置
  cycleScrollView.pageControlAliment = aliment;
  // pagecontrol样式
  cycleScrollView.pageControlStyle = style;
  //         --- 轮播时间间隔，默认1.0秒，可自定义
  cycleScrollView.autoScrollTimeInterval = timeInterval;

  //进行本地和网络判断
  if ([self isWebImageURL:images[0]]) {
    cycleScrollView.imageURLStringsGroup = images;

//    dispatch_after(
//        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
//        dispatch_get_main_queue(), ^{
//          cycleScrollView.imageURLStringsGroup = images;
//        });
  } else {
    cycleScrollView.infiniteLoop = YES; //无限循环
    cycleScrollView.localizationImageNamesGroup =
        [NSMutableArray arrayWithArray:images];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  }
  self.scrollView = nil;
  self.scrollView = cycleScrollView;
  self.scrollView.clipsToBounds = YES;
  return cycleScrollView;
}

- (SDCycleScrollView *)
createCycleScollViewWithFrame:(CGRect)frame
                       images:(NSArray *)images
             PlaceholderImage:(UIImage *)placeholderImg
           scrollTimeInterval:(NSTimeInterval)timeInterval
                     delegate:(id<SDCycleScrollViewDelegate>)delegate {
  return [self
      createCycleScollViewWithFrame:frame
                             images:images
                   PlaceholderImage:placeholderImg
                 scrollTimeInterval:timeInterval
                 pageControlAliment:SDCycleScrollViewPageContolAlimentCenter
                   pageControlStyle:SDCycleScrollViewPageContolStyleClassic
                           delegate:delegate];
}

- (SDCycleScrollView *)
createCycleScollViewWithFrame:(CGRect)frame
                       images:(NSArray *)images
             PlaceholderImage:(UIImage *)placeholderImg
           scrollTimeInterval:(NSTimeInterval)timeInterval
          currentPageDotImage:(UIImage *)currentPageDotImage
                 pageDotImage:(UIImage *)pageDotImage
                     delegate:(id<SDCycleScrollViewDelegate>)delegate {
  [self
      createCycleScollViewWithFrame:frame
                             images:images
                   PlaceholderImage:placeholderImg
                 scrollTimeInterval:timeInterval
                 pageControlAliment:SDCycleScrollViewPageContolAlimentCenter
                   pageControlStyle:SDCycleScrollViewPageContolStyleAnimated
                           delegate:delegate];

  
  self.scrollView.currentPageDotImage = currentPageDotImage;
  self.scrollView.pageDotImage = pageDotImage;
  return self.scrollView;
  
//  cycleScrollView.currentPageDotImage = currentPageDotImage;
//  cycleScrollView.pageDotImage        = pageDotImage;
//  self.scrollView                     = nil;
//  self.scrollView                     = cycleScrollView;
//  return cycleScrollView;
}

- (SDCycleScrollView *)
createCycleScollViewWithFrame:(CGRect)frame
                       images:(NSArray *)images
             PlaceholderImage:(UIImage *)placeholderImg
           scrollTimeInterval:(NSTimeInterval)timeInterval
          currentPageDotImage:(UIImage *)currentPageDotImage
                 pageDotImage:(UIImage *)pageDotImage
                 bottomHeight:(CGFloat)height
                     delegate:(id<SDCycleScrollViewDelegate>)delegate {
  [self createCycleScollViewWithFrame:frame
                                   images:images
                         PlaceholderImage:placeholderImg
                       scrollTimeInterval:timeInterval
                      currentPageDotImage:currentPageDotImage
                             pageDotImage:pageDotImage
                                 delegate:delegate];
  self.scrollView.bottomHeight = height;
  return self.scrollView;
}

- (void)initLoadingScrollProperty {
  self.scrollView.autoScroll   = NO;
  self.scrollView.infiniteLoop = NO;
}

//- (void)clearScrollView {
//  self.scrollView = nil;
//}

#pragma mark - 私有方法
- (BOOL)isWebImageURL:(NSString *)imgUrl {
  if ([imgUrl hasPrefix:@"http://"] || [imgUrl hasPrefix:@"https://"]) {
    return YES;
  }
  return NO;
}
@end

//
//  FGHomepageTopScrollCellView.m
//  CSP
//
//  Created by JasonLu on 16/9/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGHomepageTopScrollCellView.h"
#import "SDCycleManager.h"

@interface FGHomepageTopScrollCellView () <SDCycleScrollViewDelegate> {
  NSArray *imagesURLStrings;
}
@end

@implementation FGHomepageTopScrollCellView
@synthesize delegate;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  imagesURLStrings = @[
                                @"BannerGroupTraining.jpg",
                                @"BannerPersonalTrainer.jpg",
                                @"BannerProfile.jpg",
//                                @"BannerWorkout.jpg",
                                ];
  [self internalInitalTopInfoContent];
}

- (void)dealloc {
  self.delegate = nil;
  self.view_topInfoScroll = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - 私有方法
- (void)internalInitalTopInfoContent {
  UIImage *_img = IMG_PLACEHOLDER;
  _img = [_img rescaleImageToSize:CGSizeMake(320, 160)];
  
  CGSize size             = self.bounds.size;
  self.view_topInfoScroll = [[SDCycleManager shareInstance]
                             createCycleScollViewWithFrame:CGRectMake(0, 0, size.width, size.height)
                             images:imagesURLStrings
                             PlaceholderImage:nil
                             scrollTimeInterval:0
                             delegate:self];
  [commond useDefaultRatioToScaleView:self.view_topInfoScroll];
  [self addSubview:self.view_topInfoScroll];
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView
       didScrollToIndex:(NSInteger)index {
  self.currentScollIndex = index;
}

- (void)cycleScrollViewDidScroll:(UIScrollView *)scrollView {
}

#pragma mark - 成员方法
- (void)updateCellViewWithInfo:(id)_dataInfo {
//  NSArray *topScrollInfos = (NSArray *)_dataInfo;
//  [self.view_topInfoScroll setImageURLStringsGroup:topScrollInfos];
  // block监听点击方式
  __weak typeof(self) weakSelf = self;
  self.view_topInfoScroll.clickItemOperationBlock = ^(NSInteger index) {
    NSLog(@">>>>>  %ld", (long)index);
    if (weakSelf.delegate) {
      [weakSelf.delegate action_didSelectTopScrollAtIndex:index];
    }
  };
  self.view_topInfoScroll.autoScroll = imagesURLStrings.count > 1 ? YES : NO;
  self.view_topInfoScroll.showPageControl = imagesURLStrings.count > 1 ? YES : NO;
  [self.view_topInfoScroll setAutoScrollTimeInterval:imagesURLStrings.count > 1 ? 6.0 : 0];
}

//网络图片数组
//  NSArray *imagesURLStrings = @[
//    @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/"
//    @"whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/"
//    @"0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
//    @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/"
//    @"whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/"
//    @"5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//    @"http://c.hiphotos.baidu.com/image/w%3D400/"
//    @"sign=c2318ff84334970a4773112fa5c8d1c0/"
//    @"b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
//  ];

// 自定义pagecontrol图片
//  self.view_topInfoScroll = [[SDCycleManager shareInstance]
//      createCycleScollViewWithFrame:CGRectMake(0, 0, size.width, size.height)
//                             images:imagesURLStrings
//                   PlaceholderImage:IMGWITHNAME(@"placeholder")
//                 scrollTimeInterval:5.0
//                currentPageDotImage:[UIImage imageNamed:@"pageControlCurr"]
//                       pageDotImage:[UIImage imageNamed:@"pageControlDot"]
//                       bottomHeight:60
//                           delegate:self];

// 系统自定义pagecontrol
//  self.view_topInfoScroll = [[SDCycleManager shareInstance] CGRectMake(0, 0, size.width, size.height)
//                  images:imagesURLStrings
//        PlaceholderImage:[UIImage
//                             imageNamed:@"placeholder"]
//      scrollTimeInterval:5.0
//                delegate:self];
@end

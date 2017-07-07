//
//  FGLoadingViewController.m
//  CSP
//
//  Created by JasonLu on 16/9/15.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLoadingViewController.h"
#import "SDCycleManager.h"
#import "UIView+CornerRaduis.h"
#import <UIKit/UIKit.h>

@interface FGLoadingViewController () <SDCycleScrollViewDelegate, UIScrollViewDelegate>
#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UIButton *btn_getStart;
@property (weak, nonatomic) IBOutlet UIScrollView *view_intro;
#pragma mark - 属性
@property (nonatomic, assign) NSInteger introNum;
@property (nonatomic, strong) UIPageControl *pageContrl;
@end

@implementation FGLoadingViewController
@synthesize btn_getStart;

#pragma mark - 生命周期
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  [[UIApplication sharedApplication] setStatusBarHidden:YES];
  self.btn_getStart.titleLabel.font = font(FONT_TEXT_REGULAR, 19);
    [self.btn_getStart setTitle:multiLanguage(@"GET STARTED") forState:UIControlStateNormal];
    [self.btn_getStart setTitle:multiLanguage(@"GET STARTED") forState:UIControlStateHighlighted];
  [self.btn_getStart makeWithCornerRadius:self.btn_getStart.bounds.size.height / 2];

  [self hideBottomPanelWithAnimtaion:NO];
  [self topPanelStatus:Hidden withAnimtaion:NO];
  [self getStartButtonStatus:Hidden withAnimtation:NO];
}


- (void)manullyFixSize {
  [super manullyFixSize];

  [commond useDefaultRatioToScaleView:self.view_intro];
  [commond useDefaultRatioToScaleView:self.btn_getStart];
  [self internalInitalSrollView];
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
  self.view_intro = nil;
  self.pageContrl = nil;
}

#pragma mark - 私有方法
- (void)internalInitalSrollView {
  //本地图片
  NSString *_str_suf = [commond isChinese] ? @"Chinese":@"";
  NSMutableArray *_marr_imagesURLStrings = [NSMutableArray array];
  for (int i = 1; i < 6; i++) {
    NSString *_str_name = [NSString stringWithFormat:@"OnBoardingScreen%d%@.jpg", i, _str_suf];
    [_marr_imagesURLStrings addObject:_str_name];
  }
  NSInteger num                                  = _marr_imagesURLStrings.count;
  self.view_intro.contentSize                    = CGSizeMake(W * num, H);
  self.view_intro.pagingEnabled                  = YES;
  self.view_intro.showsVerticalScrollIndicator   = NO;
  self.view_intro.showsHorizontalScrollIndicator = NO;
  self.view_intro.bounces                        = NO;

  for (int i = 0; i < num; i++) {
    UIImage *img    = IMGWITHNAME(_marr_imagesURLStrings[i]);
    UIImageView *iv = [[UIImageView alloc] initWithImage:img];
    iv.frame        = CGRectMake(i * W, 0, W, H);
    [self.view_intro addSubview:iv];
  }

  /*
  self.pageContrl                               = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 100, H - 60, 200, 20)];
  self.pageContrl.numberOfPages                 = num;
  self.pageContrl.currentPageIndicatorTintColor = rgb(80, 227, 194);
  self.pageContrl.pageIndicatorTintColor        = [UIColor whiteColor];
  [self.view addSubview:self.pageContrl];
   */
}

- (void)getStartButtonStatus:(EMStatus)status withAnimtation:(BOOL)animated {
  self.btn_getStart.alpha  = 0.0;
  self.btn_getStart.hidden = YES;
  [self.view bringSubviewToFront:self.btn_getStart];

  if (status) {
    self.btn_getStart.hidden = NO;

    if (animated == NO) {
      self.btn_getStart.alpha = 1.0f;
      return;
    }

    [UIView animateWithDuration:.3f
        animations:^{
          self.btn_getStart.alpha = 1.0;
        }
        completion:^(BOOL finished) {
          NSLog(@"animation complete==%@", self.btn_getStart);
        }];
  }
}

- (IBAction)buttonAction_getStart:(id)sender {
    
    nav_location = nil;//释放loadingViewController
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager initNavigation:&nav_location rootControllerName:@"FGLoginViewController"];
    
}

#pragma mark - SDCycleScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  NSInteger currentPage = scrollView.contentOffset.x / W;
  [self.pageContrl setCurrentPage:currentPage];

  float limitX = W * 4;
  if (scrollView.contentOffset.x < limitX) {
    if (scrollView.contentOffset.x < 0) {
      [scrollView setContentOffset:CGPointMake(0, 0)];
      return;
    }

    if (self.btn_getStart.hidden == NO) {
      [self getStartButtonStatus:Hidden withAnimtation:NO];
    }
  } else {
    if (self.btn_getStart.hidden == YES) {
      [self getStartButtonStatus:Show withAnimtation:NO];
    }
    [scrollView setContentOffset:CGPointMake(limitX, 0)];
  }
}

@end

//
//  FGHomepageTrendingWorkoutCellView.m
//  CSP
//
//  Created by JasonLu on 16/9/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "FGHomepageBigIconView.h"
#import "FGHomepageSmallIconView.h"
#import "FGHomepageTitleView.h"
#import "FGHomepageTrendingWorkoutCellView.h"
#define TAG_TITLEVIEW 100

@interface FGHomepageTrendingWorkoutCellView () {
}

@end

@implementation FGHomepageTrendingWorkoutCellView
@synthesize delegate;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  [self internalInitCell];
}

#pragma mark - 私有方法
#pragma mark 初始化Cell
- (void)internalInitCell {
  [commond useDefaultRatioToScaleView:self.view_title];
  [commond useDefaultRatioToScaleView:self.view_content];
  [commond useDefaultRatioToScaleView:self.btn_select];

  //添加标题信息
  FGHomepageTitleView *titleView = (FGHomepageTitleView *)[[[NSBundle mainBundle] loadNibNamed:@"FGHomepageTitleView" owner:nil options:nil] objectAtIndex:0];
  [titleView updateLeftTitleHidden:NO withTitle:multiLanguage(@"TRENDING WORKOUTS") color:color_homepage_black andRightTitleHidden:NO withTitle:multiLanguage(@"See more >") color:color_homepage_lightGray];
  titleView.frame = CGRectMake(0, 0, self.view_title.bounds.size.width, self.view_title.bounds.size.height);
  [self.view_title addSubview:titleView];
}

#pragma mark - 成员方法
- (void)updateCellViewWithInfo:(id)_dataInfo {
  NSArray *trendingWorkouts = (NSArray *)_dataInfo;
  if (trendingWorkouts.count > 2) {
  // 添加featured用户的头像信息
  [self addTrendingWorkoutsInfoViewWithInfo:trendingWorkouts[0] atIndex:0];
  [self addTrendingWorkoutsInfoViewWithInfo:trendingWorkouts[1] atIndex:1];
  }
//  CGFloat startx = 8;
//  [trendingWorkouts enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
//    NSDictionary *info = (NSDictionary *)obj;
//
//    FGHomepageBigIconView *bigUserView = (FGHomepageBigIconView *)[[[NSBundle mainBundle] loadNibNamed:@"FGHomepageBigIconView" owner:nil options:nil] objectAtIndex:0];
//    [commond useDefaultRatioToScaleView:bigUserView];
//    CGSize size       = bigUserView.frame.size;
//    bigUserView.frame = CGRectMake(startx + size.width * idx, 0, size.width, size.height);
//    bigUserView.tag   = TAG_TITLEVIEW + idx;
//
//    [bigUserView updateViewWithIconLink:info[@"img"] title:info[@"username"]];
//    [self.view_content addSubview:bigUserView];
//    [bigUserView.btn_info addTarget:self action:@selector(buttonAction_info:) forControlEvents:UIControlEventTouchUpInside];
//  }];
}

- (IBAction)buttonAction_selected:(id)sender {
  if (self.delegate) {
    [self.delegate didClickButton:sender];
  }
}

- (IBAction)buttonAction_info:(id)sender {
  if (self.delegate) {
    UIButton *_btn = (UIButton *)sender;
    UIView * _view_super = _btn.superview;
    
     [self.delegate didClickInfoButtonWithType:@"trendingWorkout" objAtIndex:_view_super.tag - TAG_TITLEVIEW];
  }
}

- (void)addTrendingWorkoutsInfoViewWithInfo:(NSDictionary *)_dic_info atIndex:(NSInteger)_int_idx {
  CGFloat _flt_c = self.bounds.size.width/2;
  if (_int_idx == 0) {
    _flt_c /= 2;
  } else if (_int_idx == 1) {
    CGFloat _flt_tmp = _flt_c / 2;
    _flt_c += _flt_tmp;
  }
  
  FGHomepageBigIconView *bigUserView = (FGHomepageBigIconView *)[[[NSBundle mainBundle] loadNibNamed:@"FGHomepageBigIconView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:bigUserView];
  CGSize size       = bigUserView.frame.size;
  bigUserView.frame = CGRectMake(_flt_c - size.width/2, 0, size.width, size.height);
  bigUserView.tag   = TAG_TITLEVIEW + _int_idx;
  
  [bigUserView updateViewWithIconLink:_dic_info[@"img"] title:_dic_info[@"username"]];
  [self.view_content addSubview:bigUserView];
  [bigUserView.btn_info addTarget:self action:@selector(buttonAction_info:) forControlEvents:UIControlEventTouchUpInside];
}
@end

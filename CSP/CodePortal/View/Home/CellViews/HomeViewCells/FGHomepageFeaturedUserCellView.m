//
//  FGHomepageFeaturedUserCellView.m
//  CSP
//
//  Created by JasonLu on 16/9/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "FGHomepageFeaturedUserCellView.h"
#import "FGHomepageSmallIconView.h"
#import "FGHomepageTitleView.h"
#import "UITableViewCell+BindDataToUI.h"
#define TAG_TITLEVIEW 100

@interface FGHomepageFeaturedUserCellView ()

@end

@implementation FGHomepageFeaturedUserCellView
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
  [titleView updateLeftTitleHidden:NO withTitle:multiLanguage(@"FEATURED USERS") color:color_homepage_black andRightTitleHidden:NO withTitle:multiLanguage(@"See more >") color:color_homepage_lightGray];
  titleView.frame = CGRectMake(0, 0, self.view_title.bounds.size.width, self.view_title.bounds.size.height);
  [self.view_title addSubview:titleView];
  
  //添加featured用户的头像信息
  CGFloat startx = 15;
  for (int i = 0; i < 5; i++) {
    FGHomepageSmallIconView *smallUserView = (FGHomepageSmallIconView *)[[[NSBundle mainBundle] loadNibNamed:@"FGHomepageSmallIconView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:smallUserView];
    CGSize size         = smallUserView.frame.size;
    smallUserView.frame = CGRectMake(startx + size.width * i, 0, size.width, size.height);
    smallUserView.tag   = TAG_TITLEVIEW + i;
    [self.view_content addSubview:smallUserView];
  }
}

- (FGHomepageSmallIconView *)featureUserSmallViewWithTag:(NSInteger)tag {
  return (FGHomepageSmallIconView *)[self.view_content viewWithTag:tag];
}

#pragma mark - 成员方法
- (void)updateCellViewWithInfo:(id)_dataInfo {
  NSArray *featuredUsers = (NSArray *)_dataInfo;
  // 添加featured用户的头像信息
  
  for (int i = 0; i < 5 && i < featuredUsers.count; i++) {
    NSDictionary *info = (NSDictionary *)featuredUsers[i];
    FGHomepageSmallIconView *smallUserView = (FGHomepageSmallIconView *)[self.view_content viewWithTag:TAG_TITLEVIEW + i];
    [smallUserView updateViewWithIconLink:info[@"img"] title:info[@"username"]];
    [smallUserView.btn_info addTarget:self action:@selector(buttonAction_info:) forControlEvents:UIControlEventTouchUpInside];
  }
}

- (IBAction)buttonAction_seeAll:(id)sender {
  if (self.delegate) {
    [self.delegate didClickButton:sender];
  }
}

- (IBAction)buttonAction_info:(id)sender {
  if (self.delegate) {
    UIButton *_btn = (UIButton *)sender;
    UIView * _view_super = _btn.superview;
    
    [self.delegate didClickInfoButtonWithType:@"featuredUser" objAtIndex:_view_super.tag - TAG_TITLEVIEW];
  }
}

@end

//
//  FGProfileSettingCellView.m
//  CSP
//
//  Created by JasonLu on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCircluarWithBottomTitleButton.h"
#import "FGProfileSettingCellView.h"

@implementation FGProfileSettingCellView
@synthesize btn_mybooking;
@synthesize btn_workinglog;
@synthesize btn_savedworkouts;
@synthesize btn_favorite;
@synthesize btn_fitnessleveltest;
@synthesize btn_setting;
@synthesize view_bookingBadge;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  [self internalInitCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

#pragma mark - 私有方法
#pragma mark 初始化Cell
- (void)internalInitCell {
  [commond useDefaultRatioToScaleView:self.view_bg];
  [commond useDefaultRatioToScaleView:self.btn_mybooking];
  [commond useDefaultRatioToScaleView:self.btn_workinglog];
  [commond useDefaultRatioToScaleView:self.btn_savedworkouts];
  [commond useDefaultRatioToScaleView:self.btn_favorite];
  [commond useDefaultRatioToScaleView:self.btn_fitnessleveltest];
  [commond useDefaultRatioToScaleView:self.btn_setting];
  [commond useDefaultRatioToScaleView:self.view_bookingBadge];
  self.view_bookingBadge.hidden = YES;
//  NSDictionary *otherInfos = @{
//                               multiLanguage(@"My booking") : @{
//                                   @"img" : @"booking.png",
//                                   @"title" : multiLanguage(@"My booking"),
//                                   @"number": [NSNumber numberWithInteger:0]
//
//                                   },
//                               multiLanguage(@"Working log") : @{
//                                   @"img" : @"log.png",
//                                   @"title" : multiLanguage(@"Working log")
//                                   },
//                               multiLanguage(@"Saved workouts") : @{
//                                   @"img" : @"saved.png",
//                                   @"title" : multiLanguage(@"Saved workouts")
//                                   },
//                               multiLanguage(@"My Group") : @{
//                                   @"img" : @"mygroup.png",
//                                   @"title" : multiLanguage(@"My Group")
//                                   },
//                               multiLanguage(@"Fitness level test") : @{
//                                   @"img" : @"test.png",
//                                   @"title" : multiLanguage(@"Fitness level test")
//                                   },
//                               multiLanguage(@"Setting") : @{
//                                   @"img" : @"psetting.png",
//                                   @"title" : multiLanguage(@"Setting")
//                                   },
//                               };
//  [self updateCellViewWithInfo:otherInfos];
}

- (void)updateCellViewWithInfo:(id)_dataInfo {
  if (_dataInfo == nil)
    return;
    NSString *_str_mybooking = multiLanguage(@"My booking");
    if(![commond isUser])
        _str_mybooking = multiLanguage(@"Manage booking");
        
    
    
  NSDictionary *info = _dataInfo[_str_mybooking];
  
  if ([info[@"number"] integerValue] > 0) {
    self.view_bookingBadge.hidden = NO;
  } else {
    self.view_bookingBadge.hidden = YES;
  }
//  [self.view_bookingBadge setupViewWithInfo:@{@"cnt":info[@"number"]}];
  
//  [self.btn_mybooking setupButtonInfoWithTitle:info[@"title"] buttonImage:info[@"img"]];
  [self.btn_mybooking setupButtonInfoWithTitle:info[@"title"] titleColor:color_homepage_black titleAlignment:VerticalAlignmentMiddle textAlignment:NSTextAlignmentCenter buttonImageName:info[@"img"]];

  info = _dataInfo[multiLanguage(@"Workout log")];
//  [self.btn_workinglog setupButtonInfoWithTitle:info[@"title"] buttonImage:info[@"img"]];
  [self.btn_workinglog setupButtonInfoWithTitle:info[@"title"] titleColor:color_homepage_black titleAlignment:VerticalAlignmentMiddle textAlignment:NSTextAlignmentCenter buttonImageName:info[@"img"]];

  info = _dataInfo[multiLanguage(@"Saved workouts")];
//  [self.btn_savedworkouts setupButtonInfoWithTitle:info[@"title"] buttonImage:info[@"img"]];
    [self.btn_savedworkouts setupButtonInfoWithTitle:info[@"title"] titleColor:color_homepage_black titleAlignment:VerticalAlignmentMiddle textAlignment:NSTextAlignmentCenter buttonImageName:info[@"img"]];

  info = _dataInfo[multiLanguage(@"My Group")];
//  [self.btn_favorite setupButtonInfoWithTitle:info[@"title"] buttonImage:info[@"img"]];
    [self.btn_favorite setupButtonInfoWithTitle:info[@"title"] titleColor:color_homepage_black titleAlignment:VerticalAlignmentMiddle textAlignment:NSTextAlignmentCenter buttonImageName:info[@"img"]];

  info = _dataInfo[multiLanguage(@"Fitness level test")];
//  [self.btn_fitnessleveltest setupButtonInfoWithTitle:info[@"title"] buttonImage:info[@"img"]];
    [self.btn_fitnessleveltest setupButtonInfoWithTitle:info[@"title"] titleColor:color_homepage_black titleAlignment:VerticalAlignmentMiddle textAlignment:NSTextAlignmentCenter buttonImageName:info[@"img"]];

  info = _dataInfo[multiLanguage(@"Setting")];
//  [self.btn_setting setupButtonInfoWithTitle:info[@"title"] buttonImage:info[@"img"]];
    [self.btn_setting setupButtonInfoWithTitle:info[@"title"] titleColor:color_homepage_black titleAlignment:VerticalAlignmentMiddle textAlignment:NSTextAlignmentCenter buttonImageName:info[@"img"]];
}
@end

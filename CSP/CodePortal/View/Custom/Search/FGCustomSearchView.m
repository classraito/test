//
//  FGCustomSearchView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/13.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCustomSearchView.h"
#import "Global.h"
@interface FGCustomSearchView () {
}
@end

@implementation FGCustomSearchView
@synthesize iv_searchIcon;
@synthesize tf_search;
@synthesize view_bg;
@synthesize isEditing;
@synthesize rect_originSelfFrame;
@synthesize rect_originSearchIcon;
@synthesize rect_originSearchTF;
@synthesize rect_originViewBgFrame;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  [commond useDefaultRatioToScaleView:iv_searchIcon];
  [commond useDefaultRatioToScaleView:tf_search];
  //[commond useDefaultRatioToScaleView:view_bg];

  self.rect_originSelfFrame   = self.frame;
  self.rect_originViewBgFrame = self.view_bg.frame;
  self.rect_originSearchIcon  = self.iv_searchIcon.frame;
  self.rect_originSearchTF    = self.tf_search.frame;
    
    tf_search.placeholder = multiLanguage(@"Search");
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - 设置方法
- (void)setupByBGColor:(UIColor *)_bgColor borderColor:(UIColor *)_borderColor roundRadius:(CGFloat)_roundRaduis borderWidth:(CGFloat)_borderWidth {
  [self setupByBGColor:_bgColor borderColor:_borderColor roundRadius:_roundRaduis borderWidth:_borderWidth placeHolderColor:nil placeHolderFont:nil];
}

#pragma mark - 设置方法(带placeholder设置)
- (void)setupByBGColor:(UIColor *)_bgColor borderColor:(UIColor *)_borderColor roundRadius:(CGFloat)_roundRaduis borderWidth:(CGFloat)_borderWidth placeHolderColor:(UIColor *)_placeHolderColor placeHolderFont:(UIFont *)_placeHolderFont {
  if (_placeHolderColor)
    [tf_search setValue:_placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
  if (_placeHolderFont)
    [tf_search setValue:_placeHolderFont forKeyPath:@"_placeholderLabel.font"];
  self.view_content.backgroundColor = _bgColor;
  self.view_bg.backgroundColor      = _bgColor;
  self.view_bg.layer.borderColor    = _borderColor.CGColor;
  self.view_bg.layer.borderWidth    = _borderWidth;
  self.view_bg.layer.cornerRadius   = _roundRaduis;
  self.view_bg.layer.masksToBounds  = YES;
}

@end

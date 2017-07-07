//
//  FGHomepageBigIconView.m
//  CSP
//
//  Created by JasonLu on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGHomepageBigIconView.h"

@interface FGHomepageBigIconView ()

@end

@implementation FGHomepageBigIconView
@synthesize iv_icon;
@synthesize lb_title;
@synthesize btn_info;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];

  [commond useDefaultRatioToScaleView:lb_title];
  [commond useDefaultRatioToScaleView:iv_icon];
  [commond useDefaultRatioToScaleView:btn_info];

  lb_title.font      = font(FONT_TEXT_REGULAR, 14);
  lb_title.textColor = color_homepage_lightGray;
}

- (void)updateViewWithIconLink:(NSString *)link title:(NSString *)title{
  [self.iv_icon sd_setImageWithURL:[NSURL URLWithString:link] placeholderImage:IMG_PLACEHOLDER completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//    对图片进行裁剪
//    CGSize _size_img = image.size;
//    image = [image imageCompressForTargetWidth:_size_img.width/2];
//    UIImage *_img_sub = image;//[image subImageWithSquare];
    self.iv_icon.image = image;
  }];
  self.lb_title.text = title;
}
@end

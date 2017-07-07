//
//  FGAblumScrollView.m
//  CSP
//
//  Created by JasonLu on 16/10/21.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGAblumScrollView.h"
#import "UIImageView+WebCache.h"
@interface FGAblumScrollView () <UIScrollViewDelegate> {
  NSInteger imagesCount;
  CGSize imageSize;
  CGFloat imagePadding;
  NSInteger showImageNumber;
}

@property (weak, nonatomic) IBOutlet UIScrollView *sv_content;
@property (weak, nonatomic) IBOutlet UIImageView *iv_leftArr;
@property (weak, nonatomic) IBOutlet UIImageView *iv_rightArr;

@end

@implementation FGAblumScrollView
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];

  [commond useDefaultRatioToScaleView:self.iv_leftArr];
  [commond useDefaultRatioToScaleView:self.iv_rightArr];

  self.sv_content.delegate      = self;
  self.sv_content.contentOffset = CGPointMake(0, 0);

  self.iv_leftArr.hidden     = NO;
  self.iv_rightArr.hidden    = NO;
  self.iv_rightArr.transform = CGAffineTransformMakeScale(-1.0, 1.0);
}

- (void)setupAblumWithImages:(NSArray *)images imgSize:(CGSize)imgSize showNumber:(NSInteger)number inBoundSize:(CGSize)boundSize padding:(CGFloat)padding {
  CGFloat width    = number * imgSize.width + (number - 1) * padding;
  CGRect rect_self = self.frame;
  //居中
  self.sv_content.frame = CGRectMake((rect_self.size.width - width) / 2, 0, width, boundSize.height);

  NSInteger count = images.count;
  CGFloat startx  = 0;
  if (count > number) {
    startx = 0;
  } else {
    CGFloat flt_width = count * imgSize.width + (count-1) * padding;
    startx = 0;//(width - flt_width) / 2;
    self.iv_rightArr.hidden    = YES;
  }
  
  CGRect rect_iv  = CGRectZero;
  //可能图片地址
  for (int i = 0; i < count; i++) {
    NSString *imgUrl = images[i];
    UIImageView *iv  = [[UIImageView alloc] initWithFrame:CGRectMake(startx + (imgSize.width + padding) * i, (boundSize.height - imgSize.height) / 2, imgSize.width, imgSize.height)];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.clipsToBounds = YES;
    [self.sv_content addSubview:iv];
    [iv sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    rect_iv = iv.frame;
  }
  showImageNumber             = number;
  imagesCount                 = count;
  imageSize                   = CGSizeMake(imgSize.width, imgSize.height);
  imagePadding                = padding;
  self.sv_content.contentSize = CGSizeMake((imagesCount - 1) * (imgSize.width + padding) + imgSize.width, imgSize.height);
  
  self.iv_rightArr.hidden = NO;
  self.iv_leftArr.hidden  = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView.contentOffset.x > imageSize.width) {
    self.iv_leftArr.hidden = NO;
  } else {
    self.iv_leftArr.hidden = YES;
  }

  if (scrollView.contentOffset.x * (ratioW) >= self.sv_content.contentSize.width - ((imageSize.width * showImageNumber) + (imagePadding * (showImageNumber - 1)))) {
    self.iv_rightArr.hidden = YES;
  } else {
    self.iv_rightArr.hidden = NO;
  }
}

@end

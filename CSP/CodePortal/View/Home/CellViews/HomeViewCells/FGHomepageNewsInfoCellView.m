//
//  FGHomepageNewsInfoCellView.m
//  CSP
//
//  Created by JasonLu on 16/9/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGHomepageNewsInfoCellView.h"
@interface FGHomepageNewsInfoCellView ()
@property (weak, nonatomic) IBOutlet UIButton *btn_news;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIImageView *iv_bg;
@property (weak, nonatomic) IBOutlet UIImageView *iv_shadowbg;
@property (weak, nonatomic) IBOutlet UIImageView *iv_arrowRight;

@end

@implementation FGHomepageNewsInfoCellView
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  [self internalInitCell];
}

#pragma mark - 私有方法
#pragma mark 初始化Cell
- (void)internalInitCell {
  self.lb_title.userInteractionEnabled = NO;

  [commond useDefaultRatioToScaleView:self.lb_title];
  [commond useDefaultRatioToScaleView:self.btn_news];
  [commond useDefaultRatioToScaleView:self.iv_bg];
  [commond useDefaultRatioToScaleView:self.iv_shadowbg];
  [commond useDefaultRatioToScaleView:self.iv_arrowRight];
  
  self.lb_title.font = font(FONT_TEXT_REGULAR, 20);
  self.lb_title.numberOfLines = 2;

}

#pragma mark - 成员方法
- (void)updateCellViewWithInfo:(id)_dataInfo {
  
  self.lb_title.text =  _dataInfo[@"newsTitle"];
  [self.iv_bg sd_setImageWithURL:[NSURL URLWithString:_dataInfo[@"img"]] placeholderImage:IMG_PLACEHOLDER completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //    对图片进行裁剪
    image = [image imageCompressForTargetWidth:320 * ratioW];
    self.iv_bg.image = image;
  }];
  
//  [self.iv_bg sd_setImageWithURL:[NSURL URLWithString:_dataInfo[@"img"]] placeholderImage:IMG_PLACEHOLDER];
}


- (IBAction)buttonAction_selected:(id)sender {
  if (self.delegate) {
    [self.delegate didClickButton:sender];
  }
}
@end

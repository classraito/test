//
//  FGTrainerProfileInfoCellView.m
//  CSP
//
//  Created by JasonLu on 16/10/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCircluarForTrainerIconButton.h"
#import "FGTrainerProfileInfoCellView.h"
#import "FGViewsQueueCustomView.h"
#import "UIImage+BlurEffect.h"
@interface FGTrainerProfileInfoCellView ()
@property (nonatomic, strong) NSMutableArray *arr_imgs;
@end

@implementation FGTrainerProfileInfoCellView
@synthesize view_useIconAndname;
@synthesize iv_bg;
@synthesize qv_trainerLevel;
@synthesize arr_imgs;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  [commond useDefaultRatioToScaleView:self.iv_bg];
  [commond useDefaultRatioToScaleView:self.view_useIconAndname];
  [commond useDefaultRatioToScaleView:self.qv_trainerLevel];
  
  self.arr_imgs = [qv_trainerLevel initalQueueByImageNames:@[ @"star_stoke.png", @"star_stoke.png", @"star_stoke.png", @"star_stoke.png", @"star_stoke.png" ] highlightedImageNames:@[ @"star_filled.png", @"star_filled.png", @"star_filled.png", @"star_filled.png", @"star_filled.png" ] padding:1 imgBounds:CGRectMake(0, 0, 12 * ratioW, 12 * ratioW) increaseMode:ViewsQueueIncreaseMode_CENTER];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

}

- (void)dealloc {
  self.arr_imgs = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - 成员方法
- (void)updateCellViewWithInfo:(id)_dataInfo {
  [super updateCellViewWithInfo:_dataInfo];
  
  NSString *username = _dataInfo[@"username"];
  NSString *title    = [NSString stringWithFormat:@"%@",username];
  
  UIImage *blurImage = _dataInfo[@"imgbg"];
  UIImage *tmpImage  = _dataInfo[@"img"];
  
  [self.iv_bg setImage:blurImage];
  [self.view_useIconAndname setupButtonInfoWithTitle:title titleColor:[UIColor whiteColor] titleAlignment:VerticalAlignmentBottom textAlignment:NSTextAlignmentCenter buttonImage:tmpImage];
  [self.view_useIconAndname setProcessPercent:0.3];
  [self.view_useIconAndname setupStatusWithShowProcessBg:YES showProcess:NO];

  NSInteger level = [_dataInfo[@"level"] integerValue];
  [self setupTrainerInfoWithLevel:level];
  
}

- (void)setupTrainerInfoWithLevel:(NSInteger)level {
  for (int i = 0; i < level; i++) {
    UIImageView *iv = [self.arr_imgs objectAtIndex:i];
    iv.highlighted  = YES;
  }
}
@end

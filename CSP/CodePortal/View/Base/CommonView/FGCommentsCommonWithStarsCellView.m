//
//  FGCommentsCommonWithStarsCellView.m
//  CSP
//
//  Created by JasonLu on 16/10/25.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCommentsCommonWithStarsCellView.h"
#import "FGViewsQueueCustomView.h"
@interface FGCommentsCommonWithStarsCellView ()
@property (nonatomic, strong) NSMutableArray *arr_imgs;
@end
@implementation FGCommentsCommonWithStarsCellView
@synthesize qv_ratingLevel;
@synthesize arr_imgs;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  [commond useDefaultRatioToScaleView:self.qv_ratingLevel];
  
  arr_imgs = [self.qv_ratingLevel initalQueueByImageNames:@[ @"star_stoke.png", @"star_stoke.png", @"star_stoke.png", @"star_stoke.png", @"star_stoke.png" ] highlightedImageNames:@[ @"star_filled.png", @"star_filled.png", @"star_filled.png", @"star_filled.png", @"star_filled.png" ] padding:1 imgBounds:CGRectMake(0, 0, 12 * ratioW, 12 * ratioW) increaseMode:ViewsQueueIncreaseMode_CENTER];
}

- (void)dealloc {
  self.arr_imgs = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

- (void)layoutSubviews {
  [super layoutSubviews];

  //重新定 qv_ratingLevel的位置
  [self.lb_time sizeToFit];
  CGRect rect_lbframe       = self.lb_time.frame;
  CGRect rect_qvRatingLevel = self.qv_ratingLevel.frame;
  CGFloat y                 = (rect_lbframe.origin.y + rect_lbframe.size.height / 2) - rect_qvRatingLevel.size.height / 2;
  self.qv_ratingLevel.frame = CGRectMake(rect_lbframe.origin.x + rect_lbframe.size.width + 10, y, rect_qvRatingLevel.size.width, rect_qvRatingLevel.size.height);
}

- (void)updateCellViewWithInfo:(id)_dataInfo {
  [super updateCellViewWithInfo:_dataInfo];

  NSInteger level = [_dataInfo[@"level"] integerValue];
  [self setupTrainerInfoWithLevel:level];

  [self sizeToFit];
}

- (void)setupTrainerInfoWithLevel:(NSInteger)level {
  for (int i = 0; i < level; i++) {
    UIImageView *iv = [self.arr_imgs objectAtIndex:i];
    iv.highlighted  = YES;
  }
}
@end

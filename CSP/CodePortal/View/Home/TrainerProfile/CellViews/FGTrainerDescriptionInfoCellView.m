//
//  FGTrainerDescriptionInfoCellView.m
//  CSP
//
//  Created by JasonLu on 16/10/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainerDescriptionInfoCellView.h"
#import "FGUtils.h"
@interface FGTrainerDescriptionInfoCellView ()
@property (weak, nonatomic) IBOutlet UILabel *lb_trainerDescription;
@end

@implementation FGTrainerDescriptionInfoCellView
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  [commond useDefaultRatioToScaleView:self.lb_trainerDescription];
  self.lb_trainerDescription.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - 成员方法
- (void)updateCellViewWithInfo:(id)_dataInfo {
  NSArray *detailInfo                           = (NSArray *)_dataInfo;
  __block NSMutableAttributedString *resultAStr = [[NSMutableAttributedString alloc] init];
  [detailInfo enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    NSDictionary *dic        = (NSDictionary *)obj;
    NSArray *contentInfoArr  = dic[@"content"];
    NSAttributedString *aStr = [FGUtils createAttributedStringWithContentInfo:contentInfoArr];
    [resultAStr appendAttributedString:aStr];
  }];

  self.lb_trainerDescription.attributedText = resultAStr;
  [self.lb_trainerDescription sizeToFit];

  CGRect rect                      = [FGUtils calculatorAttributeString:self.lb_trainerDescription.attributedText withWidth:self.lb_trainerDescription.bounds.size.width * ratioW];
  self.lb_trainerDescription.frame = CGRectMake(self.lb_trainerDescription.frame.origin.x, 8, self.lb_trainerDescription.frame.size.width, rect.size.height);
}

- (CGFloat)cellHeight {
  if (self.lb_trainerDescription.attributedText == nil) {
    return 44 * ratioH;
  }
  return (self.lb_trainerDescription.frame.size.height + 16);
}

@end

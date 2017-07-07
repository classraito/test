//
//  FGAboutusTitleView.m
//  CSP
//
//  Created by JasonLu on 17/1/20.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGAboutusTitleView.h"
@interface FGAboutusTitleView ()
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign) BOOL bool_isOpen;

@end

@implementation FGAboutusTitleView
@synthesize bool_isOpen;

#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self addGestureRecognizer:self.tapGesture];
}


-(UITapGestureRecognizer *)tapGesture
{
  if (!_tapGesture) {
    _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapped:)];
  }
  return _tapGesture;
}

-(void)updateCellViewWithInfo:(id)_dataInfo {
  NSLog(@"_dataInfo==%@", _dataInfo);
  self.bool_isOpen = [_dataInfo[@"status"] boolValue];
  self.tag = [_dataInfo[@"tag"] integerValue];
}


-(void)shouldExpand:(BOOL)shouldExpand
{
//  [UIView animateWithDuration:0.2
//                   animations:^{
//                     if (shouldExpand) {
//                       if (self.arrowPosition == YUFoldingSectionHeaderArrowPositionRight) {
//                         self.arrowImageView.transform = CGAffineTransformMakeRotation(-M_PI/2);
//                       }else{
//                         self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
//                       }
//                     } else {
//                       if (self.arrowPosition == YUFoldingSectionHeaderArrowPositionRight) {
//                         _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
//                       }else{
//                         self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
//                       }
//                     }
//                   } completion:^(BOOL finished) {
//                     if (finished == YES) {
//                       self.sepertorLine.hidden = shouldExpand;
//                     }
//                   }];
}

-(void)onTapped:(UITapGestureRecognizer *)gesture
{
  [self shouldExpand:![NSNumber numberWithInteger:self.bool_isOpen].boolValue];
  if (_tapDelegate && [_tapDelegate respondsToSelector:@selector(action_sectionHeaderTappedAtIndex::)]) {
    self.bool_isOpen = [NSNumber numberWithBool:(![NSNumber numberWithInteger:self.bool_isOpen].boolValue)].integerValue;
    [_tapDelegate action_sectionHeaderTappedAtIndex:self.tag];
  }
}
@end

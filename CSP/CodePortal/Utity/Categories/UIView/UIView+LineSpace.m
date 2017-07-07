//
//  UIView+LineSpace.m
//  Framafoto
//
//  Created by PengLei on 16/12/28.
//  Copyright © 2016年 PengLei. All rights reserved.
//

#import "UIView+LineSpace.h"

@implementation UIView (LineSpace)

-(void)reSetLineHeight
{
    [self reSetLineHeightWithH:0.5];
}

-(void)reSetLineWidth
{
    [self reSetLineWidthWithW:0.5];
}

-(void)reSetLineWidthWithW:(CGFloat)_width
{
    CGRect _frame = self.frame;
    CGFloat orign_width = _frame.size.width;
    _frame.size.width = _width;
    _frame.origin.x += orign_width - _width;
    self.frame = _frame;
}


-(void)reSetLineHeightWithH:(CGFloat)_height
{
    CGRect _frame = self.frame;
    CGFloat orign_height = _frame.size.height;
    _frame.size.height = _height;
    _frame.origin.y += orign_height - _height;
    self.frame = _frame;
}
@end

//
//  FGViewWithSepratorLineView.h
//  DunkinDonuts
//
//  Created by Ryan Gong on 15/11/17.
//  Copyright © 2015年 Ryan Gong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGCustomizableBaseView.h"
@interface FGViewWithSepratorLineView : FGCustomizableBaseView
{

}
@property(nonatomic,assign)IBOutlet UIView *view_leftSepratorLine;
@property(nonatomic,assign)IBOutlet UIView *view_rightSepratorLine;
-(void)setupByMiddleView:(UIView *)_view padding:(CGFloat )_padding lineHeight:(CGFloat)_lineHeight lineColor:(UIColor *)_lineColor;
-(void)setupByMiddleView:(UIView *)_view padding:(CGFloat)_padding lineHeight:(CGFloat)_lineHeight lineColor:(UIColor *)_lineColor limitedLineWidth:(CGFloat)_limitedLineWidth;
@end

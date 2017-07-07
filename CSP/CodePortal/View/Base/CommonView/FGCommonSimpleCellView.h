//
//  FGHomepageSearchSimpleCellView.h
//  CSP
//
//  Created by JasonLu on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGCommonSimpleCellView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_right;
- (void)setupViewWithRightButtonTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)btnColor borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)bgColor;
- (void)setupViewWithRightButtonTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)btnColor borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)bgColor cornerRadius:(CGFloat)radius;
- (void)setupViewHiddenRightBtn:(BOOL)isHidden;
@end

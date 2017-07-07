//
//  FGHomepageTitleView.h
//  CSP
//
//  Created by JasonLu on 16/9/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FGHomepageTitleViewDelegate <NSObject>

- (void)action_didSelectTitle:(id)sender;

@end


@interface FGHomepageTitleView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lb_left;
@property (weak, nonatomic) IBOutlet UILabel *lb_right;
@property (weak, nonatomic) IBOutlet UIButton *btn_right;
@property (assign, nonatomic) id<FGHomepageTitleViewDelegate> delegate;

- (void)updateLeftTitleHidden:(BOOL)lhidden withTitle:(id)lTitle color:(UIColor *)lcolor andRightTitleHidden:(BOOL)rhidden withTitle:(NSString *)rTitle color:(UIColor *)rcolor;
- (void)updateLeftTitleHidden:(BOOL)lhidden withTitle:(id)lTitle color:(UIColor *)lcolor andRightTitleHidden:(BOOL)rhidden withTitle:(NSString *)rTitle color:(UIColor *)rcolor rightButtonHidden:(BOOL)_bool_hidden tag:(NSInteger)_int_tag;
- (void)setupWithBgColor:(UIColor *)color leftTitleFont:(UIFont *)lfont rightTitleFont:(UIFont *)rfont;

- (void)updateLeftTitleStatus:(BOOL)lhidden rightTitleStatus:(BOOL)rhidden;
- (void)updateLeftTitleWith:(id)leftTitle rightTitleWith:(NSString *)rightTitle;
@end

//
//  FGCustomSearchViewWithButtonView.h
//  CSP
//
//  Created by JasonLu on 16/10/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCustomizableBaseView.h"

typedef enum : NSUInteger {
  TF_NORMAL,
  TF_EDITING,
} TFSTATUS;

@interface FGCustomSearchViewWithButtonView : FGCustomizableBaseView

@property (nonatomic, assign) IBOutlet UIImageView *iv_searchIcon;
@property (nonatomic, assign) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet UIView *view_bg;
@property (weak, nonatomic) IBOutlet UIButton *btn_right;
- (void)setupSearchViewWithButton:(NSString *)title buttonColor:(UIColor *)buttonColor;
- (void)setupSearchViewWithButton:(NSString *)title buttonColor:(UIColor *)buttonColor searchIcon:(NSString *)iconName;
- (void)setupSearchViewWithStatus:(TFSTATUS)status withAnimation:(BOOL)isAnimation;
- (void)setupViewOriginStyleWithAnimation:(BOOL)isAnimated;
@end

//
//  FGCircularButton.h
//  CSP
//
//  Created by Ryan Gong on 16/9/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCustomizableBaseView.h"

@interface FGCircularButton : FGCustomizableBaseView
{
    UIColor *bgColor;
    UIColor *bgHighlightedColor;
    NSString *str_highlightedText;
    NSString *str_buttonText;
    UIColor *defaultTextColor;
    UIColor *highlightedTextColor;
}
@property(nonatomic,assign)IBOutlet UIButton *btn;
@property(nonatomic,assign)IBOutlet UILabel *lb_buttonText;
-(void)setupCircularButtonByBgColor:(UIColor *)_bgColor bgHighlightColor:(UIColor *)_highlightColor textColor:(UIColor *)_textDefaultColor textHighlightColor:(UIColor *)_textHighlightColor btnText:(NSString *)_str_buttonText btnHighlightedText:(NSString *)_str_highlightedButtonText buttonFont:(UIFont *)_buttonFont;
-(void)setHighlighted;
-(void)setNormal;
-(void)setMyBackgroundColor:(UIColor *)_color;
@end

//
//  FGCircularButton.m
//  CSP
//
//  Created by Ryan Gong on 16/9/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCircularButton.h"
#import "Global.h"
@implementation FGCircularButton
@synthesize btn;
@synthesize lb_buttonText;
-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)setupCircularButtonByBgColor:(UIColor *)_bgColor bgHighlightColor:(UIColor *)_highlightColor textColor:(UIColor *)_textDefaultColor textHighlightColor:(UIColor *)_textHighlightColor btnText:(NSString *)_str_buttonText btnHighlightedText:(NSString *)_str_highlightedButtonText buttonFont:(UIFont *)_buttonFont
{
    lb_buttonText.hidden = YES;
    [btn setTitle:_str_buttonText forState:UIControlStateNormal];
    [btn setTitle:_str_buttonText forState:UIControlStateHighlighted];
    
    str_buttonText = [_str_buttonText mutableCopy];
    str_highlightedText = [_str_highlightedButtonText mutableCopy];
    
    [btn setTitleColor:_textDefaultColor forState:UIControlStateNormal];
    [btn setTitleColor:_textHighlightColor forState:UIControlStateHighlighted];
    
    btn.titleLabel.font = _buttonFont;
    
    defaultTextColor = _textDefaultColor;
    highlightedTextColor = _textHighlightColor;
    
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
    
    bgColor = _bgColor;
    self.view_content.backgroundColor = bgColor;
    self.backgroundColor = bgColor;
    bgHighlightedColor = _highlightColor;
    
}

-(void)setMyBackgroundColor:(UIColor *)_color
{
    self.view_content.backgroundColor = _color;
    self.backgroundColor = _color;
}

-(void)setHighlighted
{
    self.view_content.backgroundColor = bgHighlightedColor;
    [btn setTitle:str_highlightedText forState:UIControlStateNormal];
    [btn setTitle:str_highlightedText forState:UIControlStateHighlighted];
    [btn setTitleColor:highlightedTextColor forState:UIControlStateNormal];
    [btn setTitleColor:highlightedTextColor forState:UIControlStateHighlighted];
}

-(void)setNormal
{
    self.view_content.backgroundColor = bgColor;
    [btn setTitle:str_buttonText forState:UIControlStateNormal];
    [btn setTitle:str_buttonText forState:UIControlStateHighlighted];
    [btn setTitleColor:defaultTextColor forState:UIControlStateNormal];
    [btn setTitleColor:defaultTextColor forState:UIControlStateHighlighted];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    btn.frame = self.bounds;
    lb_buttonText.frame = self.bounds;
}


-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    str_highlightedText = nil;
    str_buttonText = nil;
}

@end

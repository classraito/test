//
//  FGTextInput.h
//  TextFieldTestProject
//
//  Created by JasonLu on 16/11/1.
//  Copyright © 2016年 JasonLu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ActionHandler)();
@protocol FGTextInput <NSObject>
#pragma mark - 初始化方法
- (void)setupAttributesWithFont:(UIFont *)font textColor:(UIColor *)color;
- (void)setupMatchPatternMarkWithString:(NSString *)matchStr
                              maxLength:(NSInteger)maxLength;
- (void)setupMathPatternsWithArray:(NSArray *)arr_Matches
                         maxLength:(NSInteger)maxLength;
- (void)setupWithSpecialPattern:(NSString *)str_specialPattern withActionHandler:(ActionHandler)actionHandler;

#pragma mark - 属性方法
- (void)setupTextFont:(UIFont*)textFont;
- (void)setupLineSpaceing:(CGFloat)lineSpacing;
- (void)setupLineBreakMode:(NSLineBreakMode)lineBreakMode;
- (void)setupTextAlignment:(NSTextAlignment)textAlignment;
- (void)setupTextColor:(UIColor *)color;

- (NSArray *)textlinkInfos;
- (void)clearMemory;

@end

//
//  Font.h
//  MyStock
//
//  Created by Ryan Gong on 15/9/11.
//  Copyright (c) 2015年 Ryan Gong. All rights reserved.
//
#import "commond.h"

#pragma mark - App 自定义字体
#define FONT_NUM_MEDIUM     @"DIN-Medium"
#define FONT_NUM_REGULAR    @"DINPro-Regular"
#define FONT_EN_BOLD        @"Montserrat-Bold"
#define FONT_EN_REGULAR     @"Montserrat-Regular"
#define FONT_CN_BOLD        @"Montserrat-Bold"
#define FONT_CN_REGULAR     @"Montserrat-Regular"
//#define FONT_CN_BOLD        @"PingFangSC-Semibold"
//#define FONT_CN_REGULAR     @"PingFangSC-Regular"
//#define FONT_CN_BOLD        @"STYuanti-SC-Bold"
//#define FONT_CN_REGULAR     @"STYuanti-SC-Regular"

#define FONT_TEXT_BOLD [commond isChinese] ?  FONT_CN_BOLD : FONT_EN_BOLD
#define FONT_TEXT_REGULAR [commond isChinese] ?  FONT_CN_REGULAR : FONT_EN_REGULAR 

#pragma mark - 获取字体
#define font(fontname,fSize)        [UIFont fontWithName:fontname size: (int)(((float)fSize/*中文字体稍大些*/+ ([commond isChinese] ?  1.5 : 0.0)) * (W / 414.0f))   ]   //我这里字体大小是按照iphone 6 plus取的，这个宏可以按照屏幕宽度的变化而变化字体的尺寸
//fSize是磅值(pt) 像素磅值转换公式:px=pt*dpi/72   pt=px*72/dpi 美工如果给的是px(像素) 那么他必须给dpi 不然无法推算出 pt


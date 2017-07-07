//
//  UIColor+ColorChange.h
//  CSP
//
//  Created by JasonLu on 17/1/22.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorChange)
// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;
@end

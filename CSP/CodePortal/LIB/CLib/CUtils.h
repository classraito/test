//
//  CUtils.h
//  RuntimeTestProject
//
//  Created by JasonLu on 16/9/1.
//  Copyright © 2016年 JasonLu. All rights reserved.
//

#ifndef CUtils_h
#define CUtils_h

#include <stdio.h>
#include <objc/runtime.h>

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector);

#endif /* CUtils_h */

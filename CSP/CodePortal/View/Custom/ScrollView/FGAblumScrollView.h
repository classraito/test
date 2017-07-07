//
//  FGAblumScrollView.h
//  CSP
//
//  Created by JasonLu on 16/10/21.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGAblumScrollView : FGCustomizableBaseView
- (void)setupAblumWithImages:(NSArray *)images imgSize:(CGSize)imgSize showNumber:(NSInteger)number inBoundSize:(CGSize)boundSize padding:(CGFloat)padding;
@end

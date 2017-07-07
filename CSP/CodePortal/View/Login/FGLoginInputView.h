//
//  FGLoginInputView.h
//  CSP
//
//  Created by JasonLu on 16/9/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGLoginInputView : UIView
- (NSString *)inputStr;
- (void)updateViewWithIcon:(NSString *)iconName Placeholder:(NSString *)str;
- (void)updateTFWithString:(NSString *)_str;
@end

//
//  UITextField+MatchPattern.h
//  TextFieldTestProject
//
//  Created by JasonLu on 16/9/27.
//  Copyright © 2016年 JasonLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (MatchPattern)
@property(nonatomic, copy, readonly) NSString *maxLength;
@property(nonatomic, copy, readonly) NSString *matchPatternStr;
@property(nonatomic, copy, readonly) NSString *inputStr;
@property(nonatomic, copy, readonly) NSString *oldInputStr;

- (void)setTFMatchPatternMarkWithString:(NSString *)matchStr
                              maxLength:(NSString *)maxLength;

@end

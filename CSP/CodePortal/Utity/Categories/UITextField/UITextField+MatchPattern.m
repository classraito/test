//
//  UITextField+MatchPattern.m
//  TextFieldTestProject
//
//  Created by JasonLu on 16/9/27.
//  Copyright © 2016年 JasonLu. All rights reserved.
//

#import "UITextField+MatchPattern.h"
#import <objc/runtime.h>
static const void *matchPatternStrKey = &matchPatternStrKey;
static const void *inputStrKey = &inputStrKey;
static const void *oldInputStrKey = &oldInputStrKey;
static const void *maxLengthKey = &maxLengthKey;
@implementation UITextField (MatchPattern)
#pragma mark - 匹配字符
- (void)setTFMatchPatternMarkWithString:(NSString *)matchStr
                              maxLength:(NSString *)maxLength {
  [self setMatchPatternStr:matchStr];
  [self setMaxLength:maxLength];

  [self addTarget:self
                action:@selector(textFieldEditingChanged:)
      forControlEvents:UIControlEventEditingChanged];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(textFiledEditChanged:)
             name:@"UITextFieldTextDidChangeNotification"
           object:self];
}

- (NSString *)matchPatternStr {
  return objc_getAssociatedObject(self, matchPatternStrKey);
}

- (void)setMatchPatternStr:(NSString *)aPatternStr {
  objc_setAssociatedObject(self, matchPatternStrKey, aPatternStr,
                           OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)maxLength {
  return objc_getAssociatedObject(self, maxLengthKey);
}

- (void)setMaxLength:(NSString *)aStr {
  objc_setAssociatedObject(self, maxLengthKey, aStr,
                           OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - textfield内容修改后的内容
- (NSString *)inputStr {
  return objc_getAssociatedObject(self, inputStrKey);
}

- (void)setInputStr:(NSString *)aStr {
  objc_setAssociatedObject(self, inputStrKey, aStr,
                           OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - textfield内容之前的内容
- (NSString *)oldInputStr {
  return objc_getAssociatedObject(self, oldInputStrKey);
}

- (void)setOldInputStr:(NSString *)aStr {
  objc_setAssociatedObject(self, oldInputStrKey, aStr,
                           OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - 监听方法
//正要发生的变化，保存原来字符串
- (void)textFieldEditingChanged:(NSNotification *)obj {
  UITextField *tf = (UITextField *)obj;
  [self setOldInputStr:[self inputStr]];
  [self setInputStr:tf.text];
}

//已经发生变化，最新字符串
- (void)textFiledEditChanged:(NSNotification *)obj {
  // TODO: 需要做的逻辑处理
  UITextField *textField = (UITextField *)obj.object;
  NSString *toBeString = textField.text;
  NSString *oldString = [self oldInputStr];

  if (![[self matchPatternStr] isEqualToString:@""] && oldString.length > 0) {
    //如果是删除
    if (oldString.length > toBeString.length) {
      NSString *deleteChar =
          [oldString substringFromIndex:oldString.length - 1];
      NSString *leftString = [oldString substringToIndex:oldString.length - 1];
      if ([deleteChar isEqualToString:[self matchPatternStr]]) {
        NSRange range = [leftString rangeOfString:[self matchPatternStr]
                                          options:NSBackwardsSearch];
        NSString *newLeftStr =
            [leftString substringWithRange:NSMakeRange(0, range.location)];
        textField.text = newLeftStr;
        toBeString = newLeftStr;
      }
    }
  }

  //获取高亮部分
  UITextRange *selectedRange = [textField markedTextRange];
  UITextPosition *position =
      [textField positionFromPosition:selectedRange.start offset:0];

  NSInteger MAX_STARWORDS_LENGTH = [[self maxLength] integerValue];
  // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
  if (!position) {
    if (toBeString.length > MAX_STARWORDS_LENGTH) {
      NSRange rangeIndex = [toBeString
          rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
      if (rangeIndex.length == 1) {
        textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
      } else {
        NSRange rangeRange =
            [toBeString rangeOfComposedCharacterSequencesForRange:
                            NSMakeRange(0, MAX_STARWORDS_LENGTH)];
        textField.text = [toBeString substringWithRange:rangeRange];
      }
    }
  }
  [self setInputStr:textField.text];
  //  NSLog(@"old str==%@", [self oldInputStr]);
  //  NSLog(@"new str==%@", [self inputStr]);
}

- (void)dealloc {
  objc_removeAssociatedObjects(self);
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:UITextFieldTextDidChangeNotification
              object:nil];
}
@end

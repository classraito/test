//
//  UITextView+Util.m
//  TextFieldTestProject
//
//  Created by JasonLu on 16/11/1.
//  Copyright © 2016年 JasonLu. All rights reserved.
//
#include <objc/runtime.h>
#import "UITextView+Utils.h"
#import "NSAttributedString+Attributes.h"

static char kMatchPatterns; //可能有多个通配符号
static char kInputStr;
static char kOldInputStr;
static char kMaxLength;
static char kActionHandlers;
static char kCurrentMatchPatterns;
static char kAttrLineBreakMode;
static char kAttrLineSpacing;
static char kAttrTextAlignment;
static char kAttrTextColor;
static char kAttrTextFont;
static char kLinkInfos;
@implementation UITextView (Utils)
#pragma mark - 私有方法
- (void)setupBasicPropertyWithMaxLength:(NSInteger)maxLength{
    [self setMaxLength:[NSString stringWithFormat:@"%ld", maxLength]];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textViewEditChanged:)
     name:UITextViewTextDidChangeNotification
     object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContentWithObj:) name:NOTIFICATION_UPDATECONTENT object:nil];
    
    
    NSArray *arr_matchPatterns = [self matchPatterns];
    NSMutableArray *marr_tmp = [[NSMutableArray   alloc] init];
    for (NSDictionary *dic_matchPattern in arr_matchPatterns) {
        NSArray *arr_keys = dic_matchPattern[@"key"];
        NSDictionary *tmp_dic = @{@"key":arr_keys,
                                  @"infos":[NSArray array],
                                  @"linkPrefix":dic_matchPattern[@"linkPrefix"]};
        [marr_tmp addObject:tmp_dic];
    }
    [self setLinkInfos:marr_tmp];
    
    
}



- (BOOL)isInvalidMatchPatterns {
  NSArray * arr_matchPattern = [self matchPatterns];
  __block BOOL bool_isInvalid = YES;
  [arr_matchPattern enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSDictionary *dic_matchPattern = (NSDictionary *)obj;
//    NSString * str_matchPattern = dic_matchPattern[@"key"];
    NSArray * arr_matchPatternKey = dic_matchPattern[@"key"];
    if (arr_matchPatternKey.count > 0) {
      bool_isInvalid = NO;
      *stop = YES;
    }
  }];
  return bool_isInvalid;
}

- (void)updateDisplayTextView {
    NSMutableAttributedString *tmpAStr = [[NSMutableAttributedString alloc] initWithString:self.attributedText.string];
    float length                       = self.attributedText.string.length;
    [tmpAStr addAttribute:NSForegroundColorAttributeName value:[self attrTextColor] range:NSMakeRange(0, length)];
    [tmpAStr addAttribute:NSFontAttributeName value:[self attrTextFont] range:NSMakeRange(0, length)];
    //段落样式
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    //行间距
    paragraph.lineSpacing = [self attrLineSpacing];
    //对齐方式
    paragraph.alignment = [self attrTextAlignment];
    //指定段落开始的缩进像素
    paragraph.firstLineHeadIndent = 0;
    //调整全部文字的缩进像素
  if ([paragraph respondsToSelector:@selector(headIndent)])
    paragraph.headIndent = 0;
  else {
    ;
  }
    //添加段落设置
    [tmpAStr addAttribute:NSParagraphStyleAttributeName
                    value:paragraph
                    range:NSMakeRange(0, tmpAStr.length)];
    
    NSMutableArray *marr_subStrings = [NSMutableArray array];
    //设置特殊字符的样式
    NSMutableAttributedString *mas = tmpAStr;
    NSArray *arr_matchPatterns = [self matchPatterns];
    for (NSDictionary *dic_matchPattern in arr_matchPatterns) {
        NSArray * arr_matchPatternKeys = dic_matchPattern[@"key"];
        UIColor *color = dic_matchPattern[@"color"];
        UIColor *bgcolor = dic_matchPattern[@"bgColor"];
        UIFont * _font = dic_matchPattern[@"font"];
        //有两个匹配符号
        if (arr_matchPatternKeys.count > 1) {
            NSArray *arr_rect = [FGUtils arrayFromString:mas.string beginMatchPatternStr:arr_matchPatternKeys[0] endMatchPatternStr:arr_matchPatternKeys[1]];
            if (arr_rect.count == 0) {
                continue;
            }
            
            for (id obj_range in arr_rect) {
                NSRange range = NSRangeFromString(obj_range);
                NSRange range_new = NSMakeRange(range.location-1, range.length+2);
                NSString *str_sub = [mas.string substringWithRange:range_new];
                //        NSLog(@"str_sub==%@", str_sub);
                [mas addAttribute:NSForegroundColorAttributeName value:color range:range_new];
                [mas addAttribute:NSBackgroundColorAttributeName value:bgcolor range:range_new];
                [mas addAttribute:NSFontAttributeName value:_font range:range_new];
                [marr_subStrings addObject:@{@"key":arr_matchPatternKeys,@"content":str_sub}];
            }
        }
        else {
            //只有一个匹配符号
            NSArray *arr_ranges = [FGUtils getRangesFromString:mas.string findText:arr_matchPatternKeys[0] specailKeys:[self matchPatterns]];
            if (arr_ranges.count > 0) {
                for (id obj_range in arr_ranges) {
                    NSRange range = NSRangeFromString(obj_range);
                    NSRange range_new = NSMakeRange(range.location, range.length+1);
                    
                    NSString *str_sub = [mas.string substringWithRange:range_new];
                    //          NSLog(@"str_sub==%@", str_sub);
                    [mas addAttribute:NSForegroundColorAttributeName value:color range:range_new];
                    [mas addAttribute:NSBackgroundColorAttributeName value:bgcolor range:range_new];
                    [mas addAttribute:NSFontAttributeName value:_font range:range_new];
                    [marr_subStrings addObject:@{@"key":arr_matchPatternKeys,@"content":str_sub}];
                }
            }
        }
    }
    
//    [self setSubStrings:marr_subStrings];
    self.attributedText = mas;
    self.selectedRange = NSMakeRange(mas.string.length, 0);
    
    tmpAStr   = nil;
    paragraph = nil;
    mas = nil;
}

#pragma mark 设置行间距
- (CGFloat)attrLineSpacing {
  return [objc_getAssociatedObject(self, &kAttrLineSpacing) floatValue];
}

- (void)setAttrLineSpacing:(CGFloat)lineSpacing {
  if (lineSpacing < 0) {
    objc_setAssociatedObject(self, &kAttrLineSpacing, nil,
                             OBJC_ASSOCIATION_RETAIN);
    return;
  }
  objc_setAssociatedObject(self, &kAttrLineSpacing, [NSNumber numberWithFloat:lineSpacing],
                           OBJC_ASSOCIATION_RETAIN);
}
#pragma mark 设置文本对齐方式
- (NSTextAlignment)attrTextAlignment {
  return [objc_getAssociatedObject(self, &kAttrTextAlignment) integerValue];
}

- (void)setAttrTextAlignment:(NSTextAlignment)textAlignment {
  if (textAlignment < 0) {
    objc_setAssociatedObject(self, &kAttrTextAlignment, nil,
                             OBJC_ASSOCIATION_RETAIN);
    return;
  }
  
  objc_setAssociatedObject(self, &kAttrTextAlignment, [NSNumber numberWithInteger:textAlignment],
                           OBJC_ASSOCIATION_RETAIN);
}
#pragma mark 设置换行方式
- (NSLineBreakMode)attrlineBreakMode {
  return [objc_getAssociatedObject(self, &kAttrLineBreakMode) integerValue];
}

- (void)setAttrLineBreakMode:(NSLineBreakMode)lineBreakMode {
  if (lineBreakMode < 0) {
    objc_setAssociatedObject(self, &kAttrLineBreakMode, nil,
                             OBJC_ASSOCIATION_RETAIN);
    return;
  }
  objc_setAssociatedObject(self, &kAttrLineBreakMode, [NSNumber numberWithInteger:lineBreakMode],
                           OBJC_ASSOCIATION_RETAIN);
}
#pragma mark 设置文本颜色
- (UIColor *)attrTextColor {
  return objc_getAssociatedObject(self, &kAttrTextColor);
}

- (void)setAttrTextColor:(UIColor *)attrTextColor {
  objc_setAssociatedObject(self, &kAttrTextColor, attrTextColor,
                           OBJC_ASSOCIATION_RETAIN);
}
#pragma mark 设置文本字体
- (UIFont *)attrTextFont {
  return objc_getAssociatedObject(self, &kAttrTextFont);
}

- (void)setAttrTextFont:(UIFont *)attrTextFont {
  objc_setAssociatedObject(self, &kAttrTextFont, attrTextFont,
                           OBJC_ASSOCIATION_RETAIN);
}

#pragma mark 设置当前匹配字符
- (NSArray *)currentMatchPatterns {
  return objc_getAssociatedObject(self, &kCurrentMatchPatterns);
}

- (void)setCurrentMatchPatterns:(NSArray *)aPatterns {
  objc_setAssociatedObject(self, &kCurrentMatchPatterns, aPatterns,
                           OBJC_ASSOCIATION_RETAIN);
}

#pragma mark 设置当前链接信息
- (NSMutableArray *)linkInfos {
  return objc_getAssociatedObject(self, &kLinkInfos);
}

- (void)setLinkInfos:(NSMutableArray *)linkInfos {
  objc_setAssociatedObject(self, &kLinkInfos, linkInfos,
                           OBJC_ASSOCIATION_RETAIN);
}

#pragma mark 监听方法
//已经发生变化，最新字符串
- (void)textViewEditChanged:(NSNotification *)obj {
    
    
  // TODO: 需要做的逻辑处理
  UITextView *textView = (UITextView *)obj.object;
    
    if(textView.markedTextRange)//markedTextRange 不为空 说明用了输入法 不处理以下代码
        return;
    
  __block NSString *toBeString = textView.attributedText.string;//textView.text;
  __block NSString *oldString = @"";
  if ([[self oldInputStr] isKindOfClass:[NSNull class]] ||
      [self oldInputStr] == nil){
    [self setOldInputStr:@""];
    oldString = @"";
  }
  else {
    oldString = [self oldInputStr];
  }
//  __block NSString *str_currentMatchPatternKey = nil;
  __block NSArray *arr_currentMatchPatternKeys = nil;
  
  __block ActionHandler action_handler = nil;
//    NSLog(@"toBeString=%@,oldString=%@", toBeString, oldString);
//    NSLog(@"textView.markedTextRange = %@",textView.markedTextRange);
    
    
  //删除动作
  //![self isInvalidMatchPatterns] &&
  if (oldString.length > 0) {
    //如果是删除
    if (toBeString.length >0 &&
        oldString.length > toBeString.length) {
      NSString *deleteChar =
      [oldString substringFromIndex:oldString.length - 1];
      NSString *leftString = [oldString substringToIndex:oldString.length - 1];
      
      //需要循环遍历是否匹配通配符
      NSArray * arr_matchPattern = [self matchPatterns];
      [arr_matchPattern enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic_matchPattern = (NSDictionary *)obj;
        NSArray * arr_matchPatternKeys = dic_matchPattern[@"key"];
        
        // 2个匹配符号
        if (arr_matchPatternKeys.count > 1) {
          NSString * str_matchPattern = arr_matchPatternKeys[1];
          if ([deleteChar isEqualToString:str_matchPattern]) {
//            如果前面没有空格就需要删除
//            如果前面有空格就不能删除
            NSString *str_fristMatchPatternKey = arr_matchPatternKeys[0];
//            NSRange range_space = [leftString rangeOfString:@" "
//                                                    options:NSBackwardsSearch];
            NSRange range_firstMatchPatternKey = [leftString rangeOfString:str_fristMatchPatternKey options:NSBackwardsSearch];
            ;
//            if (range_space.location != NSNotFound &&
//                range_firstMatchPatternKey.location != NSNotFound &&
//                range_space.location < range_firstMatchPatternKey.location)
            {
              NSString *newLeftStr =
              [leftString substringWithRange:NSMakeRange(0, range_firstMatchPatternKey.location)];
              toBeString = newLeftStr;
              
              *stop = YES;
            }
          }
        }
        
      }];
    }
  }
  
  
  //  添加动作
  if (toBeString.length > oldString.length) {
    NSString *str_added = [toBeString substringFromIndex:toBeString.length-1];
    //第一步首先需要循环通配符号
    NSArray *arr_matchPatterns = [self matchPatterns];
    [arr_matchPatterns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSDictionary *dic_matchPattern = (NSDictionary *)obj;
      NSArray * arr_matchPatternKeys = dic_matchPattern[@"key"];
      NSString * str_first_matchPatternKey = arr_matchPatternKeys[0];
      
      if ([str_added isEqualToString:str_first_matchPatternKey]) {
        //第二步搜索匹配通配符的action
        NSArray *arr_actions = [self specialActioinHandlers];
        [arr_actions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          NSDictionary *dic_handler = (NSDictionary *)obj;
          NSString * str_handlerMatchPattern = dic_handler[@"key"];
          
          if ([str_handlerMatchPattern isEqualToString:str_first_matchPatternKey]) {
            ActionHandler handler = dic_handler[@"handler"];
            if (handler) {
              action_handler = handler;
              arr_currentMatchPatternKeys = arr_matchPatternKeys;
              *stop= YES;
            }
          }
        }];
        *stop = YES;
      }
    }];
    
    if (action_handler) {
      [self setCurrentMatchPatterns:arr_currentMatchPatternKeys];
      action_handler();
      return;
    }
  }
  
  NSInteger MAX_STARWORDS_LENGTH = [[self maxLength] integerValue];
  // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//  if (!position) {
    if (toBeString.length > MAX_STARWORDS_LENGTH) {
      NSRange rangeIndex = [toBeString
                            rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
      if (rangeIndex.length == 1) {
        //        textView.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
        
        toBeString = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
        //        textView.attributedText = [self setupAttributedStringWithString:toBeString];
      } else {
        NSRange rangeRange =
        [toBeString rangeOfComposedCharacterSequencesForRange:
         NSMakeRange(0, MAX_STARWORDS_LENGTH)];
        //        textView.text = [toBeString substringWithRange:rangeRange];
        
        toBeString = [toBeString substringWithRange:rangeRange];
        //        textView.attributedText = [self setupAttributedStringWithString:toBeString];
      }
    } else {
      //      textView.attributedText = [self setupAttributedStringWithString:toBeString];
    }
    
    
    NSMutableAttributedString *mAttr_new = [[NSMutableAttributedString alloc] initWithString:toBeString];
    self.attributedText = mAttr_new;
    [self updateDisplayTextView];
//  }
  
  
  [self setInputStr:textView.attributedText.string];
  [self setOldInputStr:[self inputStr]];
}

#pragma mark 设置最大输入长度
- (NSString *)maxLength {
  return objc_getAssociatedObject(self, &kMaxLength);
}

- (void)setMaxLength:(NSString *)aStr {
  objc_setAssociatedObject(self, &kMaxLength, aStr,
                           OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#pragma mark textfield内容修改后的内容
- (NSString *)inputStr {
  return objc_getAssociatedObject(self, &kInputStr);
}

- (void)setInputStr:(NSString *)aStr {
  objc_setAssociatedObject(self, &kInputStr, aStr,
                           OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark textfield内容之前的内容
- (NSString *)oldInputStr {
  return objc_getAssociatedObject(self, &kOldInputStr);
}

- (void)setOldInputStr:(NSString *)aStr {
  objc_setAssociatedObject(self, &kOldInputStr, aStr,
                           OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (void)updateContentWithObj:(NSNotification *)notification {
    if ([[notification object] isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic_notificationInfo = (NSDictionary *)[notification object];
        NSString *content = dic_notificationInfo[@"content"];
        NSArray *arr_currentMatchPatterns = [self currentMatchPatterns];
        NSString *str_new = @"" ;
        if (arr_currentMatchPatterns.count > 1) {
            
            str_new = [NSString stringWithFormat:@"%@%@%@%@ ",[self oldInputStr],arr_currentMatchPatterns[0],content,arr_currentMatchPatterns[1]];
        } else {
            str_new = [NSString stringWithFormat:@"%@%@%@ ",[self oldInputStr],arr_currentMatchPatterns[0],content];
        }
        NSMutableArray *marr_infos;
        NSMutableArray *marr_tmp = [self linkInfos];
        int i = 0;
        for (NSDictionary *dic_infos in marr_tmp) {
            NSArray *arr_key = dic_infos[@"key"];
            //搜索key
            if (arr_currentMatchPatterns.count > 1) {
                if ([arr_currentMatchPatterns[0] isEqualToString:arr_key[0]] &&
                    [arr_currentMatchPatterns[1] isEqualToString:arr_key[1]]) {
                    marr_infos = [NSMutableArray arrayWithArray:dic_infos[@"infos"]];
                    [marr_infos addObject:dic_notificationInfo];
                    
                    NSDictionary *tmp_dic = @{@"key":arr_key,@"infos":marr_infos, @"linkPrefix": dic_infos[@"linkPrefix"]};
                    [marr_tmp replaceObjectAtIndex:i withObject:tmp_dic];
                    [self setLinkInfos:marr_tmp];
                    break;
                }
            } else {
                if ([arr_currentMatchPatterns[0] isEqualToString:arr_key[0]]){
                    marr_infos = [NSMutableArray arrayWithArray:dic_infos[@"infos"]];
                    [marr_infos addObject:dic_notificationInfo];
                    
                    NSDictionary *tmp_dic = @{@"key":arr_key,@"infos":marr_infos, @"linkPrefix": dic_infos[@"linkPrefix"]};
                    [marr_tmp replaceObjectAtIndex:i withObject:tmp_dic];
                    [self setLinkInfos:marr_tmp];
                    break;
                }
            }
            
            i++;
        }
        
        NSLog(@"link infos=%@", [self linkInfos]);
        
        
        NSMutableAttributedString *mAttr_new = [[NSMutableAttributedString alloc] initWithString:str_new];
        self.attributedText = mAttr_new;
        [self updateDisplayTextView];
        [self setInputStr:self.attributedText.string];
        [self setOldInputStr:[self inputStr]];
    }
}

#pragma mark - 属性方法
#pragma mark 设置textview样式
- (void)setupAttributesWithFont:(UIFont *)font textColor:(UIColor *)color{
  [self setupAttributesWithFont:font LineSpacing:-1 textAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByTruncatingHead textColor:color];
}

- (void)setupAttributesWithFont:(UIFont *)font LineSpacing:(CGFloat)lineSpacing textAlignment:(NSTextAlignment)textAlignment lineBreakMode:(NSLineBreakMode)lineBreakMode textColor:(UIColor *)color {
  [self setAttrLineSpacing:lineSpacing];
  [self setAttrLineBreakMode:lineBreakMode];
  [self setAttrTextAlignment:textAlignment];
  [self setAttrTextColor:color];
  [self setAttrTextFont:font];
}

#pragma mark 匹配字符
- (void)setupMatchPatternMarkWithString:(NSString *)matchStr
                              maxLength:(NSInteger)maxLength {
  [self setMatchPatterns:@[matchStr]];
  [self setupBasicPropertyWithMaxLength:maxLength];
}

- (void)setupMathPatternsWithArray:(NSArray *)arr_Matches
                         maxLength:(NSInteger)maxLength {
  [self setMatchPatterns:arr_Matches];
  [self setupBasicPropertyWithMaxLength:maxLength];
}
#pragma mark 设置字体
- (void)setupTextFont:(UIFont*)textFont {
  [self setAttrTextFont:textFont];
  [self updateDisplayTextView];
}
#pragma mark 设置行间距
- (void)setupLineSpaceing:(CGFloat)lineSpacing {
  [self setAttrLineSpacing:lineSpacing];
  [self updateDisplayTextView];
}
#pragma mark 设置行换行模式
- (void)setupLineBreakMode:(NSLineBreakMode)lineBreakMode {
  [self setAttrLineBreakMode:lineBreakMode];
  [self updateDisplayTextView];
}
#pragma mark 设置文本对齐
- (void)setupTextAlignment:(NSTextAlignment)textAlignment {
  [self setAttrTextAlignment:textAlignment];
  [self updateDisplayTextView];
}
#pragma mark 设置文本颜色
- (void)setupTextColor:(UIColor *)color {
  [self setAttrTextColor:color];
  [self updateDisplayTextView];
}
- (void)setupTextColor:(UIColor *)color range:(NSRange)range {
  NSMutableAttributedString *mas = [self.attributedText mutableCopy];
  [mas setTextColor:color range:range];
  self.attributedText = mas;
}

#pragma mark 设置特殊字符的事件
//- (void)setupWithSpecialPatterns:(NSArray *)arr_specialPatterns withActionHandler:(ActionHandler)actionHandler {
//  NSDictionary * dic = @{@"key":arr_specialPatterns,
//                         @"handler":actionHandler};
//  [self setSpecialActioinHandlers:dic];
//}

- (void)setupWithSpecialPattern:(NSString *)str_specialPattern withActionHandler:(ActionHandler)actionHandler {
  NSDictionary * dic = @{@"key":str_specialPattern,
                         @"handler":actionHandler};
  [self setSpecialActioinHandlers:dic];
}

- (NSMutableArray *)specialActioinHandlers {
  return objc_getAssociatedObject(self, &kActionHandlers);
}
- (void)setSpecialActioinHandlers:(id)handler {
  
  NSMutableArray *marr_handlers = [NSMutableArray arrayWithArray:[self specialActioinHandlers]];
  
  [marr_handlers addObject:handler];
  objc_setAssociatedObject(self, &kActionHandlers, marr_handlers,
                           OBJC_ASSOCIATION_COPY);
}

- (void)setSpecialActioinHandlerBeNil {
    
    objc_setAssociatedObject(self, &kActionHandlers, nil,
                             OBJC_ASSOCIATION_COPY);
}

- (NSArray *)matchPatterns {
  return objc_getAssociatedObject(self, &kMatchPatterns);
}

- (void)setMatchPatterns:(NSArray *)aPatterns {
  objc_setAssociatedObject(self, &kMatchPatterns, aPatterns,
                           OBJC_ASSOCIATION_RETAIN);
}

- (NSArray *)textlinkInfos {
  return [self linkInfos];
}

- (void)clearMemory {
  [[NSNotificationCenter defaultCenter]
   removeObserver:self
   name:UITextViewTextDidChangeNotification
   object:nil];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UPDATECONTENT object:nil];
  
  
  [self setAttrTextColor:nil];
  [self setAttrLineBreakMode:-1];
  [self setAttrTextAlignment:-1];
  [self setAttrLineSpacing:-1];
  [self setCurrentMatchPatterns:nil];
  [self setMatchPatterns:nil];
  [self setInputStr:nil];
  [self setOldInputStr:nil];
  [self setMaxLength:nil];
  [self setSpecialActioinHandlerBeNil];
}

@end

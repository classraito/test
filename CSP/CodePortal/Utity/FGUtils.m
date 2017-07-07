//
//  FGUtils.m
//  CSP
//
//  Created by JasonLu on 16/8/31.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "JPUSHService.h"
#import "UIImage+BlurEffect.h"
#import "FGUtils.h"
#define multiLanguage(text) NSLocalizedStringFromTable(text, @"MyString", @"")
#define SEARCHKEY @"searchKey"
@implementation FGUtils
// MARK: -Utility Methods
/*!
 *  @brief 输出当前App所支持的所有字体名称
 *
 *  @return
 */
+ (void)printAllSupportFontName {
  NSArray *familyNames = [UIFont familyNames];
  for (NSString *familyName in familyNames) {
    printf("Family: %s \n", [familyName UTF8String]);

    NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
    for (NSString *fontName in fontNames) {
      printf("\tFont: %s \n", [fontName UTF8String]);
    }
  }
}

#pragma mark - 自定义文字颜色，样式
/*!
 *  @brief 自定义文字颜色，样式
 *
 *  @param strInfoArr    文字信息
 *
 *      文字数组中包含的文字信息对象：
 NSDictionary *textInfo = @{
 @"text" : text,
 @"font" : font,
 @"color" : color,
 @"paragraphSpacing" : [NSNumber numberWithFloat:paragraphSpacing],
 @"lineSpacing" : [NSNumber numberWithFloat:lineSpacing],
 @"textAlignment" : [NSNumber numberWithInteger:textAlignment],
 @"sepeatorString" : sepeator
 };
 *
 *  @return 自定义AttributeString
 */
+ (NSMutableAttributedString *)createAttributedStringWithContentInfo:(NSArray *)strInfoArr {
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
  [strInfoArr enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    NSString *str                 = obj[@"text"];
    NSString *str_Sepeator        = obj[@"sepeatorString"];
    UIFont *font                  = obj[@"font"];
    UIColor *color                = obj[@"color"];
    CGFloat paragraphSpacing      = [obj[@"paragraphSpacing"] floatValue];
    CGFloat lineSpacing           = [obj[@"lineSpacing"] floatValue];
    NSTextAlignment textAlignment = [obj[@"textAlignment"] integerValue];
    str                           = [NSString stringWithFormat:@"%@%@", str, str_Sepeator];

    NSMutableAttributedString *tmpAStr = [[NSMutableAttributedString alloc] initWithString:str];
    float length                       = str.length;
    [tmpAStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, length)];
    [tmpAStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, length)];
    //段落样式
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    //行间距
    paragraph.lineSpacing = lineSpacing;
    //段落间距
    paragraph.paragraphSpacing = paragraphSpacing;
    //对齐方式
    paragraph.alignment = textAlignment;
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
    [attributedString appendAttributedString:tmpAStr];
    tmpAStr   = nil;
    paragraph = nil;
  }];
  return attributedString;
}

+ (NSDictionary *)createAttributeTextInfo:(NSString *)text font:(UIFont *)font color:(UIColor *)color paragraphSpacing:(CGFloat)paragraphSpacing lineSpacing:(CGFloat)lineSpacing textAlignment:(NSTextAlignment)textAlignment sepeatorByString:(NSString *)sepeator {
  NSDictionary *textInfo = @{
    @"text" : text,
    @"font" : font,
    @"color" : color,
    @"paragraphSpacing" : [NSNumber numberWithFloat:paragraphSpacing],
    @"lineSpacing" : [NSNumber numberWithFloat:lineSpacing],
    @"textAlignment" : [NSNumber numberWithInteger:textAlignment],
    @"sepeatorString" : sepeator
  };
  return textInfo;
}

+ (CGRect)calculatorAttributeString:(NSAttributedString *)aStr withWidth:(CGFloat)width {
  NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
  CGRect rect                    = [aStr boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options context:nil];
  return rect;
}

#pragma mark - 时间工具
//返回特定时间段
+ (NSString *)formatScheduleSpecificTimeDurationWithStartTime:(NSString *)_startTime {
  
  if ([_startTime hasSuffix:@"06:00"]) {
    return @"06:00-07:00";
  }
  else if ([_startTime hasSuffix:@"07:30"]) {
    return @"07:30-08:30";
  }
  else if ([_startTime hasSuffix:@"09:00"]) {
    return @"09:00-10:00";
  }
  else if ([_startTime hasSuffix:@"10:30"]) {
    return @"10:30-11:30";
  }
  else if ([_startTime hasSuffix:@"12:00"]) {
    return @"12:00-13:00";
  }
  else if ([_startTime hasSuffix:@"13:30"]) {
    return @"13:30-14:30";
  }
  else if ([_startTime hasSuffix:@"15:00"]) {
    return @"15:00-16:00";
  }
  else if ([_startTime hasSuffix:@"16:30"]) {
    return @"16:30-17:30";
  }
  else if ([_startTime hasSuffix:@"18:00"]) {
    return @"18:00-19:00";
  }
  else if ([_startTime hasSuffix:@"19:30"]) {
    return @"19:30-20:30";
  }
  else if ([_startTime hasSuffix:@"21:00"]) {
    return @"21:00-22:00";
  }
  
  return @"";
}
/*!
 *  @brief  返回日期字符串
 *
 *  @param time1970SecondStr 1970开始的秒时间
 *
 *  @return 返回日期格式: 2016-10-10 17:12:00
 */
+ (NSString *)dateSpecificTimeWithTimeIntervalSecondStr:(NSString *)time1970Sec {
  NSDate *date                   = [NSDate dateWithTimeIntervalSince1970:[time1970Sec doubleValue]];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSString *dateStr = [dateFormatter stringFromDate:date];
  dateFormatter     = nil;
  return dateStr;
}

+ (NSString *)dateSpecificTimeWithTimeIntervalSecondStr:(NSString *)time1970Sec withFormat:(NSString *)dateFormat {
//  @"yyyy-MM-dd HH:mm:ss"
  NSDate *date                   = [NSDate dateWithTimeIntervalSince1970:[time1970Sec doubleValue]];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.locale= [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];

  [dateFormatter setDateFormat:dateFormat];
  NSString *dateStr = [dateFormatter stringFromDate:date];
  dateFormatter     = nil;
  return dateStr;
}

+ (NSString *)dateSpecificTimeWithTimeInterval:(NSTimeInterval)time1970Sec withFormat:(NSString *)dateFormat {
  //  @"yyyy-MM-dd HH:mm:ss"
  NSDate *date                   = [NSDate dateWithTimeIntervalSince1970:time1970Sec];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.locale= [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
  
  [dateFormatter setDateFormat:dateFormat];
  NSString *dateStr = [dateFormatter stringFromDate:date];
  dateFormatter     = nil;
  return dateStr;
}

+ (NSString *)intervalNowBeginWith1970SecondStr:(NSString *)time1970Sec {
  NSString *date  = [FGUtils dateSpecificTimeWithTimeIntervalSecondStr:time1970Sec];
  NSCalendar *cal = [NSCalendar currentCalendar];
  //  NSInteger days            = 5;
  unsigned int unitFlags    = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateFormatter *formater = [[NSDateFormatter alloc] init];
  [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSDate *d1              = [formater dateFromString:date];
  NSDate *d2              = [NSDate date]; //[NSDate dateWithTimeInterval:-days * 24 * 60 * 60 sinceDate:[NSDate date]];
  NSDateComponents *d     = [cal components:unitFlags fromDate:d1 toDate:d2 options:0];
  NSMutableString *result = [[NSMutableString alloc] init];
  if ([d year] > 0) {
    [result appendFormat:@"%ld %@ ", (long)[d year], [d year] > 1 ? multiLanguage(@"years ago") : multiLanguage(@"year ago")];
  } else if ([d month] > 0) {
    [result appendFormat:@"%ld %@ ", (long)[d month], [d month] > 1 ? multiLanguage(@"months ago") : multiLanguage(@"month ago")];
  } else if ([d day] > 0) {
    [result appendFormat:@"%ld %@ ", (long)[d day], [d day] > 1 ? multiLanguage(@"days ago") : multiLanguage(@"day ago")];
  }
  BOOL dayuyitian = result.length > 0;
  if (dayuyitian)
    return [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

  if ([d hour] > 0) {
    [result appendFormat:@"%ld %@ ", (long)[d hour], [d hour] > 1 ? multiLanguage(@"hours ago") : multiLanguage(@"hour ago")];
  } else if ([d minute] > 0) {
    [result appendFormat:@"%ld %@ ", (long)[d minute], [d minute] > 1 ? multiLanguage(@"minutes ago") : multiLanguage(@"minute ago")];
  } else if ([d second] > 0 && !dayuyitian) {
    //    [result appendFormat:@"%ld%@ ", (long)[d second], [d second] > 1 ? multiLanguage(@"seconds") : multiLanguage(@"second")];
    [result appendFormat:@"%@ ", multiLanguage(@"just now")];
  }
  else if ([d second] <= 0 && !dayuyitian)
  {
      [result appendFormat:@"%@ ", multiLanguage(@"just now")];
  }

  return [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// 根据秒数格式化天时分
+ (NSString *)formatDayHourMinuteWithSecondTimeInterval:(NSTimeInterval)secondsTime {
  
  NSString *format_time = @"";
  NSInteger day = secondsTime/(3600*24);
//  if (day > 0)
//  {
    // 天时分格式
    // 时分秒格式
    NSInteger intSeconds = secondsTime - (day * 3600 *24);// (NSInteger)secondsTime;
    //format of hour
    NSString *str_hour      = [NSString stringWithFormat:@"%02ld", intSeconds/3600];
    //format of minute
    NSString *str_minute  = [NSString stringWithFormat:@"%02ld", (intSeconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld", intSeconds%60];
//    //format of day
//    NSString *str_day = [NSString stringWithFormat:@"%01d", day];
//    //format of time
    format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
//  }
//  else {
//    // 时分秒格式
//    NSInteger intSeconds = (NSInteger)secondsTime;
//    //format of hour
//    NSString *str_hour      = [NSString stringWithFormat:@"%02d", intSeconds/3600];
//    //format of minute
//    NSString *str_minute  = [NSString stringWithFormat:@"%02d", (intSeconds%3600)/60];
//    //format of second
//    NSString *str_second = [NSString stringWithFormat:@"%02d", intSeconds%60];
//    //format of time
//    format_time = [NSString stringWithFormat:@"剩余%@时%@分%@秒",str_hour,str_minute,str_second];
//  }
  
  return format_time;
}

+ (NSTimeInterval)formatTimeIntervalFromDate:(NSDate *)_date{
  NSDate * today = _date;
  // FIXME: 可能有问题，时区问题
  NSTimeZone *zone = [NSTimeZone timeZoneForSecondsFromGMT:8];//[NSTimeZone systemTimeZone];
//  [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//直接指定时区，这里是东8区

  NSInteger interval = [zone secondsFromGMTForDate:today];
  NSDate *localeDate = [today dateByAddingTimeInterval:interval];
  NSLog(@"%@", localeDate);
  return [localeDate timeIntervalSince1970];
//  // 时间转换成时间戳
//  NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
//  NSLog(@"timeSp : %@", timeSp);
}

// 根据秒数格式化天时分
+ (void)calculateHourMinuteWithSecondTimeInterval:(NSTimeInterval)secondsTime withHours:(NSInteger *)hours withMinutes:(NSInteger *)minutes withSeconds:(NSInteger *)seconds  {
  
  NSInteger day = secondsTime/(3600*24);
  NSInteger intSeconds = secondsTime - (day * 3600 *24);// (NSInteger)secondsTime;

  NSInteger _int_hours   = intSeconds/3600;
  NSInteger _int_minutes = (intSeconds%3600)/60;
  NSInteger _int_seconds = intSeconds%60;
  
  if (hours)
    *hours   = _int_hours;
  if (minutes)
    *minutes = _int_minutes;
  if (seconds)
    *seconds = _int_seconds;
}

+ (NSString *)pathInDocumentsWithFileName:(NSString *)_fileName {
  if (_fileName == nil)
    return @"";
  
  NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
  //文件管理器
  NSFileManager *fileManager = [NSFileManager defaultManager];
  [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
  
  NSString *path = [[NSString alloc]initWithFormat:@"%@/%@",DocumentsPath,  _fileName];
  return path;
}

+ (NSString *)pathInDocumentsWithPNG:(NSString *)_fileName {
  if (_fileName == nil)
    return @"";
  
  return [FGUtils pathInDocumentsWithFileName:[NSString stringWithFormat:@"%@.png",_fileName]];;
}

+ (BOOL)saveDocumentsFileWithName:(NSString *)_name suffixType:(NSString *)_suffixType fileData:(NSData *)_fileData {
  if (_name == nil || _fileData == nil)
    return NO;
  //图片保存的路径
  //这里将图片放在沙盒的documents文件夹中
  NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
  //文件管理器
  NSFileManager *fileManager = [NSFileManager defaultManager];
  //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
  BOOL bool_ret = [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
  [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@.%@",_name, _suffixType]] contents:_fileData attributes:nil];
  return bool_ret;
//  //得到选择后沙盒中图片的完整路径
//  NSString * filePath = [FGUtils pathInDocumentsWithFileName:@"userAvatar.png"];//
}

+ (BOOL)saveDocumentsFilePNGWithName:(NSString *)_name fileData:(NSData *)_fileData {
  return [FGUtils saveDocumentsFileWithName:_name suffixType:@"png" fileData:_fileData];
}

//对于需要有两个匹配符号的
+ (NSArray *)arrayFromString:(NSString *)str beginMatchPatternStr:(NSString *)str_beginMatchPattern endMatchPatternStr:(NSString *)str_endMatchPattern {
  NSString *str_tmp = str;
  NSString *str_regex = [NSString stringWithFormat:@"(?<=\\%@).*?(?=\\%@)",str_beginMatchPattern,str_endMatchPattern];
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:str_regex options:0 error:nil];
  
  NSArray *matches = [regex matchesInString:str_tmp options:0 range:NSMakeRange(0, str_tmp.length)];
  
  NSMutableArray *marr_rect = [NSMutableArray array];
  int i = 0;
  for (NSTextCheckingResult *result in matches) {
    NSRange matchRange = [result range];
    if (i % 2 == 0)
      [marr_rect addObject:NSStringFromRange(matchRange)];
    i++;
  }
  
  return marr_rect;
}

+ (NSArray *)getRangesFromString:(NSString *)text findText:(NSString *)findText specailKeys:(NSArray *)arr_specialKeys{
  NSMutableArray *marr_ranges = [NSMutableArray array];
  if (findText == nil && [findText isEqualToString:@""]) {
    return marr_ranges;
  }
  NSString *str_tmp = text;
  NSRange range_search = NSMakeRange(0, str_tmp.length);
  NSRange range_ret;
  NSRange range_tmp = NSMakeRange(0, 0);
  do {
    range_ret = [str_tmp rangeOfString:findText options:NSCaseInsensitiveSearch range:range_search];
    //    @"fj@kdja 89bhj @ffds "
    if (range_ret.location != NSNotFound) {
      
      if (!NSEqualRanges(range_tmp, NSMakeRange(0, 0))) {
        
        NSRange range_specialKey;
        //搜索空格
        NSRange range_space = NSMakeRange(range_tmp.location+range_tmp.length, str_tmp.length - (range_tmp.location+range_tmp.length));
        range_specialKey = [str_tmp rangeOfString:@" " options:NSCaseInsensitiveSearch range:range_space];
        
        //搜索特殊字符
        for (NSDictionary* dic_matchPattern in arr_specialKeys) {
          NSArray *arr_keys = dic_matchPattern[@"key"];
          for (NSString *str_key in arr_keys) {
            if (![str_key isEqualToString:findText]) {
              NSRange range_tmp = [str_tmp rangeOfString:str_key options:NSCaseInsensitiveSearch range:range_space];
              
              if (range_tmp.location != NSNotFound &&
                  range_tmp.location < range_specialKey.location) {
                range_specialKey = range_tmp;
              }
            }
          }
        }
        
        NSInteger int_length = range_ret.location - range_tmp.location - 1;
        //        添加range
        NSRange range_position = NSMakeRange(range_tmp.location, int_length);
        //        [marr_ranges addObject:NSStringFromRange(range_position)];
        
        //如果第二个字符是空格的话,需要重新分割
        NSLog(@"subString==%@", [str_tmp substringWithRange:NSMakeRange(range_tmp.location+1, 1)]);
        if ([[str_tmp substringWithRange:NSMakeRange(range_tmp.location+1, 1)] isEqualToString:@" "]) {
          ;
        } else if (range_ret.location > range_specialKey.location) {
          ;
          NSInteger int_length = range_specialKey.location - range_tmp.location - 1;
          NSRange range_position = NSMakeRange(range_tmp.location, int_length);
          [marr_ranges addObject:NSStringFromRange(range_position)];
        }
        else {
          [marr_ranges addObject:NSStringFromRange(range_position)];
        }
      }
      
      range_search = NSMakeRange(range_ret.location+range_ret.length, str_tmp.length - (range_ret.location+range_ret.length));
      range_tmp = range_ret;
      
    } else {
      if (!NSEqualRanges(range_tmp, NSMakeRange(0, 0))) {
        
        // 最后一个需要找空格
        range_ret = [str_tmp rangeOfString:@" " options:NSCaseInsensitiveSearch range:range_search];
        
        //搜索特殊字符
        for (NSDictionary* dic_matchPattern in arr_specialKeys) {
          NSArray *arr_keys = dic_matchPattern[@"key"];
          for (NSString *str_key in arr_keys) {
            if (![str_key isEqualToString:findText]) {
              NSRange range_tmp = [str_tmp rangeOfString:str_key options:NSCaseInsensitiveSearch range:range_search];
              
              if (range_tmp.location != NSNotFound &&
                  range_tmp.location < range_ret.location) {
                range_ret = range_tmp;
              }
            }
          }
        }
        
        
        //        如果碰到空格就说明断掉了
        //        如果碰不到空格说明字符串结束了
        NSInteger int_length;
        if (range_ret.location != NSNotFound) {
          int_length = range_ret.location - range_tmp.location - 1;
        } else {
          int_length = str_tmp.length - range_tmp.location - 1;
        }
        
        //        添加range
        NSRange range_position = NSMakeRange(range_tmp.location, int_length);
        [marr_ranges addObject:NSStringFromRange(range_position)];
      }
      break;
    }
    
  } while (YES);
  return marr_ranges;
}

//<a href=\"userid:47539\">@Nice</a><a href=\"\">#Race match#</a>
+ (NSString *)formatToHtmlStringWithString:(NSString *)str useMatchPatterns:(NSArray *)matchPatterns {
  //设置特殊字符的样式
  NSMutableString *mstr_ret = [NSMutableString string];
  NSArray *arr_matchPatterns = matchPatterns;
  NSMutableArray *marr_specialLinkInfos = [NSMutableArray array];
  
  for (NSDictionary *dic_matchPattern in arr_matchPatterns) {
    NSArray * arr_matchPatternKeys = dic_matchPattern[@"key"];
    //有两个匹配符号
    if (arr_matchPatternKeys.count > 1) {
      NSArray *arr_rect = [FGUtils arrayFromString:str beginMatchPatternStr:arr_matchPatternKeys[0] endMatchPatternStr:arr_matchPatternKeys[1]];
      if (arr_rect.count == 0) {
        continue;
      }
      
      for (id obj_range in arr_rect) {
        NSRange range = NSRangeFromString(obj_range);
        NSRange range_new = NSMakeRange(range.location-1, range.length+2);
        
        //遍历info项目
        NSArray *arr_infos = dic_matchPattern[@"infos"];
        for (NSDictionary *dic_info in arr_infos) {
          NSString *str_sub = [str substringWithRange:NSMakeRange(range_new.location, range_new.length)];
          NSString *str_content = dic_info[@"content"];
          NSRange range_match = [str_sub rangeOfString:str_content];
          if (range_match.location != NSNotFound){
            NSDictionary* dic_find = @{@"range":NSStringFromRange(range_new),@"content":str_content,@"link":dic_info[@"link"], @"keys":arr_matchPatternKeys, @"linkPrefix":dic_matchPattern[@"linkPrefix"]};
            [marr_specialLinkInfos addObject:dic_find];
            break;
          }
        }
      }
    }
    else {
      //只有一个匹配符号
      NSArray *arr_ranges = [FGUtils getRangesFromString:str findText:arr_matchPatternKeys[0] specailKeys:matchPatterns];
      if (arr_ranges.count > 0) {
        for (id obj_range in arr_ranges) {
          NSRange range = NSRangeFromString(obj_range);
          NSRange range_new = NSMakeRange(range.location, range.length+1);
          NSLog(@"11111range_new==%@", NSStringFromRange(range_new));
          //          [mas addAttribute:NSForegroundColorAttributeName value:color range:range_new];
          
          
          //遍历info项目
          NSArray *arr_infos = dic_matchPattern[@"infos"];
          for (NSDictionary *dic_info in arr_infos) {
            NSString *str_sub = [str substringWithRange:NSMakeRange(range_new.location, range_new.length)];
            NSString *str_content = dic_info[@"content"];
            NSRange range_match = [str_sub rangeOfString:str_content];
            if (range_match.location != NSNotFound){
              NSDictionary* dic_find = @{@"range":NSStringFromRange(range_new),@"content":str_content,@"link":dic_info[@"link"], @"keys":arr_matchPatternKeys,@"linkPrefix":dic_matchPattern[@"linkPrefix"]};
              NSLog(@"dic_find==%@", dic_find);
              [marr_specialLinkInfos addObject:dic_find];
              break;
            }
          }
        }
      }
    }
  }
  
  //range排序
  for (int i = 0; i < marr_specialLinkInfos.count; i++) {
    NSDictionary *dic_i = marr_specialLinkInfos[i];
    for (int j = i+1; j < marr_specialLinkInfos.count; j++) {
      NSDictionary *dic_j = marr_specialLinkInfos[j];
      NSRange range_i = NSRangeFromString(dic_i[@"range"]);
      NSRange range_j = NSRangeFromString(dic_j[@"range"]);
      if (range_i.location > range_j.location) {
        [marr_specialLinkInfos exchangeObjectAtIndex:i withObjectAtIndex:j];
      }
    }
  }
  
//  mstr_ret
//  替换字符串
  NSRange range_prev = NSMakeRange(0, 0);
  for (int i =0;i < marr_specialLinkInfos.count;i++) {
    NSDictionary *dic_info = marr_specialLinkInfos[i];
    NSArray *arr_keys = dic_info[@"keys"];
    NSRange range_i = NSRangeFromString(dic_info[@"range"]);
    if (i == 0 && range_i.location != 0) {
      NSString *str_tmp = [str substringToIndex:range_i.location];
      [mstr_ret appendString:str_tmp];
      
      NSString *str_sub = dic_info[@"content"];
      NSString *str_htmlLink;
      if (arr_keys.count > 1) {
        str_htmlLink = [NSString stringWithFormat:@"<a href=\"%@%@\">%@%@%@</a>",dic_info[@"linkPrefix"],dic_info[@"link"],arr_keys[0],str_sub,arr_keys[1]];
      }
      else {
        str_htmlLink = [NSString stringWithFormat:@"<a href=\"%@%@\">%@%@</a>",dic_info[@"linkPrefix"],dic_info[@"link"],arr_keys[0] ,str_sub];
      }
      [mstr_ret appendString:str_htmlLink];
      ;
    }
    else {
      //如果range_i.location > range_prev.location+range.prev+length需要截取字符串
      if (range_i.location > range_prev.location+range_prev.length) {
        NSString *str_sub = [str substringWithRange:NSMakeRange(range_prev.location+range_prev.length, range_i.location - (range_prev.location+range_prev.length))];
        [mstr_ret appendString:str_sub];
        
        str_sub = dic_info[@"content"];
        NSString *str_htmlLink;
        if (arr_keys.count > 1) {
          str_htmlLink = [NSString stringWithFormat:@"<a href=\"%@%@\">%@%@%@</a>",dic_info[@"linkPrefix"],dic_info[@"link"],arr_keys[0],str_sub,arr_keys[1]];
        }
        else {
          str_htmlLink = [NSString stringWithFormat:@"<a href=\"%@%@\">%@%@</a>",dic_info[@"linkPrefix"],dic_info[@"link"],arr_keys[0] ,str_sub];
        }
        [mstr_ret appendString:str_htmlLink];
      }
      else {
        NSString *str_sub = dic_info[@"content"];
        NSString *str_htmlLink;
        if (arr_keys.count > 1) {
          str_htmlLink = [NSString stringWithFormat:@"<a href=\"%@%@\">%@%@%@</a>",dic_info[@"linkPrefix"],dic_info[@"link"],arr_keys[0],str_sub,arr_keys[1]];
        }
        else {
          str_htmlLink = [NSString stringWithFormat:@"<a href=\"%@%@\">%@%@</a>",dic_info[@"linkPrefix"],dic_info[@"link"],arr_keys[0] ,str_sub];
        }
        
        [mstr_ret appendString:str_htmlLink];
      }
    }
    range_prev = range_i;
  }
  
  //最后还需要判断range_prev是否是最后了
  if (range_prev.location + range_prev.length < str.length) {
    NSString *str_tmp = [str substringFromIndex:range_prev.location+range_prev.length];
    [mstr_ret appendString:str_tmp];
  }
//  NSLog(@"marr_specialLinkInfos==%@", marr_specialLinkInfos);
  NSLog(@"mstr_rect==%@", mstr_ret);
  return mstr_ret;
}

+ (NSString *)findValueWithKey:(NSString *)key inArray:(NSArray *)originalArr {
  if (key == nil || originalArr == nil) {
    return @"";
  }
  
  for (NSDictionary *dic_info in originalArr) {
    NSString *str_key = dic_info[key];
    if (str_key != nil) {
      return str_key;
    }
  }
  
  return @"";
}

+ (NSArray *)tmpArray {
  return @[@{@"aaa":@"2123"},
           @{@"bbb":@"1234"},
           @{@"ccc":@"3432"}];
}

+ (NSString *)limitWithString:(NSString *)content maxLength:(NSInteger)length {
  NSInteger maxLength = length;
  NSString * str_ret = content;
  if (str_ret.length > maxLength) {
    NSString *str_subContent = [str_ret substringToIndex:maxLength];
    str_ret = [str_subContent stringByAppendingString:@"..."];
  }
  
  return str_ret;
}

#pragma mark - 保存搜索关键字
+ (void)saveSeachKeyWithString:(NSString *)_str_key {
  NSMutableArray *_marr_keys = nil;
  NSMutableArray *_marr_keys_new = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]];
  if (ISNULLObj(_str_key))
    return;
  
  if (ISNULLObj([FGUtils searchKeys])) {
    _marr_keys = [NSMutableArray array];
  } else {
    _marr_keys = [NSMutableArray arrayWithArray:[FGUtils searchKeys]];
  }
  
  for (int i = 1,j = 0; i < _marr_keys.count && i < 10; i++, j++) {
    [_marr_keys_new replaceObjectAtIndex:i withObject:_marr_keys[j]];
  }
  [_marr_keys_new replaceObjectAtIndex:0 withObject:_str_key];
  
  [commond setUserDefaults:_marr_keys_new forKey:SEARCHKEY];
}

+ (NSArray *)searchKeys {
  if (ISNULLObj([commond getUserDefaults:SEARCHKEY]))
    return nil;
  
  NSArray *_arr_tmp = (NSArray *)[commond getUserDefaults:SEARCHKEY];
  NSSet *set = [NSSet setWithArray:_arr_tmp];
  
  return [set allObjects];
}


+ (NSDictionary *)infoFromArray:(NSArray *)_arr_info withKey:(NSString *)_key{
  __block NSDictionary *_dic_ret = @{};
  [_arr_info enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSDictionary *_dic = (NSDictionary *)obj;
    if ([_dic[@"ResponseName"] isEqualToString:_key]) {
      _dic_ret = _dic;
      *stop = YES;
    }
  }];
  return _dic_ret;
}

#pragma mark - 去除号码格式
+ (NSString *)formatPhoneNumber:(NSString*)number
{
  number = [number stringByReplacingOccurrencesOfString:@"-"withString:@""];
  number = [number stringByReplacingOccurrencesOfString:@" "withString:@""];
  number = [number stringByReplacingOccurrencesOfString:@"("withString:@""];
  number = [number stringByReplacingOccurrencesOfString:@")"withString:@""];
  number = [number stringByReplacingOccurrencesOfString:@" "withString:@""];
  
  NSInteger len = number.length;
  if (len < 6)
  {
    return number;
  }
  
  if ([[number substringToIndex:2] isEqualToString:@"86"])
  {
    number = [number substringFromIndex:2];
  }
  else if ([[number substringToIndex:3] isEqualToString:@"+86"])
  {
    number = [number substringFromIndex:3];
  }
  else if ([[number substringToIndex:4]isEqualToString:@"0086"])
  {
    number = [number substringFromIndex:4];
  }
  else if ([[number substringToIndex:5]isEqualToString:@"12593"])
  {
    number = [number substringFromIndex:5];
  }
  else if ([[number substringToIndex:5]isEqualToString:@"17951"])
  {
    number = [number substringFromIndex:5];
  }
  else if (len == 16 && [[number substringToIndex:6] isEqualToString:@"125201"])
  {
    number = [number substringFromIndex:5];
  }
  
  return number;
}

#pragma mark - cell工具
+ (CGFloat)calculateCellHeightByDynamicView:(UIView *)_view originalCellHeight:(CGFloat)_originalCellHeight originalLabelFrame:(CGRect)_originalLabelFrame
                originalVideoContainerFrame:(CGRect)_originalVideoContainerFrame{
  
  CGFloat videoContainerHeight = 180 * ratioW / 1.33;//高度是根据宽度 4:3 的比例得到的
  CGFloat cellHeight = (_originalCellHeight - _originalLabelFrame.size.height - _originalVideoContainerFrame.size.height) * ratioH + _view.frame.size.height + videoContainerHeight + 15 * ratioH;
  
  
  return cellHeight;
}

#pragma mark - 利用一个已经临时的UILabel 来计算 table中 带可变高度UILabel的cellview的总高度
+ (CGFloat)calculateCellHeightByDynamicView:(UIView *)_view originalCellHeight:(CGFloat)_originalCellHeight originalLabelFrame:(CGRect)_originalLabelFrame
                    originalCollectionFrame:(CGRect)_originalCollectionFrame collectionImagesCount:(NSInteger)_collectionImagesCount{
  
    float cellWidth = CollectionWidth / (float)_collectionImagesCount;
    cellWidth = _collectionImagesCount == 1 ? CollectionWidth * 0.8f : cellWidth;//略微缩小1张图的 大小
    
    CGFloat collecionCellHeight =  cellWidth;
    
    CGFloat cellHeight = (_originalCellHeight - _originalLabelFrame.size.height - _originalCollectionFrame.size.height) * ratioH + _view.frame.size.height + collecionCellHeight + 15 * ratioH;
  return cellHeight;
}

#pragma mark - 计算数组中最大值和最小值
+ (void)sortedGetMaxMinWithArray:(NSArray *)arr_sort max:(CGFloat *)max min:(CGFloat*)min {
  NSArray *sortedValues = [arr_sort sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    return [obj1 compare:obj2];
  }];
  CGFloat flt_min = [[sortedValues objectAtIndex:0] floatValue];
  CGFloat flt_max = [[sortedValues lastObject]      floatValue];
  
  *max = flt_max;
  *min = flt_min;
}

#pragma mark - 判断数据是否正确
+ (BOOL)isErrorFromResponseInfo:(NSDictionary *)_dic_info withTableView:(UITableView *)_tableView {
  NSInteger _int_code = [_dic_info[@"Code"] integerValue];
  if (_int_code != 0) {
    [_tableView reloadData];
    [_tableView.mj_header endRefreshing];
    return YES;
  }
  return NO;
}

#pragma mark - 刷新tableview底部加载
+ (void)refreshWithTableView:(UITableView *)_tableView footerWithActivityStatus:(BOOL)_bool_activity {
  [_tableView allowedShowActivityAtFooter:_bool_activity];
  [_tableView.refreshFooter endRefreshing];
}

+ (void)refreshheaderWithTableView:(UITableView *)_tableView{
  [_tableView.mj_header endRefreshing];
}

#pragma mark - 刷新tableview某一行
+ (void)reloadCellWithTableView:(UITableView *)_tb atIndex:(NSInteger)_int_idx {
//  UITableView *_tb = _tb;
  NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForItem:_int_idx inSection:0];
  [_tb reloadRowsAtIndexPaths:@[tmpIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

+ (void)reloadCellWithTableView:(UITableView *)_tb atSection:(NSInteger)_int_section atIndex:(NSInteger)_int_idx {
  //  UITableView *_tb = _tb;
  NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForItem:_int_idx inSection:_int_section];
  [_tb reloadRowsAtIndexPaths:@[tmpIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

+ (NSData *)getBlurEffectWithImage:(UIImage *)_img {
  UIImage *_img_tmp = [_img imageCompressForTargetWidth:320 * ratioW];
  UIImage *blurImage = [_img_tmp blurEffectUseGPUImageWithBlurLevel:0.15];
  NSData *_data_img = UIImagePNGRepresentation(blurImage);//UIImageJPEGRepresentation(blurImage, 0.8);
  return _data_img;
}

+ (NSString *)getCityNameWithString:(NSString *)_str_cities {
//  NSString *_str_cityNames = [_str_cityAll componentsSeparatedByString:@"-"][0];
//  _str_cityNames = [_str_cityNames stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  
  NSString *_str_cityAll = _str_cities;
  NSString *_str_cityNames = [_str_cityAll componentsSeparatedByString:@"-"][0];
  _str_cityNames = [_str_cityNames stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  
  
  NSRange _range = [_str_cityNames rangeOfString:@" " options:NSBackwardsSearch];
  NSString *_str_city = @"";
  NSLog(@"_str_cityAll==%@",_str_cityAll);
  if ([commond isChinese]) {
    _str_city = [_str_cityNames substringFromIndex:_range.location+1];
  }
  else {
    _str_city = [_str_cityNames substringToIndex:_range.location];
  }
  
  return [_str_city trimmingWhitespace];
}

+ (NSString *)getCityNameWithId:(NSString *)_str_cityId {
  if ([_str_cityId isEmptyStr])
    return @"";
  
  NSString *_str_path = [[NSBundle mainBundle] pathForResource:@"countrylist" ofType:@"json"];
  NSError *error = nil;
  NSString* _str_tmp = [NSString stringWithContentsOfFile:_str_path encoding:NSUTF8StringEncoding error:&error];
  NSArray *_arr_tmp = [_str_tmp objectFromJSONString];
  __block NSInteger _int_cityIndex;
  [_arr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSString *_str_cityAll = [NSString stringWithFormat:@"%@", obj];
    NSString *_str_cityCode = [_str_cityAll componentsSeparatedByString:@"-"][1];
    if ([_str_cityAll rangeOfString:_str_cityId].location != NSNotFound) {
      _int_cityIndex = idx;
      *stop = YES;
    }
  }];
  
  NSString *_str_cityAll = [_arr_tmp objectAtIndex:_int_cityIndex];
//  NSString *_str_cityNames = [_str_cityAll componentsSeparatedByString:@"-"][0];
//  _str_cityNames = [_str_cityNames stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  
  return [FGUtils getCityNameWithString:_str_cityAll];
}

+ (NSString *)getCityIdWithName:(NSString *)_str_name {
  if ([_str_name isEmptyStr])
    return @"";
  
  NSString *_str_path = [[NSBundle mainBundle] pathForResource:@"countrylist" ofType:@"json"];
  NSError *error = nil;
  NSString* _str_tmp = [NSString stringWithContentsOfFile:_str_path encoding:NSUTF8StringEncoding error:&error];
  NSArray *_arr_tmp = [_str_tmp objectFromJSONString];
  __block NSInteger _int_cityIndex;
  [_arr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSString *_str_cityAll = [NSString stringWithFormat:@"%@", obj];
    if ([_str_cityAll rangeOfString:_str_name].location != NSNotFound){
      _int_cityIndex = idx;
      *stop = YES;
    }
  }];
  
  NSString *_str_cityAll = [_arr_tmp objectAtIndex:_int_cityIndex];
  NSString *_str_cityCode = [_str_cityAll componentsSeparatedByString:@"-"][1];
  _str_cityCode = [_str_cityCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  
  return _str_cityCode;
}

+ (NSDictionary *)getUserDefaultAvatarInfo {
  NSLog(@"BLURBG==%@", [FGUtils pathInDocumentsWithPNG:USERAVATARBLURBGDEFAULT]);
  NSLog(@"ICON==%@", [FGUtils pathInDocumentsWithPNG:USERAVATARDEFAULT]);

  UIImage *_img_placeholer = IMAGEWITHPATH([FGUtils pathInDocumentsWithPNG:USERAVATARBLURBGDEFAULT]);
  UIImage *_img_userAvatar = IMAGEWITHPATH([FGUtils pathInDocumentsWithPNG:USERAVATARDEFAULT]);
  
#ifdef USELOCALDEFAULTBGIMAGE
  if ([commond isUser])
    _img_placeholer = IMGWITHNAME(@"Bannerprofile_user");
  else
    _img_placeholer = IMGWITHNAME(@"Bannerprofile_Coach1");
#else
  ;
#endif
  
  
  NSDictionary *_dic_info = @{
                              @"img" : _img_userAvatar,
                              @"imgbg": _img_placeholer,
                              @"isDownloadAvatar": @NO
                              };
  return _dic_info;
}

+ (NSDictionary *)getUserAvatarInfo {
  NSLog(@"BLURBG==%@", [FGUtils pathInDocumentsWithPNG:USERAVATARBLURBG]);
  NSLog(@"ICON==%@", [FGUtils pathInDocumentsWithPNG:USERAVATAR]);
  
  [FGUtils internalInitalUserAvatar];
  
  UIImage *_img_placeholer = IMAGEWITHPATH([FGUtils pathInDocumentsWithPNG:USERAVATARBLURBG]);
  UIImage *_img_userAvatar = IMAGEWITHPATH([FGUtils pathInDocumentsWithPNG:USERAVATAR]);
  
#ifdef USELOCALDEFAULTBGIMAGE
  if ([commond isUser])
    _img_placeholer = IMGWITHNAME(@"Bannerprofile_user");
  else
    _img_placeholer = IMGWITHNAME(@"Bannerprofile_Coach1");
#else
  ;
#endif
  
  
  NSDictionary *_dic_info = @{
                              @"img" : _img_userAvatar,
                              @"imgbg": _img_placeholer
                              };
  return _dic_info;
}

+ (NSDictionary *)getUserAvatarInfoWithType:(BOOL)_bool_isUser {
  NSLog(@"BLURBG==%@", [FGUtils pathInDocumentsWithPNG:USERAVATARBLURBG]);
  NSLog(@"ICON==%@", [FGUtils pathInDocumentsWithPNG:USERAVATAR]);
  
  [FGUtils internalInitalUserAvatar];
  UIImage *_img_placeholer;// = IMAGEWITHPATH([FGUtils pathInDocumentsWithPNG:USERAVATARBLURBG]);
  UIImage *_img_userAvatar = IMAGEWITHPATH([FGUtils pathInDocumentsWithPNG:USERAVATAR]);
  
#ifdef USELOCALDEFAULTBGIMAGE
  if (_bool_isUser)
    _img_placeholer = IMGWITHNAME(@"Bannerprofile_user");
  else
    _img_placeholer = IMGWITHNAME(@"Bannerprofile_Coach1");
#else
  _img_placeholer = IMAGEWITHPATH([FGUtils pathInDocumentsWithPNG:USERAVATARBLURBG]);
#endif
  
  NSDictionary *_dic_info = @{
                              @"img" : _img_userAvatar,
                              @"imgbg": _img_placeholer,
                              @"isDownloadAvatar": @NO
                              };
  return _dic_info;
}

+ (UIImage *)getUserBgImageUseType {
  if ([commond isUser])
    return [self getUserBgImage];
  
  return [self getTrainerBgImage];
}

+ (UIImage *)getUserBgImage{
  UIImage *_img_placeholer;
  _img_placeholer = IMGWITHNAME(@"Bannerprofile_user");
  return _img_placeholer;
}

+ (UIImage *)getTrainerBgImage{
  UIImage *_img_placeholer;
  _img_placeholer = IMGWITHNAME(@"Bannerprofile_Coach1");
  
  return _img_placeholer;
}


+(void)internalInitalUserAvatar {
  UIImage *_img_placeholer = IMAGEWITHPATH([FGUtils pathInDocumentsWithPNG:USERAVATARBLURBG]);
  UIImage *_img_userAvatar = IMAGEWITHPATH([FGUtils pathInDocumentsWithPNG:USERAVATAR]);
  
  if (ISNULLObj(_img_placeholer) ||
      ISNULLObj(_img_userAvatar))
  {
    NSString *_str_path = [[NSBundle mainBundle] pathForResource:@"ic_user_default" ofType:AVATARTYPE];
    NSData *_data_img = [NSData dataWithContentsOfFile:_str_path];
    [FGUtils saveDocumentsFilePNGWithName:USERAVATAR fileData:_data_img];
    [FGUtils saveDocumentsFilePNGWithName:USERAVATARDEFAULT fileData:_data_img];
    NSString *_str_filePath = [FGUtils pathInDocumentsWithFileName:[NSString stringWithFormat:@"%@.%@",USERAVATAR, AVATARTYPE]];
    
    _str_path = [[NSBundle mainBundle] pathForResource:USERAVATARBLURBG ofType:AVATARTYPE];
    _data_img = [NSData dataWithContentsOfFile:_str_path];
    [FGUtils saveDocumentsFilePNGWithName:USERAVATARBLURBG fileData:_data_img];
    [FGUtils saveDocumentsFilePNGWithName:USERAVATARBLURBGDEFAULT fileData:_data_img];
    _str_filePath = [FGUtils pathInDocumentsWithPNG:USERAVATARBLURBG];
    
    [commond setUserDefaults:[NSNumber numberWithBool:YES] forKey:@"isInit"];
  }
}

+ (void)saveUserAvatarWithUrlString:(NSString *)_str_url {
  NSString *imageString = _str_url;//[NSString stringWithFormat:@"%@",_dic_qqInfo[@"figureurl_qq_2"]];//用户头像
  NSURL *url = [[NSURL alloc] initWithString:imageString];
  NSData *_data_img =[[NSData alloc] initWithContentsOfURL:url];
  UIImage *_img_avatar = [[UIImage alloc] initWithData:_data_img];
  
  [FGUtils saveDocumentsFilePNGWithName:USERAVATAR fileData:_data_img];
  [FGUtils saveDocumentsFilePNGWithName:USERAVATARBLURBG fileData:[FGUtils getBlurEffectWithImage:_img_avatar]];
}

+ (NSData *)getDataWithImage:(UIImage *)_img {
  NSData *data;
  if (UIImagePNGRepresentation(_img) == nil)
  {
    data = UIImageJPEGRepresentation(_img, 1.0);
  }
  else
  {
    data = UIImagePNGRepresentation(_img);
  }
  return data;
}

+ (UIView *)getToolbarViewWithSize:(CGSize)_size {
  UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _size.width, _size.height)];
  toolbar.barStyle = UIBarStyleBlack;
  toolbar.alpha = 1.0f;
  return toolbar;
}

+ (UIView *)getBlackBgViewWithSize:(CGSize)_size withAlpha:(CGFloat)_flt_alpha{
  UIView *_view_bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _size.width, _size.height)];
  _view_bg.backgroundColor = [UIColor blackColor];
  _view_bg.alpha = _flt_alpha;
  return _view_bg;
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
+ (NSString *)logDic:(NSDictionary *)dic {
  if (![dic count]) {
    return nil;
  }
  NSString *tempStr1 =
  [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                               withString:@"\\U"];
  NSString *tempStr2 =
  [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
  NSString *tempStr3 =
  [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
  NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
  NSString *str =
  [NSPropertyListSerialization propertyListFromData:tempData
                                   mutabilityOption:NSPropertyListImmutable
                                             format:NULL
                                   errorDescription:NULL];
  return str;
}

#pragma mark - 推送注册，注销方法
+ (void)jpush_registerAlias:(NSString *)_str_alias {
  // 设置推送别名
  [JPUSHService setTags:nil alias:[NSString stringWithFormat:@"csp%@",_str_alias] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
  }];
}

+ (void)jpush_resignAlias {
  // 设置推送别名,解除之前绑定
  [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags , iAlias);
  }];
}
@end

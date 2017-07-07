//
//  commond.m
//  Kline
//
//  Created by zhaomingxi on 14-2-11.
//  Copyright (c) 2014年 zhaomingxi. All rights reserved.
//
#import "ZJProgressHUD.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netinet/in.h>
#import "commond.h"
#import <CommonCrypto/CommonDigest.h>
#import "PQFCustomLoaders.h"
#import "UIColor+FlatColors.h"
#import "FGPhotoVideoGallery.h"
#import "FGCustomAlertView+Util.h"
//#import "Global.h"
CGSize getScreenSize() {
  CGSize screenSize = [UIScreen mainScreen].bounds.size;
  if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) &&
      UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
    return CGSizeMake(screenSize.height, screenSize.width);
  }
  return screenSize;
}

MBProgressHUD *HUD;
UIImageView *iv_indicator;
PQFBouncingBalls *bouncingBalls;
FGPhotoVideoGallery *view_photoGallery;
MMMaterialDesignSpinner *spinnerView;
static AVPlayer *player_public;
static AVPlayerLayer *playerLayer_public;
FGPopupViewController *vc_location_requesteSended;
 NSMutableArray *arr_reportContents;

@implementation commond

+(id)getJsonObjectFromJsonString:(NSString *)_str_json
{
    return [NSJSONSerialization JSONObjectWithData:[_str_json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}

+(NSString *)getJsonStringFromJsonObject:(id)_obj
{
    NSData *_jsonData = [NSJSONSerialization dataWithJSONObject:_obj options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:_jsonData encoding:NSUTF8StringEncoding];
}

+(NSData *)getJsonDataFromJsonObject:(id)_obj
{
    return [NSJSONSerialization dataWithJSONObject:_obj options:NSJSONWritingPrettyPrinted error:nil];
}

+ (void)showLoadingWithCustomView:(NSString *)imgName number:(NSInteger)number {
  //  // FIXME: 先return
  //  return;
  dispatch_async(dispatch_get_main_queue(), ^{
    if (!iv_indicator) {
      iv_indicator             = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@1.png", imgName]]];
      iv_indicator.bounds      = CGRectMake(0, 0, iv_indicator.image.size.width / 2, iv_indicator.image.size.height / 2);
      NSMutableArray *arr_imgs = [NSMutableArray array];
      for (int i = 0; i < number; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d.png", imgName, i + 1]];
        [arr_imgs addObject:img];
      }
      iv_indicator.animationImages      = arr_imgs;
      iv_indicator.animationDuration    = 1;
      iv_indicator.animationRepeatCount = 0;
    }
    [iv_indicator startAnimating];
    HUD            = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:NO];
    HUD.customView = iv_indicator;

    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
  });
}

+ (void)showLoadingInView:(UIView *)_parentView {
   /* if(bouncingBalls)
        return;
  
    dispatch_async(dispatch_get_main_queue(), ^{
      if(bouncingBalls)
        return;
      
        bouncingBalls = [[PQFBouncingBalls alloc] initLoaderOnView:_parentView];
        bouncingBalls.center = CGPointMake(W/2, H/2);
        //      bouncingBalls.label.text = multiLanguage(@"LOADING...");
        bouncingBalls.label.font = font(FONT_TEXT_BOLD, 16);
        bouncingBalls.backgroundColor = [UIColor clearColor];
        
        bouncingBalls.loaderColor = color_red_panel;
        [bouncingBalls show];
        bouncingBalls.label.textColor = bouncingBalls.loaderColor;
        
        HUD            = [MBProgressHUD showHUDAddedTo:_parentView animated:NO];
        HUD.customView = bouncingBalls;
        
        // Set custom view mode
        HUD.mode = MBProgressHUDModeCustomView;
    });*/
    
    if(spinnerView)
        return;
    
    spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    // Set the line width of the spinner
    spinnerView.lineWidth = 2.0f;
    // Set the tint color of the spinner
    spinnerView.tintColor = color_red_panel;
    
    HUD            = [MBProgressHUD showHUDAddedTo:_parentView animated:NO];
   
    HUD.customView = spinnerView;
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    
    [_parentView addSubview:spinnerView];
    
    [spinnerView startAnimating];
}

+ (void)showLoading {
    [commond showLoadingInView:appDelegate.window];
}

+ (void)removeLoading {
  dispatch_async(dispatch_get_main_queue(), ^{
   /* if (bouncingBalls != nil){
        [bouncingBalls remove];
        SAFE_RemoveSupreView(bouncingBalls);
      bouncingBalls = nil;
  }*/
    if(HUD != nil)
    {
    [HUD hide:YES];
    HUD = nil;
        [spinnerView stopAnimating];
    SAFE_RemoveSupreView(spinnerView);
    spinnerView = nil;
    }
    
    
  });
      
      
}

/*将20131123字符串转换为year:2013 month:11 day:23的字典*/
+ (NSMutableDictionary *)splitDateStringByYYYYMMDD:(NSString *)_str_date {
  if (!_str_date)
    return nil;
  if ([@"" isEqualToString:_str_date])
    return nil;
  if ([_str_date intValue] == NAN)
    return nil;
  if ([_str_date length] != 8)
    return nil;

  NSString *str_year               = [_str_date substringWithRange:NSMakeRange(0, 4)];
  NSString *str_month              = [_str_date substringWithRange:NSMakeRange(4, 2)];
  NSString *str_day                = [_str_date substringWithRange:NSMakeRange(6, 2)];
  NSMutableDictionary *_dic_retVal = [NSMutableDictionary dictionaryWithCapacity:3];
  [_dic_retVal setObject:str_year forKey:@"year"];
  [_dic_retVal setObject:str_month forKey:@"month"];
  [_dic_retVal setObject:str_day forKey:@"day"];
  return _dic_retVal;
}

/*将180620字符串转换为hours:18 minutes:06 seconds:20*/
+ (NSMutableDictionary *)splitTimeStringByHHMMSS:(NSString *)_str_timestamp {
  if (!_str_timestamp)
    return nil;
  if ([@"" isEqualToString:_str_timestamp])
    return nil;
  if ([_str_timestamp intValue] == NAN)
    return nil;
  if ([_str_timestamp length] < 5 || [_str_timestamp length] > 6)
    return nil;

  NSInteger strLen      = [_str_timestamp length];
  NSString *str_ms      = [_str_timestamp substringWithRange:NSMakeRange(strLen - 2, 2)];
  NSString *str_minutes = [_str_timestamp substringWithRange:NSMakeRange(strLen - 4, 2)];
  NSInteger hourCount   = 0;
  if (strLen == 5)
    hourCount = 1;
  else if (strLen == 6)
    hourCount         = 2;
  NSString *str_hours = [_str_timestamp substringWithRange:NSMakeRange(strLen - 4 - hourCount, hourCount)];

  NSMutableDictionary *_dic_retVal = [NSMutableDictionary dictionaryWithCapacity:3];
  [_dic_retVal setObject:str_hours forKey:@"hours"];
  [_dic_retVal setObject:str_minutes forKey:@"minutes"];
  [_dic_retVal setObject:str_ms forKey:@"seconds"];

  return _dic_retVal;
}

+ (NSString *)meterToKMIfNeeded:(int)_meters {
  NSString *ret = nil;
  if (_meters / 1000 >= 1) {
    CGFloat km = (CGFloat)_meters / 1000.0f;
    ret        = [NSString stringWithFormat:@"%.1f %@", km, multiLanguage(@"km")];
  } else {
    ret = [NSString stringWithFormat:@"%d %@", _meters, multiLanguage(@"m")];
  }

  return ret;
}

+ (NSString *)numberToString:(NSNumber *)_number {
  if (!_number)
    return nil;
  if (![_number isKindOfClass:[NSNumber class]])
    return nil;

  return [NSString stringWithFormat:@"%@", _number];
}

#pragma mark 字符串转换为日期时间对象
+ (NSDate *)dateFromString:(NSString *)str {
  // 创建一个时间格式化对象
  NSDateFormatter *datef = [[NSDateFormatter alloc] init];
  // 设定时间的格式
  [datef setDateFormat:@"yyyy-MM-dd"];
  // 将字符串转换为时间对象
  NSDate *tempDate = [datef dateFromString:str];
  return tempDate;
}



+ (NSDate *)dateFromString:(NSString *)str formatter:(NSString *)_str_formatter {
    // 创建一个时间格式化对象
    NSDateFormatter *datef = [[NSDateFormatter alloc] init];
    // 设定时间的格式
    [datef setDateFormat:_str_formatter];
    // 将字符串转换为时间对象
    NSDate *tempDate = [datef dateFromString:str];
    return tempDate;
}

+ (NSString *)stringFromDate:(NSDate *)date {
  // 创建一个时间格式化对象
  NSDateFormatter *datef = [[NSDateFormatter alloc] init];
  // 设定时间的格式
  [datef setDateFormat:@"HH:mm:ss"];
  // 将字符串转换为时间对象
  return [datef stringFromDate:date];
}

+ (NSString *)dateStringBySince1970:(long)_timeStamp {
    return [commond dateStringBySince1970:_timeStamp dateFormat:@"yyyy年MM月dd日"];
}

+ (NSString *)dateStringBySince1970:(long)_timeStamp dateFormat:(NSString *)_str_dateFormat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_timeStamp];
    // 创建一个时间格式化对象
    NSDateFormatter *datef = [[NSDateFormatter alloc] init];
    // 设定时间的格式
    [datef setDateFormat:_str_dateFormat];
    NSString *retval = [datef stringFromDate:date];
    return retval;
}


+ (NSString *)numberMinDigitsFormatter:(int)_minIntegerDigits num:(int)_num {
  NSNumberFormatter *numberFormatter   = [[NSNumberFormatter alloc] init];
  numberFormatter.minimumIntegerDigits = _minIntegerDigits;
  [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
  NSString *str_num = [numberFormatter stringFromNumber:[NSNumber numberWithInt:_num]];
  numberFormatter   = nil;
  return str_num;
}

+(NSString *)numberCountFormatByCount:(NSInteger)_count
{
    switch (_count) {
            
        case 1:
            if([commond isChinese])
                return @"第一";
            else
                return @"1St";
            
        case 2:
            if([commond isChinese])
                return @"第二";
            else
                return @"2nd";
            
        case 3:
            if([commond isChinese])
                return @"第三";
            else
                return @"3rd";
            
        case 4:
            if([commond isChinese])
                return @"第四";
            else
                return @"4th";
            
        case 5:
            if([commond isChinese])
                return @"第五";
            else
                return @"5th";
            
        case 6:
            if([commond isChinese])
                return @"第六";
            else
                return @"6th";
            
        case 7:
            if([commond isChinese])
                return @"第七";
            else
                return @"7th";
    }
    return nil;
}

/*
 将秒钟数 转换成 时钟格式字符串 01:59:59 或 03:00
 */
+ (NSString *)clockFormatBySeconds:(NSInteger)_sec {
  NSString *_str_retval = nil;

  NSInteger sec                        = _sec % 60;
  NSInteger min                        = (_sec % 3600) / 60;
  NSInteger hour                       = _sec / 60 / 60;
  NSNumberFormatter *numberFormatter   = [[NSNumberFormatter alloc] init];
  numberFormatter.minimumIntegerDigits = 2;
  [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
  NSString *str_hour = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:hour]];
  NSString *str_min  = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:min]];
  NSString *str_sec  = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:sec]];
  if (hour == 0)
    _str_retval = [NSString stringWithFormat:@"%@:%@", str_min, str_sec];
  else
    _str_retval   = [NSString stringWithFormat:@"%@:%@:%@", str_hour, str_min, str_sec];
  numberFormatter = nil;
  return _str_retval;
}

+ (NSString *)clockFormatByMicroSeconds:(NSTimeInterval)_microSecs {
  NSString *_str_retval  = nil;
  NSString *_str_hhmmss  = [commond clockFormatBySeconds:(NSInteger)_microSecs];
  NSTimeInterval digital = _microSecs - (NSInteger)_microSecs;
  _str_retval            = [NSString stringWithFormat:@"%@.%02ld", _str_hhmmss, (NSInteger)(digital * 100.0f)];
  return _str_retval;
}

/*
 _str_timeFormat 必须是 小时:分钟:秒钟 或者  分钟:秒钟 的格式
 */
+ (NSInteger)secondsByClockFormat:(NSString *)_str_timeFormat {
  NSInteger secs     = -1;
  NSArray *_arr_nums = [_str_timeFormat componentsSeparatedByString:@":"];
  if (!_arr_nums)
    return secs;
  if ([_arr_nums count] <= 0)
    return secs;

  if ([_arr_nums count] == 2) {
    NSInteger _mins = [[_arr_nums objectAtIndex:0] integerValue];
    NSInteger _secs = [[_arr_nums objectAtIndex:1] integerValue];

    secs = _mins * 60 + _secs;
    return secs;
  } else if ([_arr_nums count] == 3) {
    NSInteger _hours = [[_arr_nums objectAtIndex:0] integerValue];
    NSInteger _mins  = [[_arr_nums objectAtIndex:1] integerValue];
    NSInteger _secs  = [[_arr_nums objectAtIndex:2] integerValue];

    secs = _hours * 3600 + _mins * 60 + _secs;
    return secs;
  }

  return secs;
}

+ (void)setTextField:(UITextField *)_textField placeHolderFont:(UIFont *)_font placeHolderColor:(UIColor *)_color {
  [_textField setValue:_color forKeyPath:@"_placeholderLabel.textColor"];
  [_textField setValue:_font forKeyPath:@"_placeholderLabel.font"];
}

+ (AVAudioPlayer *)initBackgroundSound:(NSString *)filename loop:(long)loop player:(AVAudioPlayer *)_player type:(NSString *)type {
  NSString *bgSPath = [[NSBundle mainBundle] pathForResource:filename ofType:type inDirectory:@"/"];

  NSURL *url = [[NSURL alloc] initFileURLWithPath:bgSPath];

  _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];

  [_player prepareToPlay];
  //player.delegate = self;
  _player.volume = 1;
  if (loop != 0)
    _player.numberOfLoops = loop;

  return _player;
}

+ (void)initSystemSound:(NSString *)filename type:(NSString *)type tmpID:(SystemSoundID *)__tmpID {
  id sndpath = [[NSBundle mainBundle]
      pathForResource:filename
               ofType:type
          inDirectory:@"/"];
  CFURLRef baseURL = (CFURLRef)CFBridgingRetain([[NSURL alloc] initFileURLWithPath:sndpath]);
  AudioServicesCreateSystemSoundID(baseURL, __tmpID);
}

#pragma mark 时间对象转换为时间字段信息
+ (NSDateComponents *)dateComponentsWithDate:(NSDate *)date {
  if (date == nil) {
    date = [NSDate date];
  }
  // 获取代表公历的Calendar对象
  NSCalendar *calenar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  // 定义一个时间段的旗标，指定将会获取指定的年，月，日，时，分，秒的信息
  unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSCalendarUnitWeekdayOrdinal|NSCalendarUnitWeekday;
  // 获取不同时间字段信息
  NSDateComponents *dateComp = [calenar components:unitFlags fromDate:date];
  return dateComp;
}

+ (bool)isEqualWithFloat:(float)f1 float2:(float)f2 absDelta:(int)absDelta {
  int i1, i2;
  i1 = (f1 > 0) ? ((int)f1) : ((int)f1 - 0x80000000);
  i2 = (f2 > 0) ? ((int)f2) : ((int)f2 - 0x80000000);
  return ((abs(i1 - i2)) < absDelta) ? true : false;
}

+ (NSObject *)getUserDefaults:(NSString *)name {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  return [userDefaults objectForKey:name];
}

+ (void)setUserDefaults:(NSObject *)defaults forKey:(NSString *)key {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:defaults forKey:key];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isEmpty:(id)input {
  if (!input || [[NSNull null] isEqual:input])
    return YES;

  if (![input isKindOfClass:[NSString class]])
    return NO;

  if ([@"<null>" isEqual:input])
    return YES;

  NSString *ret = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if (ret && ![ret isEqualToString:@""])
    return NO;
  else
    return YES;
}

+ (void)dismissKeyboard:(UIView *)view {
  if ([view isKindOfClass:[UITextField class]  ] || [view isKindOfClass:[UITextView class]  ]) {
    [view resignFirstResponder];
  } else {
    for (UIView *subView in view.subviews) {
      [commond dismissKeyboard:subView];
    }
  }
}

+ (void)setTextFieldDelegate:(id<UITextFieldDelegate>)_delegate inView:(UIView *)view {
  if ([view isKindOfClass:[UITextField class]]) {
    UITextField *tf = (UITextField *)view;
    tf.delegate     = _delegate;
  } else {
    for (UIView *subView in view.subviews) {
      [commond setTextFieldDelegate:_delegate inView:subView];
    }
  }
}

+ (void)setTextViewDelegate:(id<UITextViewDelegate>)_delegate inView:(UIView *)view {
    if ([view isKindOfClass:[UITextView class]] && ((UITextView *)view).editable) {
        UITextView *tv = (UITextView *)view;
        tv.delegate     = _delegate;
    } else {
        for (UIView *subView in view.subviews) {
            [commond setTextViewDelegate:_delegate inView:subView];
        }
    }
}

+ (NSString *)stringRemovePercentAndPlus:(NSString *)_str_original {
  _str_original = [_str_original stringByReplacingOccurrencesOfString:@"%" withString:@""];
  _str_original = [_str_original stringByReplacingOccurrencesOfString:@"+" withString:@""];
  return _str_original;
}

+ (void)useRatio:(CGRect)_ratio toScaleView:(UIView *)_view {
  _view.autoresizingMask = UIViewAutoresizingNone;
  CGRect _newFrame       = _view.frame;
  _newFrame.origin.x     = _view.frame.origin.x * _ratio.origin.x;
  _newFrame.origin.y     = _view.frame.origin.y * _ratio.origin.y;
  _newFrame.size.width   = _view.frame.size.width * _ratio.size.width;
  _newFrame.size.height  = _view.frame.size.height * _ratio.size.height;
  _view.frame            = _newFrame;
}

+ (void)useDefaultRatioToScaleView:(UIView *)_view {
    _view.autoresizingMask = UIViewAutoresizingNone; //必须要设为None 因为autoresizingMask会干扰我们自己的缩放
    CGRect _newFrame       = _view.frame;
    _newFrame.origin.x     = _view.frame.origin.x * ratioW;
    _newFrame.origin.y     = _view.frame.origin.y * ratioH;
    _newFrame.size.width   = _view.frame.size.width * ratioW;
    _newFrame.size.height  = _view.frame.size.height * ratioH;
    _view.frame            = _newFrame;
}

+ (CGRect)useDefaultRatioToScaleFrame:(CGRect)_originalFrame {
  CGRect _frameReturn      = CGRectZero;
  _frameReturn.origin.x    = _originalFrame.origin.x * ratioW;
  _frameReturn.origin.y    = _originalFrame.origin.y * ratioH;
  _frameReturn.size.width  = _originalFrame.size.width * ratioW;
  _frameReturn.size.height = _originalFrame.size.height * ratioH;
  return _frameReturn;
}



+ (long)EnCodeCoordinate:(double)para {
  // 度
  //    long temp_para = para*10000000;

  long dCoordinate = (long)para;
  //--
  double dResdiue = para - dCoordinate;
  // 分
  double mCoordinate = (double)(dResdiue * 60);
  dResdiue           = (dResdiue * 60) - mCoordinate; //分的余数

  // 秒
  double sCoordinate = (double)(dResdiue * 60);
  // 毫秒
  double hCorrdinate = (double)(((dResdiue * 60) - sCoordinate) * 1000);

  long result = (dCoordinate * 60 * 60 * 1000) + (mCoordinate * 60 * 1000) + (sCoordinate * 1000) + hCorrdinate;

  return result;
}

/// <summary>
/// 长整转经伟度
/// </summary>
/// <returns></returns>
+ (double)DeCodeCoordinate:(long)totalMilliarcseconds {
  double result;
  double du      = totalMilliarcseconds / (60 * 60 * 1000);                               //度数
  double fen     = (totalMilliarcseconds - du * (60 * 60 * 1000)) / (60 * 1000);          //分
  double miao    = (totalMilliarcseconds - fen * 60 * 1000 - du * 60 * 60 * 1000) / 1000; //秒
  double haomiao = totalMilliarcseconds - miao * 1000 - fen * 60 * 1000 - du * 60 * 60 * 1000;

  double double1 = [[NSString stringWithFormat:@"%.7f", (double)fen / 60] doubleValue];
  double double2 = [[NSString stringWithFormat:@"%.7f", (double)miao / 60 / 6] doubleValue];
  double double3 = [[NSString stringWithFormat:@"%.7f", (double)haomiao / 1000 / 60 / 60] doubleValue];

  result = du + double1 + double2 + double3;
  return result;
}

+ (BOOL)isTAlertAlreadyShowedInWindow {
  UIWindow *window = (UIWindow *)[appDelegate performSelector:@selector(window)];
  for (UIView *_subview in window.subviews) {
    if ([_subview isKindOfClass:[FGCustomAlertView class]]) {
      return YES;
    }
  }
  return NO;
}

+ (void)removeAllAlertViewInWindow {
  UIWindow *window = (UIWindow *)[appDelegate performSelector:@selector(window)];
  for (UIView *_subview in window.subviews) {
    if ([_subview isKindOfClass:[TAlertView class]]) {
      [_subview removeFromSuperview];
    }
  }
}

+ (void)alert:(NSString *)_str_title message:(NSString *)_str_message callback:(void (^)(FGCustomAlertView *alertView, NSInteger buttonIndex))callBackBlock {
  if ([commond isTAlertAlreadyShowedInWindow])
    return;
  /* NSArray * buttons = @[multiLanguage(@"OK")];
    TAlertView *alert = [[TAlertView alloc] initWithTitle:_str_title
                                                  message:_str_message
                                                  buttons:buttons
                                              andCallBack:callBackBlock];
    alert.messageColor = [UIColor blackColor];
    alert.buttonsTextColor = [UIColor blackColor];
    alert.titleFont = font(FONT_NORMAL, 16);
    alert.messageFont = font(FONT_NORMAL, 16);
    alert.buttonsFont =  font(FONT_NORMAL, 16);
    [alert show];*/
  NSArray *buttons = @[ multiLanguage(@"OK") ];

  [commond alertWithButtons:buttons title:_str_title message:_str_message callback:callBackBlock];
}

+ (void)alertWithButtons:(NSArray *)_arr_buttons title:(NSString *)_str_title message:(NSString *)_str_message callback:(void (^)(FGCustomAlertView *alertView, NSInteger buttonIndex))callBackBlock {
  if ([commond isTAlertAlreadyShowedInWindow])
    return;

  FGCustomAlertView *alert = (FGCustomAlertView *)[[[NSBundle mainBundle] loadNibNamed:@"FGCustomAlertView" owner:nil options:nil] objectAtIndex:0];
  [alert setupWithTitle:_str_title message:_str_message buttons:_arr_buttons andCallBack:callBackBlock];
  [alert show];
}

+ (void)alertWithButtons:(NSArray *)_arr_buttons title:(NSString *)_str_title message:(NSString *)_str_message callback:(void (^)(FGCustomAlertView *alertView, NSInteger buttonIndex))callBackBlock dismissWithButtonIndex:(NSInteger)_int_idx{
  if ([commond isTAlertAlreadyShowedInWindow])
    return;
  
  FGCustomAlertView *alert = (FGCustomAlertView *)[[[NSBundle mainBundle] loadNibNamed:@"FGCustomAlertView" owner:nil options:nil] objectAtIndex:0];
  [alert setupWithTitle:_str_title message:_str_message buttons:_arr_buttons andCallBack:callBackBlock dismissWithButtonIndex:_int_idx];
  [alert show];
}

+ (BOOL)saveToKeyChain:(NSString *)_str_username passwd:(NSString *)_str_passwd {
  NSError *error;
  BOOL saved = [SFHFKeychainUtils storeUsername:_str_username andPassword:_str_passwd forServiceName:APP_BUNDLEID updateExisting:YES error:&error];
  if (!saved) {
    NSLog(@"Keychain保存字符时出错：%@", error);
  } else {
    NSLog(@"Keychain保存字符成功！key:%@ value:%@", _str_username, _str_passwd);
  }
  return saved;
}

+ (NSString *)getFromKeyChain:(NSString *)_str_username {
  NSError *error;
  NSString *str_passwd = [SFHFKeychainUtils getPasswordForUsername:_str_username andServiceName:APP_BUNDLEID error:&error];
  if (error || !str_passwd) {
    NSLog(@"从Keychain里获取字符出错：%@", error);
    return nil;
  } else {
    NSLog(@"从Keychain里获取加密字符成功！key:%@ value:%@", _str_username, str_passwd);
    return str_passwd;
  }
}

+ (BOOL)isChinese {
  NSString *_str_language = [commond getCurrentLanguage];
  if ([@"zh-Hans-US" isEqualToString:_str_language] ||
      [@"zh-Hant" isEqualToString:_str_language] ||
      [_str_language rangeOfString:@"zh-Han"].location != NSNotFound) {
    return YES;
  } else
    return NO;
}

+ (NSString *)getCurrentLanguage {
  NSArray *languages        = [NSLocale preferredLanguages];
  NSString *currentLanguage = [languages objectAtIndex:0];
//  NSLog(@"%@", currentLanguage);
  return currentLanguage;
}

+(FGPhotoVideoGallery *)showPhotoVideoGalleryToView:(UIView *)_parentView fromView:(UIView *)_fromView imgs:(NSMutableArray *)_arr_imgurls imgIndex:(NSInteger)_currentImgIndex videoUrl:(NSString *)_str_videoUrl
{
    if(view_photoGallery)
        return nil;
    
    view_photoGallery = (FGPhotoVideoGallery *)[[[NSBundle mainBundle] loadNibNamed:@"FGPhotoVideoGallery" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_photoGallery];
    [_parentView addSubview:view_photoGallery];
    [_parentView bringSubviewToFront:view_photoGallery];
    [commond dismissKeyboard:appDelegate.window];
    CGRect _frame = [_parentView convertRect:_fromView.bounds fromView:_fromView];
    view_photoGallery.rect_showFrom = _frame;
    if(_arr_imgurls && [_arr_imgurls count]>0)
    {
        id obj = [_arr_imgurls objectAtIndex:0];
        if([obj isKindOfClass:[UIImage class]])
        {
             [view_photoGallery setupByImags:_arr_imgurls currentIndex:_currentImgIndex videoUrl:_str_videoUrl];
        }
        else{
             [view_photoGallery setupByImagUrls:_arr_imgurls currentIndex:_currentImgIndex videoUrl:_str_videoUrl];
        }
    }
    else
        [view_photoGallery setupByImagUrls:_arr_imgurls currentIndex:_currentImgIndex videoUrl:_str_videoUrl];
    
    view_photoGallery.transform = CGAffineTransformMakeScale(.2, .2);
    view_photoGallery.center = CGPointMake(_frame.origin.x+_frame.size.width/2, _frame.origin.y+_frame.size.height/2);
    [UIView animateWithDuration:.25 animations:^{
        view_photoGallery.transform = CGAffineTransformMakeScale(1, 1);
        view_photoGallery.center = CGPointMake(W/2, H/2);
    } completion:^(BOOL finished) {
        if(finished)
            view_photoGallery.sv.delegate = view_photoGallery;
    }];
    return view_photoGallery;
}

+(void)removePhotoVideoGallery
{
    if(!view_photoGallery)
        return;
    view_photoGallery.sv.delegate = nil;
    [UIView animateWithDuration:.25 animations:^{
        CGRect _frame = view_photoGallery.rect_showFrom;
        view_photoGallery.center = CGPointMake(_frame.origin.x+_frame.size.width/2, _frame.origin.y+_frame.size.height/2);
        view_photoGallery.transform = CGAffineTransformMakeScale(.01, .01);
        
    } completion:^(BOOL finished) {
        if(finished)
        {
            SAFE_RemoveSupreView(view_photoGallery);
            view_photoGallery = nil;
        }
        
    }];

}

+(STPopupController *)presentCitiesPickViewFromController:(UIViewController *)_controller
{
  FGCitiesPickupViewController *vc_userpickup = [[FGCitiesPickupViewController alloc] initWithNibName:@"FGCitiesPickupViewController" bundle:nil];
  [commond useDefaultRatioToScaleView:vc_userpickup.view];
  STPopupController *vc_userPickPopup= [[STPopupController alloc] initWithRootViewController:vc_userpickup];
  vc_userpickup.contentSizeInPopup = vc_userpickup.view.frame.size;
  vc_userpickup.landscapeContentSizeInPopup = vc_userpickup.view.frame.size;
 vc_userpickup.title = multiLanguage(@"SELECT NOTINALITY");
  
  [STPopupNavigationBar appearance].tintColor = color_red_panel;
  vc_userPickPopup.containerView.layer.cornerRadius = 4;
  [vc_userPickPopup presentInViewController:_controller];
  vc_userpickup = nil;
  return vc_userPickPopup;
}

+(STPopupController *)presentUserPickViewFromController:(UIViewController *)_controller listType:(int)_listType
{
    
    FGUserPickupViewController *vc_userpickup = [[FGUserPickupViewController alloc] initWithNibName:@"FGUserPickupViewController" bundle:nil];
    [commond useDefaultRatioToScaleView:vc_userpickup.view];
    STPopupController *vc_userPickPopup= [[STPopupController alloc] initWithRootViewController:vc_userpickup];
    vc_userpickup.contentSizeInPopup = vc_userpickup.view.frame.size;
    vc_userpickup.landscapeContentSizeInPopup = vc_userpickup.view.frame.size;
    if(_listType == ListType_User)
        vc_userpickup.title = multiLanguage(@"PICK UP USER");
    else if(_listType == ListType_Topic)
        vc_userpickup.title = multiLanguage(@"PICK UP TOPIC");
    
    [STPopupNavigationBar appearance].tintColor = color_red_panel;
    vc_userPickPopup.containerView.layer.cornerRadius = 4;
    [vc_userPickPopup presentInViewController:_controller];
    [vc_userpickup setupByListType:_listType];
    vc_userpickup = nil;
    return vc_userPickPopup;
}

+(STPopupController *)presentTrainingLikesViewFromController:(UIViewController *)_controller trainingID:(NSString *)_str_trainingID
{
    
    FGLikesPickupViewController *vc = [[FGLikesPickupViewController alloc] initWithNibName:@"FGLikesPickupViewController" bundle:nil trainingID:_str_trainingID];
    [commond useDefaultRatioToScaleView:vc.view];
    STPopupController *vc_userPickPopup= [[STPopupController alloc] initWithRootViewController:vc];
    vc.contentSizeInPopup = vc.view.frame.size;
    vc.landscapeContentSizeInPopup = vc.view.frame.size;
    vc.title = multiLanguage(@"LIKES");
    
    [STPopupNavigationBar appearance].tintColor = color_red_panel;
    vc_userPickPopup.containerView.layer.cornerRadius = 4;
    [vc_userPickPopup presentInViewController:_controller];
    vc = nil;
    return vc_userPickPopup;
}

+(STPopupController *)presentGroupParticipantsViewFromController:(UIViewController *)_controller groupID:(NSString *)_str_groupID
{
    
    FGLikesPickupViewController *vc = [[FGLikesPickupViewController alloc] initWithNibName:@"FGLikesPickupViewController" bundle:nil groupId:_str_groupID];
    [commond useDefaultRatioToScaleView:vc.view];
    STPopupController *vc_userPickPopup= [[STPopupController alloc] initWithRootViewController:vc];
    vc.contentSizeInPopup = vc.view.frame.size;
    vc.landscapeContentSizeInPopup = vc.view.frame.size;
    vc.title = multiLanguage(@"PARTICIPANTS");
    
    [STPopupNavigationBar appearance].tintColor = color_red_panel;
    vc_userPickPopup.containerView.layer.cornerRadius = 4;
    [vc_userPickPopup presentInViewController:_controller];
    vc = nil;
    return vc_userPickPopup;
}

+(void)showGlobalPopupWithData:(id)_data
{
    FGGlobalBadgesPopupView *view_globalBadges = (FGGlobalBadgesPopupView *)[[[NSBundle mainBundle] loadNibNamed:@"FGGlobalBadgesPopupView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_globalBadges];
    view_globalBadges.center = CGPointMake(W/2, H/2);
    NSLog(@"nav_current.topViewController = %@",nav_current.topViewController);
    NSLog(@"nav_current.presentedViewController = %@",nav_current.presentedViewController);
    NSLog(@"appDelegate.window.rootViewController = %@",appDelegate.window.rootViewController);
    [nav_current.topViewController.view addSubview:view_globalBadges];
    [view_globalBadges updateBadgesPopup:_data];
}


/*显示订单查询锁定页*/
+(void)showLocationRequestSendedPopupView
{
    if(vc_location_requesteSended)
        return;
    
    FGControllerManager *manager = [FGControllerManager sharedManager];
    vc_location_requesteSended = [[FGPopupViewController alloc] initWithNibName:@"FGPopupViewController" bundle:nil];
    [vc_location_requesteSended inital_location_requestSended];
    [manager pushController:vc_location_requesteSended navigationController:nav_current];
}


+(void)removeLocationRequestSendedPopupView
{
    if(!vc_location_requesteSended)
        return;
    
    [vc_location_requesteSended remove_location_requestSended];
    vc_location_requesteSended = nil;
    
}


+(void)showReportActionSheet:(id)delegate showInView:(UIView *)_view
{
    if(!arr_reportContents)
    {
        arr_reportContents = [@[multiLanguage(@"•Illegal content"),
                               multiLanguage(@"•Content violates Laws"),
                               multiLanguage(@"•Violence or Porn"),
                               multiLanguage(@"•Scam or false information"),
                               multiLanguage(@"•Harassment"),
                               multiLanguage(@"•Fake account"),
                               multiLanguage(@"•Other")] mutableCopy];
    }
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:multiLanguage(@"Report") delegate:delegate cancelButtonTitle:multiLanguage(@"Cancel") destructiveButtonTitle:nil otherButtonTitles:
                                  [arr_reportContents objectAtIndex:0],
                                  [arr_reportContents objectAtIndex:1],
                                  [arr_reportContents objectAtIndex:2],
                                  [arr_reportContents objectAtIndex:3],
                                  [arr_reportContents objectAtIndex:4],
                                  [arr_reportContents objectAtIndex:5],
                                  [arr_reportContents objectAtIndex:6],
                                  nil];
    [actionSheet showInView:_view];
}

#pragma mark - 初始化单个AVPlayerLayer
+(AVPlayerLayer *)getSharedPlayerLayer
{
    if(playerLayer_public)
    {
        
        return playerLayer_public;
    }
    
    NSLog(@":::::::::::::::::::>initalPlayerLayer");
    player_public = [[AVPlayer alloc]initWithPlayerItem:nil];
    player_public.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    playerLayer_public = [AVPlayerLayer playerLayerWithPlayer:player_public];
    [playerLayer_public.player pause];
    playerLayer_public.player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    playerLayer_public.videoGravity = AVLayerVideoGravityResizeAspect;
    playerLayer_public.backgroundColor = [UIColor blackColor].CGColor;
    [playerLayer_public.player setMuted:YES];
    return playerLayer_public;
}

+(void)addPublicPlayerLayerToVideoContainerView:(UIView *)_view_videoContainer
{
    AVPlayerLayer *playerLayer = [commond getSharedPlayerLayer];
    [playerLayer removeFromSuperlayer];
    [_view_videoContainer.layer insertSublayer:playerLayer atIndex:0];
    playerLayer.frame = _view_videoContainer.bounds;
    if(playerLayer.player.status == AVPlayerItemStatusReadyToPlay)
    {
        [playerLayer.player.currentItem seekToTime: kCMTimeZero
                                    toleranceBefore: kCMTimeZero
                                     toleranceAfter: kCMTimeZero
                                  completionHandler: ^(BOOL finished)
         {
             if(finished)
             {
                 [playerLayer.player play];
             }
             
         }];
    }
    else if(playerLayer.player.status == AVPlayerItemStatusUnknown)
    {
        [playerLayer.player play];
    }
    
}

+(void)showAskForLogin
{
    [commond removeLoading];
    [commond alertWithButtons:@[multiLanguage(@"Register / Login"),multiLanguage(@"Skip")] title:multiLanguage(@"Please register / login") message:multiLanguage(@"To use this any many other great WeBox features and offers, please register or login by clicking the link below") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
        if(buttonIndex == 0)
        {
            [appDelegate logout];
        }
        else
        {
            
        }
    }];
}

+(void)showAskForLogout
{
  [commond removeLoading];
  [commond alertWithButtons:@[multiLanguage(@"YES"),multiLanguage(@"NO")] title:multiLanguage(@"ALERT") message:multiLanguage(@"Do you want to log out now?") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
    if(buttonIndex == 0)
    {
      [appDelegate logout];
    }
    else
    {
      
    }
  }];
}

#pragma mark -
+ (BOOL)isUser {
  NSInteger role = [(NSNumber *)[commond getUserDefaults:KEY_API_USER_ROLE] integerValue];
  
  if (role == 1)
    return NO;
  return YES;
}

+ (BOOL)isCurrentUserWithId:(NSString *)_str_id {
  NSString *_str_userId = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
  
  if ([_str_userId isEqualToString:_str_id]) {
    return YES;
  }
  return NO;
}

+ (void)alertPhoneCallWebViewWithMobile:(NSString *)_str_mobile {
  UIWebView * callWebview = [[UIWebView alloc] init];
  [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_str_mobile]]]];
  UIWindow *window = (UIWindow *)[appDelegate performSelector:@selector(window)];
  [window addSubview:callWebview];
}

+(void)trackShareContent:(NSString *)_str_content shareTo:(NSString *)_str_shareTo
{
    NSMutableDictionary *_dic_attrs = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_attrs setObject:_str_content forKey:KEY_TRACK_ATTRID_POST_SHARECONTENT];
    [_dic_attrs setObject:_str_shareTo forKey:KEY_TRACK_ATTRID_POST_SHARETO];
    [NetworkEventTrack track:KEY_TRACK_EVENTID_SHAREAPP attrs:_dic_attrs];
}

#pragma mark - 获取缓存数据
+ (float)getSDWebImageCachedSize {
  float _flt_picSize = [[SDImageCache sharedImageCache] getSize];

  return _flt_picSize/(1024.0*1024.0);
}

+ (void)clearSDWebImageCachedSize {
  [[SDImageCache sharedImageCache] clearDisk];
}

+ (void)clearTrainingDownloadVideoSize {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *path = [paths objectAtIndex:0];
  NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:path];
  for (NSString *fileName in enumerator)
  {
    NSString* fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
    if([fileAbsolutePath rangeOfString:@"cached_post_video"].location == NSNotFound  &&
       [fileAbsolutePath rangeOfString:@"userAvatar"].location == NSNotFound)//是文件夹
    {
      BOOL isdelete = [[NSFileManager defaultManager] removeItemAtPath:fileAbsolutePath error:nil];
      NSLog(@"clearTrainingDownloadVideoSize isdelete=%@, isdelete=%d", fileAbsolutePath,isdelete);
    }
  }
}

+ (float)getTrainingDownloadVideoSize {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *path = [paths objectAtIndex:0];
  long long folderSize = 0;
  
  NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:path];
  for (NSString *fileName in enumerator)
  {
    NSString* fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
    if([fileAbsolutePath rangeOfString:@"cached_post_video"].location == NSNotFound &&
        [fileAbsolutePath rangeOfString:@"userAvatar"].location == NSNotFound)//是文件夹
    {
//      NSLog(@"TrainingDownloadVideo fileAbsolutePath==%@",fileAbsolutePath);
      folderSize += [commond fileSizeAtPath:fileAbsolutePath];
    }
  }
  NSLog(@"==============================================");
//
  NSLog(@"TrainingDownloadVideo 2222222222==%f",folderSize/(1024.0*1024.0));

  return folderSize/(1024.0*1024.0);
  
//  NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
//  NSNumber *sizeNumber = attributes[@"NSFileSize"];
//  NSLog(@"TrainingDownloadVideo fileAbsolutePath==%f",sizeNumber.floatValue/1024.0);
//  return sizeNumber.floatValue/1024.0;
  
}

+ (float)getCachedPostVideoFileSize {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *path = [paths objectAtIndex:0];
  NSString *_filepath = [path stringByAppendingPathComponent:@"cached_post_video"];

  float _flt_folderSize = [commond folderSizeAtPath:_filepath];
  return _flt_folderSize;
}

+ (void)clearCachedPostVideoFileSize {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *path = [paths objectAtIndex:0];
  NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]enumeratorAtPath:path];
  for (NSString *fileName in enumerator)
  {
    NSString* fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
    if([fileAbsolutePath rangeOfString:@"cached_post_video"].location != NSNotFound)//是文件夹
    {
      BOOL isdelete = [[NSFileManager defaultManager] removeItemAtPath:fileAbsolutePath error:nil];
      NSLog(@"clearTrainingDownloadVideoSize isdelete=%@, isdelete=%d", fileAbsolutePath,isdelete);
    }
  }
}

//遍历文件夹获得文件夹大小，返回多少M
+ (float ) folderSizeAtPath:(NSString*) folderPath{
  NSFileManager* manager = [NSFileManager defaultManager];
  if (![manager fileExistsAtPath:folderPath]) return 0;
  NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
  NSString* fileName;
  long long folderSize = 0;
  NSLog(@"==============================================");
  while ((fileName = [childFilesEnumerator nextObject]) != nil){
    NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
    if ([fileAbsolutePath hasSuffix:@"mp4"] || [fileAbsolutePath hasSuffix:@"mp3"])
      folderSize += [commond fileSizeAtPath:fileAbsolutePath];
  }
  NSLog(@"==============================================");

  return folderSize/(1024.0*1024.0);
}

//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath{
  NSFileManager* manager = [NSFileManager defaultManager];
  if ([manager fileExistsAtPath:filePath]){
    return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
  }
  return 0;
}

#pragma mark - 保存订单数量
+ (void)saveBookingCntWithCnt:(NSInteger)_int_cnt {
  [commond setUserDefaults:[NSNumber numberWithInteger:_int_cnt] forKey:BOOKINGCNT];
}

+ (NSInteger)getBookingCnt {
  NSNumber *_number = (NSNumber *)[commond getUserDefaults:BOOKINGCNT];
  return [_number integerValue];
}

#pragma mark - 显示保存剪切板信息
+ (void)showHUDAfterCopyToClipboardWithMessage:(NSString *)_str_message {
  
  [ZJProgressHUD showSuccessWithStatus:_str_message andAutoHideAfterTime:3.f];
  
//  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
//  // Set the custom view mode to show any view.
//  hud.mode = MBProgressHUDModeCustomView;
//  // Set an image view with a checkmark.
//  UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//  hud.customView = [[UIImageView alloc] initWithImage:image];
//  // Looks a bit nicer if we make it square.
//  hud.square = YES;
//  // Optional label text.
////  [hud setLabelText:_str_message];
//  hud.label.text = _str_message;//multiLanguage(@"Copied to clipboard");
////  [hud hide:YES afterDelay:3.0f];
//  [hud hideAnimated:YES afterDelay:3.f];
}

#pragma mark - 判断是否联网
+(BOOL)isNetworkReachable{
  // Create zero addy
  struct sockaddr_in zeroAddress;
  bzero(&zeroAddress, sizeof(zeroAddress));
  zeroAddress.sin_len = sizeof(zeroAddress);
  zeroAddress.sin_family = AF_INET;
  
  // Recover reachability flags
  SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
  SCNetworkReachabilityFlags flags;
  
  BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
  CFRelease(defaultRouteReachability);
  
  if (!didRetrieveFlags)
  {
    return NO;
  }
  
  BOOL isReachable = flags & kSCNetworkFlagsReachable;
  BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
  return (isReachable && !needsConnection) ? YES : NO;
}
@end

//
//  UtilityMacros.h
//  CSP
//
//  Created by JasonLu on 16/8/29.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#ifndef UtilityMacros_h
#define UtilityMacros_h

#pragma mark - 获取设备大小
// NavBar高度
#define NavigationBar_HEIGHT 44

// StatusBar高度
#define StatusBar_HEIGHT 20

//获取屏幕 宽度、高度
#define W getScreenSize().width
#define H getScreenSize().height

//当前屏幕尺寸 与 320 X 568 这个标准尺寸的比值
#define ratioW W / 320.0f
#define ratioH H / 568.0f

//布局
#define LAYOUT_TOPVIEW_HEIGHT 62   //标题栏的高度
#define LAYOUT_BOTTOMVIEW_HEIGHT 0 //底部标签栏的高度
//-------------------获取设备大小-------------------------

#pragma mark - 打印日志
// DEVELOPER 的Target才是DEBUG_MODE
#if defined(DEVELOPER)
#define DEBUG_MODE
#endif

//重写NSLog,Debug模式下打印日志和当前行数 //IOS10 以后 如果把OS_ACTIVITY_MODE 设为disable的话 用这个方式打印不出结果
#ifdef DEBUG_MODE
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

//IOS10 以后 用这个方式打印
/*#ifdef DEBUG_MODE
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif*/


// DEBUG 模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#define ULog(fmt, ...)                                                    \
  {                                                                       \
    UIAlertView *alert = [[UIAlertView alloc]                             \
            initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ",  \
                                                     __PRETTY_FUNCTION__, \
                                                     __LINE__]            \
                  message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  \
                 delegate:nil                                             \
        cancelButtonTitle:@"Ok"                                           \
        otherButtonTitles:nil];                                           \
    [alert show];                                                         \
  }
#else
#define ULog(...)
#endif
//---------------------打印日志--------------------------

#pragma mark - 系统
//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)           \
  ([[[UIDevice currentDevice] systemVersion] \
       compare:v                             \
       options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)       \
  ([[[UIDevice currentDevice] systemVersion] \
       compare:v                             \
       options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) \
  ([[[UIDevice currentDevice] systemVersion]       \
       compare:v                                   \
       options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)          \
  ([[[UIDevice currentDevice] systemVersion] \
       compare:v                             \
       options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) \
  ([[[UIDevice currentDevice] systemVersion]    \
       compare:v                                \
       options:NSNumericSearch] != NSOrderedDescending)

// 是否iPad
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
// 是否iPad
#define someThing \
  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? ipad : iphone

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define isRetina                                                     \
  ([UIScreen instancesRespondToSelector:@selector(currentMode)]      \
       ? CGSizeEqualToSize(CGSizeMake(640, 960),                     \
                           [[UIScreen mainScreen] currentMode].size) \
       : NO)
#define iPhone5                                                      \
  ([UIScreen instancesRespondToSelector:@selector(currentMode)]      \
       ? CGSizeEqualToSize(CGSizeMake(640, 1136),                    \
                           [[UIScreen mainScreen] currentMode].size) \
       : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断设备的操做系统是不是ios7
#define IOS7 ([[[UIDevice currentDevice].systemVersion doubleValue] >= 7.0]

//判断当前设备是不是iphone5
#define kScreenIphone5 (([[UIScreen mainScreen] bounds].size.height) >= 568)

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
// iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
// iPhone Simulator
#endif

//----------------------系统----------------------------

#pragma mark - 内存相关
//使用ARC和不使用ARC
#if __has_feature(objc_arc)
// compiling with ARC
#else
// compiling without ARC
#endif

#define RELEASE_SAFELY(__POINTER) \
  {                               \
    [__POINTER release];          \
    __POINTER = nil;              \
  }

//释放一个对象
#define SAFE_RemoveSupreView(_view)           \
  if (_view) {                                \
    [_view removeFromSuperview], _view = nil; \
  }

#define SAFE_RELEASE(x) \
  [x release];          \
  x = nil

//安全停止一个timer
#define SAFE_INVALIDATE_TIMER(__TIMER) \
  {                                    \
    [__TIMER invalidate];              \
    __TIMER = nil;                     \
  }
//----------------------内存----------------------------

#pragma mark - 图片
//读取本地图片
#define LOADIMAGE(file, ext)                                              \
  [UIImage                                                                \
      imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file \
                                                              ofType:ext]]

//定义UIImage对象
#define IMAGE(A)                                                       \
  [UIImage                                                             \
      imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A \
                                                              ofType:nil]]

//定义UIImage对象
//#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]
#define IMGWITHNAME(_name) [UIImage imageNamed:_name]

#define IMAGEWITHPATH(path) (([(path) rangeOfString:@"Documents"].location != NSNotFound) ? [UIImage imageWithContentsOfFile:(path)] : IMAGE(path))

//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------

#pragma mark - 颜色类
// 获取RGB颜色
#define rgb(r, g, b)                      \
  [UIColor colorWithRed:(float)r / 255.0f \
                  green:(float)g / 255.0f \
                   blue:(float)b / 255.0f \
                  alpha:1]
#define rgba(r, g, b, a)                  \
  [UIColor colorWithRed:(float)r / 255.0f \
                  green:(float)g / 255.0f \
                   blue:(float)b / 255.0f \
                  alpha:a]
#define color_deepblue rgb(28, 42, 120)
#define color_bgGray rgb(232, 233, 234)
#define color_lightgreen rgba(107, 194, 162, 1)
#define color_darkblue rgba(0, 15, 105, 1)
#define color_orangeColor rgb(245, 130, 31)
#define color_meihongColor rgb(226, 40, 130)
#define color_baolanColor rgb(45, 129, 159)
#define color_skyblueColor rgb(30, 158, 196)
#define color_lightblue rgba(68, 189, 235, .7)
#define color_lightblue_transparent rgba(196, 234, 248, 1)
#define color_darkblue_transparent rgba(108, 164, 203, 1)
#define color_deepgreen rgba(60, 151, 146, 1)
#define color_red_panel rgba(180, 20, 35, 1)
#define color_lap_unclick rgba(236, 239, 240, 1)
#define color_qingse rgba(177, 187, 188, 1)
#define color_homepage_lightGray rgba(173, 177, 178, 1)
#define color_homepage_black rgba(0, 0, 0, 1)
#define color_calendar_lightGray rgba(236, 240, 241, 1)
#define color_calendar_featureDay rgba(37, 37, 37, 1)
#define color_calendar_timePassed rgba(226, 226, 226, 1)
#define color_calendar_darkLightGray rgba(127, 140, 141, 1)
#define color_calendar_darkGray rgba(0, 0, 0, 1)
#define color_workoutlog_darkGreen rgba(70, 152, 148, 1)
#define color_workoutlog_lightGreen rgba(104, 186, 163, 1)


// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)                                       \
  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
                  green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0    \
                   blue:((float)(rgbValue & 0xFF)) / 255.0             \
                  alpha:1.0]
//背景色
#define BACKGROUND_COLOR              \
  [UIColor colorWithRed:242.0 / 255.0 \
                  green:236.0 / 255.0 \
                   blue:231.0 / 255.0 \
                  alpha:1.0]
//清除背景色
#define CLEARCOLOR [UIColor clearColor]

//----------------------颜色类--------------------------

#pragma mark - 对象
#define ISNULLObj(obj) ([(obj) isEqual:[NSNull null]] || (obj) == nil)
#define ISEXISTObj(obj) (!ISNULLObj(obj) && ![(obj) isEqualToString:@"(null)"])

#pragma mark - 其他
//程序的本地化,引用国际化的文件
#define multiLanguage(text) NSLocalizedStringFromTable((text), @"MyString", nil)

// G－C－D
#define BACK(block) \
  dispatch_async(   \
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(), block)

//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian * 180.0) / (M_PI)
//----------------------其他----------------------------

typedef NS_ENUM(NSInteger, enum_BoxingLevel) {
  BL_Undefined    = 0,
  BL_Beginner     = 1,
  BL_Intermediate = 2,
  BL_Advanced     = 3,
};

typedef NS_ENUM(NSInteger, enum_Gender) {
  Gender_Female = 1,
  Gender_Male   = 0
};

typedef NS_ENUM(NSInteger, enum_Goal) {
  Goal_undefined       = 0,
  Goal_loseWeight      = 1,
  Goal_gettoned        = 2,
  Goal_howtobox        = 3

};

typedef NS_ENUM(NSInteger, enum_banner) {
  banner_findagroup       = 0,
  banner_booknow      = 1,
  banner_userprofile        = 2,
  banner_workout        = 3
};


#define GenderToInteger(x) ([(x) isEqualToString:@"Female"] ? Gender_Female : Gender_Male)
#define GenderToString(x) ((x) == Gender_Female ? multiLanguage(@"Female") : multiLanguage(@"Male"))
#define BoxingLevelToInteger(x) ([(x) isEqualToString:multiLanguage(@"Beginner")] ? BL_Beginner : [(x) isEqualToString:multiLanguage(@"Intermediate")] ? BL_Intermediate : [(x) isEqualToString:multiLanguage(@"Advanced")] ? BL_Advanced : BL_Undefined)
#define BoxingLevelToString(x) ((x) == BL_Beginner ? multiLanguage(@"Beginner") : ((x) == BL_Intermediate ? multiLanguage(@"Intermediate") : ((x) == BL_Advanced ? multiLanguage(@"Advanced"): multiLanguage(@"undefined"))))

#define GoalToInteger(x) [[(x) lowercaseString] rangeOfString:multiLanguage(@"want to lose weight")].location != NSNotFound ? Goal_loseWeight : ([[(x) lowercaseString] rangeOfString:multiLanguage(@"want to get toned")].location != NSNotFound ? Goal_gettoned : ([[(x) lowercaseString] rangeOfString:multiLanguage(@"want to learn how to box")].location != NSNotFound ? Goal_howtobox : Goal_undefined))

#define GoalToString(x) ((x) == Goal_loseWeight) ? multiLanguage(@"want to lose weight") : ((x) == Goal_gettoned) ? multiLanguage(@"want to get toned") : ((x) == Goal_howtobox) ? multiLanguage(@"want to learn how to box") : multiLanguage(@"undefined")

#define USERAVATARDEFAULT @"userAvatarDefault"
#define USERAVATARBLURBGDEFAULT @"userAvatarBlurBgDefault"
#define USERAVATAR @"userAvatar"
#define USERAVATARBLURBG @"userAvatarBlurBg"
#define AVATARTYPE @"png"

#define NOTIFICATION_CELL_TIME @"NOTIFICATION_CELL_TIME"
#define NOTIFICATION_ACCEPTCOURSESUCCESS @"NOTIFICATION_ACCEPTCOURSESUCCESS"
#define NOTIFICATION_UPDATECALENDARFROMDETAIL @"NOTIFICATION_UPDATECALENDARFROMDETAIL"
#define NOTIFICATION_REFRESHPROFILE @"NOTIFICATION_REFRESHPROFILE"

#define NOTIFICATION_UPDATEUSERAVATAR @"NOTIFICATION_UPDATEUSERAVATAR"
#define NOTIFICATION_UPDATEFIRENDPAVATAR @"NOTIFICATION_UPDATEFIRENDPAVATAR"
#define NOTIFICATION_UPDATETRAINERAVATAR @"NOTIFICATION_UPDATETRAINERAVATAR"

#define APPACTIVE_NOTIFICATION @"APPACTIVE_NOTIFICATION"
#define STATUS_NOTIFICATION @"STATUS_NOTIFICATION"
#define BOOKINGCNT @"BOOKINGCNT"
#define MOBILEFORLOGIN @"MOBILEFORLOGIN"
#define USERINVITATIONCODE @"USERINVITATIONCODE"

#endif /* UtilityMacros_h */

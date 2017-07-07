//
//  commond.h
//  Kline
//
//  Created by zhaomingxi on 14-2-11.
//  Copyright (c) 2014年 zhaomingxi. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import "FGPhotoVideoGallery.h"
@class STPopupController;
@class TAlertView;
@class FGCustomAlertView;
extern  NSMutableArray *arr_reportContents;
CGSize getScreenSize();
@interface commond : NSObject
+(id)getJsonObjectFromJsonString:(NSString *)_str_json;
+(NSString *)getJsonStringFromJsonObject:(id)_obj;
+(NSData *)getJsonDataFromJsonObject:(id)_obj;
+ (void)dismissKeyboard:(UIView *)view;
+ (void)setTextFieldDelegate:(id<UITextFieldDelegate>)_delegate inView:(UIView *)view;
+ (NSString *)numberMinDigitsFormatter:(int)_minIntegerDigits num:(int)_num;
+ (NSString *)dateStringBySince1970:(long)_timeStamp;
+ (NSString *)dateStringBySince1970:(long)_timeStamp dateFormat:(NSString *)_str_dateFormat;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSMutableDictionary *)splitDateStringByYYYYMMDD:(NSString *)_str_date;
+ (NSMutableDictionary *)splitTimeStringByHHMMSS:(NSString *)_str_timestamp;
+ (NSString *)numberToString:(NSNumber *)_number;
+ (NSDate *)dateFromString:(NSString *)str;
+ (NSDate *)dateFromString:(NSString *)str formatter:(NSString *)_str_formatter;
+ (NSDateComponents *)dateComponentsWithDate:(NSDate *)date;
+ (bool)isEqualWithFloat:(float)f1 float2:(float)f2 absDelta:(int)absDelta;
+ (NSObject *)getUserDefaults:(NSString *)name;
+ (void)setUserDefaults:(NSObject *)defaults forKey:(NSString *)key;
+ (BOOL)saveToKeyChain:(NSString *)_str_username passwd:(NSString *)_str_passwd;
+ (NSString *)getFromKeyChain:(NSString *)_str_username;
+ (BOOL)deleteFromKeyChain:(NSString *)_str_username;
+ (BOOL)isEmpty:(id)input;
+ (NSString *)stringRemovePercentAndPlus:(NSString *)_str_original;
+ (CGRect)useDefaultRatioToScaleFrame:(CGRect)_originalFrame;
+ (void)useDefaultRatioToScaleView:(UIView *)_view;
+ (long)EnCodeCoordinate:(double)para;
+ (double)DeCodeCoordinate:(long)totalMilliarcseconds;
+ (NSString *)meterToKMIfNeeded:(int)_meters;
+ (BOOL)isTAlertAlreadyShowedInWindow;
+ (void)alert:(NSString *)_str_title message:(NSString *)_str_message callback:(void (^)(FGCustomAlertView *alertView, NSInteger buttonIndex))callBackBlock;
+ (NSString *)clockFormatBySeconds:(NSInteger)_sec;
+ (NSString *)clockFormatByMicroSeconds:(NSTimeInterval)_microSecs;
+ (NSInteger)secondsByClockFormat:(NSString *)_str_timeFormat;
+ (void)showLoadingWithCustomView:(NSString *)imgName number:(NSInteger)number;
+ (void)showLoadingInView:(UIView *)_parentView;
+ (void)showLoading;
+ (void)removeLoading;
+ (void)useRatio:(CGRect)_ratio toScaleView:(UIView *)_view;
+ (void)removeAllAlertViewInWindow;
+ (void)alertWithButtons:(NSArray *)_arr_buttons title:(NSString *)_str_title message:(NSString *)_str_message callback:(void (^)(FGCustomAlertView *alertView, NSInteger buttonIndex))callBackBlock;
+ (void)alertWithButtons:(NSArray *)_arr_buttons title:(NSString *)_str_title message:(NSString *)_str_message callback:(void (^)(FGCustomAlertView *alertView, NSInteger buttonIndex))callBackBlock dismissWithButtonIndex:(NSInteger)_int_idx;
+ (NSString *)getCurrentLanguage;
+ (BOOL)isChinese;
+ (AVAudioPlayer *)initBackgroundSound:(NSString *)filename loop:(long)loop player:(AVAudioPlayer *)_player type:(NSString *)type;
+ (void)initSystemSound:(NSString *)filename type:(NSString *)type tmpID:(SystemSoundID *)__tmpID;
+ (void)setTextField:(UITextField *)_textField placeHolderFont:(UIFont *)_font placeHolderColor:(UIColor *)_color;
+ (void)setTextViewDelegate:(id<UITextViewDelegate>)_delegate inView:(UIView *)view;
+(FGPhotoVideoGallery *)showPhotoVideoGalleryToView:(UIView *)_parentView fromView:(UIView *)_fromView imgs:(NSMutableArray *)_arr_imgurls imgIndex:(NSInteger)_currentImgIndex videoUrl:(NSString *)_str_videoUrl;
+(void)removePhotoVideoGallery;
+(STPopupController *)presentCitiesPickViewFromController:(UIViewController *)_controller;
+(STPopupController *)presentUserPickViewFromController:(UIViewController *)_controller listType:(int)_listType;
+(STPopupController *)presentTrainingLikesViewFromController:(UIViewController *)_controller trainingID:(NSString *)_str_trainingID;
+(STPopupController *)presentGroupParticipantsViewFromController:(UIViewController *)_controller groupID:(NSString *)_str_groupID;

+(void)showGlobalPopupWithData:(id)_data;


#pragma mark - 
+ (float)getCachedPostVideoFileSize;
+ (float)getSDWebImageCachedSize;
+ (float)getTrainingDownloadVideoSize;
+ (void)clearCachedPostVideoFileSize;
+ (void)clearTrainingDownloadVideoSize;
+ (void)clearSDWebImageCachedSize;

#pragma mark - 保存订单数量
+ (void)saveBookingCntWithCnt:(NSInteger)_int_cnt;
+ (NSInteger)getBookingCnt;

#pragma mark - 显示保存剪切板信息
+ (void)showHUDAfterCopyToClipboardWithMessage:(NSString *)_str_message;

#pragma mark - 初始化单个AVPlayerLayer
+(AVPlayerLayer *)getSharedPlayerLayer;
+(void)addPublicPlayerLayerToVideoContainerView:(UIView *)_view_videoContainer;
#pragma mark -
+ (BOOL)isUser;
+ (BOOL)isCurrentUserWithId:(NSString *)_str_id;
+ (void)alertPhoneCallWebViewWithMobile:(NSString *)_str_mobile;
+(void)showReportActionSheet:(id)delegate showInView:(UIView *)_view;
+(NSString *)numberCountFormatByCount:(NSInteger)_count;
+(BOOL)isNetworkReachable;
+(void)showAskForLogin;
+(void)showAskForLogout;
+(void)trackShareContent:(NSString *)_str_content shareTo:(NSString *)_str_shareTo;
/*显示订单查询锁定页*/
+(void)showLocationRequestSendedPopupView;
+(void)removeLocationRequestSendedPopupView;
@end

//
//  FGUtils.h
//  CSP
//
//  Created by JasonLu on 16/8/31.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FGUtils : NSObject
+ (void)printAllSupportFontName;

+ (NSMutableAttributedString *)createAttributedStringWithContentInfo:(NSArray *)strInfoArr;
+ (NSDictionary *)createAttributeTextInfo:(NSString *)text font:(UIFont *)font color:(UIColor *)color paragraphSpacing:(CGFloat)paragraphSpacing lineSpacing:(CGFloat)lineSpacing textAlignment:(NSTextAlignment)textAlignment sepeatorByString:(NSString *)sepeator;
+ (CGRect)calculatorAttributeString:(NSAttributedString *)aStr withWidth:(CGFloat)width;

+ (NSString *)formatScheduleSpecificTimeDurationWithStartTime:(NSString *)_startTime;
+ (NSString *)dateSpecificTimeWithTimeIntervalSecondStr:(NSString *)time1970Sec;
+ (NSString *)dateSpecificTimeWithTimeIntervalSecondStr:(NSString *)time1970Sec withFormat:(NSString *)dateFormat;
+ (NSString *)dateSpecificTimeWithTimeInterval:(NSTimeInterval)time1970Sec withFormat:(NSString *)dateFormat;
+ (NSString *)intervalNowBeginWith1970SecondStr:(NSString *)time1970Sec;
+ (NSString *)formatDayHourMinuteWithSecondTimeInterval:(NSTimeInterval)secondsTime;
+ (NSTimeInterval)formatTimeIntervalFromDate:(NSDate *)_date;

+ (int)intervalNowToDate:(NSString *)theDate;
+ (void)calculateHourMinuteWithSecondTimeInterval:(NSTimeInterval)secondsTime withHours:(NSInteger *)hours withMinutes:(NSInteger *)minutes withSeconds:(NSInteger *)seconds;

+ (NSString *)pathInDocumentsWithPNG:(NSString *)_fileName;
+ (NSString *)pathInDocumentsWithFileName:(NSString *)fileName;
+ (BOOL)saveDocumentsFilePNGWithName:(NSString *)_name fileData:(NSData *)_fileData;
+ (BOOL)saveDocumentsFileWithName:(NSString *)_name suffixType:(NSString *)_suffixType fileData:(NSData *)_fileData;

+ (NSArray *)arrayFromString:(NSString *)str beginMatchPatternStr:(NSString *)str_beginMatchPattern endMatchPatternStr:(NSString *)str_endMatchPattern;
+ (NSArray *)getRangesFromString:(NSString *)text findText:(NSString *)findText specailKeys:(NSArray *)arr_specialKeys;
+ (NSString *)formatToHtmlStringWithString:(NSString *)str useMatchPatterns:(NSArray *)matchPatterns;
+ (NSString *)findValueWithKey:(NSString *)key inArray:(NSArray *)originalArr;
+ (NSArray *)tmpArray;

+ (NSString *)limitWithString:(NSString *)content maxLength:(NSInteger)length;

#pragma mark - 保存搜索关键字
+ (void)saveSeachKeyWithString:(NSString *)_str_key;
+ (NSArray *)searchKeys;
#pragma mark - 根据关键字查找信息
+ (NSDictionary *)infoFromArray:(NSArray *)_arr_info withKey:(NSString *)_key;
#pragma mark - 去除号码格式
+ (NSString *)formatPhoneNumber:(NSString*)number;
#pragma mark - cell工具
+ (CGFloat)calculateCellHeightByDynamicView:(UIView *)_view originalCellHeight:(CGFloat)_originalCellHeight originalLabelFrame:(CGRect)_originalLabelFrame
                originalVideoContainerFrame:(CGRect)_originalVideoContainerFrame;
+ (CGFloat)calculateCellHeightByDynamicView:(UIView *)_view originalCellHeight:(CGFloat)_originalCellHeight originalLabelFrame:(CGRect)_originalLabelFrame
                    originalCollectionFrame:(CGRect)_originalCollectionFrame collectionImagesCount:(NSInteger)_collectionImagesCount;
#pragma mark - 计算数组中最大值和最小值
+ (void)sortedGetMaxMinWithArray:(NSArray *)arr_sort max:(CGFloat *)max min:(CGFloat*)min;
#pragma mark - 判断数据是否正确
+ (BOOL)isErrorFromResponseInfo:(NSDictionary *)_dic_info withTableView:(UITableView *)_tableVie;
#pragma mark - 刷新tableview底部加载
+ (void)refreshWithTableView:(UITableView *)_tableView footerWithActivityStatus:(BOOL)_bool_activity;
+ (void)refreshheaderWithTableView:(UITableView *)_tableView;
#pragma mark - 刷新tableview某一行
+ (void)reloadCellWithTableView:(UITableView *)_tb atIndex:(NSInteger)_int_idx;
+ (void)reloadCellWithTableView:(UITableView *)_tb atSection:(NSInteger)_int_section atIndex:(NSInteger)_int_idx;

+ (NSData *)getBlurEffectWithImage:(UIImage *)_img;
+ (NSString *)getCityNameWithString:(NSString *)_str_cities;
+ (NSString *)getCityNameWithId:(NSString *)_str_cityId;
+ (NSString *)getCityIdWithName:(NSString *)_str_name;

+ (void)internalInitalUserAvatar;
+ (NSDictionary *)getUserDefaultAvatarInfo;
+ (NSDictionary *)getUserAvatarInfo;
+ (NSDictionary *)getUserAvatarInfoWithType:(BOOL)_bool_isUser;
+ (UIImage *)getUserBgImageUseType;
+ (UIImage *)getUserBgImage;
+ (UIImage *)getTrainerBgImage;
+ (void)saveUserAvatarWithUrlString:(NSString *)_str_url;
+ (NSData *)getDataWithImage:(UIImage *)_img;
+ (UIView *)getToolbarViewWithSize:(CGSize)_size;
+ (UIView *)getBlackBgViewWithSize:(CGSize)_size withAlpha:(CGFloat)_flt_alpha;

+ (NSString *)logDic:(NSDictionary *)dic;

#pragma mark - 推送注册，注销方法
+ (void)jpush_registerAlias:(NSString *)_str_alias;
+ (void)jpush_resignAlias;
@end

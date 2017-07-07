//
//  FGSNSManager.h
//  CSP
//
//  Created by JasonLu on 17/1/12.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/SSDKTypeDefine.h>
@interface FGSNSManager : NSObject
+ (FGSNSManager *)shareInstance;

#pragma mark - 创建系统分享界面
- (void)actionToShareWithSystemActivityOnViewController:(UIViewController *)_vc shareTitle:(NSString *)_str_shareTitle shareContent:(NSString *)_str_shareContent shareImages:(NSArray *)_arr_shareImages shareUrl:(NSString *)_str_shareUrl;

- (void)actionToShareWithTitle:(NSString *)_str_title text:(NSString *)_str_text url:(NSString *)_str_url images:(NSArray *)_arr_img;

- (void)shareToPlatformWithTitle:(NSString *)_str_title text:(NSString *)_str_text url:(NSString *)_str_url images:(NSArray *)_arr_img platformType:(SSDKPlatformType)platformType;

- (void)shareToPlatformWithTitle:(NSString *)_str_title text:(NSString *)_str_text url:(NSString *)_str_url images:(NSArray *)_arr_img platformType:(SSDKPlatformType)platformType contentType:(SSDKContentType)contentType;

#pragma mark - 分享邀请码
- (void)actionToShareInviateCodeOnView:(UIView *)_view title:(NSString *)_str_title text:(NSString *)_str_text url:(NSString *)_str_url inviateCode:(NSString *)_str_inviateCode;
#pragma mark - 分享添加好友
- (void)actionToShareAddFriendOnView:(UIView *)_view platformType:(SSDKPlatformType)platformType;
#pragma mark - 分享post内容
- (void)actionToSharePostOnView:(UIView *)_view title:(NSString *)_str_title text:(NSString *)_str_text url:(NSString *)_str_url image:(id)_img link:(NSString *)_str_Link;
#pragma mark - 分享训练内容
- (void)actionToShareTrainingOnView:(UIView *)_view title:(NSString *)_str_title text:(NSString *)_str_text url:(NSString *)_str_url;
#pragma mark - 分享edit post内容
- (void) actionToShareEditPostWithImages:(NSArray *)_arr_img text:(NSString *)_str_text onViewController:(UIViewController *)_vc;
- (void)actionToShareEditPostOnView:(UIView *)_view title:(NSString *)_str_title text:(NSString *)_str_text link:(NSString *)_str_Link;
@end

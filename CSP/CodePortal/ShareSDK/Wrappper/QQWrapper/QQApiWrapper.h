//
//  QQApiWrapper.h
//  CSP
//
//  Created by LuYang on 16/8/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEYCHAIN_KEY_ACCESSTOKEN_QQ @"KEYCHAIN_KEY_ACCESSTOKEN_QQ"
#define KEYCHAIN_KEY_REFRESHTOKEN_QQ @"KEYCHAIN_KEY_REFRESHTOKEN_QQ"
#define KEYCHAIN_KEY_USERID_QQ @"KEYCHAIN_KEY_USERID_QQ"
#define KEYCHAIN_KEY_QQ_USERINFO @"KEYCHAIN_KEY_QQ_USERINFO"
#define KEYCHAIN_KEY_OPENID_QQ @"KEYCHAIN_KEY_OPENID_QQ"

typedef enum : NSUInteger {
  QQ_ZONE,
  QQ_PERSON,
} QQ_shareType;

typedef void (^CompletetionHandler)(id result, NSError *err);

@interface QQApiWrapper : NSObject

+ (QQApiWrapper *)shareInstance;

- (void)qqloginAction;
- (void)qqreloginAction;
- (void)qqlogoutActionWithCompletionHandler:(CompletetionHandler)handler;
- (void)qqloginActionWithCompletionHandler:(CompletetionHandler)handler;
- (void)qqUserInfoRequestAction;

- (void)qqShareSendNewsMessageWithLocalImage:(NSString *)_str_img withTitle:(NSString *)title desctiption:(NSString *)description shareURL:(NSString *)url sharePreviewURL:(NSString *)previewurl toShareType:(QQ_shareType)shareType;
- (void)qqShareSendNewsMessageWithNetworkImage:(NSString *)_str_img withTitle:(NSString *)title desctiption:(NSString *)description shareURL:(NSString *)url sharePreviewURL:(NSString *)previewurl toShareType:(QQ_shareType)shareType;
- (void)qqSharesendTextMessageWithText:(NSString *)_str_text toShareType:(QQ_shareType)shareType;

- (NSString *)qqUserID;
- (NSString *)qqToken;
- (NSString *)qqUserNickName;  //qq用户昵称
- (NSString *)qqUserAvatarURL; //qq用户头像地址

- (BOOL) isLogined;
@end

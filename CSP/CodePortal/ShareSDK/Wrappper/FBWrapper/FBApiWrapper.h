//
//  FBApiWrapper.h
//  CSP
//
//  Created by JasonLu on 16/9/12.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#define KEYCHAIN_KEY_ACCESSTOKEN_FB @"KEYCHAIN_KEY_ACCESSTOKEN_FB"
#define KEYCHAIN_KEY_REFRESHTOKEN_FB @"KEYCHAIN_KEY_REFRESHTOKEN_FB"
#define KEYCHAIN_KEY_USERID_FB @"KEYCHAIN_KEY_USERID_FB"
#define KEYCHAIN_KEY_OPENID_FB @"KEYCHAIN_KEY_OPENID_FB"
#define KEYCHAIN_KEY_FB_USERINFO @"KEYCHAIN_KEY_FB_USERINFO"

typedef void (^CompletetionHandler)(id result, NSError *err);
@interface FBApiWrapper : NSObject

+ (FBApiWrapper *)shareInstance;

- (void)fbLoginAction;
- (void)fbGetProfileWithRepHandler:(CompletetionHandler)handler;
- (void)fbGetGraphWithRepHandler:(CompletetionHandler)handler;
- (void)fbLoginInVCtrl:(UIViewController *)VCtrl withCompletetionHandler:(CompletetionHandler)handler;

- (void)fbShareWithImages:(NSArray *)_arr_img inVCtrl:(UIViewController *)vCtrl;
- (void)fbShareWithTitle:(NSString *)title shareURL:(NSString *)url sharePreviewURL:(NSString *)previewurl inVCtrl:(UIViewController *)vCtrl;
- (BOOL)isLogined;

- (NSString *)fbToken;
- (NSString *)fbUserID;
- (NSString *)fbUsername;
- (NSString *)fbUserAvatarURL;
@end
